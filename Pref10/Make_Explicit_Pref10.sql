CREATE OR REPLACE FUNCTION MakeExplicit_Pref10(
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
	  d5 int4range,
    s6 int4range,
    d6 int4range,
    s7 int4range,
    d7 int4range,
    s8 int4range,
    d8 int4range,
	  s9 int4range,
	  d9 int4range,
	  s10 int4range,
	  d10 int4range

)
RETURNS TABLE(
    Attr1 varchar(150),
    Attr2 varchar(150),
    lvl1 pair[],
    lvl2 pair[],
    lvl3 pair[],
	  lvl4 pair[],
	  lvl5 pair[],
    lvl6 pair[],
    lvl7 pair[],
    lvl8 pair[],
	  lvl9 pair[],
	  lvl10 pair[]
) AS
$$
BEGIN
    RETURN QUERY SELECT Attributo1, Attributo2, Ext(s1, d1), Ext(s2, d2), Ext(s3, d3), Ext(s4, d4), Ext(s5, d5), Ext(s6, d6), Ext(s7, d7), Ext(s8, d8), Ext(s9, d9), Ext(s10, d10);
END
$$ LANGUAGE plpgsql;