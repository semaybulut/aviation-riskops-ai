--4. Hipotez: Mesafe ve Operasyonel Esneklik Hipotezi (Distance & Resilience Hypothesis)
--Amaç: Aynı anda kalkması gereken iki uçak arasında operasyonel önceliklendirme stratejisini belirlemek.

--CREATE TABLE `aviation-480106.aviation_ds2.summary_distance_risk` AS
SELECT
  --mesafe Türü (short haul, medium haul vb.)
  Distance_type,

  --kalkış gecikmesi
  ROUND(AVG(Dep_Delay), 2) as Avg_Departure_Delay,
  
  --varış gecikmesi (aradaki fark, havada kapatılan süredir)
  ROUND(AVG(Arr_Delay), 2) as Avg_Arrival_Delay,
  
  --aradaki fark (pozitifse havada zaman kaybetmiş, negatifse zaman kazanmış/telafi etmiş). burası en kritik yer çünkü kendi metriğimizi yazdık. Looker'da bu sütun negatif çıktığında "Başarılı Operasyon" diyeceğiz.
  ROUND(AVG(Arr_Delay) - AVG(Dep_Delay), 2) as Airborne_Recovery,

  --NAS (trafik) gecikmesi ortalaması. Hipotezimizde: kısa uçuşlar trafikten (NAS) daha çok etkilenir, diyordu. Bunu kanıtlamak için ortalama trafik/sistem gecikmesini de ekliyoruz. Kısa mesafelerde bu sayının yüksek çıkmasını bekleriz.
  ROUND(AVG(Delay_NAS), 2) as Avg_NAS_Delay,
  
  --toplam uçuş sayısı
  COUNT(*) as Flight_Count

FROM `aviation-480106.aviation_ds2.us_flights_2023_raw`

--distance_type boş olmasın
WHERE Distance_type IS NOT NULL --Mesafe bilgisi olmayan hayalet uçuşları atıyoruz.
GROUP BY 1
ORDER BY Avg_Departure_Delay DESC; --En çok kalkış rötarı yaşayan grubu (muhtemelen kısa mesafeler) en üste koyuyoruz ki sorun hemen göze çarpsın.
