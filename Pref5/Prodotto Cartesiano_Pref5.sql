/*CREATE INDEX idx_t1_s1_pref5 ON t1_im_pref5 USING GIST (s1);
CREATE INDEX idx_t2_s1_pref5 ON t2_im_pref5 USING GIST (s1);
CREATE INDEX idx_t1_d1_pref5 ON t1_im_pref5 USING GIST (d1);
CREATE INDEX idx_t2_d1_pref5 ON t2_im_pref5 USING GIST (d1);
CREATE INDEX idx_t1_s2_pref5 ON t1_im_pref5 USING GIST (s2);
CREATE INDEX idx_t2_s2_pref5 ON t2_im_pref5 USING GIST (s2);
CREATE INDEX idx_t1_d2_pref5 ON t1_im_pref5 USING GIST (d2);
CREATE INDEX idx_t2_d2_pref5 ON t2_im_pref5 USING GIST (d2);
CREATE INDEX idx_t1_s3_pref5 ON t1_im_pref5 USING GIST (s3);
CREATE INDEX idx_t2_s3_pref5 ON t2_im_pref5 USING GIST (s3);
CREATE INDEX idx_t1_d3_pref5 ON t1_im_pref5 USING GIST (d3);
CREATE INDEX idx_t2_d3_pref5 ON t2_im_pref5 USING GIST (d3);
CREATE INDEX idx_t1_s4_pref5 ON t1_im_pref5 USING GIST (s4);
CREATE INDEX idx_t2_s4_pref5 ON t2_im_pref5 USING GIST (s4);
CREATE INDEX idx_t1_d4_pref5 ON t1_im_pref5 USING GIST (d4);
CREATE INDEX idx_t2_d4_pref5 ON t2_im_pref5 USING GIST (d4);
CREATE INDEX idx_t1_s5_pref5 ON t1_im_pref5 USING GIST (s5);
CREATE INDEX idx_t2_s5_pref5 ON t2_im_pref5 USING GIST (s5);
CREATE INDEX idx_t1_d5_pref5 ON t1_im_pref5 USING GIST (d5);
CREATE INDEX idx_t2_d5_pref5 ON t2_im_pref5 USING GIST (d5);*/

CREATE OR REPLACE FUNCTION prodotto_cartesiano_pref5()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150),
  s1 int4range,
  d1 int4range,
  s2 int4range,
  d2 int4range,
  s3 int4range,
  d3 int4range,
  s4 int4range,
  d4 int4range,
  s5 int4range,
  d5 int4range ) AS $$
BEGIN
RETURN QUERY
SELECT 
  t1_im_pref5.Attr1, t2_im_pref5.Attr1, t1_im_pref5.Attr2, t2_im_pref5.Attr2,
  t1_im_pref5.s1 * t2_im_pref5.s1, 
  t1_im_pref5.d1 * t2_im_pref5.d1,
  CASE WHEN COALESCE(t1_im_pref5.d2 * t2_im_pref5.d2,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.s2 * t2_im_pref5.s2,'empty') END,
  CASE WHEN COALESCE(t1_im_pref5.s2 * t2_im_pref5.s2,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.d2 * t2_im_pref5.d2,'empty') END,
  
  CASE WHEN COALESCE(t1_im_pref5.d3 * t2_im_pref5.d3,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.s3 * t2_im_pref5.s3,'empty') END,
  CASE WHEN COALESCE(t1_im_pref5.s3 * t2_im_pref5.s3,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.d3 * t2_im_pref5.d3,'empty') END,

  CASE WHEN COALESCE(t1_im_pref5.d4 * t2_im_pref5.d4,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.s4 * t2_im_pref5.s4,'empty') END,
  CASE WHEN COALESCE(t1_im_pref5.s4 * t2_im_pref5.s4,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.d4 * t2_im_pref5.d4,'empty') END,
  
  CASE WHEN COALESCE(t1_im_pref5.d5 * t2_im_pref5.d5,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.s5 * t2_im_pref5.s5,'empty') END,
  CASE WHEN COALESCE(t1_im_pref5.s5 * t2_im_pref5.s5,'empty') IS NOT DISTINCT FROM 'empty' THEN 'empty' ELSE COALESCE(t1_im_pref5.d5 * t2_im_pref5.d5,'empty') END

FROM 
  t1_im_pref5, t2_im_pref5 
WHERE 
  t1_im_pref5.s1 && t2_im_pref5.s1 AND 
  t1_im_pref5.d1 && t2_im_pref5.d1;
END;
$$
LANGUAGE plpgsql;

select * from prodotto_cartesiano_pref5();

  
  