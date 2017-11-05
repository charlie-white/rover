create database rover;
use rover;

drop table if exists clickstream;
create table clickstream (
       distinct_id char(32) NOT NULL
     , event_name char(16) NOT NULL
     , page_category char(16) NOT NULL
     , person_opk char(32) NULL
     , ts BIGINT NOT NULL
     , uri_path varchar(255) NOT NULL
     , utm_source char(32) NULL
     , INDEX(ts));

LOAD DATA INFILE '/Users/charlie/code/rover/webevents.csv'
INTO TABLE clickstream
FIELDS terminated by ','
LINES terminated by '\n'
IGNORE 1 LINES
(distinct_id
,event_name
,page_category
,@person_opk
,ts
,uri_path
,@utm_source)
SET person_opk = nullif(@person_opk, '')
  , utm_source = nullif(@utm_source, '');

-- Q: How many unique users both authenticated and anonymous visited the homepage?
-- A: 4141
select count(distinct distinct_id)
  from clickstream
 where page_category = 'home';




-- Q: Of authenticated users who visited the homepage, what percent
--    go on to visit a search page in less than 30 minutes?
-- A: 46

select count(distinct first.person_opk)
from (select person_opk
           , min(ts) as first_home_ts
           , max(ts) as last_home_ts
        from clickstream
       where page_category = 'home'
         and person_opk is not null
       group by 1) last
join (select person_opk
           , min(ts) as first_search_ts
        from clickstream
       where page_category = 'search'
         and person_opk is not null
       group by 1) first
  on first.person_opk = last.person_opk
 and first_search_ts between first_home_ts and last_home_ts + 30000;


-- Q: What is the average number of search pages that a user visits?
-- A: 1.1697

select avg(search_count)
from (select distinct_id, count(*) as search_count
        from clickstream
       where page_category = 'search'
       group by 1) as user_searches;

-- Q: Which UTM source is best at generating users who visit the homepage and then a search page?
-- A: 9113d19048abb65bbff551b3417301d6
select home_click.utm_source, count(*)
  from clickstream home_click
  join clickstream search_click
    on search_click.distinct_id = home_click.distinct_id
 where home_click.page_category = 'home'
   and search_click.page_category = 'search'
 group by 1
 order by 2;
