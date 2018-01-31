select 
a.date
,a.HOUR
,FACT
,temp
,temp_min
,temp_max
,pressure
,sea_level
,grnd_level
,humidity
,speed
,deg
,rain
,snow
,alll
,weather_id
,main
,description
,icon
,a.CITY_ID
,a.ID_GTP
,a.ID_COMPANY
,f.day_dt
from (
select ID,DATE(DATE) AS DATE,HOUR,FACT,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect 
union 
(select max(ID)+24 as ID, DATE_ADD(DATE(b.DATE), INTERVAL 1 DAY) as DATE,HOUR,FACT = NULL as FACT,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect b
group by DATE,HOUR,ID_COMPANY,ID_GTP,CITY_ID,FACT
order by DATE(DATE) desc ,HOUR
limit 24
)
)a
left join energo.factory_calendar f
on DATE(a.date) = f.dt
left join energo.weather b
on a.DATE = b.DATE
and a.HOUR = b.HOUR
and a.CITY_ID = b.city_id
where a.date >= date_add(DATE(sysdate()),interval -7 day)
