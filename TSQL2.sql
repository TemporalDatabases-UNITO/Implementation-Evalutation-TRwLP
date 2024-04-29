CREATE OR REPLACE FUNCTION prodotto_cartesiano_TSQL2()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  Attr2_t1 varchar(150),
  Attr2_t2 varchar(150),
  times int4range
) 
AS $$
BEGIN
RETURN QUERY
select t7.Attr1, t7.Attr2, t8.Attr1, t8.Attr2, t7.T * t8.T as T
from t7, t8
where t7.T && t8.T;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION differenza_TSQL2()
RETURNS TABLE(
  Attr1_t1 varchar(150),
  Attr1_t2 varchar(150),
  times int4range
)
AS $$
BEGIN
RETURN QUERY
 with t as (
  select t7.Attr1, t7.Attr2, t7.T, range_exclude(t7.T, array_agg(t8.T)) as ex2 
  from t7 join t8 on (t7.Attr1 = t8.Attr1 and t7.Attr2 = t8.Attr2)
  group by t7.Attr1, t7.Attr2, t7.T)
select * from (
	select Attr1, Attr2, unnest(ex2) as Time from t 
	union
	select Attr1, Attr2, T from t7 where not exists (select * from t8 where t8.Attr1 = t7.Attr1 and t8.Attr2 = t7.Attr2)) res
where res.Time is not null;
END;
$$ LANGUAGE plpgsql;



create or replace function range_exclude(anyelement, anyelement) returns anyarray as $$
declare
  r1 text;
  r2 text;
begin
  -- Check input parameters
  if not pg_typeof($1) in ('numrange'::regtype, 'int4range'::regtype, 'daterange'::regtype, 'tsrange'::regtype, 'tstzrange'::regtype) then
    raise exception 'Function accepts only range types but got % type.', pg_typeof($1);
  end if;

  -- If result is single element
  if ($1 &< $2 or $1 &> $2) then
    return array[$1 - $2];
  end if;

  -- Else build array of two intervals
  if lower_inc($1) then r1 := '['; else r1 := '('; end if;
  r1 := r1 || lower($1) || ',' || lower($2);
  if lower_inc($2) then r1 := r1 || ')'; else r1 := r1 || ']'; end if;

  if upper_inc($2) then r2 := '('; else r2 := '['; end if;
  r2 := r2 || upper($2) || ',' || upper($1);
  if upper_inc($1) then r2 := r2 || ']'; else r2 := r2 || ')'; end if;
  return array[r1, r2];
end $$ immutable language plpgsql;

create or replace function range_exclude(anyelement, anyarray) returns anyarray as $$
declare
  i int;
  j int;
begin
  -- Check input parameters
  if not pg_typeof($1) in ('numrange'::regtype, 'int4range'::regtype, 'daterange'::regtype, 'tsrange'::regtype, 'tstzrange'::regtype) then
    raise exception 'Function accepts only range types but got % type.', pg_typeof($1);
  end if;

  if array_length($2,1) is null then
    return array[$1];
  end if;

  $0 := range_exclude($1,$2[array_lower($2,1)]);
  for i in array_lower($2,1) + 1 .. array_upper($2,1) loop
    select array(select x from (select unnest(range_exclude(x,$2[i])) from unnest($0) as t(x)) as t(x) where not isempty(x) and x is not null) into $0;
  end loop;
  return $0;
end $$ immutable language plpgsql;