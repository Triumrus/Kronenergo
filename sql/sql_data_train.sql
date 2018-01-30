select  
a.DATE 
,a.HOUR 
,a.FACT
,temp
,temp_min
,temp_max
,pressure
,sea_level
,grnd_level
,humidity
,wind_speed as speed
,wind_deg as deg
,rain_3h as rain
,snow_3h as snow
,clouds_all as alll
,weather_id
,weather_main as main
,weather_description as description
,weather_icon as icon
,a.CITY_ID
,a.ID_GTP
,a.ID_COMPANY
FROM energo.fact_energoeffect a

inner join (
SELECT max(id) as id FROM energo.fact_energoeffect
group by DATE,HOUR) b
on a.id=b.id

left join (SELECT DATE(dt_iso_2) as DATE,HOUR(dt_iso_2) as HOUR,city_id,we.dt
,dt_iso
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
,@quot as lag_quot
,@quot:=(HOUR(dt_iso_2)+1) curr_quote
,@quot2 as lag_quot2
,@quot2:=(HOUR(dt_iso_2)+2) curr_quote2
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
join (select @quot= -2 ) r2

order by dt_iso_2
) w
on a.DATE=w.DATE 
and a.CITY_ID = w.city_id
and a.HOUR = 
case 
when a.HOUR = w.HOUR then  w.HOUR
when a.HOUR != w.HOUR and a.HOUR != w.curr_quote then  w.curr_quote2
when a.HOUR != w.HOUR  then  w.curr_quote
end  
left join factory_calendar f
on a.DATE = f.dt
