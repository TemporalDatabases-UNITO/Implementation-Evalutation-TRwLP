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


/* CON PYRAMID INTERSECT
CREATE OR REPLACE FUNCTION pyramid_intersect(
    s1_t1 int4range, d1_t1 int4range, s2_t1 int4range, d2_t1 int4range, s3_t1 int4range, d3_t1 int4range,
    s1_t2 int4range, d1_t2 int4range, s2_t2 int4range, d2_t2 int4range, s3_t2 int4range, d3_t2 int4range
)
RETURNS TABLE(s1 int4range, d1 int4range, s2 int4range, d2 int4range, s3 int4range, d3 int4range) AS
$$
BEGIN
    RETURN QUERY SELECT
        s1_t1 * s1_t2,
        d1_t1 * d1_t2,
        s2_t1 * s2_t2,
        d2_t1 * d2_t2,
        s3_t1 * s3_t2,
        d3_t1 * d3_t2;
END;
$$ LANGUAGE plpgsql;

select t1.Attr1, t2.Attr1, t1.Attr2 , t2.Attr2, pyramid_intersect(t1.s1, t1.d1, t1.s2, t1.d2, t1.s3, t1.d3,t2.s1, t2.d1, t2.s2, t2.d2, t2.s3, t2.d3)
from t1, t2 
where t1.s1 && t2.s1 and t1.d1 && t2.d1
*/

/* SENZA PYRAMID INTERSECT*/
select t1.Attr1, t2.Attr1, t1.Attr2 , t2.Attr2, t1.s1 * t2.s1 , t1.d1 * t2.d1, t1.s2 * t2.s2 , t1.d2 * t2.d2, t1.s3 * t2.s3 , t1.d3 * t2.d3
from t1, t2 
where t1.s1 && t2.s1 and t1.d1 && t2.d1

  
  