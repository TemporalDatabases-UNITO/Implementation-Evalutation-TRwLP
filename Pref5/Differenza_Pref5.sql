CREATE OR REPLACE FUNCTION sub_n_m_pref5(t1_s1 int4range, t1_d1 int4range, t1_s2 int4range, t1_d2 int4range, t1_s3 int4range, t1_d3 int4range , t1_s4 int4range, t1_d4 int4range, t1_s5 int4range, t1_d5 int4range
                                 , t2_s1 int4range, t2_d1 int4range, t2_s2 int4range, t2_d2 int4range, t2_s3 int4range, t2_d3 int4range , t2_s4 int4range, t2_d4 int4range, t2_s5 int4range, t2_d5 int4range)
RETURNS TABLE(
  s1 int4range,
  d1 int4range,
  s2 int4range,
  d2 int4range,
  s3 int4range,
  d3 int4range,
  s4 int4range,
  d4 int4range,
  s5 int4range,
  d5 int4range ) AS $$
DECLARE ret1 int4range[];
DECLARE ret2 int4range[];
DECLARE ret3 int4range[];
DECLARE ret4 int4range[];
DECLARE ret5 int4range[];
BEGIN
-- Caso in cui V2 sia vuoto oppure V1 e V2 non si intersecano
IF isempty(t2_s1) and isempty(t2_d1) and isempty(t2_s2) and isempty(t2_d2) and  isempty(t2_s3) and isempty(t2_d3) and  isempty(t2_s4) and isempty(t2_d4) and  isempty(t2_s5) and isempty(t2_d5)
   or (not t1_s1 && t2_s1 or not t1_d1 && t2_d1) THEN
	RETURN QUERY VALUES (t1_s1, t1_d1, t1_s2, t1_d2, t1_s3, t1_d3, t1_s4, t1_d4 , t1_s5, t1_d5);

-- Caso intersezione tra V1 e V2
ELSE 
-- Confronto con lo il primo strato di V2
		ret1 =  sub_1_m(t1_s1, t1_d1 , t2_s1, t2_d1);
		ret2 =  sub_1_m(t1_s2, t1_d2 , t2_s1, t2_d1);
		ret3 =  sub_1_m(t1_s3, t1_d3 , t2_s1, t2_d1);
    ret4 =  sub_1_m(t1_s4, t1_d4 , t2_s1, t2_d1);
		ret5 =  sub_1_m(t1_s5, t1_d5 , t2_s1, t2_d1);


-- Rimozione di start o duration quando la corrispondente duration o start è empty
	FOR i in 1..4 LOOP
		IF isempty(ret1[i*2-1]) or isempty (ret1[i*2]) THEN
			ret1[i*2-1] = 'empty';
			ret1[i*2] = 'empty';
		END IF;

		IF isempty(ret2[i*2-1]) or isempty (ret2[i*2]) THEN
			ret2[i*2-1] = 'empty';
			ret2[i*2] = 'empty';
		END IF;

		IF isempty(ret3[i*2-1]) or isempty (ret3[i*2]) THEN
			ret3[i*2-1] = 'empty';
			ret3[i*2] = 'empty';
		END IF;	 

    IF isempty(ret4[i*2-1]) or isempty (ret4[i*2]) THEN
			ret4[i*2-1] = 'empty';
			ret4[i*2] = 'empty';
		END IF;	 

    IF isempty(ret5[i*2-1]) or isempty (ret5[i*2]) THEN
			ret5[i*2-1] = 'empty';
			ret5[i*2] = 'empty';
		END IF;	  
	END LOOP;

-- Ritorno delle colonne con le piramidi risultanti dalla differenza
	RETURN QUERY VALUES
    (ret1[1], ret1[2], ret2[1], ret2[2], ret3[1], ret3[2],  ret4[1], ret4[2], ret5[1], ret5[2] ),
		(ret1[3], ret1[4], ret2[3], ret2[4], ret3[3], ret3[4] , ret4[3], ret4[4] , ret5[3], ret5[4] ),
		(ret1[5], ret1[6], ret2[5], ret2[6], ret3[5], ret3[6] , ret4[5], ret4[6] , ret5[5], ret5[6] ),
		(ret1[7], ret1[8], ret2[7], ret2[8], ret3[7], ret3[8],  ret4[7], ret4[8]  ,ret5[7], ret5[8] );
END IF;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION differenza_pref5()
RETURNS TABLE(
  Attr1_diff varchar(150),
  Attr2_diff varchar(150),
  s1_diff int4range,
  d1_diff int4range,
  s2_diff int4range,
  d2_diff int4range,
  s3_diff int4range,
  d3_diff int4range,
  s4_diff int4range,
  d4_diff int4range,
  s5_diff int4range,
  d5_diff int4range ) AS $$
BEGIN
RETURN QUERY
with t as (
  select t1_im_pref5.Attr1, t1_im_pref5.Attr2, quadr.s1 , quadr.d1, quadr.s2 , quadr.d2 , quadr.s3 , quadr.d3, quadr.s4 , quadr.d4, quadr.s5 , quadr.d5
  from t1_im_pref5 join t2_im_pref5 on (t1_im_pref5.Attr1 = t2_im_pref5.Attr1 and t1_im_pref5.Attr2 = t2_im_pref5.Attr2) CROSS JOIN LATERAL sub_n_m_pref5(t1_im_pref5.s1, t1_im_pref5.d1, t1_im_pref5.s2, t1_im_pref5.d2, t1_im_pref5.s3, t1_im_pref5.d3 , t1_im_pref5.s4, t1_im_pref5.d4 , t1_im_pref5.s5, t1_im_pref5.d5, 
                                                                                                                      t2_im_pref5.s1, t2_im_pref5.d1, t2_im_pref5.s2, t2_im_pref5.d2, t2_im_pref5.s3, t2_im_pref5.d3, t2_im_pref5.s4, t2_im_pref5.d4, t2_im_pref5.s5, t2_im_pref5.d5)  as quadr
  where (not isempty(quadr.s1) AND not isempty(quadr.d1)) OR  (not isempty(quadr.s2) AND not isempty(quadr.d2)) OR (not isempty(quadr.s3) AND not isempty(quadr.d3)) OR (not isempty(quadr.s4) AND not isempty(quadr.d4)) OR (not isempty(quadr.s5) AND not isempty(quadr.d5)))
select * from (
	select Attr1, Attr2, s1, d1, s2, d2, s3, d3, s4, d4, s5, d5
	from t 
	union
	select Attr1, Attr2, s1 , d1, s2 , d2, s3 , d3, s4, d4, s5, d5
	from t1_im_pref5 where not exists (select * from t2_im_pref5 where t1_im_pref5.Attr1 = t2_im_pref5.Attr1 and t1_im_pref5.Attr2 = t2_im_pref5.Attr2));
END;
$$
LANGUAGE plpgsql;


SELECT * FROM differenza_pref5();



