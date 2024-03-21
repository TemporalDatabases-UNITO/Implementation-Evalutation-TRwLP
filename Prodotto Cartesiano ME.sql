select reset();
select POPOLAMENTO(100, 0.1, 0.1);

CREATE OR REPLACE FUNCTION array_intersection(t3 pair[], t4 pair[]) RETURNS pair[]
AS $$
DECLARE ret pair[];
BEGIN
    IF t3 IS NULL OR t4 IS NULL OR array_length(t3,1) = 0  OR array_length(t4,1) = 0 THEN
		RETURN '{}';
	ELSE 
		SELECT ARRAY_AGG(e) INTO ret
		FROM(
		SELECT UNNEST(t3)
        INTERSECT
        SELECT UNNEST(t4)
		) AS dt(e);
	IF ret IS NULL THEN
		RETURN '{}';
	ELSE 
		RETURN ret;
	END IF;
	END IF;
END;
$$ language plpgsql;

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

