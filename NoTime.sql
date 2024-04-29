CREATE OR REPLACE FUNCTION differenza_NoTime()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150)
) 
AS $$
BEGIN
RETURN QUERY
select * 
from t5
where not exists 
(select * from t6 where t5.Attr1 = t6.Attr1 and t5.Attr2 = t6.Attr2);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION prodotto_cartesiano_NoTime()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150)
) 
AS $$
BEGIN
RETURN QUERY
select t5.Attr1, t5.Attr2, t6.Attr1, t6.Attr2
from t5, t6;
END;
$$ LANGUAGE plpgsql;




