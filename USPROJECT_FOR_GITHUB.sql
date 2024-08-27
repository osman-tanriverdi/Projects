select *
from us_income
;

select *
from us_stat
;

alter table us_stat rename column `ï»¿id` to `id`   #Correcting a column
;

select row_id, id, count(id)    #Checking Id
from us_income                  #Some of data have more than 1 id.
group by id 
having count(id) > 1
;

select id, count(id)        	#Duplicates checked.
from us_stat                	
group by id 
having count(id) > 1
;

delete from us_income           # Query for cleaning duplicate ID's in us_income 
where row_id in (
	select row_id
	from(
		select row_id,
		row_number() over(partition by id) as cleaning
		from us_income) as subq
		where cleaning > 1)
;

select distinct state_name   #Checked.
from us_income               #One state_name is not proper. 
;


update us_income 
set state_name = 'Georgia '
where state_name = 'georia'
;

select distinct state_ab   #Checked 
from us_income
;

select *                 #Checked 
from us_income
where county is null or county = '' 
;

select *                 #Checked 
from us_income
where city is null or city = ''
;

select *                 #Checked 
from us_income           #One value is missing 
where place is null or place = ''
;

select *         # I wrote this to make sure that data which has 'Autuga County' match with 'Autaugaville' in the place variable.
from us_income   # All data same, hence, I will populate.
where county = 'Autauga County'    
;

update us_income             
set place =    'Autaugaville'
where county = 'Autauga County'
and city = 'Vinemont'
;

select distinct type   # Checked 
from us_income
;

select *           #Checked 
from us_income
where `primary` is null or `primary` = ''
;

select *                 #Checked 
from us_income
where zip_code is null or zip_code = '' or zip_code = 0
;

select *                 #Checked 
from us_income
where area_code is null or area_code  = '' or area_code = 0
;

select *                 # There are 66 missing values. 
from us_income
where aland is null or aland = '' or aland = 0
;


select *             # 12370 of data has no water area. It could be possible, therefore, I will do nothing.
from us_income
where awater is null or awater = '' or awater = 0
;


select *            #Checked
from us_income 
where lat is null or lat = '' or lat = 0
;

select *            #Checked
from us_income 
where lon is null or lon = '' or lon = 0
;

#Standartize and Cleaning us_stat table. 

select id, count(id)    #Duplicate ID checked. 
from us_stat 
group by id 
having count(id) > 1
;

select distinct(state_name) #Checked
from us_stat 
;

select *
from us_stat
where mean is null or mean = '' or mean = 0 
;

select *
from us_stat
where median is null or median  = '' or median  = 0 
;

select *
from us_stat
where stdev is null or stdev  = '' or stdev  = 0 
;

select *
from us_stat
where sum_w is null or sum_w  = '' or sum_w  = 0 
;

# After checking mean,median,stdev and sum_w, I found that 315 values are missing for all 4 categories.
# Hence, I will clean those outliers. 

delete from us_stat 
where mean is null or mean = '' or mean = 0 
;


#Explaratory Data Analysis
#Starting with join 

select inc.state_name, round(avg(mean),2),round(avg(median),2)
from us_income inc             # Top five state for mean income. 
join us_stat st
on inc.id = st.id
group by inc.state_name
order by avg(mean) desc
limit 5 
;
 
select inc.city, round(avg(mean),1), round(avg(median),1)
from us_income inc          
inner join us_stat st         #Top 10 five city according to the mean of income. 
on inc.id = st.id 
group by inc.city
order by 2 desc
limit 10
; 

select `type`, count(Type), round(avg(aland),2), round(avg(awater),2) 
from us_income              #Average aland and awater according to settlement type. 
group by `type`
;


select count(*)     #Check number of mean greater than average.
from us_stat
where mean > (select avg(mean)
				from us_stat)
;


select *
from us_income
;

select *
from us_stat
;