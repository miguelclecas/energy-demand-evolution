SELECT date, cast(hour as string) as hour, real, expected, scheduled, EXTRACT(month FROM date) AS month, 
  CASE WHEN EXTRACT(month FROM date) < 4 THEN 'winter'
    WHEN EXTRACT(month FROM date) < 7 THEN 'spring'
    WHEN EXTRACT(month FROM date) < 10 THEN 'summer'
    ELSE 'autumn' END AS season,
  CASE WHEN date < '2021-08-01' THEN '20-21'
    ELSE '21-22' END AS year
FROM `energy-ree-project.energy_generic_info.energy-demand-ree`
ORDER BY date, hour;