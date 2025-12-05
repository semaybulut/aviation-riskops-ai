# ✈️ Aviation RiskOps AI
**Flight Risk Level Scoring & Delay Causality Modeling**
**-Havacılık RiskOps AI: Uçus Risk Seviyesi Puanlama ve Gecikme Nedensellik Modellemesi-**

EN: This project leverages 1.5 GB of U.S. civil aviation data (2023) combined with meteorological datasets to score flight cancellation/diversion risk (0–100) and predict the root cause of potential delays (weather, operational factors, traffic, etc.) using machine learning.

TR: Bu proje, 1.5 GB'lık ABD sivil havacılık verilerini (2023) ve meteorolojik verileri kullanarak uçuş iptal risklerini puanlar (0-100) ve olası rötarların kök nedenlerini (hava durumu, operasyonel, trafik vb.) yapay zeka ile tahmin eder.

## EN:🎯 Project Objectives
1. **Risk Scoring:** Estimate cancellation/diversion risk before the flight takes place.
2. **Causality Modeling:** Classify the expected delay cause (e.g., Weather vs. Carrier vs. Traffic).
3. **Business Intelligence:** Provide interactive dashboards to support airline operational decision-making.

##  TR: 🎯 Proje Hedefleri
1. **Risk Scoring:** Uçuş gerçekleşmeden iptal/divert riskini hesaplamak.
2. **Causality Modeling:** Rötar olacaksa bunun sebebini (Weather vs Carrier) önceden sınıflandırmak.
3. **Business Intelligence:** Havayolu operasyonel kararları destekleyen interaktif dashboardlar sunmak.

## EN: 🛠️ Tech Stack
This project follows a fully integrated, “End-to-End” data science pipeline:
- **Data Storage:** Google BigQuery (Data Warehouse) & Google Drive
- **Compute Environment:** Google Colab (Model Training + GPU)
- **Version Control:** Git & GitHub
- **Modeling:** XGBoost, Random Forest (Python)
- **Libraries:** Pandas, Scikit-learn
- **Data Analysis:** Pandas, SQL (BigQuery), Seaborn
- **Development Environment:** VS Code (Local Development & Git Management)
- **BI & Visualization:** Google Looker Studio

## TR: 🛠️ Tech Stack (Teknolojiler)
Bu projede "End-to-End" bir veri bilimi akışı kurgulanmıştır:
- **Veri Depolama:** Google BigQuery (Data Warehouse) & Google Drive
- **İşlemci:** Google Colab (Model Eğitimi & GPU)
- **Versiyon Kontrol:** Git & GitHub
- **Modelleme:** XGBoost, Random Forest (Python)
- **Kütüphaneler:** Pandas, Scikit-learn,
- **Veri Analizi:** Pandas, SQL (BigQuery), Seaborn
- **Geliştirme Ortamı (IDE):** VS Code (Local Development & Git Management)
- **İş Zekası (BI) & Görselleştirme:** Google Looker Studio

## EN: 📂 Folder Structure
- `notebooks/`: Jupyter/Colab notebooks for analysis and modeling (.ipynb)
- `scripts/`: Python scripts for preprocessing and feature engineering at VS Code (.py)
- `data/`:  Local raw datasets *Note: Main datasets are stored in BigQuery*

## TR: 📂 Klasör Yapısı
- `notebooks/`: Google Colab üzerinde çalıştırılacak analiz ve modelleme dosyaları (.ipynb).
- `scripts/`: VS Code üzerinde geliştirilen veri temizliği ve ön işleme için kullanılan Python scriptleri (.py).
- `data/`: (Local) Ham veri dosyaları. *Not: Ana veri seti BigQuery üzerinde tutulmaktadır.*

## EN: 🚀 Setup & Run Instructions
1. Clone the repository:
   ```bash
   git clone [https://github.com/semaybulut/aviationvs.git](https://github.com/semaybulut/aviationvs.git)

## TR: 🚀 Kurulum & Çalıştırma
1. Repoyu klonlayın:
   ```bash
   git clone [https://github.com/semaybulut/aviationvs.git](https://github.com/semaybulut/aviationvs.git)