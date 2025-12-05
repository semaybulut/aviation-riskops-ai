--3.Hipotez: Zincirleme Reaksiyon Hipotezi (The Ripple Effect Hypothesis)
--Amaç: Sabah saatlerinde (06-10) her şey yolundayken, akşam (16+) saatlerinde "Late Aircraft" (Önceki uçak) gecikmesinin patladığını göstermek.

--CREATE TABLE `aviation-480106.aviation_ds2.summary_ripple` AS
SELECT
  DepTime_label as Time_Period,

  -- Looker'da sıralamanın düzgün olması için (sabah -> akşam) numara atıyoruz:
  CASE 
    WHEN DepTime_label = 'Morning' THEN 1
    WHEN DepTime_label = 'Afternoon' THEN 2
    WHEN DepTime_label = 'Evening' THEN 3
    WHEN DepTime_label = 'Night' THEN 4
    ELSE 5 
  END as Sort_Order,

  ROUND(AVG(Delay_Weather), 2) as Avg_Weather_Delay,
  ROUND(AVG(Delay_LastAircraft), 2) as Avg_LateAircraft_Delay,
  --suçluları kıyaslıyoruz. hipotez testi: Grafikte bu iki sütunu yarıştıracağız. Sabahları Weather yüksek çıkabilir ama akşamları LateAircraft (Zincirleme Etki) sütununun fırladığını göreceğiz.
  ROUND(AVG(Dep_Delay), 2) as Avg_Total_Delay,
  COUNT(*) as Flight_Count

FROM `aviation-480106.aviation_ds2.us_flights_2023_raw`

-- Boş olanları atalım
WHERE DepTime_label IS NOT NULL --Eğer bir uçuşun zaman etiketi boşsa (Null), onu hesaplamaya katma.

GROUP BY 1, 2 --GROUP BY 1, 2: "Bana her uçuşu tek tek verme. Sabah uçanları bir torbaya, akşam uçanları bir torbaya koy ve özetle."
ORDER BY 2; -- Sort_Order'a göre sırala (Sabah en üste gelsin)