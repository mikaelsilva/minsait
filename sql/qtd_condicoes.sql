select distinct(DISPLAY),count(*) QTD_CONDITION
from condition
group by DISPLAY
order by QTD_CONDITION desc
limit 100