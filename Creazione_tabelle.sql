CREATE OR REPLACE FUNCTION RESET() RETURNS VOID AS $$
BEGIN

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	s1 int4range,
	d1 int4range,
	s2 int4range,
	d2 int4range,
	s3 int4range,
	d3 int4range
);

DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	s1 int4range,
	d1 int4range,
	s2 int4range,
	d2 int4range,
	s3 int4range,
	d3 int4range
);

DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	s1 int4range,
	d1 int4range,
	s2 int4range,
	d2 int4range,
	s3 int4range,
	d3 int4range
);

DROP TABLE IF EXISTS t3;
CREATE TABLE t3 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	low pair[],
	medium pair[],
	high pair[]
);

DROP TABLE IF EXISTS t4;
CREATE TABLE t4 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	low pair[],
	medium pair[],
	high pair[]
);

DROP TABLE IF EXISTS t5;
CREATE TABLE t5 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	ID Serial
);

DROP TABLE IF EXISTS t6;
CREATE TABLE t6 (
	Attr1 varchar(150),
	Attr2 varchar(150),
	ID Serial
);
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_text_md5_v2(INTEGER)
RETURNS TEXT
LANGUAGE SQL
AS $$ 
  select upper(
    substring(
      (SELECT string_agg(md5(random()::TEXT), '')
       FROM generate_series(
           1,
           CEIL($1 / 32.)::integer) 
       ), 1, $1) );
$$;
SELECT RESET();

CREATE OR REPLACE FUNCTION POPOLAMENTO(numrows decimal, nontempintersect decimal, tempintersect decimal) 
RETURNS VOID AS $$
DECLARE r1 t1%rowtype;
DECLARE r2 t2%rowtype;
DECLARE start timestamp;
DECLARE countrows decimal;
DECLARE a integer;
DECLARE b integer;
DECLARE smin integer;
DECLARE smax integer;
DECLARE dmin integer;
DECLARE dmax integer;

BEGIN
set seed to 0.35;
start = clock_timestamp();
countrows = 0;
	LOOP 
	EXIT WHEN countrows>=numrows;
		countrows = countrows+1;
		r1.Attr1 = random_text_md5_v2(25);
		r1.Attr2 = random_text_md5_v2(25);
		IF countrows < floor(numrows*nontempintersect) THEN
		r2.Attr1 = r1.Attr1;
		r2.Attr2 = r1.Attr2;
		ELSE 
		r2.Attr1 = random_text_md5_v2(25);
		r2.Attr2 = random_text_md5_v2(25);
		END IF;
		
		-- DURATA QUADRUPLA 1 PRIMA TABELLA
		a = 1; b = 10;
		dmin = floor(random()*(b-a+1))+a;
		a = 21; b = 30;
		dmax = floor(random()*(b-a+1))+a;
		
		r1.d1 = int4range(dmin, dmax, '[]');

		
		-- DURATA QUADRUPLA 1 SECONDA TABELLA
		a = 1; b = 10;                
		dmin = floor(random()*(b-a+1))+a;
		a = 21; b = 30;
		dmax = floor(random()*(b-a+1))+a;
		
		r2.d1 = int4range(dmin, dmax, '[]');


		IF countrows < numrows*tempintersect THEN --le quadruple si devono intersecare
		--QUADRUPLA 1 PRIMA TABELLA
		a = 50; b = 75;
		smin = floor(random()*(b-a+1))+a;
		a = 100; b = 125;
		smax = floor(random()*(b-a+1))+a;
		r1.s1 = int4range(smin,smax, '[]');		
	    -- QUADRUPLA 1 SECONDA TABELLA
		a = 60; b = 85;
		smin = floor(random()*(b-a+1))+a;
		a = 110; b = 135;
		smax = floor(random()*(b-a+1))+a;
		r2.s1 = int4range(smin,smax, '[]');
		
		ELSE --le quadruple non si devono intersecare
		-- QUADRUPLA 1 PRIMA TABELLA
		a = 150; b = 175;
		smin = floor(random()*(b-a+1))+a;
		a = 200; b = 225;
		smax = floor(random()*(b-a+1))+a;
		r1.s1 = int4range(smin,smax, '[]');


		-- QUADRUPLA 1 SECONDA TABELLA
		a = 250; b = 275;
		smin = floor(random()*(b-a+1))+a;
		a = 300; b = 325;
		smax = floor(random()*(b-a+1))+a;
		r2.s1 = int4range(smin,smax, '[]');
	

		
		END IF;
		-- QUADRUPLA 2 PRIMA TABELLA
		a = 5; b = 10;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs ( upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 1; b = 2;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = upper(r1.d1) - (floor(random()*(b-a+1))+a);
		r1.s2 = int4range(smin ,smax , '[]');
		r1.d2 = int4range(dmin,dmax, '[]');				
					

		-- QUADRUPLA 3 PRIMA TABELLA
		a = 10; b = 20;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 2; b = 3;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r1.s3 = int4range(smax,smin, '[]');
		ELSE 
		r1.s3 = int4range(smin,smax, '[]');
		END IF;
		r1.d3 = int4range(dmin,dmax, '[]');
	
	
		-- QUADRUPLA 2 SECONDA TABELLA
		a =  5; b = 10;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 1; b = 2;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		r2.s2 = int4range(smin,smax, '[]');
		r2.d2 = int4range(dmin,dmax, '[]');
	
		-- QUADRUPLA 3 SECONDA TABELLA
		a = 10; b = 20;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 2; b = 3;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		r2.d3 = int4range(dmin,dmax, '[]');
		IF smin > smax THEN
		r2.s3 = int4range(smax,smin, '[]');		
		ELSE
		r2.s3 = int4range(smin,smax, '[]');		
		END IF;

-- INSERIMENTO NELLE TABELLE
		INSERT INTO t1 SELECT r1.*;
		INSERT INTO t2 SELECT r2.*;
		
		INSERT INTO t3 SELECT * FROM MakeExplicit(r1.Attr1, r1.Attr2, r1.s1, r1.d1, r1.s2, r1.d2, r1.s3, r1.d3);
		INSERT INTO t4 SELECT * FROM MakeExplicit(r2.Attr1, r2.Attr2, r2.s1, r2.d1, r2.s2, r2.d2, r2.s3, r2.d3);
								   
		INSERT INTO t5 SELECT r1.Attr1, r1.Attr2;
		INSERT INTO t6 SELECT r2.Attr1, r2.Attr2;
		
	END LOOP;
END; $$
LANGUAGE plpgsql;

select POPOLAMENTO(1000, 0.1, 0.2);


