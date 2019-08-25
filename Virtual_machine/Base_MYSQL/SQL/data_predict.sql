select 
a.DATE
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
select DATE(DATE) AS DATE,HOUR,FACT,ID_COMPANY,ID_GTP,CITY_ID from (select a.* from energo.fact_energoeffect a
inner join (
select DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval -7 DAY) as pre ,
ID_COMPANY,ID_GTP,CITY_ID 
from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID)
b
on 
a.ID_COMPANY =b.ID_COMPANY
and a.ID_GTP = a.ID_GTP
and a.CITY_ID = b.CITY_ID 
and DATE_ADD(CONVERT(a.DATE,DATETIME),INTERVAL a.HOUR HOUR) >= b.pre
) fact_lag 
union all
select DATE,HOUR,NULL as FACT,ID_COMPANY,ID_GTP,CITY_ID from 
(select a.ID,DATE(DATE_ADD(DATE_ADD(CONVERT(a.DATE,DATETIME),INTERVAL a.HOUR HOUR), interval 37 HOUR)) AS DATE,
HOUR(DATE_ADD(DATE_ADD(CONVERT(a.DATE,DATETIME),INTERVAL a.HOUR HOUR), interval 37 HOUR)) AS HOUR,
a.FACT,a.DATE_ZALIVA,a.ID_COMPANY,a.ID_GTP,a.CITY_ID
from energo.fact_energoeffect a inner join
(select DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval -37 HOUR) as pre ,
ID_COMPANY,ID_GTP,CITY_ID 
from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID) pre
on a.CITY_ID = pre.CITY_ID
and a.ID_GTP = pre.ID_GTP
and a.ID_COMPANY = pre.ID_COMPANY
and DATE_ADD(CONVERT(a.DATE,DATETIME),INTERVAL a.HOUR HOUR) > pre.pre
)pree
)a
left join energo.factory_calendar f
on DATE(a.date) = f.dt
left join (select * FROM energo.weather a
inner join (
select MAX(ID) as ID2 FROM energo.weather
group by date,hour,city_id
) b
on a.ID = b.ID2) b
on a.DATE = b.DATE
and a.HOUR = b.HOUR
and a.CITY_ID = b.city_id
where 1=1
and a.ID_COMPANY = 2
and a.ID_GTP = 1