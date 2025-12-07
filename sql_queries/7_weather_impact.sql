
--Hava Durumu Etki Matrisi (summary_weather_impact)
--Amaç: Operasyona "Rüzgar 40 km/s olunca kapasiteyi %50 düşür" kuralını getirmek.

--CREATE TABLE `aviation-480106.aviation_ds2.summary_weather_impact` AS
SELECT
  -- Rüzgarı Grupla (0-10, 10-20...)
  CAST(FLOOR(Dep_Wind_Speed / 10) * 10 AS STRING) || '-' || CAST(FLOOR(Dep_Wind_Speed / 10) * 10 + 9 AS STRING) as Wind_Speed_Bucket,
  
  -- Kar Durumu
  CASE 
    WHEN Dep_Snow > 0 THEN 'Snowy' 
    ELSE 'No Snow' 
  END as Snow_Condition,

  -- KPI: İptal Oranı (Bu hava koşulunda uçuşların yüzde kaçı iptal oluyor?)
  ROUND(COUNTIF(Is_Cancelled = 1) / COUNT(*) * 100, 2) as Cancellation_Rate,
  
  -- KPI: Ortalama Gecikme
  ROUND(AVG(IF(Is_Cancelled=0, Dep_Delay, NULL)), 2) as Avg_Delay,

  COUNT(*) as Flight_Count

FROM `aviation-480106.aviation_ds2.master_table`
WHERE Dep_Wind_Speed IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;