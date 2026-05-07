# 🧠 EEG-Based Multi-Disease Neurological Classification
> MSc Applied AI & Data Science — Dissertation Project

![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat&logo=python&logoColor=white)
![Deep Learning](https://img.shields.io/badge/Deep%20Learning-CNN%20%2B%20SVM-7B68EE?style=flat)
![EEG](https://img.shields.io/badge/Domain-EEG%20%2F%20Biomedical-2E8B57?style=flat)
![Accuracy](https://img.shields.io/badge/Best%20Accuracy-93%25-27AE60?style=flat)
![Status](https://img.shields.io/badge/Status-Complete-success?style=flat)

---

## 📌 Overview

Neurological diseases affect approximately **3.4 billion people** worldwide. Traditional diagnostic methods — clinical assessments, behavioural observation, and manual EEG interpretation — require specialist expertise and create significant barriers to early and accurate detection at scale.

This project proposes a **unified deep learning framework** for automated, multi-disease classification of neurological conditions from raw EEG signals. Unlike existing models that focus on a single condition, this framework simultaneously handles **alcoholism**, **schizophrenia**, and **depression** using signal decomposition, time-frequency imaging, and transfer learning — forming a scalable, end-to-end ML pipeline relevant to enterprise AI and clinical decision support systems.

---

## 🔬 Methodology

### Signal Processing Pipeline

```
Raw EEG Signal
      │
      ▼
Variational Mode Decomposition (VMD)
   └─ Separates frequency-specific signal components
      │
      ▼
Continuous Wavelet Transform (CWT)
   └─ Converts 1D signals into 2D time-frequency scalograms
      │
      ▼
Pre-trained CNN (Transfer Learning)
   └─ Feature extraction from scalogram images
      │
      ▼
Support Vector Machine (SVM)
   └─ Multi-class neurological condition classification
      │
      ▼
Predicted Condition (Healthy / Alcoholism / Schizophrenia / Depression)
```

| Stage | Technique | Purpose |
|---|---|---|
| Decomposition | Variational Mode Decomposition (VMD) | Isolate frequency-specific EEG components |
| Imaging | Continuous Wavelet Transform (CWT) | Transform 1D signals into 2D scalograms |
| Feature Extraction | Pre-trained CNNs | Deep spatial feature learning via transfer learning |
| Classification | Support Vector Machine (SVM) | Final multi-class disease prediction |

---

## 📊 Model Performance

| Model | Accuracy | Notes |
|---|---|---|
| **EfficientNet-B0** | **93%** | Best performing model |
| ResNet-50 | 92% | Strong generalisation across conditions |
| GoogLeNet | 91% | Efficient with competitive accuracy |
| Xception | 91% | Depthwise separable convolutions |

> All models trained on the same three-disease dataset split and evaluated using accuracy, precision, recall, and F1-score.

---

## 🗂️ Datasets

Three publicly available EEG datasets were used, each covering healthy control and diseased subjects:

| Dataset | Condition | Classes |
|---|---|---|
| EEG Alcoholism Dataset | Alcoholism | Healthy vs Alcoholic |
| Schizophrenia EEG Dataset | Schizophrenia | Healthy vs Schizophrenic |
| Depression EEG Dataset | Depression | Healthy vs Depressed |

---

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Language | Python 3.9+ |
| Deep Learning | PyTorch / TensorFlow, Keras |
| Classical ML | scikit-learn (SVM) |
| Signal Processing | PyWavelets, VMD library |
| Data Handling | NumPy, Pandas |
| Visualisation | Matplotlib, Seaborn |
| Models | ResNet-50, GoogLeNet, EfficientNet-B0, Xception |

---

## ✅ Skills Demonstrated

- **End-to-end ML pipeline** for high-dimensional biomedical signal data
- **Full data lifecycle**: raw signal ingestion, preprocessing, cleaning, feature engineering, model training, and evaluation
- **Signal-to-image transformation**: VMD + CWT to convert 1D EEG into 2D scalograms for CNN compatibility
- **Transfer learning**: leveraging pre-trained ImageNet weights for a medical imaging domain
- **Error analysis**: identifying failure cases, class imbalance, and edge cases to improve robustness
- **Performance evaluation**: accuracy, precision, recall, F1-score, confusion matrices, and cross-model benchmarking
- **Noisy real-world dataset handling** in structured pipelines applicable to enterprise AI and clinical systems
- **Multi-disease unified framework**: single pipeline classifying across three neurological conditions simultaneously

---

## 📁 Repository Structure

```
├── data/
│   ├── alcoholism/
│   ├── schizophrenia/
│   └── depression/
├── preprocessing/
│   ├── vmd_decomposition.py
│   └── cwt_scalogram.py
├── models/
│   ├── resnet50.py
│   ├── googlenet.py
│   ├── efficientnetb0.py
│   └── xception.py
├── classification/
│   └── svm_classifier.py
├── evaluation/
│   └── metrics.py
├── notebooks/
│   └── EEG_Classification_Pipeline.ipynb
├── results/
│   └── model_comparison.csv
└── README.md
```

The framework achieved strong classification performance across all three neurological conditions, with **EfficientNet-B0 reaching 93% accuracy** as the top-performing model. The VMD + CWT transformation proved effective at surfacing discriminative frequency-domain features from raw EEG signals, enabling pre-trained image models to be applied successfully to a non-image domain.


## 📄 Citation / Acknowledgements

This project was completed as part of an MSc in Applied AI & Data Science. Datasets sourced from publicly available repositories. Pre-trained model weights sourced from ImageNet via PyTorch/Keras model hubs.


*Built as part of the MSc Applied AI & Data Projects portfolio.*
