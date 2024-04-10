CREATE OR REPLACE FUNCTION differenza_ME_pref5()
RETURNS TABLE(
  Attr1_diff varchar(150),
  Attr2_diff varchar(150),
  lvl1_diff pair[],
  lvl2_diff pair[],
  lvl3_diff pair[],
  lvl4_diff pair[],
  lvl5_diff pair[]) AS $$
BEGIN
RETURN QUERY
with t as (
  select t1_me_pref5.Attr1, t1_me_pref5.Attr2, array_difference(t1_me_pref5.lvl1,t2_me_pref5.lvl1) as lvl1_d, array_difference(t1_me_pref5.lvl2,t2_me_pref5.lvl1) as lvl2_d, array_difference(t1_me_pref5.lvl3,t2_me_pref5.lvl1) as lvl3_d,
  array_difference(t1_me_pref5.lvl4,t2_me_pref5.lvl1) as lvl4_d, array_difference(t1_me_pref5.lvl5,t2_me_pref5.lvl1) as lvl5_d
  from t1_me_pref5 join t2_me_pref5 on (t1_me_pref5.Attr1 = t2_me_pref5.Attr1 and t1_me_pref5.Attr2 = t2_me_pref5.Attr2)     
  where not (array_difference(t1_me_pref5.lvl1,t2_me_pref5.lvl1)  = '{}'))
select * from (
	select Attr1, Attr2, lvl1_d, lvl2_d, lvl3_d, lvl4_d, lvl5_d
	from t 
	union
	select Attr1, Attr2, lvl1, lvl2, lvl3, lvl4, lvl5
	from t1_me_pref5 where not exists (select * from t2_me_pref5 where t1_me_pref5.Attr1 = t2_me_pref5.Attr1 and t1_me_pref5.Attr2 = t2_me_pref5.Attr2));
END;
$$
LANGUAGE plpgsql;

SELECT * FROM differenza_ME_pref5();

