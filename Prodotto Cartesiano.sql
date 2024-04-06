CREATE INDEX idx_t1_s1 ON t1_im USING GIST (s1);
CREATE INDEX idx_t2_s1 ON t2_im USING GIST (s1);
CREATE INDEX idx_t1_d1 ON t1_im USING GIST (d1);
CREATE INDEX idx_t2_d1 ON t2_im USING GIST (d1);
CREATE INDEX idx_t1_s2 ON t1_im USING GIST (s2);
CREATE INDEX idx_t2_s2 ON t2_im USING GIST (s2);
CREATE INDEX idx_t1_d2 ON t1_im USING GIST (d2);
CREATE INDEX idx_t2_d2 ON t2_im USING GIST (d2);
CREATE INDEX idx_t1_s3 ON t1_im USING GIST (s3);
CREATE INDEX idx_t2_s3 ON t2_im USING GIST (s3);
CREATE INDEX idx_t1_d3 ON t1_im USING GIST (d3);
CREATE INDEX idx_t2_d3 ON t2_im USING GIST (d3);

CREATE OR REPLACE FUNCTION prodotto_cartesiano()
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
  d3 int4range ) AS $$
BEGIN
RETURN QUERY
SELECT 
  t1_im.Attr1, t2_im.Attr1, t1_im.Attr2, t2_im.Attr2,
  t1_im.s1 * t2_im.s1, t1_im.d1 * t2_im.d1,
  t1_im.s2 * t2_im.s2, t1_im.d2 * t2_im.d2,
  t1_im.s3 * t2_im.s3, t1_im.d3 * t2_im.d3
FROM 
  t1_im, t2_im 
WHERE 
  t1_im.s1 && t2_im.s1 AND 
  t1_im.d1 && t2_im.d1;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM prodotto_cartesiano();


  
  