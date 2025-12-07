
--summary_kpis tablosu için sorgu


CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.summary_kpis` AS
SELECT
  -- Toplam Planlanan Uçuş (Master tablo hepsini içeriyor)
  COUNT(*) as Total_Scheduled_Flights,

  -- Zamanında Kalkış (OTP) Oranı (Sadece iptal olmayanlar üzerinden)
  ROUND(COUNTIF(Is_Cancelled = 0 AND Dep_Delay < 15) / COUNTIF(Is_Cancelled = 0) * 100, 2) as OTP_Rate,

  -- İptal Oranı (Tüm uçuşlar üzerinden)
  ROUND(COUNTIF(Is_Cancelled = 1) / COUNT(*) * 100, 2) as Cancellation_Rate,

  -- Tahmini Zarar (1 İptal = 5000$)
  COUNTIF(Is_Cancelled = 1) * 5000 as Estimated_Financial_Loss,

  -- Riskli Uçuş Oranı (İptal + Divert)
  ROUND(COUNTIF(Target_Risk_Label = 1) / COUNT(*) * 100, 2) as Total_Risk_Rate

FROM `aviation-480106.aviation_ds2.master_table`