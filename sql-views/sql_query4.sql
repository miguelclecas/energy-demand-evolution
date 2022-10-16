SELECT
  CAST(gen.date AS string) AS date,
  CAST(gen.hour AS string) AS hour,
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