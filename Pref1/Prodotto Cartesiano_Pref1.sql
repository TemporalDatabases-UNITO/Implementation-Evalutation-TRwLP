CREATE INDEX idx_t1_s1_pref1 ON t1_im_pref1 USING GIST (s1);
CREATE INDEX idx_t2_s1_pref1 ON t2_im_pref1 USING GIST (s1);
CREATE INDEX idx_t1_d1_pref1 ON t1_im_pref1 USING GIST (d1);
CREATE INDEX idx_t2_d1_pref1 ON t2_im_pref1 USING GIST (d1);

CREATE OR REPLACE FUNCTION prodotto_cartesiano_Pref1()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150),
  s1 int4range,
  d1 int4range
) AS $$
BEGIN
RETURN QUERY
SELECT 
  t1_im_pref1.Attr1, t2_im_pref1.Attr1, t1_im_pref1.Attr2, t2_im_pref1.Attr2,
  t1_im_pref1.s1 * t2_im_pref1.s1, t1_im_pref1.d1 * t2_im_pref1.d1
FROM 
  t1_im_pref1, t2_im_pref1 
WHERE 
  t1_im_pref1.s1 && t2_im_pref1.s1 AND 
  t1_im_pref1.d1 && t2_im_pref1.d1;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM prodotto_cartesiano_pref1();


  
  