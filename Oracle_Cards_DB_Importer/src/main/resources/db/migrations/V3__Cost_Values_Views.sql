
--Value Averages by Color and Rarity*/
CREATE OR REPLACE VIEW color_value_average AS
SELECT c.color_identity,
       COUNT(c.id) AS total_cards,
       ROUND(AVG(c.usd), 2) AS avg_usd,
       ROUND(AVG(c.usd_foil), 2) AS avg_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 5 THEN c.usd ELSE NULL END), 2) AS avg_common_usd,
       ROUND(AVG(CASE WHEN r.id = 4 THEN c.usd ELSE NULL END), 2) AS avg_uncommon_usd,
       ROUND(AVG(CASE WHEN r.id = 3 THEN c.usd ELSE NULL END), 2) AS avg_rare_usd,
       ROUND(AVG(CASE WHEN r.id = 1 THEN c.usd ELSE NULL END), 2) AS avg_mythic_usd,
       ROUND(AVG(CASE WHEN r.id = 2 THEN c.usd ELSE NULL END), 2) AS avg_special_usd,
       ROUND(AVG(CASE WHEN r.id = 5 THEN c.usd_foil ELSE NULL END), 2) AS avg_common_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 4 THEN c.usd_foil ELSE NULL END), 2) AS avg_uncommon_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 3 THEN c.usd_foil ELSE NULL END), 2) AS avg_rare_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 1 THEN c.usd_foil ELSE NULL END), 2) AS avg_mythic_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 2 THEN c.usd_foil ELSE NULL END), 2) AS avg_special_usd_foil
FROM cards c
JOIN rarity r ON c.rarity::INTEGER = r.id
GROUP BY c.color_identity
ORDER BY total_cards DESC;



--Value Averages by Artist and Rarity*/
CREATE OR REPLACE VIEW artist_value_average AS
SELECT a.name AS artist_name,
       COUNT(c.id) AS total_cards,
       ROUND(AVG(c.usd), 2) AS avg_usd,
       ROUND(AVG(c.usd_foil), 2) AS avg_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 5 THEN c.usd ELSE NULL END), 2) AS avg_common_usd,
       ROUND(AVG(CASE WHEN r.id = 4 THEN c.usd ELSE NULL END), 2) AS avg_uncommon_usd,
       ROUND(AVG(CASE WHEN r.id = 3 THEN c.usd ELSE NULL END), 2) AS avg_rare_usd,
       ROUND(AVG(CASE WHEN r.id = 1 THEN c.usd ELSE NULL END), 2) AS avg_mythic_usd,
       ROUND(AVG(CASE WHEN r.id = 2 THEN c.usd ELSE NULL END), 2) AS avg_special_usd,
       ROUND(AVG(CASE WHEN r.id = 5 THEN c.usd_foil ELSE NULL END), 2) AS avg_common_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 4 THEN c.usd_foil ELSE NULL END), 2) AS avg_uncommon_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 3 THEN c.usd_foil ELSE NULL END), 2) AS avg_rare_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 1 THEN c.usd_foil ELSE NULL END), 2) AS avg_mythic_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 2 THEN c.usd_foil ELSE NULL END), 2) AS avg_special_usd_foil
FROM cards c
JOIN artist a ON c.artist::INTEGER = a.id
JOIN rarity r ON c.rarity::INTEGER = r.id
GROUP BY a.name
ORDER BY total_cards DESC;

--Value Averages by Set and Rarity*/
CREATE OR REPLACE VIEW set_value_average AS
SELECT s.set_name,
       EXTRACT(YEAR FROM s.release_date) AS release_year,
       COUNT(c.id) AS total_cards,
       ROUND(AVG(c.usd), 2) AS avg_usd,
       ROUND(AVG(c.usd_foil), 2) AS avg_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 5 THEN c.usd ELSE NULL END), 2) AS avg_common_usd,
       ROUND(AVG(CASE WHEN r.id = 4 THEN c.usd ELSE NULL END), 2) AS avg_uncommon_usd,
       ROUND(AVG(CASE WHEN r.id = 3 THEN c.usd ELSE NULL END), 2) AS avg_rare_usd,
       ROUND(AVG(CASE WHEN r.id = 1 THEN c.usd ELSE NULL END), 2) AS avg_mythic_usd,
       ROUND(AVG(CASE WHEN r.id = 2 THEN c.usd ELSE NULL END), 2) AS avg_special_usd,
       ROUND(AVG(CASE WHEN r.id = 5 THEN c.usd_foil ELSE NULL END), 2) AS avg_common_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 4 THEN c.usd_foil ELSE NULL END), 2) AS avg_uncommon_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 3 THEN c.usd_foil ELSE NULL END), 2) AS avg_rare_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 1 THEN c.usd_foil ELSE NULL END), 2) AS avg_mythic_usd_foil,
       ROUND(AVG(CASE WHEN r.id = 2 THEN c.usd_foil ELSE NULL END), 2) AS avg_special_usd_foil
FROM cards c
JOIN set_data s ON c.set_data_id::INTEGER = s.id
JOIN rarity r ON c.rarity::INTEGER = r.id
GROUP BY s.set_name, release_year
ORDER BY release_year DESC;



