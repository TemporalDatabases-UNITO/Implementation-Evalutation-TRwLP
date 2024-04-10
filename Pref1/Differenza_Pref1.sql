CREATE OR REPLACE FUNCTION sub_n_m_pref1(t1_s1 int4range, t1_d1 int4range, t2_s1 int4range, t2_d1 int4range)
RETURNS TABLE(
  s1 int4range,
  d1 int4range
) AS $$
DECLARE ret1 int4range[];
BEGIN
-- Caso in cui V2 sia vuoto oppure V1 e V2 non si intersecano
IF isempty(t2_s1) and isempty(t2_d1) or (not t1_s1 && t2_s1 or not t1_d1 && t2_d1) THEN
	RETURN QUERY VALUES (t1_s1, t1_d1);

-- Caso intersezione tra V1 e V2
ELSE 
-- Confronto con lo il primo strato di V2
		ret1 =  sub_1_m(t1_s1, t1_d1 , t2_s1, t2_d1);
-- Rimozione di start o duration quando la corrispondente duration o start è empty
	FOR i in 1..4 LOOP
		IF isempty(ret1[i*2-1]) or isempty (ret1[i*2]) THEN
			ret1[i*2-1] = 'empty';
			ret1[i*2] = 'empty';
		END IF;
	END LOOP;

-- Ritorno delle colonne con le piramidi risultanti dalla differenza
	RETURN QUERY VALUES
    	(ret1[1], ret1[2]),
		(ret1[3], ret1[4]),
		(ret1[5], ret1[6]),
		(ret1[7], ret1[8]);
END IF;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION differenza_pref1()
RETURNS TABLE(
  Attr1_diff varchar(150),
  Attr2_diff varchar(150),
  s1_diff int4range,
  d1_diff int4range
   ) AS $$
BEGIN
RETURN QUERY
with t as (
  select t1_im_pref1.Attr1, t1_im_pref1.Attr2, quadr.s1 , quadr.d1
  from t1_im_pref1 join t2_im_pref1 on (t1_im_pref1.Attr1 = t2_im_pref1.Attr1 and t1_im_pref1.Attr2 = t2_im_pref1.Attr2) CROSS JOIN LATERAL sub_n_m_pref1(t1_im_pref1.s1, t1_im_pref1.d1, t2_im_pref1.s1, t2_im_pref1.d1)  as quadr
  where (not isempty(quadr.s1) AND not isempty(quadr.d1)))
select * from (
	select Attr1, Attr2, s1, d1
	from t 
	union
	select Attr1, Attr2, s1 , d1
	from t1_im_pref1 where not exists (select * from t2_im_pref1 where t1_im_pref1.Attr1 = t2_im_pref1.Attr1 and t1_im_pref1.Attr2 = t2_im_pref1.Attr2));
END;
$$
LANGUAGE plpgsql;

SELECT * FROM differenza_pref1();




