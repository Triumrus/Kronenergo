/*ЭТО Join факта с фактом погоды для train*/


select distinct a.DATE as DATE_FACT,a.HOUR as HOUR_FACT,a.FACT
,w.DATE
,w.HOUR
,dt
,dt_iso
,city_id
,city_name
,lat
,lon
,temp
,temp_min
,temp_max
,pressure
,sea_level
,grnd_level
,humidity
,wind_speed
,wind_deg
,rain_1h
,rain_3h
,rain_24h
,rain_today
,snow_1h
,snow_3h
,snow_24h
,snow_today
,clouds_all
,weather_id
,weather_main
,weather_description
,weather_icon
,dt_iso_2
,w.id  
FROM energo.fact_energoeffect a
-- черз join по полю ID выбираем послдние запись по фатку
inner join (
SELECT max(id) as id FROM energo.fact_energoeffect
group by DATE,HOUR) b
on a.id=b.id
-- черз join по DATE(dt_iso_2) as DATE,HOUR(dt_iso_2) HOUR+1 добавляем погоду в факте не каждый есть час скакого то приода начинаеться факт погода каждые два часа поэтому к часу прибаляем один
left join (SELECT DATE(dt_iso_2) as DATE,HOUR(dt_iso_2) as HOUR,we.dt
,dt_iso
,city_id
,city_name
,lat
,lon
,temp
,temp_min
,temp_max
,pressure
,sea_level
,grnd_level
,humidity
,wind_speed
,wind_deg
,rain_1h
,rain_3h
,rain_24h
,rain_today
,snow_1h
,snow_3h
,snow_24h
,snow_today
,clouds_all
,weather_id
,weather_main
,weather_description
,weather_icon
,dt_iso_2
,id  
FROM energo.historical_data_weather we) w
on a.DATE=w.DATE and (a.HOUR = w.HOUR or a.HOUR = w.HOUR+1)