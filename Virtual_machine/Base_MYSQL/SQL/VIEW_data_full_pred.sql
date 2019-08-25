
SELECT * FROM (SELECT a.* FROM energo.fact_energoeffect a
inner join (select date,hour,max(ID) as id from energo.fact_energoeffect
group by date,hour
) b
on a.ID=b.id) a
left join (select a.* from energo.weather a
inner join (select date,hour,max(id) as id from energo.weather
group by date,hour
) b

on a.date = b.date
and a.hour = b.hour
and a.id = b.id
) weather
on a.DATE= weather.date
and a.HOUR= weather.hour


;