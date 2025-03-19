select distinct(GENDER),count(*) count_gender 
from patient 
group by GENDER 
order by count_gender desc
limit 10