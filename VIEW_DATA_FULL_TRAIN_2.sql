select  a.DATE as DATE_FACT,a.HOUR as HOUR_FACT,a.FACT
,a.id
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

inner join (
SELECT max(id) as id FROM energo.fact_energoeffect
group by DATE,HOUR) b
on a.id=b.id

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
,@quot+1 as lag_quot
,@quot:=HOUR(dt_iso_2) curr_quote
FROM  (
select a.* 
from energo.historical_data_weather a
inner join (
select max(id) as id
from energo.historical_data_weather
group by dt_iso_2) b
on a.id=b.id

) we
join (select @quot= -1 ) r

order by dt_iso_2
) w
on a.DATE=w.DATE and a.HOUR = 
case 
when a.HOUR = w.HOUR then  w.HOUR
when a.HOUR != w.HOUR then  w.lag_quot
end  
