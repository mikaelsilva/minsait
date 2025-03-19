select distinct(MEDICATION_TEXT),count(*) QTD_MEDICATION
from medication_request
group by MEDICATION_TEXT
order by QTD_MEDICATION desc
limit 100