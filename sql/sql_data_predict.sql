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
select DATE(DATE) AS DATE,HOUR,FACT,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect 
union all
select DATE,HOUR,NULL as FACT,ID_COMPANY,ID_GTP,CITY_ID from 
(select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 1 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 1 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 2 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 2 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 3 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 3 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 4 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 4 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 5 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 5 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 6 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 6 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 7 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 7 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 8 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 8 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 9 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 9 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 10 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 10 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 11 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 11 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 12 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 12 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 13 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 13 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 14 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 14 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 15 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 15 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 16 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 16 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 17 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 17 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 18 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 18 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 19 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 19 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 20 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 20 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 21 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 21 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 22 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 22 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 23 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 23 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 24 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 24 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 25 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 25 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 26 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 26 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 27 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 27 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 28 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 28 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 29 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 29 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 30 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 30 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 31 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 31 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 32 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 32 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 33 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 33 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
union all
select DATE(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 34 HOUR)) AS DATE, HOUR(DATE_ADD(max(DATE_ADD(CONVERT(DATE,DATETIME),INTERVAL HOUR HOUR)), interval 34 HOUR)) AS HOUR,ID_COMPANY,ID_GTP,CITY_ID from energo.fact_energoeffect
group by ID_COMPANY,ID_GTP,CITY_ID
)pree
)a
left join energo.factory_calendar f
on DATE(a.date) = f.dt
left join (select * FROM energo.weather a
inner join (
select MAX(ID) as ID2 FROM energo.weather
group by date,hour
) b
on a.ID = b.ID2) b
on a.DATE = b.DATE
and a.HOUR = b.HOUR
and a.CITY_ID = b.city_id
where 1=1
and a.date >= date_add(DATE(sysdate()),interval -7 day)
and ID_GTP = 1
order by 1 desc ,2 desc
