select reset();
select POPOLAMENTO(10, 0, 0.2);
/*
CREATE TYPE sub_n_m_result AS (
  s1 int4multirange,
  d1 int4multirange,
  s2 int4multirange,
  d2 int4multirange,
  s3 int4multirange,
  d3 int4multirange
);*/



CREATE OR REPLACE FUNCTION safe_int4range(lower_bound INT, upper_bound INT, bounds TEXT) RETURNS int4range AS $$
  BEGIN
    IF lower_bound > upper_bound THEN
      RETURN 'empty'::int4range;
    ELSE
      RETURN int4range(lower_bound, upper_bound, bounds);
    END IF;
  END; $$
 LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION pyramid_diff(t1_s int4range, t1_d int4range, t2_s1 int4range, t2_d1 int4range)
RETURNS int4range[] AS $$
DECLARE ret int4range[];
BEGIN

ret = ARRAY[safe_int4range(lower(t1_s),greatest(lower(t1_s),lower(t2_s1)), '[]'),
	   safe_int4range(greatest(lower(t1_d),lower(t2_d1)), upper(t1_d),'[]'),
	   
	   safe_int4range(greatest(lower(t1_s),lower(t2_s1)), upper(t1_s), '[]'),
	   safe_int4range(least(upper(t1_d),upper(t2_d1)), upper(t1_d),'[]'),
	   
	   safe_int4range(least(upper(t1_s),upper(t2_s1)), upper(t1_s), '[]'),
	   safe_int4range(lower(t1_d), least(upper(t1_d),upper(t2_d1)),'[]'),
	   
	   safe_int4range(lower(t1_s),least(upper(t1_s),upper(t2_s1)), '[]'),
	   safe_int4range(lower(t1_d), greatest(lower(t1_d),lower(t2_d1)),'[]')];
RETURN ret;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sub_1_m(s1 int4range, d1 int4range, t2_s1 int4range, t2_d1 int4range, t2_s2 int4range, t2_d2 int4range, t2_s3 int4range, t2_d3 int4range)
RETURNS int4range[] AS $$
DECLARE arr int4range[];
BEGIN
arr = pyramid_diff(s1, d1 , t2_s1, t2_d1);
RETURN arr;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sub_n_m(t1_s1 int4range, t1_d1 int4range, t1_s2 int4range, t1_d2 int4range, t1_s3 int4range, t1_d3 int4range , t2_s1 int4range, t2_d1 int4range, t2_s2 int4range, t2_d2 int4range, t2_s3 int4range, t2_d3 int4range)
RETURNS sub_n_m_result AS $$
DECLARE ret sub_n_m_result;
DECLARE ret1 int4range[];
DECLARE ret2 int4range[];
DECLARE ret3 int4range[];
BEGIN
IF isempty(t2_s1) and isempty(t2_d1) and isempty(t2_s2) and isempty(t2_d2) and  isempty(t2_s3) and isempty(t2_d3) THEN
ret = (t1_s1, t1_d1, t1_s2, t1_d2, t1_s3, t1_d3);
ELSE 
ret1 =  sub_1_m(t1_s1, t1_d1 , t2_s1, t2_d1, t2_s2, t2_d2, t2_s3, t2_d3);
ret2 =  sub_1_m(t1_s2, t1_d2 , t2_s1, t2_d1, t2_s2, t2_d2, t2_s3, t2_d3);
ret3 =  sub_1_m(t1_s3, t1_d3 , t2_s1, t2_d1, t2_s2, t2_d2, t2_s3, t2_d3);
ret = (int4multirange(ret1[1],ret1[3],ret1[5],ret1[7]), int4multirange(ret1[2],ret1[4],ret1[6],ret1[8]),
	  int4multirange(ret2[1],ret2[3],ret2[5],ret2[7]), int4multirange(ret2[2],ret2[4],ret2[6],ret2[8]),
	  int4multirange(ret3[1],ret3[3],ret3[5],ret3[7]), int4multirange(ret3[2],ret3[4],ret3[6],ret3[8])
	  );
END IF;
RETURN ret;
END; $$
LANGUAGE plpgsql;



with t as (
  select t1.Attr1, t1.Attr2, quadr.s1 as s1, quadr.d1 as d1, quadr.s2 as s2, quadr.d2 as d2, quadr.s3 as s3, quadr.d3 as d3
  from t1 join t2 on (t1.Attr1 = t2.Attr1 and t1.Attr2 = t2.Attr2),  sub_n_m(t1.s1, t1.d1, t1.s2, t1.d2, t1.s3, t1.d3 , t2.s1, t2.d1, t2.s2, t2.d2, t2.s3, t2.d3) as quadr
  where (not isempty(quadr.s1) or  not isempty(quadr.d1)) or ( not isempty(quadr.s2) or  not isempty(quadr.d2)) or ( not isempty(quadr.s3) or  not isempty (quadr.d3)))



select * from (
	select Attr1, Attr2, s1, d1, s2, d2, s3, d3 from t 
	union
	select Attr1, Attr2, int4multirange(s1) , int4multirange(d1), int4multirange(s2) , int4multirange(d2), int4multirange(s3) , int4multirange(d3)
	from t1 where not exists (select * from t2 where t1.Attr1 = t2.Attr1 and t1.Attr2 = t2.Attr2))







