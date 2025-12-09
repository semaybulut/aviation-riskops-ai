CREATE TABLE `aviation-480106.aviation_ds2.summary_routes` AS
SELECT
  -- Rota Tanımı (Görsel olarak güzel dursun diye emoji ekliyoruz)
  CONCAT(Dep_Airport, ' ✈️ ', Arr_Airport) as Route_Name,
  
  -- Detaylar (Filtreleme için)
  Airline,
  Distance_type,
  
  -- Metrikler
  COUNT(*) as Total_Flights,
  
  -- İptal Oranı
  ROUND(IEEE_DIVIDE(SUM(Is_Cancelled), COUNT(*)) * 100, 2) as Cancel_Rate,
  
  -- Ortalama Gecikme
  ROUND(AVG(IF(Is_Cancelled=0, Dep_Delay, NULL)), 2) as Avg_Delay,
  
  -- Para Kaybı
  (SUM(Is_Cancelled) * 5000) as Estimated_Loss

FROM `aviation-480106.aviation_ds2.master_table`
GROUP BY 1, 2, 3
-- Sadece anlamlı rotaları alalım (Yılda en az 50 uçuşu olanlar)
HAVING Total_Flights > 50
ORDER BY Cancel_Rate DESC;