
--4. Hipotez: Mesafe ve Operasyonel Esneklik Hipotezi (Distance & Resilience Hypothesis)
--Amaç: Aynı anda kalkması gereken iki uçak arasında operasyonel önceliklendirme stratejisini belirlemek.

CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.summary_distance_risk` AS
SELECT
  Distance_type,--mesafe Türü (short haul, medium haul vb.)
  
  -- Kalkış ve Varış Gecikmeleri (Sadece gerçekleşenler)
  ROUND(AVG(IF(Is_Cancelled=0, Dep_Delay, NULL)), 2) as Avg_Departure_Delay, --kalkış gecikmesi
  ROUND(AVG(IF(Is_Cancelled=0, Arr_Delay, NULL)), 2) as Avg_Arrival_Delay, --varış gecikmesi (aradaki fark, havada kapatılan süredir)
  
  -- Telafi (Airborne Recovery)
  -- Negatif değer = İYİ (Havada zaman kazanmış)
  -- Pozitif değer = KÖTÜ (Havada zaman kaybetmiş)
  --burası en kritik yer çünkü kendi metriğimizi yazdık. Looker'da bu sütun negatif çıktığında "Başarılı Operasyon" diyeceğiz.
  ROUND(AVG(IF(Is_Cancelled=0, Arr_Delay - Dep_Delay, NULL)), 2) as Airborne_Recovery,
  ROUND(AVG(IF(Is_Cancelled=0, Delay_NAS, NULL)), 2) as Avg_NAS_Delay,  --NAS (trafik) gecikmesi ortalaması. Hipotezimizde: kısa uçuşlar trafikten (NAS) daha çok etkilenir, diyordu. Bunu kanıtlamak için ortalama trafik/sistem gecikmesini de ekliyoruz. Kısa mesafelerde bu sayının yüksek çıkmasını bekleriz.Yani >>Hipotez: Kısa mesafelerde bu sayı yüksek çıkmalı.
  
  COUNT(*) as Flight_Count

FROM `aviation-480106.aviation_ds2.master_table`
--distance_type boş olmasın
WHERE Distance_type IS NOT NULL --Mesafe bilgisi olmayan hayalet uçuşları atıyoruz.
GROUP BY 1
ORDER BY Avg_Departure_Delay DESC; --En çok kalkış rötarı yaşayan grubu (muhtemelen kısa mesafeler) en üste koyuyoruz ki sorun hemen göze çarpsın.