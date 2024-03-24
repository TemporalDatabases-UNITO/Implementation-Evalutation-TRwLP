CREATE INDEX idx_gin_t3_low ON t3 USING gin (low);
CREATE INDEX idx_gin_t4_low ON t4 USING gin (low);

CREATE INDEX idx_gin_t3_medium ON t3 USING gin (medium);
CREATE INDEX idx_gin_t4_medium ON t4 USING gin (medium);

CREATE INDEX idx_gin_t3_high ON t3 USING gin (high);
CREATE INDEX idx_gin_t4_high ON t4 USING gin (high);

CREATE OR REPLACE FUNCTION array_intersection(t3 pair[], t4 pair[]) RETURNS pair[]
AS $$
BEGIN
    RETURN ARRAY(
        SELECT UNNEST(t3)
        INTERSECT
        SELECT UNNEST(t4)
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
SELECT t3.Attr1 AS Attr1_t1, t4.Attr1 AS Attr1_t2,
       t3.Attr2 AS Attr2_t1, t4.Attr2 AS Attr2_t2,
	   array_intersection(t3.low, t4.low) AS low_ps,
	   array_intersection(t3.medium, t4.medium) AS medium,
	   array_intersection(t3.high , t4.high) AS high
FROM t3, t4
WHERE NOT (array_intersection(t3.low, t4.low) = '{}');
END;
$$ LANGUAGE plpgsql;

SELECT * FROM prodotto_cartesiano_ME();

