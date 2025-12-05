--2.Hipotez: Coğrafi Risk(Geo-Constraint-Latitude Bazlı)
--Amaç: Kuzey (Soğuk İklim) vs Güney (Ilıman İklim) havalimanlarında İptal Oranının (Cancellation Rate) daha yüksek olduğunu kanıtlamak.
-- ——havalimanlarını Kuzey (Lat > 38) ve Güney (Lat <= 38) olarak ayırıyoruz. (38. paralel ABD'de kabaca kar sınırını ayırır).——-
--Mantığımız şu: "Rakım verim yok ama elimde Enlem (Latitude) var. Kuzeydeki havalimanları (soğuk/kar) ile Güneydeki havalimanlarını (sıcak/fırtına) kıyaslayabilirim."

--Not: IEEE_DIVIDE sıfıra bölme hatasını engeller, güvenlidir

---CREATE TABLE `aviation-480106.aviation_ds2.summary_geo_risk` AS
SELECT
  a.IATA_CODE,
  a.AIRPORT,
  a.LATITUDE,
  a.LONGITUDE,
  
  -- Rakım olmadığı için ENLEM (Latitude) kullanıyoruz.Looker Studio'da harita çizebilmek için Nokta (Koordinat) lazım.
  -- 38. Enlem üzeri genelde kış şartlarının ağır olduğu "Snow Belt"tir.
  CASE
    WHEN a.LATITUDE >= 38 THEN 'Northern Region (Cold/Snow Risk)' --ABD haritasında 38. Enlem (kabaca San Francisco'dan Washington DC'ye çekilen bir çizgi) ülkeyi iklimsel olarak ikiye böler.Yukarıdakiler (>=38): Kışın kar, buzlanma ve don riskiyle savaşır. (Risk Türü: Snow). Aşağıdakiler (<38): Yazın kasırga, nem ve oraj riskiyle savaşır. (Risk Türü: Storm).
    ELSE 'Southern Region (Warm/Storm Risk)'
  END as Climate_Region, --Bu sütun sayesinde Looker'da haritayı iki farklı renge boyayabileceğiz.

  -- Sadece iptal tablosundan veri çektiğimiz için direkt sayıyoruz. Bizim hipotezimiz "Neresi daha riskli?" sorusunu soruyor.Bunu cevaplamak için o havalimanında 2023 boyunca kaç tane iptal yaşandığını sayıyoruz (COUNT).
  COUNT(*) as Total_Cancelled_Flights

FROM `aviation-480106.aviation_ds2.cancelled_diverted_2023` c
JOIN `aviation-480106.aviation_ds2.airports_geolocation` a
  ON c.Dep_Airport = a.IATA_CODE --"İptal listesindeki her uçuşun kalkış havalimanına bak, git koordinat listesinden o havalimanını bul ve bilgilerini yan yana getir."
WHERE c.Cancelled = 1 -- Sadece İptalleri al çünkü cancelled_diverted tablosunda bazen sadece rötarlı olup iptal olmayan veya "Divert" (başka yere inen) uçuşlar da olabilir. Ama biz sadece Kesin İptalleri (Cancelled = 1) istiyoruz.
GROUP BY 1,2,3,4,5 --GROUP BY:Her havalimanını (JFK, LAX, ORD) tek bir satır yap, o havalimanındaki toplam iptalleri yanına yaz. 
ORDER BY Total_Cancelled_Flights DESC;--ORDER BY: En çok iptal yaşayan havalimanını (Muhtemelen Chicago veya New York çıkacaktır) en üste koy.
