select reset();
select POPOLAMENTO(10000, 0.1, 0.1);

CREATE INDEX idx_t1_s1 ON t1 USING GIST (s1);
CREATE INDEX idx_t2_s1 ON t2 USING GIST (s1);
CREATE INDEX idx_t1_d1 ON t1 USING GIST (d1);
CREATE INDEX idx_t2_d1 ON t2 USING GIST (d1);
CREATE INDEX idx_t1_s2 ON t1 USING GIST (s2);
CREATE INDEX idx_t2_s2 ON t2 USING GIST (s2);
CREATE INDEX idx_t1_d2 ON t1 USING GIST (d2);
CREATE INDEX idx_t2_d2 ON t2 USING GIST (d2);
CREATE INDEX idx_t1_s3 ON t1 USING GIST (s3);
CREATE INDEX idx_t2_s3 ON t2 USING GIST (s3);
CREATE INDEX idx_t1_d3 ON t1 USING GIST (d3);
CREATE INDEX idx_t2_d3 ON t2 USING GIST (d3);

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
  t1.Attr1, t2.Attr1, t1.Attr2, t2.Attr2,
  t1.s1 * t2.s1, t1.d1 * t2.d1,
  t1.s2 * t2.s2, t1.d2 * t2.d2,
  t1.s3 * t2.s3, t1.d3 * t2.d3
FROM 
  t1, t2 
WHERE 
  t1.s1 && t2.s1 AND 
  t1.d1 && t2.d1;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM prodotto_cartesiano();


  
  