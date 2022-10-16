WITH genem AS
  (
    SELECT gen.date, SUM(gen.generation) AS generation, SUM(em.emission) AS emission
    FROM `energy-ree-project.energy_generic_info.energy-generation-ree` AS gen
    LEFT JOIN `energy-ree-project.energy_generic_info.co2-emission-ree` AS em
    ON gen.date = em.date
      AND gen.hour = em.hour
      AND gen.energy_source_id = em.energy_source_id
    GROUP BY gen.date
  )
  SELECT genem.date, genem.generation, genem.emission, dem.demand,
    CASE WHEN EXTRACT(month FROM genem.date) < 4 THEN 'winter'
      WHEN EXTRACT(month FROM genem.date) < 7 THEN 'spring'
      WHEN EXTRACT(month FROM genem.date) < 10 THEN 'summer'
      ELSE 'autumn' END AS season
  FROM genem
  LEFT JOIN
  (
    SELECT date, SUM(real) AS demand
    FROM `energy-ree-project.energy_generic_info.energy-demand-ree`
    GROUP BY date
  ) AS dem
  ON genem.date = dem.date;