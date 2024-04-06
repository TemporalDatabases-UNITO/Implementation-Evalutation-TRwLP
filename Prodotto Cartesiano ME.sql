CREATE INDEX idx_gin_t3_low ON t1_me USING gin (low);
CREATE INDEX idx_gin_t4_low ON t2_me USING gin (low);

CREATE INDEX idx_gin_t3_medium ON t1_me USING gin (medium);
CREATE INDEX idx_gin_t4_medium ON t2_me USING gin (medium);

CREATE INDEX idx_gin_t3_high ON t1_me USING gin (high);
CREATE INDEX idx_gin_t4_high ON t2_me USING gin (high);

CREATE OR REPLACE FUNCTION array_intersection(t1_me pair[], t2_me pair[]) RETURNS pair[]
AS $$
BEGIN
    RETURN ARRAY(
        SELECT UNNEST(t1_me)
        INTERSECT
        SELECT UNNEST(t2_me)
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION prodotto_cartesiano_ME()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150),
  low pair[],
  medium pair[],
  high pair[]
) AS $$
BEGIN
RETURN QUERY
SELECT t1_me.Attr1 AS Attr1_t1, t2_me.Attr1 AS Attr1_t2,
       t1_me.Attr2 AS Attr2_t1, t2_me.Attr2 AS Attr2_t2,
	   array_intersection(t1_me.low, t2_me.low) AS low_ps,
	   array_intersection(t1_me.medium, t2_me.medium) AS medium,
	   array_intersection(t1_me.high , t2_me.high) AS high
FROM t1_me, t2_me
WHERE NOT (array_intersection(t1_me.low, t2_me.low) = '{}');
END;
$$ LANGUAGE plpgsql;

SELECT * FROM prodotto_cartesiano_ME();

