--"Carrier Delay" (Havayolu Kaynaklı Rötar) ile uçak yaşı arasında doğrudan bir korelasyon olması beklenir. Eski uçaklar daha sık teknik arıza yapar. Bunun için yeni bir özet tablo (summary_aircraft_age):
--Bu sorgu, uçakları yaşlarına göre gruplar (0-5 yaş, 5-10 yaş vb.) ve her grubun teknik arıza (Carrier Delay) performansını ölçer.
--Kaynak oalrak "master_table" kullanıyoruz: master_table; uçanları, iptalleri, hava durumunu ve bölge bilgisini (Dep_Region) harmanlamış, temizlenmiş, tek bir kaynaktır.


--CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.summary_aircraft_age` AS
SELECT
  -- Uçakları Yaş Gruplarına Ayır (Feature Engineering)
  CASE
    WHEN Aicraft_age <= 5 THEN '0-5 Years (New)'
    WHEN Aicraft_age <= 15 THEN '6-15 Years (Mid-Life)'
    WHEN Aicraft_age <= 25 THEN '16-25 Years (Mature)'
    ELSE '25+ Years (Old)'
  END as Age_Group,

  -- KPI: Teknik Güvenilirlik (Carrier Delay Ortalaması)
  ROUND(AVG(IF(Is_Cancelled=0, Delay_Carrier, NULL)), 2) as Avg_Carrier_Delay,
  
  -- KPI: Teknik Arıza Oranı (Bu gruptaki rötarların yüzde kaçı teknik?)
  ROUND(COUNTIF(Target_Delay_Cause = 'Carrier') / COUNT(*) * 100, 2) as Technical_Failure_Rate,

  COUNT(*) as Total_Flights

FROM `aviation-480106.aviation_ds2.master_table`
WHERE Aicraft_age IS NOT NULL
GROUP BY 1
ORDER BY 1;

