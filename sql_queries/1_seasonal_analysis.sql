--1.Hipotez: Mevsimsel Analiz
-- Amaç: Aylara göre hangi gecikme türünün baskın olduğunu bulmak.

--CREATE TABLE `aviation-480106.aviation_ds2.summary_seasonal` AS>>SORGUYU ÇALIŞTIRIP ZATEN TABLO CREATE ETTİĞİMİZ İÇİN BUNU ETİKETLEDİM.
-- create table diyerek hipotezimiz için looker a aktarabileceğimiz küçük bir özet tablo-Data Mart- oluşturduk.
SELECT
  EXTRACT(MONTH FROM FlightDate) as Month,
  --flightdate sütunu date formatındaydı zaten, biz de direkt month diyerek o uçuşun hangi ayda olduğu bilgisini çektik.
  CASE
    WHEN EXTRACT(MONTH FROM FlightDate) IN (12, 1, 2) THEN 'Winter' -- 12-1-2 bu aylar kış kabul edildiği için, Month sütununda bu aylardan herhangi birini görürse 'winter' olarak etiketlemesini öğrettik. (label yaptık)
    WHEN EXTRACT(MONTH FROM FlightDate) IN (6, 7, 8) THEN 'Summer'
    ELSE 'Transition' -- yaz ve kış ayları dışındaki diğer ayları geçiş dönemi olarak ayırdık. Bizim hipotezimiz zıtlar-uçlar üzerine kurulu olduğu için geçiş mevsimlerini ilkbahar-sonbahar diye eklemek sinyal değil gürültü olur.
  END as Season,
  ROUND(AVG(Delay_Weather),2) as Avg_Weather_Delay,--SUM değil AVG kullandık çünkü:Ortalama alarak şunu soruyoruz: "Uçak başına düşen hava durumu gecikmesi ne kadar?"
  ROUND(AVG(Delay_NAS),2) as Avg_NAS_Delay, -- Operasyonel Yoğunluk
  ROUND(AVG(Delay_Carrier),2) as Avg_Carrier_Delay,
  COUNT(*) as Total_Flights
FROM `aviation-480106.aviation_ds2.us_flights_2023_raw`
GROUP BY 1, 2
ORDER BY 1;
