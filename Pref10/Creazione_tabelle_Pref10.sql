CREATE OR REPLACE FUNCTION RESET_PREF10() RETURNS VOID AS $$
BEGIN

DROP TABLE IF EXISTS t1_im_pref10;
CREATE TABLE t1_im_pref10 (
	Attr1 varchar(150),
	Attr2 varchar(150),
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
);

DROP TABLE IF EXISTS t2_im_pref10;
CREATE TABLE t2_im_pref10 (
	Attr1 varchar(150),
	Attr2 varchar(150),
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
);

DROP TABLE IF EXISTS t1_me_pref10;
CREATE TABLE t1_me_pref10 (
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
);

DROP TABLE IF EXISTS t2_me_pref10;
CREATE TABLE t2_me_pref10 (
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

SELECT RESET_PREF10();
CREATE OR REPLACE FUNCTION POPOLAMENTO_pref10(numrows decimal, nontempintersect decimal, tempintersect decimal, interval_mul decimal) 
RETURNS VOID AS $$
DECLARE r1 t1_im_pref10%rowtype;
DECLARE r2 t2_im_pref10%rowtype;
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
IF interval_mul <= 0 THEN
interval_mul = 1;
END IF;
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
		a = 1 *interval_mul ; b = 25 *interval_mul;
		dmin = floor(random()*(b-a+1))+a;
		a = 26 *interval_mul; b = 50*interval_mul;
		dmax = floor(random()*(b-a+1))+a;
		
		r1.d1 = int4range(dmin, dmax, '[]');

		
		-- DURATA QUADRUPLA 1 SECONDA TABELLA
		a = 1*interval_mul; b = 25*interval_mul;                
		dmin = floor(random()*(b-a+1))+a;
		a = 26 *interval_mul; b = 50*interval_mul;
		dmax = floor(random()*(b-a+1))+a;
		
		r2.d1 = int4range(dmin, dmax, '[]');


		IF countrows < numrows*tempintersect THEN --le quadruple si devono intersecare
		--QUADRUPLA 1 PRIMA TABELLA
		a = 10 * interval_mul; b = 35 * interval_mul;          
		smin = floor(random()*(b-a+1))+a; 
		a = 36 * interval_mul; b = 50 * interval_mul;          
		smax = floor(random()*(b-a+1))+a;
		r1.s1 = int4range(smin,smax, '[]');		
	    -- QUADRUPLA 1 SECONDA TABELLA
		a = 12 * interval_mul ; b = 38 * interval_mul;
		smin = floor(random()*(b-a+1))+a;
		a = 39 * interval_mul ; b = 47 * interval_mul;
		smax = floor(random()*(b-a+1))+a;
		r2.s1 = int4range(smin,smax, '[]');
		
		ELSE --le quadruple non si devono intersecare
		-- QUADRUPLA 1 PRIMA TABELLA
		a = 30 * interval_mul ; b = 56 * interval_mul;        
		smin = floor(random()*(b-a+1))+a; 
		a = 57 * interval_mul ; b = 65 * interval_mul;        
		smax = floor(random()*(b-a+1))+a;
		r1.s1 = int4range(smin,smax, '[]');


		-- QUADRUPLA 1 SECONDA TABELLA
		a = 50 * interval_mul; b = 76 * interval_mul;           
		smin = floor(random()*(b-a+1))+a;               
		a = 77 * interval_mul; b = 95 * interval_mul;
		smax = floor(random()*(b-a+1))+a;
		r2.s1 = int4range(smin,smax, '[]');
	

		
		END IF;
		-- QUADRUPLA 2 PRIMA TABELLA
		a = 1 * interval_mul ; b = 2 * interval_mul;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs ( upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 1 *interval_mul; b = 2 * interval_mul;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = upper(r1.d1) - (floor(random()*(b-a+1))+a);
		IF smin > smax THEN
		r1.s2 = int4range(smax,smin, '[]');		
		ELSE
		r1.s2 = int4range(smin,smax, '[]');	
		END IF;
		
		IF dmin > dmax THEN
		r1.d2 = int4range(dmax,dmin, '[]');		
		ELSE
		r1.d2 = int4range(dmin,dmax, '[]');	
		END IF;
		-- QUADRUPLA 3 PRIMA TABELLA
		a = 2 * interval_mul ; b = 3 * interval_mul;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 2 * interval_mul; b = 3 * interval_mul;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r1.s3 = int4range(lower(r1.s2),upper(r1.s2)-1, '[]');		
		ELSE 
		r1.s3 = int4range(smin,smax, '[]');
		END IF;
		
		IF dmin > dmax THEN
		r1.d3 = int4range(lower(r1.d2),upper(r1.d2)-1, '[]');		
		ELSE 
		r1.d3 = int4range(dmin,dmax, '[]');
		END IF;

    -- QUADRUPLA 4 PRIMA TABELLA
		a = 3 * interval_mul ; b = 4 * interval_mul;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 3 * interval_mul; b = 4 * interval_mul;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r1.s4 = int4range(lower(r1.s3),upper(r1.s3)-1, '[]');		
		ELSE 
		r1.s4 = int4range(smin,smax, '[]');
		END IF;
		
		IF dmin > dmax THEN
		r1.d4 = int4range(lower(r1.d3),upper(r1.d3)-1, '[]');		
		ELSE 
		r1.d4 = int4range(dmin,dmax, '[]');
		END IF;

    -- QUADRUPLA 5 PRIMA TABELLA
		a = 4 * interval_mul ; b = 5 * interval_mul;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 4 * interval_mul; b = 5 * interval_mul;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r1.s5 = int4range(lower(r1.s4),upper(r1.s4)-1, '[]');		
		ELSE 
		r1.s5 = int4range(smin,smax, '[]');
		END IF;
		
		IF dmin > dmax THEN
		r1.d5 = int4range(lower(r1.d4),upper(r1.d4)-1, '[]');		
		ELSE 
		r1.d5 = int4range(dmin,dmax, '[]');
		END IF;



     -- QUADRUPLA 6 PRIMA TABELLA
		a = 5 * interval_mul ; b = 6 * interval_mul;
		smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
		a = 5 * interval_mul; b = 6 * interval_mul;
		dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r1.s6 = int4range(lower(r1.s5),upper(r1.s5)-1, '[]');		
		ELSE 
		r1.s6 = int4range(smin,smax, '[]');
		END IF;
		
		IF dmin > dmax THEN
		r1.d6 = int4range(lower(r1.d5),upper(r1.d5)-1, '[]');		
		ELSE 
		r1.d6 = int4range(dmin,dmax, '[]');
		END IF;


    -- QUADRUPLA 7 PRIMA TABELLA
    a = 6 * interval_mul; b = 7 * interval_mul;
    smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
    a = 6 * interval_mul; b = 7 * interval_mul;
    dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r1.s7 = int4range(lower(r1.s6), upper(r1.s6)-1, '[]');
    ELSE 
        r1.s7 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r1.d7 = int4range(lower(r1.d6), upper(r1.d6)-1, '[]');
    ELSE 
        r1.d7 = int4range(dmin, dmax, '[]');
    END IF;


    -- QUADRUPLA 8 PRIMA TABELLA
    a = 7 * interval_mul; b = 8 * interval_mul;
    smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
    a = 7 * interval_mul; b = 8 * interval_mul;
    dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r1.s8 = int4range(lower(r1.s7), upper(r1.s7)-1, '[]');
    ELSE 
        r1.s8 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r1.d8 = int4range(lower(r1.d7), upper(r1.d7)-1, '[]');
    ELSE 
        r1.d8 = int4range(dmin, dmax, '[]');
    END IF;

    -- QUADRUPLA 9 PRIMA TABELLA
    a = 8 * interval_mul; b = 9 * interval_mul;
    smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
    a = 8 * interval_mul; b = 9 * interval_mul;
    dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r1.s9 = int4range(lower(r1.s8), upper(r1.s8)-1, '[]');
    ELSE 
        r1.s9 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r1.d9 = int4range(lower(r1.d8), upper(r1.d8)-1, '[]');
    ELSE 
        r1.d9 = int4range(dmin, dmax, '[]');
    END IF;

    -- QUADRUPLA 10 PRIMA TABELLA
    a = 9 * interval_mul; b = 10 * interval_mul;
    smin = lower(r1.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r1.s1) - (floor(random()*(b-a+1))+a));
    a = 9 * interval_mul; b = 10 * interval_mul;
    dmin = lower(r1.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r1.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r1.s10 = int4range(lower(r1.s9), upper(r1.s9)-1, '[]');
    ELSE 
        r1.s10 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r1.d10 = int4range(lower(r1.d9), upper(r1.d9)-1, '[]');
    ELSE 
        r1.d10 = int4range(dmin, dmax, '[]');
    END IF;

	
		-- QUADRUPLA 2 SECONDA TABELLA
		a =  1* interval_mul; b = 2*interval_mul;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 1 * interval_mul; b = 2 * interval_mul;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r2.s2 = int4range(lower(r2.s1),upper(r2.s1)-1, '[]');		
		ELSE
		r2.s2 = int4range(smin,smax, '[]');	
		END IF;
		
		IF dmin > dmax THEN
		r2.d2 = int4range(lower(r2.d1),upper(r2.d1)-1, '[]');		
		ELSE
		r2.d2 = int4range(dmin,dmax, '[]');	
		END IF;
	
		-- QUADRUPLA 3 SECONDA TABELLA
		a = 2 * interval_mul ; b = 3 * interval_mul;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 2 * interval_mul; b = 3 * interval_mul;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r2.s3 = int4range(lower(r2.s2),upper(r2.s2)-1, '[]');		
		ELSE
		r2.s3 = int4range(smin,smax, '[]');		
		END IF;
		IF dmin > dmax THEN
		r2.d3 = int4range(lower(r2.d2),upper(r2.d2)-1, '[]');			
		ELSE
		r2.d3 = int4range(dmin,dmax, '[]');		
		END IF;

    -- QUADRUPLA 4 SECONDA TABELLA
		a = 3 * interval_mul ; b = 4 * interval_mul;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 3 * interval_mul; b = 4 * interval_mul;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r2.s4 = int4range(lower(r2.s3),upper(r2.s3)-1, '[]');		
		ELSE
		r2.s4 = int4range(smin,smax, '[]');		
		END IF;
		IF dmin > dmax THEN
		r2.d4 = int4range(lower(r2.d3),upper(r2.d3)-1, '[]');		
		ELSE
		r2.d4 = int4range(dmin,dmax, '[]');		
		END IF;

    -- QUADRUPLA 5 SECONDA TABELLA
		a = 4 * interval_mul ; b = 5 * interval_mul;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 4 * interval_mul; b = 5 * interval_mul;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r2.s5 = int4range(lower(r2.s4),upper(r2.s4)-1, '[]');		
		ELSE
		r2.s5 = int4range(smin,smax, '[]');		
		END IF;
		IF dmin > dmax THEN
		r2.d5 = int4range(lower(r2.d4),upper(r2.d4)-1, '[]');		
		ELSE
		r2.d5 = int4range(dmin,dmax, '[]');		
		END IF;

     -- QUADRUPLA 6 SECONDA TABELLA
		a = 5 * interval_mul ; b = 6 * interval_mul;
		smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
		smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
		a = 5 * interval_mul; b = 6 * interval_mul;
		dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
		dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
		IF smin > smax THEN
		r2.s6 = int4range(lower(r2.s5),upper(r2.s5)-1, '[]');		
		ELSE 
		r2.s6 = int4range(smin,smax, '[]');
		END IF;
		
		IF dmin > dmax THEN
		r2.d6 = int4range(lower(r2.d5),upper(r2.d5)-1, '[]');		
		ELSE 
		r2.d6 = int4range(dmin,dmax, '[]');
		END IF;


    -- QUADRUPLA 7 SECONDA TABELLA
    a = 6 * interval_mul; b = 7 * interval_mul;
    smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
    a = 6 * interval_mul; b = 7 * interval_mul;
    dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r2.s7 = int4range(lower(r2.s6), upper(r2.s6)-1, '[]');
    ELSE 
        r2.s7 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r2.d7 = int4range(lower(r2.d6), upper(r2.d6)-1, '[]');
    ELSE 
        r2.d7 = int4range(dmin, dmax, '[]');
    END IF;


    -- QUADRUPLA 8 SECONDA TABELLA
    a = 7 * interval_mul; b = 8 * interval_mul;
    smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
    a = 7 * interval_mul; b = 8 * interval_mul;
    dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r2.s8 = int4range(lower(r2.s7), upper(r2.s7)-1, '[]');
    ELSE 
        r2.s8 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r2.d8 = int4range(lower(r2.d7), upper(r2.d7)-1, '[]');
    ELSE 
        r2.d8 = int4range(dmin, dmax, '[]');
    END IF;

    -- QUADRUPLA 9 SECONDA TABELLA
    a = 8 * interval_mul; b = 9 * interval_mul;
    smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
    a = 8 * interval_mul; b = 9 * interval_mul;
    dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r2.s9 = int4range(lower(r2.s8), upper(r2.s8)-1, '[]');
    ELSE 
        r2.s9 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r2.d9 = int4range(lower(r2.d8), upper(r2.d8)-1, '[]');
    ELSE 
        r2.d9 = int4range(dmin, dmax, '[]');
    END IF;

    -- QUADRUPLA 10 SECONDA TABELLA
    a = 9 * interval_mul; b = 10 * interval_mul;
    smin = lower(r2.s1) + (floor(random()*(b-a+1))+a);
    smax = abs (upper(r2.s1) - (floor(random()*(b-a+1))+a));
    a = 9 * interval_mul; b = 10 * interval_mul;
    dmin = lower(r2.d1) + (floor(random()*(b-a+1))+a);
    dmax = abs (upper(r2.d1) - (floor(random()*(b-a+1))+a));
    IF smin > smax THEN
        r2.s10 = int4range(lower(r2.s9), upper(r2.s9)-1, '[]');
    ELSE 
        r2.s10 = int4range(smin, smax, '[]');
    END IF;

    IF dmin > dmax THEN
        r2.d10 = int4range(lower(r2.d9), upper(r2.d9)-1, '[]');
    ELSE 
        r2.d10 = int4range(dmin, dmax, '[]');
    END IF;




-- INSERIMENTO NELLE TABELLE
		INSERT INTO t1_im_pref10 SELECT r1.*;
		INSERT INTO t2_im_pref10 SELECT r2.*;
		
		INSERT INTO t1_me_pref10 SELECT * FROM MakeExplicit_Pref10(r1.Attr1, r1.Attr2, r1.s1, r1.d1, r1.s2, r1.d2, r1.s3, r1.d3, r1.s4, r1.d4,  r1.s5, r1.d5,
                                                                                 r1.s6, r1.d6, r1.s7, r1.d7, r1.s8, r1.d8, r1.s9, r1.d9,  r1.s10, r1.d10);
		INSERT INTO t2_me_pref10 SELECT * FROM MakeExplicit_Pref10(r2.Attr1, r2.Attr2, r2.s1, r2.d1, r2.s2, r2.d2, r2.s3, r2.d3, r2.s4, r2.d4,  r2.s5, r2.d5,
                                                                                 r2.s6, r2.d6, r2.s7, r2.d7, r2.s8, r2.d8, r2.s9, r2.d9,  r2.s10, r2.d10);
								   
		INSERT INTO t5 SELECT r1.Attr1, r1.Attr2;
		INSERT INTO t6 SELECT r2.Attr1, r2.Attr2;
		
	END LOOP;
END; $$
LANGUAGE plpgsql;

SELECT POPOLAMENTO_PREF10(250,0.1,0.1,1);

