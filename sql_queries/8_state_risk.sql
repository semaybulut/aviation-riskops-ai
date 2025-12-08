--Eyalet Bazlı Risk Haritası (summary_state_risk)
--Amaç: Haritada sadece nokta değil, Eyalet bazlı boyama yapmak.

CREATE TABLE `aviation-480106.aviation_ds2.summary_state_risk` AS
SELECT
  Dep_State, -- Eyalet Kodu (NY, TX, CA...) - Master tabloda artık var!
  
  COUNT(*) as Total_Flights,
  COUNTIF(Is_Cancelled = 1) as Cancelled_Flights,
  
  -- KPI: Eyalet Risk Skoru (İptal Oranı)
  ROUND(COUNTIF(Is_Cancelled = 1) / COUNT(*) * 100, 2) as State_Risk_Score,
  
  -- KPI: Ortalama Rötar
  ROUND(AVG(IF(Is_Cancelled=0, Dep_Delay, NULL)), 2) as Avg_Delay,

  -- YENİ KPI: Tahmini Finansal Kayıp ($)
  -- Varsayım: Her iptal ortalama 5.000$ maliyet yaratır (Tazminat + Ekip + Otel)
  (COUNTIF(Is_Cancelled = 1) * 5000) as Estimated_Financial_Loss

FROM `aviation-480106.aviation_ds2.master_table`
WHERE Dep_State IS NOT NULL
GROUP BY 1
-- Sıralamayı artık 'Paraya' göre yapalım ki en çok zarar eden eyalet en üste gelsin
ORDER BY Estimated_Financial_Loss DESC;