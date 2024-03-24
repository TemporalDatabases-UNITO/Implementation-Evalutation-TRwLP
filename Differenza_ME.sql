select reset();
select POPOLAMENTO(1000, 0.1, 0.1,1);

/* NON MANTIENE ORDINE MA PIU' EFFICIENTE*/
CREATE OR REPLACE FUNCTION array_difference(t3 pair[], t4 pair[]) RETURNS pair[] AS $$
DECLARE ret pair[];
BEGIN
    SELECT ARRAY_AGG(e) INTO ret
		FROM(
		SELECT UNNEST(t3)
        EXCEPT
        SELECT UNNEST(t4)
		) AS dt(e);
   RETURN ret;
END;
$$ LANGUAGE plpgsql;

/*MANTIENE ORDINE MA MOLTO INEFFICIENTE
CREATE OR REPLACE FUNCTION array_difference_order(t3 pair[], t4 pair[]) RETURNS pair[] AS $$
DECLARE ret pair[];
BEGIN
   SELECT COALESCE(array_agg(elem), '{}') INTO RET
   FROM UNNEST(t3) elem
   WHERE elem <> ALL(t4);
   RETURN ret;
END;
$$ LANGUAGE plpgsql;
*/
CREATE OR REPLACE FUNCTION differenza_ME()
RETURNS TABLE(
  Attr1_diff varchar(150),
  Attr2_diff varchar(150),
  low_diff pair[],
  medium_diff pair[],
  high_diff pair[]) AS $$
BEGIN
RETURN QUERY
with t as (
  select t3.Attr1, t3.Attr2, array_difference(t3.low,t4.low) as low_d, array_difference(t3.medium,t4.medium) as medium_d, array_difference(t3.high,t4.high) as high_d
  from t3 join t4 on (t3.Attr1 = t4.Attr1 and t3.Attr2 = t4.Attr2)     
  where not (array_difference(t3.low,t4.low)  = '{}'))
select * from (
	select Attr1, Attr2, low_d, medium_d, high_d
	from t 
	union
	select Attr1, Attr2, low, medium, high
	from t3 where not exists (select * from t4 where t3.Attr1 = t4.Attr1 and t3.Attr2 = t4.Attr2));
END;
$$
LANGUAGE plpgsql;

SELECT * FROM differenza_ME();




