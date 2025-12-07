--1.Hipotez: Mevsimsel Analiz
--Amaç: Aylara göre hangi gecikme türünün baskın olduğunu bulmak.

--CREATE OR REPLACE TABLE `aviation-480106.aviation_ds2.summary_seasonal` AS
SELECT
  EXTRACT(MONTH FROM FlightDate) as Month,
  --flightdate sütunu date formatındaydı zaten, biz de direkt month diyerek o uçuşun hangi ayda olduğu bilgisini çektik.
  CASE
    WHEN EXTRACT(MONTH FROM FlightDate) IN (12, 1, 2) THEN 'Winter' --12-1-2 bu aylar kış baul edildiği için, Month sütununda bu aylardan herhangi birini görürse 'winter' olarak etiketlemesini öğrettik. (label yaptık)
    WHEN EXTRACT(MONTH FROM FlightDate) IN (6, 7, 8) THEN 'Summer'
    ELSE 'Transition'  --yaz ve kış ayları dışındaki diğer ayları geçiş dönemi olarak ayırdık. Bizim hipotezimiz zıtlar-uçlar üzerine kurulu olduğu için geçiş mevsimlerini ilkbahar-sonbahar diye eklemek sinyal değil gürültü olur.
  END as Season,
  
  -- İptal Sayısı
  COUNTIF(Is_Cancelled = 1) as Cancelled_Flights,
  
  -- Gecikme Nedenleri (Sadece gerçekleşen uçuşlarda ortalama)
  ROUND(AVG(IF(Is_Cancelled=0, Delay_Weather, NULL)), 2) as Avg_Weather_Delay, --SUM değil AVG kullandık çünkü:Ortalama alarak şunu soruyoruz: "Uçak başına düşen hava durumu gecikmesi ne kadar?"
  ROUND(AVG(IF(Is_Cancelled=0, Delay_NAS, NULL)), 2) as Avg_NAS_Delay, -- Operasyonel Yoğunluk
  ROUND(AVG(IF(Is_Cancelled=0, Delay_Carrier, NULL)), 2) as Avg_Carrier_Delay,
  
  COUNT(*) as Total_Flights

FROM `aviation-480106.aviation_ds2.master_table`
GROUP BY 1, 2
ORDER BY 1;
