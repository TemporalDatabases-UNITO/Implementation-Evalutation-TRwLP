
CREATE OR REPLACE FUNCTION Ext(range1 int4range, range2 int4range)
RETURNS int[][] AS
$$
DECLARE
  result int[][];
BEGIN
  SELECT array_agg(ARRAY[g1.val, g2.val])
  INTO result
  FROM generate_series(lower(range1), upper(range1) - 1) AS g1(val),
       generate_series(lower(range2), upper(range2) - 1) AS g2(val);

  RETURN result;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION MakeExplicit(
    Attributo1 varchar(150),
    Attributo2 varchar(150),
    s1 int4range,
    d1 int4range,
    s2 int4range,
    d2 int4range,
    s3 int4range,
    d3 int4range
)
RETURNS TABLE(
    Attr1 varchar(150),
    Attr2 varchar(150),
    low int[][],
    medium int[][],
    high int[][]
) AS
$$
BEGIN
    RETURN QUERY SELECT Attributo1, Attributo2, Ext(s1, d1), Ext(s2, d2), Ext(s3, d3);
END
$$ LANGUAGE plpgsql;
