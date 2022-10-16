SELECT
  SUM(gen.generation) AS generation,
  SUM(em.emission) AS emission,
  tm.energy_source_name_en,
  tm.energy_source_class_1,
  SUM(SUM(gen.generation)) OVER(PARTITION BY tm.energy_source_class_1 ) AS source_class_total,
  SUM(gen.generation)*100/(SUM(SUM(gen.generation)) OVER(PARTITION BY tm.energy_source_class_1)) AS generation_percentage_by_class,
  SUM(em.emission)*100/(SUM(SUM(em.emission)) OVER ()) AS emission_percentage,
  SUM(gen.generation)*100/(SUM(SUM(gen.generation)) OVER ()) AS generation_percentage
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
  gen.energy_source_id = tm.energy_source_id
GROUP BY
  tm.energy_source_name_en,
  tm.energy_source_class_1
ORDER BY
  energy_source_class_1;