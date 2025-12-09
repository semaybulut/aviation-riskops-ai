--Amaç: Havayollarını karneye dizmek. "En Dakik Kim?" sorusunun cevabı.

--summary_airlines :

--CREATE TABLE `aviation-480106.aviation_ds2.summary_airlines` AS
SELECT
  Airline,
  
  -- Hacim
  COUNT(*) as Total_Flights,
  
  -- Performans Karnesi
  ROUND(IEEE_DIVIDE(COUNTIF(Is_Cancelled=0 AND Dep_Delay < 15), COUNTIF(Is_Cancelled=0)) * 100, 1) as On_Time_Performance, -- OTP (En önemlisi)
  ROUND(IEEE_DIVIDE(SUM(Is_Cancelled), COUNT(*)) * 100, 2) as Cancel_Rate,
  
  -- Teknik Arıza Oranı (Bakım kalitesi göstergesi)
  ROUND(AVG(IF(Is_Cancelled=0, Delay_Carrier, NULL)), 1) as Avg_Tech_Delay

FROM `aviation-480106.aviation_ds2.master_table`
GROUP BY 1
ORDER BY On_Time_Performance DESC; -- En iyiler üstte