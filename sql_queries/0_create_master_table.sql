--CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.master_table` AS

WITH Combined_Flights AS (
  -- 1. GERÇEKLEŞEN UÇUŞLAR
  SELECT
    FlightDate,
    Airline,
    Dep_Airport,
    Arr_Airport, -- <-- YENİ EKLENDİ!
    DepTime_label,
    Distance_type,
    Aicraft_age,
    Dep_Delay,
    Arr_Delay,
    Delay_Carrier,
    Delay_Weather,
    Delay_NAS,
    Delay_LastAircraft,
    0 as Is_Cancelled, 
    0 as Is_Diverted
  FROM `aviation-480106.aviation_ds2.us_flights_2023_raw`
  
  UNION ALL
  
  -- 2. İPTAL VE DIVERT EDİLEN UÇUŞLAR
  SELECT
    FlightDate,
    Airline,
    Dep_Airport,
    Arr_Airport, -- <-- YENİ EKLENDİ!
    DepTime_label,
    Distance_type,
    NULL as Aicraft_age, 
    0 as Dep_Delay,
    0 as Arr_Delay,
    0 as Delay_Carrier,
    0 as Delay_Weather,
    0 as Delay_NAS,
    0 as Delay_LastAircraft,
    Cancelled as Is_Cancelled, 
    Diverted as Is_Diverted    
  FROM `aviation-480106.aviation_ds2.cancelled_diverted_2023`
)

SELECT
  f.*,
  
  -- HAVA DURUMU (Weather Tablosundan)
  w.tavg AS Dep_Temp_Avg,
  w.prcp AS Dep_Precipitation,
  w.snow AS Dep_Snow,
  w.wspd AS Dep_Wind_Speed,
  w.pres AS Dep_Pressure,

  -- HAVALİMANI BİLGİLERİ (Airports Tablosundan)
  a.LATITUDE AS Dep_Lat,
  a.LONGITUDE AS Dep_Lon,
  a.STATE AS Dep_State,  -- <--(NY, CA, TX vb.)
  
  -- Coğrafi Bölge (Kuzey/Güney Ayrımı)
  CASE
    WHEN a.LATITUDE >= 38 THEN 'North' -- Rakım olmadığı için ENLEM (Latitude) kullanıyoruz.Looker Studio'da harita çizebilmek için Nokta (Koordinat) lazım.
  -- 38. Enlem üzeri genelde kış şartlarının ağır olduğu "Snow Belt"tir.
    ELSE 'South' --#ABD haritasında 38. Enlem (kabaca San Francisco'dan Washington DC'ye çekilen bir çizgi) ülkeyi iklimsel olarak ikiye böler.Yukarıdakiler (>=38): Kışın kar, buzlanma ve don riskiyle savaşır. (Risk Türü: Snow). Aşağıdakiler (<38): Yazın kasırga, nem ve oraj riskiyle savaşır. (Risk Türü: Storm).
  END AS Dep_Region, 

  -- MODÜL A HEDEFİ: RİSK SKORU
  CASE 
    WHEN f.Is_Cancelled = 1 OR f.Is_Diverted = 1 THEN 1 
    ELSE 0 
  END as Target_Risk_Label,

  -- MODÜL B HEDEFİ: RÖTAR NEDENİ
  CASE
    WHEN f.Is_Cancelled = 1 THEN 'Cancelled' 
    WHEN f.Arr_Delay < 15 THEN 'No_Delay'
    WHEN f.Delay_Weather >= f.Delay_Carrier AND f.Delay_Weather >= f.Delay_NAS AND f.Delay_Weather >= f.Delay_LastAircraft THEN 'Weather'
    WHEN f.Delay_Carrier >= f.Delay_Weather AND f.Delay_Carrier >= f.Delay_NAS AND f.Delay_Carrier >= f.Delay_LastAircraft THEN 'Carrier'
    WHEN f.Delay_NAS >= f.Delay_Weather AND f.Delay_NAS >= f.Delay_Carrier AND f.Delay_NAS >= f.Delay_LastAircraft THEN 'NAS'
    WHEN f.Delay_LastAircraft >= f.Delay_Weather AND f.Delay_LastAircraft >= f.Delay_Carrier AND f.Delay_LastAircraft >= f.Delay_NAS THEN 'Late_Aircraft'
    ELSE 'Other' 
  END AS Target_Delay_Cause

FROM Combined_Flights f

-- Hava Durumu Join
LEFT JOIN `aviation-480106.aviation_ds2.weather_meteo_by_airport` w
  ON f.Dep_Airport = w.airport_id
  AND DATE(f.FlightDate) = DATE(w.time) 

-- Havalimanı Join
LEFT JOIN `aviation-480106.aviation_ds2.airports_geolocation` a
  ON f.Dep_Airport = a.IATA_CODE;
