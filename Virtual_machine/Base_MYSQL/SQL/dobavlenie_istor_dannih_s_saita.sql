
/*Создаем клоны на вский случай если что то не так пойдет*/
/*
piter2 - таблица import wizard погоды с сайта
*/
;

drop table tbl_new;
drop table clone_historical_data_weather;
CREATE TABLE tbl_new AS SELECT * FROM piter2;
CREATE TABLE clone_historical_data_weather AS SELECT * FROM historical_data_weather;


/*преобразоваем цифры в нужный формат*/;

SET SQL_SAFE_UPDATES = 0;
UPDATE tbl_new 
SET 
rain_1h =(case when rain_1h != '' then cast(rain_1h as DECIMAL (12,3)) when rain_1h = '' then null end),
rain_3h =(case when rain_3h != '' then cast(rain_3h as DECIMAL (12,3)) when rain_3h = '' then null end),
rain_24h =(case when rain_24h != '' then cast(rain_24h as DECIMAL (12,3)) when rain_24h = '' then null end),
rain_today =(case when rain_today != '' then cast(rain_today as DECIMAL (12,3)) when rain_today = '' then null end),
snow_1h =(case when snow_1h != '' then cast(snow_1h as DECIMAL (12,3)) when snow_1h = '' then null end),
snow_3h =(case when snow_3h != '' then cast(snow_3h as DECIMAL (12,3)) when snow_3h = '' then null end),
snow_24h =(case when snow_24h != '' then cast(snow_24h as DECIMAL (12,3)) when snow_24h = '' then null end),
snow_today =(case when snow_today != '' then cast(snow_today as DECIMAL (12,3)) when snow_today = '' then null end),
city_name = case when city_name = '' then null end,
lat = case when lat = '' then null end,
lon = case when lon = '' then null end,
sea_level = case when sea_level = '' then null end,
grnd_level = case when grnd_level = '' then null end;



/*меняем формат еще разок*/;

UPDATE tbl_new set 
rain_1h =  convert (rain_1h , DECIMAL(12,3)),
rain_3h =  convert (rain_3h , DECIMAL(12,3)),
rain_24h =  convert (rain_24h , DECIMAL(12,3)),
rain_today =  convert (rain_today , DECIMAL(12,3)),
snow_1h =  convert (snow_1h , DECIMAL(12,3)),
snow_3h =  convert (snow_3h , DECIMAL(12,3)),
snow_24h =  convert (snow_24h , DECIMAL(12,3)),
snow_today =  convert (snow_today , DECIMAL(12,3))
;

/*меняем формат на DOUBLE */;

ALTER TABLE `energo`.`tbl_new` 
CHANGE COLUMN `rain_1h` `rain_1h` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `rain_3h` `rain_3h` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `rain_24h` `rain_24h` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `rain_today` `rain_today` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `snow_1h` `snow_1h` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `snow_3h` `snow_3h` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `snow_24h` `snow_24h` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `snow_today` `snow_today` DOUBLE NULL DEFAULT NULL ;


/*переводи в цельси*/

UPDATE tbl_new set 
temp = case when temp > 200 then round(temp - 273.15,2) else temp end ,
temp_min = case when temp_min > 200 then round(temp_min - 273.15,2) else temp_min end, 
temp_max = case when temp_max > 200 then round(temp_max - 273.15,2) else temp_max end 
;

/*чек что все ок по фрматам*/;

select * from tbl_new

/*добавляем значения в таблицу*/;

INSERT INTO historical_data_weather (
`historical_data_weather`.`dt`,
    `historical_data_weather`.`dt_iso`,
    `historical_data_weather`.`city_id`,
    `historical_data_weather`.`city_name`,
    `historical_data_weather`.`lat`,
    `historical_data_weather`.`lon`,
    `historical_data_weather`.`temp`,
    `historical_data_weather`.`temp_min`,
    `historical_data_weather`.`temp_max`,
    `historical_data_weather`.`pressure`,
    `historical_data_weather`.`sea_level`,
    `historical_data_weather`.`grnd_level`,
    `historical_data_weather`.`humidity`,
    `historical_data_weather`.`wind_speed`,
    `historical_data_weather`.`wind_deg`,
    `historical_data_weather`.`rain_1h`,
    `historical_data_weather`.`rain_3h`,
    `historical_data_weather`.`rain_24h`,
    `historical_data_weather`.`rain_today`,
    `historical_data_weather`.`snow_1h`,
    `historical_data_weather`.`snow_3h`,
    `historical_data_weather`.`snow_24h`,
    `historical_data_weather`.`snow_today`,
    `historical_data_weather`.`clouds_all`,
    `historical_data_weather`.`weather_id`,
    `historical_data_weather`.`weather_main`,
    `historical_data_weather`.`weather_description`,
    `historical_data_weather`.`weather_icon`,
        `historical_data_weather`.`date_zaliva`) SELECT 
    `tbl_new`.`dt`,
    `tbl_new`.`dt_iso`,
    `tbl_new`.`city_id`,
    `tbl_new`.`city_name`,
    `tbl_new`.`lat`,
    `tbl_new`.`lon`,
    `tbl_new`.`temp`,
    `tbl_new`.`temp_min`,
    `tbl_new`.`temp_max`,
    `tbl_new`.`pressure`,
    `tbl_new`.`sea_level`,
    `tbl_new`.`grnd_level`,
    `tbl_new`.`humidity`,
    `tbl_new`.`wind_speed`,
    `tbl_new`.`wind_deg`,
    `tbl_new`.`rain_1h`,
    `tbl_new`.`rain_3h`,
    `tbl_new`.`rain_24h`,
    `tbl_new`.`rain_today`,
    `tbl_new`.`snow_1h`,
    `tbl_new`.`snow_3h`,
    `tbl_new`.`snow_24h`,
    `tbl_new`.`snow_today`,
    `tbl_new`.`clouds_all`,
    `tbl_new`.`weather_id`,
    `tbl_new`.`weather_main`,
    `tbl_new`.`weather_description`,
    `tbl_new`.`weather_icon`
    , DATE_ADD(sysdate(), INTERVAL 4 HOUR) as date_zaliva
        FROM tbl_new;
        
/*проверяем что все ОК*/
       
SELECT * FROM energo.historical_data_weather
where date_zaliva > DATE_ADD(sysdate(), INTERVAL -1 DAY)
order by id desc
;
select distinct city_id FROM energo.historical_data_weather;
select  * FROM historical_data_weather
order by id desc;



/*ЕСЛИ ВСЕ ОК ДРОПАЕМ ЛИШНЕЕ*/;

drop table tbl_new;
drop table clone_historical_data_weather;
drop table piter2;

/*Postgrech не понятно как переводит время но с UNIX  на время он ошибается на 4 часа*/

SET SQL_SAFE_UPDATES = 0;
UPDATE energo.historical_data_weather  
SET dt_iso_2 = FROM_UNIXTIME(dt) + interval 4 hour;

/*время очень сранное в таблицах храниться*/

#select dt,FROM_UNIXTIME(dt),dt_iso,FROM_UNIXTIME(dt) + interval 4 hour from energo.historical_data_weather  ;