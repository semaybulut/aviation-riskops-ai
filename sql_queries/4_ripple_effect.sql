--3.Hipotez: Zincirleme Reaksiyon Hipotezi (The Ripple Effect Hypothesis)
--Amaç: Sabah saatlerinde (06-10) her şey yolundayken, akşam (16+) saatlerinde "Late Aircraft" (Önceki uçak) gecikmesinin patladığını göstermek.

CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.summary_ripple` AS
SELECT
  DepTime_label as Time_Period,
  
  -- Sıralama için numara veriyoruz (Grafik düzgün aksın diye- sıralamanın düzgün olması için (Sabah -> Akşam) numara atıyoruz:)
  CASE 
    WHEN DepTime_label = 'Morning' THEN 1
    WHEN DepTime_label = 'Afternoon' THEN 2
    WHEN DepTime_label = 'Evening' THEN 3
    WHEN DepTime_label = 'Night' THEN 4
    ELSE 5 
  END as Sort_Order,

  -- Gecikme Nedenleri (Sadece uçanlar için): #suçluları kıyaslıyoruz. hipotez testi: grafikte bu sütunları yarıştıracağız. Sabahları Weather yüksek çıkabilir ama akşamları LateAircraft (Zincirleme Etki) sütununun fırladığını göreceğiz.
  ROUND(AVG(IF(Is_Cancelled=0, Delay_Weather, NULL)), 2) as Avg_Weather_Delay,
  ROUND(AVG(IF(Is_Cancelled=0, Delay_LastAircraft, NULL)), 2) as Avg_LateAircraft_Delay,
  
  -- Toplam Gecikme
  ROUND(AVG(IF(Is_Cancelled=0, Dep_Delay, NULL)), 2) as Avg_Total_Delay,
      -- EKLENEN SÜTUN: Toplam Uçuş Sayısı
  COUNT(*) as Flight_Count

FROM `aviation-480106.aviation_ds2.master_table`
WHERE DepTime_label IS NOT NULL #-- Boş olanları atalım> Eğer bir uçuşun zaman etiketi boşsa (Null), onu hesaplamaya katma.
GROUP BY 1, 2 --sabah ve akşam uçanları ayrı ayrı gruplandırıp özetle 
ORDER BY 2;