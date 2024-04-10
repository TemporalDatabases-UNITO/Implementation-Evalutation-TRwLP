CREATE OR REPLACE FUNCTION MakeExplicit_Pref5(
    Attributo1 varchar(150),
    Attributo2 varchar(150),
    s1 int4range,
    d1 int4range,
    s2 int4range,
    d2 int4range,
    s3 int4range,
    d3 int4range,
	  s4 int4range,
	  d4 int4range,
	  s5 int4range,
	  d5 int4range
)
RETURNS TABLE(
    Attr1 varchar(150),
    Attr2 varchar(150),
    lvl1 pair[],
    lvl2 pair[],
    lvl3 pair[],
	  lvl4 pair[],
	  lvl5 pair[]
) AS
$$
BEGIN
    RETURN QUERY SELECT Attributo1, Attributo2, Ext(s1, d1), Ext(s2, d2), Ext(s3, d3), Ext(s4, d4), Ext(s5, d5);
END
$$ LANGUAGE plpgsql;