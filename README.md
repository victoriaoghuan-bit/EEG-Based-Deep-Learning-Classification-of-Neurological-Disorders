# EEG-Based-Deep-Learning-Classification-of-Neurological-Disorders

> An agentic RAG pipeline for automated regulatory literature synthesis — built for speed, accuracy, and real-world consulting workflows.

## Overview

This project combines **EEG signal classification** with an **agentic Retrieval-Augmented Generation (RAG) pipeline** to support research and regulatory workflows in the neurological space. The system orchestrates multi-step LLM calls with vector store retrieval and live web search to synthesise EMA and FDA regulatory documents — reducing manual literature search time by approximately **70%** in internal testing.

## Key Features

- **Agentic RAG pipeline** built in Python using [LangGraph](https://github.com/langchain-ai/langgraph), orchestrating multi-step LLM reasoning with tool integration
- **Vector store retrieval** for fast semantic search over regulatory document corpora
- **Web search tool integration** for up-to-date EMA and FDA guidance
- **EEG signal classification** using deep learning to identify neurological disorder patterns
- Validated as a viable prototype for **consulting and regulated-industry workflows**

## Tech Stack

| Component | Technology |
|---|---|
| Pipeline orchestration | LangGraph |
| Language model calls | Python (LLM API) |
| Vector store | (e.g. FAISS / Chroma / Pinecone) |
| Web search | Tool-integrated search API |
| Deep learning | Python (PyTorch / TensorFlow) |
| Data | EEG signal datasets |

## Architecture

User Query
    │
    ▼
LangGraph Agent
    ├── Vector Store Retrieval  ← Regulatory document corpus (EMA / FDA)
    ├── Web Search Tool         ← Live guidance and updates
    └── LLM Synthesis           ← Structured response generation
    │
    ▼
Synthesised Regulatory Summary

## Results

- ~**70% reduction** in manual literature search time (internal testing)
- Viable prototype for **LLM orchestration** in regulated industries
- Demonstrates practical **context management** across multi-step tool calls

## Relevance

This project is directly applicable to roles requiring:
- LLM orchestration and agentic system design
- Context management across multi-turn reasoning chains
- Tool integration in regulated industries (pharma, medtech, clinical research)
- RAG pipeline development and evaluation

