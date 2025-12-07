--2.Hipotez: Coğrafi Risk(Geo-Constraint-Latitude Bazlı)
--Amaç: Kuzey (Soğuk İklim) vs Güney (Ilıman İklim) havalimanlarında İptal Oranının (Cancellation Rate) daha yüksek olduğunu kanıtlamak.
--havalimanlarını Kuzey (Lat > 38) ve Güney (Lat <= 38) olarak ayırıyoruz. (38. paralel ABD'de kabaca kar sınırını ayırır).——-
--Mantığımız şu: "Rakım verim yok ama elimde Enlem (Latitude) var. Kuzeydeki havalimanları (soğuk/kar) ile Güneydeki havalimanlarını (sıcak/fırtına) kıyaslayabilirim."


CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.summary_geo_risk` AS
SELECT
  f.Dep_Region, -- North/South (Master tablodan hazır geliyor)
  f.Dep_Lat,
  f.Dep_Lon,
  f.Dep_Airport, -- Havalimanı kodu (Örn: JFK)
  a.AIRPORT as Airport_Name, -- < Örn: John F. Kennedy Intl
  f.Dep_State,   -- <-- Eyalet Kodu: NY
  
  COUNT(*) as Total_Flights,
  COUNTIF(f.Is_Cancelled = 1) as Cancelled_Flights, --Bizim hipotezimiz "Neresi daha riskli?" sorusunu soruyor.Bunu cevaplamak için o havalimanında 2023 boyunca kaç tane iptal yaşandığını sayıyoruz (COUNT).
  
  
  -- İptal Oranı
  ROUND(COUNTIF(f.Is_Cancelled = 1) / COUNT(*) * 100, 2) as Cancellation_Rate

FROM `aviation-480106.aviation_ds2.master_table` f
-- havalimanı ismini almak için Airports tablosuna bağlanırız
LEFT JOIN `aviation-480106.aviation_ds2.airports_geolocation` a
  ON f.Dep_Airport = a.IATA_CODE

GROUP BY 1, 2, 3, 4, 5, 6 -- Tüm detay sütunlarını gruplamaya ekledik: Her havalimanını (JFK, LAX, ORD) tek bir satır yap, o havalimanındaki toplam iptalleri yanına yaz. 
ORDER BY Cancellation_Rate DESC;