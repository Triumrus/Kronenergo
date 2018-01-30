select 
a.date
,a.hour
,a.HOUR
,FACT
,temp
,temp_min
,temp_max
,pressure
sea_level
,grnd_level
,humidity
,weather_id
,main
,description
,icon
,alll
,speed
,deg
,rain

from (
select ID,DATE(DATE) AS DATE,HOUR,FACT,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect 
union 
(select max(ID)+24 as ID, DATE_ADD(DATE(b.DATE), INTERVAL 1 DAY) as DATE,HOUR,FACT = NULL as FACT,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect b
group by DATE,HOUR,ID_COMPANY,ID_GTP,CITY_ID,FACT
order by DATE(DATE) desc ,HOUR
limit 24
)
)a
left join energo.weather b
on a.DATE = b.DATE
and a.HOUR = b.HOUR
and a.CITY_ID = b.city_id
