

import pandas as pd
import os

# Python dosyasının (script) çalıştığı klasörü otomatik bulmak için:
script_dir = os.path.dirname(os.path.abspath(__file__))

# Böylece terminal nerede olursa olsun, dosyaları bulur
PATH_FLIGHTS   = os.path.join(script_dir, 'US_flights_2023.csv')
PATH_WEATHER   = os.path.join(script_dir, 'weather_meteo_by_airport.csv')
PATH_AIRPORTS  = os.path.join(script_dir, 'airports_geolocation.csv')
PATH_CANCELLED = os.path.join(script_dir, 'Cancelled_Diverted_2023.csv')
def check_flights():
    print("\n" + "="*40)
    print("✈️  1. UÇUŞ VERİSİ KONTROLÜ (US_flights)")
    print("="*40)
    
    #sadece ilk 100 bin satır
    try:
        df = pd.read_csv(PATH_FLIGHTS, nrows=100000)
        print(f"✅ Dosya okundu. Örneklem Boyutu: {len(df)} satır")
        
        # diğer kritik kontroller
        nulls = df[['Arr_Delay', 'Dep_Delay', 'Airline']].isnull().sum()
        print(f"\n--- Kritik Eksik Veriler ---\n{nulls[nulls > 0]}")
        
        neg_time = df[df['Flight_Duration'] < 0]
        print(f"\n--- Mantıksal Hatalar ---")
        print(f"Negatif Uçuş Süresi Sayısı: {len(neg_time)}")
        
    except FileNotFoundError:
        print("❌ HATA: Uçuş dosyası bulunamadı! Yolu kontrol et.")

def check_weather():
    print("\n" + "="*40)
    print("⛈️  2. HAVA DURUMU KONTROLÜ (Weather)")
    print("="*40)
    
    try:
        df = pd.read_csv(PATH_WEATHER)
        print(f"✅ Dosya okundu. Toplam: {len(df)} satır")
        
        # hava durumu null değer kontrolü
        missing_weather = df[['wspd', 'prcp', 'snow', 'pres']].isnull().sum()
        print(f"\n--- Eksik Meteorolojik Değerler ---\n{missing_weather[missing_weather > 0]}")
        
    except FileNotFoundError:
        print("❌ HATA: Hava durumu dosyası bulunamadı!")

def check_airports():
    print("\n" + "="*40)
    print("📍 3. HAVALİMANI KONTROLÜ (Geolocation)")
    print("="*40)
    
    try:
        df = pd.read_csv(PATH_AIRPORTS)
        print(f"✅ Dosya okundu. Toplam Havalimanı: {len(df)}")
        
        # harita çizimi için koordinat önemli, koordinat kontrolü
        missing_loc = df[df['LATITUDE'].isnull() | df['LONGITUDE'].isnull()]
        print(f"\n--- Koordinatı Eksik Havalimanları ---")
        if len(missing_loc) > 0:
            print(f"Sayı: {len(missing_loc)}")
            print(missing_loc['IATA_CODE'].unique())
        else:
            print("Mükemmel! Tüm havalimanlarının koordinatı tam.")
            
    except FileNotFoundError:
        print("❌ HATA: Havalimanı dosyası bulunamadı!")

def check_cancelled():
    print("\n" + "="*40)
    print("⚠️  4. İPTAL VERİSİ KONTROLÜ (Risk Labels)")
    print("="*40)
    
    try:
        df = pd.read_csv(PATH_CANCELLED)
        print(f"✅ Dosya okundu. Toplam İptal/Divert: {len(df)}")
        
        # İptal kodu kontrolü
        if 'Cancelled' in df.columns:
            print(f"\nİptal edilen uçuş sayısı: {df['Cancelled'].sum()}")
        else:
            print("\nUYARI: 'Cancelled' sütunu bulunamadı!")

    except FileNotFoundError:
        print("❌ HATA: İptal dosyası bulunamadı!")

if __name__ == "__main__":
    print("🔍 VERİ DEDEKTİFİ BAŞLATILIYOR...")
    check_flights()
    check_weather()
    check_airports()
    check_cancelled()
    print("\n✅ KONTROL TAMAMLANDI. Raporu yukarıdan inceleyin.")