CREATE OR REPLACE FUNCTION sub_n_m_pref10(t1_s1 int4range, t1_d1 int4range, t1_s2 int4range, t1_d2 int4range, t1_s3 int4range, t1_d3 int4range , t1_s4 int4range, t1_d4 int4range, t1_s5 int4range, t1_d5 int4range,
                                 t1_s6 int4range, t1_d6 int4range, t1_s7 int4range, t1_d7 int4range, t1_s8 int4range, t1_d8 int4range , t1_s9 int4range, t1_d9 int4range, t1_s10 int4range, t1_d10 int4range,
																  t2_s1 int4range, t2_d1 int4range, t2_s2 int4range, t2_d2 int4range, t2_s3 int4range, t2_d3 int4range , t2_s4 int4range, t2_d4 int4range, t2_s5 int4range, t2_d5 int4range,
																	t2_s6 int4range, t2_d6 int4range, t2_s7 int4range, t2_d7 int4range, t2_s8 int4range, t2_d8 int4range , t2_s9 int4range, t2_d9 int4range, t2_s10 int4range, t2_d10 int4range)
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
  d5 int4range
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
	 ) AS $$
DECLARE ret1 int4range[];
DECLARE ret2 int4range[];
DECLARE ret3 int4range[];
DECLARE ret4 int4range[];
DECLARE ret5 int4range[];
DECLARE ret6 int4range[];
DECLARE ret7 int4range[];
DECLARE ret8 int4range[];
DECLARE ret9 int4range[];
DECLARE ret10 int4range[];
BEGIN
-- Caso in cui V2 sia vuoto oppure V1 e V2 non si intersecano
IF isempty(t2_s1) and isempty(t2_d1) and isempty(t2_s2) and isempty(t2_d2) and  isempty(t2_s3) and isempty(t2_d3) and  isempty(t2_s4) and isempty(t2_d4) and  isempty(t2_s5) and isempty(t2_d5) and
   isempty(t2_s6) and isempty(t2_d6) and isempty(t2_s7) and isempty(t2_d7) and  isempty(t2_s8) and isempty(t2_d8) and  isempty(t2_s9) and isempty(t2_d9) and  isempty(t2_s10) and isempty(t2_d10)

   or (not t1_s1 && t2_s1 or not t1_d1 && t2_d1) THEN
	RETURN QUERY VALUES (t1_s1, t1_d1, t1_s2, t1_d2, t1_s3, t1_d3, t1_s4, t1_d4 , t1_s5, t1_d5, t1_s6, t1_d6, t1_s7, t1_d7, t1_s8, t1_d8, t1_s9, t1_d9 , t1_s10, t1_d10);

-- Caso intersezione tra V1 e V2
ELSE 
-- Confronto con lo il primo strato di V2
		ret1 =  sub_1_m(t1_s1, t1_d1 , t2_s1, t2_d1);
		ret2 =  sub_1_m(t1_s2, t1_d2 , t2_s1, t2_d1);
		ret3 =  sub_1_m(t1_s3, t1_d3 , t2_s1, t2_d1);
    ret4 =  sub_1_m(t1_s4, t1_d4 , t2_s1, t2_d1);
		ret5 =  sub_1_m(t1_s5, t1_d5 , t2_s1, t2_d1);
		ret6 =  sub_1_m(t1_s6, t1_d6 , t2_s1, t2_d1);
		ret7 =  sub_1_m(t1_s7, t1_d7 , t2_s1, t2_d1);
		ret8 =  sub_1_m(t1_s8, t1_d8 , t2_s1, t2_d1);
    ret9 =  sub_1_m(t1_s9, t1_d9 , t2_s1, t2_d1);
		ret10 =  sub_1_m(t1_s10, t1_d10 , t2_s1, t2_d1);


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



		IF isempty(ret6[i*2-1]) or isempty (ret6[i*2]) THEN
			ret6[i*2-1] = 'empty';
			ret6[i*2] = 'empty';
		END IF;

		IF isempty(ret7[i*2-1]) or isempty (ret7[i*2]) THEN
			ret7[i*2-1] = 'empty';
			ret7[i*2] = 'empty';
		END IF;

		IF isempty(ret8[i*2-1]) or isempty (ret8[i*2]) THEN
			ret8[i*2-1] = 'empty';
			ret8[i*2] = 'empty';
		END IF;	 

    IF isempty(ret9[i*2-1]) or isempty (ret9[i*2]) THEN
			ret9[i*2-1] = 'empty';
			ret9[i*2] = 'empty';
		END IF;	 

    IF isempty(ret10[i*2-1]) or isempty (ret10[i*2]) THEN
			ret10[i*2-1] = 'empty';
			ret10[i*2] = 'empty';
		END IF;	  
	END LOOP;

