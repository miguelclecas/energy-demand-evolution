SELECT
  CAST(gen.date AS string) AS date,
  CAST(gen.hour AS string) AS hour,
  EXTRACT(month
  FROM
    gen.date) AS month,
  CASE
    WHEN EXTRACT(month FROM gen.date) < 4 THEN 'winter'
    WHEN EXTRACT(month
  FROM
    gen.date) < 7 THEN 'spring'
    WHEN EXTRACT(month FROM gen.date) < 10 THEN 'summer'
  ELSE
  'autumn'
END
  AS season,
  CASE
    WHEN gen.date < '2021-08-01' THEN '20-21'
  ELSE
  '21-22'
END
  AS year,
  gen.generation,
  em.emission,
  tm.energy_source_name_en,
  tm.energy_source_class_1
FROM
  `energy-ree-project.energy_generic_info.energy-generation-ree` AS gen
LEFT JOIN
  `energy-ree-project.energy_generic_info.co2-emission-ree` AS em
ON
  gen.date = em.date
  AND gen.hour = em.hour
  AND gen.energy_source_id = em.energy_source_id
LEFT JOIN
  `energy-ree-project.energy_generic_info.dim-basic-energy-data` AS tm
ON
  gen.energy_source_id = tm.energy_source_id;