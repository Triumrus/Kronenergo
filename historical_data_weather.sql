#Преобразование столбцов из текста в DECIMAL . Для данных из History Bulk
SET SQL_SAFE_UPDATES = 0;
SET SESSION sql_mode = '';
update energo.historical_data_weather set
snow_1h = case
 when CONVERT(snow_1h,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(snow_1h,DECIMAL(9,3))
 end ,
 snow_3h =case
 when CONVERT(snow_3h,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(snow_3h,DECIMAL(9,3))
 end , 
 snow_24h = case
 when CONVERT(snow_24h,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(snow_24h,DECIMAL(9,3))
 end , 
snow_today = case
 when CONVERT(snow_today,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(snow_today,DECIMAL(9,3))
 end ,	
 rain_1h = case
 when CONVERT(rain_1h,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(rain_1h,DECIMAL(9,3))
 end ,
rain_3h = case
 when CONVERT(rain_3h,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(rain_3h,DECIMAL(9,3))
 end ,
 rain_24h = case
 when CONVERT(rain_24h,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(rain_24h,DECIMAL(9,3))
 end ,
rain_today	= case
 when CONVERT(rain_today,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(rain_today,DECIMAL(9,3))
 end ,
sea_level = case
 when CONVERT(sea_level,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(sea_level,DECIMAL(9,3))
 end ,
 grnd_level = case
 when CONVERT(grnd_level,DECIMAL(9,3)) =0 then NULL 
 else CONVERT(grnd_level,DECIMAL(9,3))
 end 
