/*CREATE TYPE pair AS (
s int,
d int
);*/

CREATE OR REPLACE FUNCTION Ext(s int4range, d int4range)
RETURNS pair[] AS
$$
DECLARE result pair[];
BEGIN
  SELECT array_agg((s_val, d_val))
  INTO result
  FROM generate_series(lower(s), upper(s) - 1) AS s_val,
       generate_series(lower(d), upper(d) - 1) AS d_val;
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
    low pair[],
    medium pair[],
    high pair[]
) AS
$$
BEGIN
    RETURN QUERY SELECT Attributo1, Attributo2, Ext(s1, d1), Ext(s2, d2), Ext(s3, d3);
END
$$ LANGUAGE plpgsql;