-- Ritorno delle colonne con le piramidi risultanti dalla differenza
	RETURN QUERY VALUES
    (ret1[1], ret1[2], ret2[1], ret2[2], ret3[1], ret3[2],  ret4[1], ret4[2], ret5[1], ret5[2],
		ret6[1], ret6[2], ret7[1], ret7[2], ret8[1], ret8[2],  ret9[1], ret9[2], ret10[1], ret10[2]  ),
		(ret1[3], ret1[4], ret2[3], ret2[4], ret3[3], ret3[4] , ret4[3], ret4[4] , ret5[3], ret5[4] ,
		ret6[3], ret6[4], ret7[3], ret7[4], ret8[3], ret8[4] , ret9[3], ret9[4] , ret10[3], ret10[4] ),
		(ret1[5], ret1[6], ret2[5], ret2[6], ret3[5], ret3[6] , ret4[5], ret4[6] , ret5[5], ret5[6] ,
		ret6[5], ret6[6], ret7[5], ret7[6], ret8[5], ret8[6] , ret9[5], ret9[6] , ret10[5], ret10[6] ),
		(ret1[7], ret1[8], ret2[7], ret2[8], ret3[7], ret3[8],  ret4[7], ret4[8]  ,ret5[7], ret5[8] 
		ret6[7], ret6[8], ret7[7], ret7[8], ret8[7], ret8[8],  ret9[7], ret9[8]  ,ret10[7], ret10[8]);
END IF;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION differenza_pref10()
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
  d5_diff int4range,
  s6_diff int4range,
  d6_diff int4range,
  s7_diff int4range,
  d7_diff int4range,
  s8_diff int4range,
  d8_diff int4range,
  s9_diff int4range,
  d9_diff int4range,
  s10_diff int4range,
  d10_diff int4range
   ) AS $$
BEGIN
RETURN QUERY
with t as (
  select t1_im_pref10.Attr1, t1_im_pref10.Attr2, quadr.s1 , quadr.d1, quadr.s2 , quadr.d2 , quadr.s3 , quadr.d3, quadr.s4 , quadr.d4, quadr.s5 , quadr.d5,  quadr.s6 , quadr.d6, quadr.s7 , quadr.d7 , quadr.s8 , quadr.d8, quadr.s9 , quadr.d9, quadr.s10 , quadr.d10
  from t1_im_pref10 join t2_im_pref10 on (t1_im_pref10.Attr1 = t2_im_pref10.Attr1 and t1_im_pref10.Attr2 = t2_im_pref10.Attr2) CROSS JOIN LATERAL sub_n_m_pref10(t1_im_pref10.s1, t1_im_pref10.d1, t1_im_pref10.s2, t1_im_pref10.d2, t1_im_pref10.s3, t1_im_pref10.d3 , t1_im_pref10.s4, t1_im_pref10.d4 , t1_im_pref10.s5, t1_im_pref10.d5, 
                                                                                                                                                                  t1_im_pref10.s6, t1_im_pref10.d6, t1_im_pref10.s7, t1_im_pref10.d7, t1_im_pref10.s8, t1_im_pref10.d8 , t1_im_pref10.s9, t1_im_pref10.d9 , t1_im_pref10.s10, t1_im_pref10.d10, 
                                                                                                                      t2_im_pref10.s1, t2_im_pref10.d1, t2_im_pref10.s2, t2_im_pref10.d2, t2_im_pref10.s3, t2_im_pref10.d3, t2_im_pref10.s4, t2_im_pref10.d4, t2_im_pref10.s5, t2_im_pref10.d5,
                                                                                                                       t2_im_pref10.s6, t2_im_pref10.d6, t2_im_pref10.s7, t2_im_pref10.d7, t2_im_pref10.s8, t2_im_pref10.d8, t2_im_pref10.s9, t2_im_pref10.d9, t2_im_pref10.s10, t2_im_pref10.d10)  as quadr
  where (not isempty(quadr.s1) AND not isempty(quadr.d1)) OR  (not isempty(quadr.s2) AND not isempty(quadr.d2)) OR (not isempty(quadr.s3) AND not isempty(quadr.d3)) OR (not isempty(quadr.s4) AND not isempty(quadr.d4)) OR (not isempty(quadr.s5) AND not isempty(quadr.d5)) OR
  (not isempty(quadr.s6) AND not isempty(quadr.d6)) OR  (not isempty(quadr.s7) AND not isempty(quadr.d7)) OR (not isempty(quadr.s8) AND not isempty(quadr.d8)) OR (not isempty(quadr.s9) AND not isempty(quadr.d9)) OR (not isempty(quadr.s10) AND not isempty(quadr.d10)))
select * from (
	select Attr1, Attr2, s1, d1, s2, d2, s3, d3, s4, d4, s5, d5, s6, d6, s7, d7, s8, d8, s9, d9, s10, d10
	from t 
	union
	select Attr1, Attr2, s1 , d1, s2 , d2, s3 , d3, s4, d4, s5, d5, s6, d6, s7, d7, s8, d8, s9, d9, s10, d10
	from t1_im_pref10 where not exists (select * from t2_im_pref10 where t1_im_pref10.Attr1 = t2_im_pref10.Attr1 and t1_im_pref10.Attr2 = t2_im_pref10.Attr2));
END;
$$
LANGUAGE plpgsql;


SELECT * FROM differenza_pref10();



