# Perenos historical date in weather

INSERT INTO weather (date, hour, city_id, temp,temp_min,temp_max,pressure,sea_level,grnd_level,humidity,weather_id,main,description,icon,alll,speed,deg,rain,snow)
SELECT DATE(dt_iso_2), HOUR(dt_iso_2), city_id, temp,temp_min,temp_max,pressure,sea_level,grnd_level,humidity,weather_id,weather_main,weather_description,weather_icon,clouds_all,wind_speed,wind_deg,rain_3h,snow_3h
FROM historical_data_weather
WHERE city_id = 545575
and DATE(dt_iso_2) >= '2018-06-01' ;


/*UNION historical_data_weather - weather Соотношение столбцов прогноза на факт данных

* DATE(dt_iso_2) = date
* HOUR(dt_iso_2) = hour
* city_id = city_id
* temp = temp
* temp_min = temp_min
* temp_max = temp_max
* pressure = pressure
* sea_level = sea_level
* grnd_level = grnd_level
* humidity = humidity
* weather_id = weather_id
* weather_main = main
* weather_description = description
* weather_icon = icon
* clouds_all = alll
* wind_speed = speed
* wind_deg = deg
* rain_3h = rain
* snow_3h = snow
*/