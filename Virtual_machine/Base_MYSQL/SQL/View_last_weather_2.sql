select a.* from energo.weather a
inner join (select date,hour,max(id) as id from energo.weather
group by date,hour
) b
on a.id = b.id
