"""
pipeline/agent.py

Agentic RAG pipeline for regulatory document synthesis.
Orchestrates multi-step LLM calls using LangGraph, with:
  - Chroma vector store retrieval over EMA/FDA document corpus
  - Web search tool for live regulatory updates
  - Claude (Anthropic) as the reasoning backbone

Usage:
    from pipeline.agent import run_agent
    result = run_agent("What are the EMA guidelines for EEG biomarker validation?")
"""

import os
from typing import TypedDict, Annotated
from dotenv import load_dotenv

from langchain_anthropic import ChatAnthropic
from langchain_chroma import Chroma
from langchain_core.messages import HumanMessage, AIMessage, ToolMessage
from langchain_core.tools import tool
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.tools.tavily_search import TavilySearchResults
from langgraph.graph import StateGraph, END
from langgraph.prebuilt import ToolNode

load_dotenv()

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY")
TAVILY_API_KEY    = os.getenv("TAVILY_API_KEY")
CHROMA_PERSIST_DIR = os.getenv("CHROMA_PERSIST_DIR", "./data/chroma_db")
COLLECTION_NAME    = "regulatory_docs"

# ---------------------------------------------------------------------------
# Models & embeddings
# ---------------------------------------------------------------------------

llm = ChatAnthropic(
    model="claude-3-5-sonnet-20241022",
    temperature=0,
    anthropic_api_key=ANTHROPIC_API_KEY,
)

embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2"
)

vectorstore = Chroma(
    collection_name=COLLECTION_NAME,
    embedding_function=embeddings,
    persist_directory=CHROMA_PERSIST_DIR,
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------

@tool
def retrieve_regulatory_docs(query: str) -> str:
    """
    Retrieve relevant EMA and FDA regulatory documents from the vector store.
    Use this first for any question about guidelines, approvals, or compliance.
    """
    docs = retriever.invoke(query)
    if not docs:
        return "No relevant documents found in the regulatory corpus."

    formatted = []
    for i, doc in enumerate(docs, 1):
        source = doc.metadata.get("source", "Unknown source")
        agency = doc.metadata.get("agency", "")
        formatted.append(
            f"[Doc {i}] {agency} — {source}\n{doc.page_content.strip()}"
        )
    return "\n\n---\n\n".join(formatted)


@tool
def web_search(query: str) -> str:
    """
    Search the web for recent regulatory updates, news, or guidance not yet
    in the vector store. Use when retrieved documents are outdated or missing.
    """
    search = TavilySearchResults(max_results=3, tavily_api_key=TAVILY_API_KEY)
    results = search.invoke(query)
    if not results:
        return "No web results found."

    formatted = []
    for r in results:
        formatted.append(f"Source: {r['url']}\n{r['content']}")
    return "\n\n---\n\n".join(formatted)


tools = [retrieve_regulatory_docs, web_search]
tool_node = ToolNode(tools)
llm_with_tools = llm.bind_tools(tools)

# ---------------------------------------------------------------------------
# Agent state
# ---------------------------------------------------------------------------

class AgentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]
    query: str
    retrieved_context: str
    final_answer: str


# ---------------------------------------------------------------------------
# Graph nodes
# ---------------------------------------------------------------------------

SYSTEM_PROMPT = """You are a regulatory intelligence assistant specialising in 
neurological disorder research. You have access to two tools:

1. retrieve_regulatory_docs — searches an indexed corpus of EMA and FDA documents
2. web_search — finds recent regulatory updates on the web

Your workflow:
- Always retrieve from the vector store first
- If the retrieved documents are insufficient or outdated, use web search
- Synthesise findings into a clear, structured response with source attribution
- Be precise about which agency (EMA or FDA) each guideline comes from"""


def call_agent(state: AgentState) -> AgentState:
    """Main reasoning node — calls Claude with tools bound."""
    messages = state["messages"]
    if not any(hasattr(m, "role") and m.role == "system" for m in messages):
        from langchain_core.messages import SystemMessage
        messages = [SystemMessage(content=SYSTEM_PROMPT)] + messages

    response = llm_with_tools.invoke(messages)
    return {"messages": [response]}


def should_continue(state: AgentState) -> str:
    """Route: if the last message has tool calls, run tools; else finish."""
    last = state["messages"][-1]
    if hasattr(last, "tool_calls") and last.tool_calls:
        return "tools"
    return "end"


def format_final_answer(state: AgentState) -> AgentState:
    """Extract the last AI text response as the final answer."""
    for msg in reversed(state["messages"]):
        if isinstance(msg, AIMessage) and msg.content:
            return {"final_answer": msg.content}
    return {"final_answer": "No answer generated."}


# ---------------------------------------------------------------------------
# Build the graph
# ---------------------------------------------------------------------------

def build_graph() -> StateGraph:
    graph = StateGraph(AgentState)

    graph.add_node("agent", call_agent)
    graph.add_node("tools", tool_node)
    graph.add_node("format", format_final_answer)

    graph.set_entry_point("agent")

    graph.add_conditional_edges(
        "agent",
        should_continue,
        {"tools": "tools", "end": "format"},
    )
    graph.add_edge("tools", "agent")
    graph.add_edge("format", END)

    return graph.compile()


# ---------------------------------------------------------------------------
# Public interface
# ---------------------------------------------------------------------------

_graph = None

def run_agent(query: str) -> str:
    """
    Run the agentic RAG pipeline on a regulatory query.

    Args:
        query: Natural language question about EMA/FDA guidelines or approvals.

    Returns:
        Synthesised answer with source attribution.

    Example:
        >>> run_agent("What are EMA requirements for EEG biomarkers in epilepsy trials?")
    """
    global _graph
    if _graph is None:
        _graph = build_graph()

    initial_state: AgentState = {
        "messages": [HumanMessage(content=query)],
        "query": query,
        "retrieved_context": "",
        "final_answer": "",
    }

    result = _graph.invoke(initial_state)
    return result.get("final_answer", "No answer generated.")


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import sys

    query = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else (
        "What are the current EMA guidelines for clinical trials "
        "involving EEG-based biomarkers in neurological disorders?"
    )

    print(f"\nQuery: {query}\n{'─' * 60}")
    answer = run_agent(query)
    print(answer)
