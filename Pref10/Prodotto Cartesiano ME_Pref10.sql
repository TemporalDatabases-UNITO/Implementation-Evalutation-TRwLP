CREATE INDEX idx_gin_t3_lvl1 ON t1_me_pref10 USING gin (lvl1);
CREATE INDEX idx_gin_t4_lvl1 ON t2_me_pref10 USING gin (lvl1);

CREATE INDEX idx_gin_t3_lvl2 ON t1_me_pref10 USING gin (lvl2);
CREATE INDEX idx_gin_t4_lvl2 ON t2_me_pref10 USING gin (lvl2);

CREATE INDEX idx_gin_t3_lvl3 ON t1_me_pref10 USING gin (lvl3);
CREATE INDEX idx_gin_t4_lvl3 ON t2_me_pref10 USING gin (lvl3);

CREATE INDEX idx_gin_t3_lvl4 ON t1_me_pref10 USING gin (lvl4);
CREATE INDEX idx_gin_t4_lvl4 ON t2_me_pref10 USING gin (lvl4);

CREATE INDEX idx_gin_t3_lvl5 ON t1_me_pref10 USING gin (lvl5);
CREATE INDEX idx_gin_t4_lvl5 ON t2_me_pref10 USING gin (lvl5);

CREATE INDEX idx_gin_t3_lvl6 ON t1_me_pref10 USING gin (lvl6);
CREATE INDEX idx_gin_t4_lvl6 ON t2_me_pref10 USING gin (lvl6);

CREATE INDEX idx_gin_t3_lvl7 ON t1_me_pref10 USING gin (lvl7);
CREATE INDEX idx_gin_t4_lvl7 ON t2_me_pref10 USING gin (lvl7);

CREATE INDEX idx_gin_t3_lvl8 ON t1_me_pref10 USING gin (lvl8);
CREATE INDEX idx_gin_t4_lvl8 ON t2_me_pref10 USING gin (lvl8);

CREATE INDEX idx_gin_t3_lvl9 ON t1_me_pref10 USING gin (lvl9);
CREATE INDEX idx_gin_t4_lvl9 ON t2_me_pref10 USING gin (lvl9);

CREATE INDEX idx_gin_t3_lvl10 ON t1_me_pref10 USING gin (lvl10);
CREATE INDEX idx_gin_t4_lvl10 ON t2_me_pref10 USING gin (lvl10);

CREATE OR REPLACE FUNCTION prodotto_cartesiano_ME_Pref10()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150),
  lvl1 pair[],
  lvl2 pair[],
  lvl3 pair[],
  lvl4 pair[],
  lvl5 pair[],
  lvl6 pair[],
  lvl7 pair[],
  lvl8 pair[],
  lvl9 pair[],
  lvl10 pair[]
) AS $$
BEGIN
RETURN QUERY
SELECT t1_me_pref10.Attr1 AS Attr1_t1, t2_me_pref10.Attr1 AS Attr1_t2,
       t1_me_pref10.Attr2 AS Attr2_t1, t2_me_pref10.Attr2 AS Attr2_t2,
	   array_intersection(t1_me_pref10.lvl1, t2_me_pref10.lvl1) AS lvl1_pc,
	   array_intersection(t1_me_pref10.lvl2, t2_me_pref10.lvl2) AS lvl2_pc,
	   array_intersection(t1_me_pref10.lvl3 , t2_me_pref10.lvl3) AS lvl3_pc,
     array_intersection(t1_me_pref10.lvl4 , t2_me_pref10.lvl4) AS lvl4_pc,
	   array_intersection(t1_me_pref10.lvl5 , t2_me_pref10.lvl5) AS lvl5_pc,
     array_intersection(t1_me_pref10.lvl6, t2_me_pref10.lvl6) AS lvl6_pc,
	   array_intersection(t1_me_pref10.lvl7, t2_me_pref10.lvl7) AS lvl7_pc,
	   array_intersection(t1_me_pref10.lvl8 , t2_me_pref10.lvl8) AS lvl8_pc,
     array_intersection(t1_me_pref10.lvl9 , t2_me_pref10.lvl9) AS lvl9_pc,
	   array_intersection(t1_me_pref10.lvl10 , t2_me_pref10.lvl10) AS lvl10_pc


FROM t1_me_pref10, t2_me_pref10
WHERE NOT (array_intersection(t1_me_pref10.lvl1, t2_me_pref10.lvl1) = '{}');
END;
$$ LANGUAGE plpgsql;


select * from prodotto_cartesiano_ME_Pref5();