/*CREATE INDEX idx_t1_s1_pref10 ON t1_im_pref10 USING GIST (s1);
CREATE INDEX idx_t2_s1_pref10 ON t2_im_pref10 USING GIST (s1);
CREATE INDEX idx_t1_d1_pref10 ON t1_im_pref10 USING GIST (d1);
CREATE INDEX idx_t2_d1_pref10 ON t2_im_pref10 USING GIST (d1);
CREATE INDEX idx_t1_s2_pref10 ON t1_im_pref10 USING GIST (s2);
CREATE INDEX idx_t2_s2_pref10 ON t2_im_pref10 USING GIST (s2);
CREATE INDEX idx_t1_d2_pref10 ON t1_im_pref10 USING GIST (d2);
CREATE INDEX idx_t2_d2_pref10 ON t2_im_pref10 USING GIST (d2);
CREATE INDEX idx_t1_s3_pref10 ON t1_im_pref10 USING GIST (s3);
CREATE INDEX idx_t2_s3_pref10 ON t2_im_pref10 USING GIST (s3);
CREATE INDEX idx_t1_d3_pref10 ON t1_im_pref10 USING GIST (d3);
CREATE INDEX idx_t2_d3_pref10 ON t2_im_pref10 USING GIST (d3);
CREATE INDEX idx_t1_s4_pref10 ON t1_im_pref10 USING GIST (s4);
CREATE INDEX idx_t2_s4_pref10 ON t2_im_pref10 USING GIST (s4);
CREATE INDEX idx_t1_d4_pref10 ON t1_im_pref10 USING GIST (d4);
CREATE INDEX idx_t2_d4_pref10 ON t2_im_pref10 USING GIST (d4);
CREATE INDEX idx_t1_s5_pref10 ON t1_im_pref10 USING GIST (s5);
CREATE INDEX idx_t2_s5_pref10 ON t2_im_pref10 USING GIST (s5);
CREATE INDEX idx_t1_d5_pref10 ON t1_im_pref10 USING GIST (d5);
CREATE INDEX idx_t2_d5_pref10 ON t2_im_pref10 USING GIST (d5);
CREATE INDEX idx_t1_s6_pref10 ON t1_im_pref10 USING GIST (s6);
CREATE INDEX idx_t2_s6_pref10 ON t2_im_pref10 USING GIST (s6);
CREATE INDEX idx_t1_d6_pref10 ON t1_im_pref10 USING GIST (d6);
CREATE INDEX idx_t2_d6_pref10 ON t2_im_pref10 USING GIST (d6);
CREATE INDEX idx_t1_s7_pref10 ON t1_im_pref10 USING GIST (s7);
CREATE INDEX idx_t2_s7_pref10 ON t2_im_pref10 USING GIST (s7);
CREATE INDEX idx_t1_d7_pref10 ON t1_im_pref10 USING GIST (d7);
CREATE INDEX idx_t2_d7_pref10 ON t2_im_pref10 USING GIST (d7);
CREATE INDEX idx_t1_s8_pref10 ON t1_im_pref10 USING GIST (s8);
CREATE INDEX idx_t2_s8_pref10 ON t2_im_pref10 USING GIST (s8);
CREATE INDEX idx_t1_d8_pref10 ON t1_im_pref10 USING GIST (d8);
CREATE INDEX idx_t2_d8_pref10 ON t2_im_pref10 USING GIST (d8);
CREATE INDEX idx_t1_s9_pref10 ON t1_im_pref10 USING GIST (s9);
CREATE INDEX idx_t2_s9_pref10 ON t2_im_pref10 USING GIST (s9);
CREATE INDEX idx_t1_d9_pref10 ON t1_im_pref10 USING GIST (d9);
CREATE INDEX idx_t2_d9_pref10 ON t2_im_pref10 USING GIST (d9);
CREATE INDEX idx_t1_s10_pref10 ON t1_im_pref10 USING GIST (s10);
CREATE INDEX idx_t2_s10_pref10 ON t2_im_pref10 USING GIST (s10);
CREATE INDEX idx_t1_d10_pref10 ON t1_im_pref10 USING GIST (d10);
CREATE INDEX idx_t2_d10_pref10 ON t2_im_pref10 USING GIST (d10);
*/

CREATE OR REPLACE FUNCTION prodotto_cartesiano_pref10()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150),
  s1 int4range, d1 int4range,
  s2 int4range, d2 int4range,
  s3 int4range, d3 int4range,
  s4 int4range, d4 int4range,
  s5 int4range, d5 int4range,
  s6 int4range, d6 int4range,
  s7 int4range, d7 int4range,
  s8 int4range, d8 int4range,
  s9 int4range, d9 int4range,
  s10 int4range, d10 int4range) AS $$
BEGIN
RETURN QUERY
SELECT 
  t1_im_pref10.Attr1, t2_im_pref10.Attr1, t1_im_pref10.Attr2, t2_im_pref10.Attr2,
  t1_im_pref10.s1 * t2_im_pref10.s1, 
  t1_im_pref10.d1 * t2_im_pref10.d1,
  CASE WHEN COALESCE(t1_im_pref10.d2 * t2_im_pref10.d2,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s2 * t2_im_pref10.s2,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s2 * t2_im_pref10.s2,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d2 * t2_im_pref10.d2,'empty') END,
  
  CASE WHEN COALESCE(t1_im_pref10.d3 * t2_im_pref10.d3,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s3 * t2_im_pref10.s3,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s3 * t2_im_pref10.s3,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d3 * t2_im_pref10.d3,'empty') END,

  CASE WHEN COALESCE(t1_im_pref10.d4 * t2_im_pref10.d4,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s4 * t2_im_pref10.s4,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s4 * t2_im_pref10.s4,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d4 * t2_im_pref10.d4,'empty') END,
  
  CASE WHEN COALESCE(t1_im_pref10.d5 * t2_im_pref10.d5,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s5 * t2_im_pref10.s5,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s5 * t2_im_pref10.s5,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d5 * t2_im_pref10.d5,'empty') END,


  CASE WHEN COALESCE(t1_im_pref10.d6 * t2_im_pref10.d6,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s6 * t2_im_pref10.s6,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s6 * t2_im_pref10.s6,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d6 * t2_im_pref10.d6,'empty') END,
  
  CASE WHEN COALESCE(t1_im_pref10.d7 * t2_im_pref10.d7,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s7 * t2_im_pref10.s7,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s7 * t2_im_pref10.s7,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d7 * t2_im_pref10.d7,'empty') END,

  CASE WHEN COALESCE(t1_im_pref10.d8 * t2_im_pref10.d8,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s8 * t2_im_pref10.s8,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s8 * t2_im_pref10.s8,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d8 * t2_im_pref10.d8,'empty') END,
  
  CASE WHEN COALESCE(t1_im_pref10.d9 * t2_im_pref10.d9,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s9 * t2_im_pref10.s9,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s9 * t2_im_pref10.s9,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d9 * t2_im_pref10.d9,'empty') END,

  CASE WHEN COALESCE(t1_im_pref10.d10 * t2_im_pref10.d10,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.s10 * t2_im_pref10.s10,'empty') END,
  CASE WHEN COALESCE(t1_im_pref10.s10 * t2_im_pref10.s10,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref10.d10 * t2_im_pref10.d10,'empty') END



FROM 
  t1_im_pref10, t2_im_pref10 
WHERE 
  t1_im_pref10.s1 && t2_im_pref10.s1 AND 
  t1_im_pref10.d1 && t2_im_pref10.d1;
END;
$$
LANGUAGE plpgsql;

select * from prodotto_cartesiano_pref10();

  
  