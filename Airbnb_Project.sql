#Duplicate ID check. 

select *
from airbnb
;

select * 
from ( 
select id, row_number() over (partition by id order by id) as duplicates
from airbnb) cleaning 
where duplicates > 1    #There is no duplicates ID 
;

select distinct `host_identity_verified`
from airbnb
;

select count(*)   #There 31 data which are not identified on verify subject. 
from airbnb       # If it was big population I would not remove, but very little there I will remove.
where `host_identity_verified` = '' or `host_identity_verified` is null or `host_identity_verified` = '0'
;

delete from airbnb
where `host_identity_verified` = '' or `host_identity_verified` is null or `host_identity_verified` = '0'
;

select distinct `neighbourhood group`
from airbnb
;

select *           # Ten data is empty, that i will remove.
from airbnb 
where `neighbourhood group` = ''
;

delete from airbnb 
where `neighbourhood group` = '' 
;

update airbnb                          #Updated spelling mistakes
set `neighbourhood group` = case
when `neighbourhood group` = 'brookln' then 'Brooklyn'
when `neighbourhood group` = 'manhatan' then 'Manhattan'
else `neighbourhood group`
end
;

select distinct country  #Checked 
from airbnb
;

update airbnb      #All date is based on US therefore, I populated all blanks and null values to United States in country variable.
set country = 'United States' 
where country = '' or country is null 
;


select distinct cancellation_policy #Checked 
from airbnb
;

select *   # There are 34 missing that, however, I will not remove. 
from airbnb  
where cancellation_policy is null or cancellation_policy = '' or cancellation_policy 
;

select distinct `room type`  #Checked 
from airbnb 
;


select distinct `Construction year`  #Checked 
from airbnb 
;

update airbnb                      #Correcting 
set price = replace(price, '$', '')
;

select concat('$', price),         #Correcting 
concat( '$', `service fee`)
from airbnb 
;

select *   #Checking null, blank, 0 values.
from airbnb 
where price = '' or price = 0 or price is null
;

update airbnb        #According to data there is 20% service fee of price, therefore populated.
set price = `service fee` * 5
where price = '' or price is null or price = '0'
;

select *
from airbnb 
where `service fee` = '' or `service fee` = 0 or `service fee` is null
;

update airbnb          #According to data there is 20% service fee of price, therefore updated this one also.
set `service fee` = price / 5
where `service fee` = '' or `service fee` is null or `service fee` = 0
;

select *      #Checked
from airbnb 
where `minimum nights` is null or `minimum nights` = '' or `minimum nights` = 0
;

select *    # 885 data here which are 0, it could be, hence , I will do nothing. 
from airbnb 
where `number of reviews` is null or `number of reviews` = '' or `number of reviews` = 0
;

select *  # Checked the count of data based on null or 0. 
from airbnb 
where `number of reviews` = 0
;

show columns from airbnb   #last_review is not in date foormat.
;

select *           #There are null string values, I will change these to null.
from airbnb 
where `last review` = '' 
;

update airbnb    #Updated.
set `last review` = null
where `last review` = ''
;

select str_to_date(`last review`, '%m/%d/%Y')  #Changed the style also. 
from airbnb
;

update airbnb                                 #Updated. 
set `last review` = str_to_date(`last review`, '%m/%d/%Y') 
;

alter table airbnb                       #Addding new column in date format
add column `last_review_date` date
;

update airbnb     #Carried to the new location.
set `last_review_date` = `last review`
;

alter table airbnb        #Dropping old column. 
drop column `last review`  
;

select min(`reviews per month`), max(`reviews per month`)
from airbnb
;

select *
from airbnb 
where `reviews per month` is null or `reviews per month` = 0 or `reviews per month` = '' 
;

show columns from airbnb;

select *   # Realized that data type is text, it has to be float. 
from airbnb 
where `reviews per month` = 0
;


select `reviews per month`, cast(`reviews per month` as float)
from airbnb
;

update airbnb  
set `reviews per month` = round(cast(`reviews per month` as float),1)  #Changed to data type from text to float.
;

alter table airbnb               #Changed to data type from text to float.
modify `reviews per month` float
;

show columns from airbnb  #Checked.
;

update airbnb        #Changed to string values to null 
set `reviews per month` = null 
where `reviews per month` = '' 
;

select *    #Checked
from airbnb 
where `review rate number` is null or `review rate number` = 0 or `review rate number` = ''
;

select min(`review rate number`), max(`review rate number`)  #Checked.
from airbnb
;

select *    #Checked. 
from airbnb 
where `calculated host listings count` is null or `calculated host listings count` = 0 or `calculated host listings count` =''
;

select avg (`calculated host listings count`), min(`calculated host listings count`), max(`calculated host listings count`)
from airbnb  #Checked.
;

select *    # 21 data are 0,however when I checked other variables, it can not be. Hence, I will change these from 0 to NULL.
from airbnb 
where `availability 365` is null or `availability 365` = 0 or `availability 365` = ''
;

update airbnb 
set `availability 365` = null 
where `availability 365` = 0 
;

select *
from airbnb
;

select price, min(price), max(price) 
from airbnb 
group by price 
order by min(price) desc
;

select *
from airbnb 
where price = '0' or price = '' or price is null
;

update airbnb
set price = null 
where price = '0' or price = '' or price is null
;


#EXPLARATORY DATA ANALYSIS 

select avg_price
from(
select round(avg(price),2) as avg_price
from airbnb 
where `room type` = 'Entire home/apt' 
and  `neighbourhood group` = 'Brooklyn') as avg_price_summary
;

select avg(price) 
from airbnb
where `room type` = 'Entire home/apt' 
and `neighbourhood group` = 'Brooklyn'
;

select count(*)
from airbnb
;


select *        
from airbnb
where price > (select avg(price)
from airbnb)
and `room type` = 'Entire home/apt' 
;

select count(*)  #Denemeler mantığına bakıcam sonra. 
from airbnb
where price > (
    select avg(price)
    from airbnb)
and `room type` = 'Entire home/apt'
;

select count(*),   #Calculating number of prices below and above of average_
case               # Numbers of 2 categories are almost same, which means there is no huge difference between all prices.
when price > avg_price then 'High Price'   #It is kinda outlier dedection also. 
when price < avg_price then 'Low Price'
else 'Average Price'
end as price_category
from ( select price,
		(select avg(price) from airbnb) as avg_price
from airbnb) as subq
group by  
case 
when price > avg_price then 'High Price'
when price < avg_price then 'Low Price'
else 'Average Price'
end
;

select count(*), min(price),max(price), avg(price)  #Checked 
from airbnb
where `neighbourhood group` = 'Manhattan'
and   `room type`= 'Private room'
;

select count(*) 
from airbnb
where `neighbourhood group` = 'Manhattan'
;

select count(*) # It is a interesting finding.
from airbnb     #There are tonnes of data, which indicate private room could be higher than entire apt.   
where `neighbourhood group` = 'Manhattan' 
and price > (select avg(price)  #Checked 
from airbnb
where `neighbourhood group` = 'Manhattan'
and   `room type`= 'Entire home/apt') 
;


select avg(price)     #There is not a significant difference between verified and unconfirmed subject.
from airbnb 
where host_identity_verified = 'unconfirmed'
;

select avg(price)
from airbnb 
where host_identity_verified = 'verified'
;

select `neighbourhood group`, `room type`, avg(price) 
from airbnb
where `neighbourhood group` = 'Manhattan'
group by  `neighbourhood group`, `room type`
;

select `neighbourhood group`,
dense_rank() over(partition by `neighbourhood group` order by price desc) top_list
from airbnb
;

select `neighbourhood group`, avg(price)
from airbnb 
group by `neighbourhood group`
having avg(price) > 500
;

select id,`minimum nights`#Company desires to give award top 10 customers according to their accomadations days.
from airbnb
order by `minimum nights` desc 
limit 10
;

select round(avg(`minimum nights`),1)   # Average minimum night is 9.1 
from airbnb
;



select count(*)   #There are 1220 data which are higher than average 'minimum nights' variable.  
from airbnb 
where (`minimum nights`) > 
						(select round(avg(`minimum nights`),1)
						from airbnb)
;

select id, sum(`availability 365`)   #Finding homeowners who have more availability compared to average to give discount.
from airbnb 
group by id
having sum(`availability 365`) > (select avg(`availability 365`) 
								  from airbnb)
;

select *  # Lowest 100 prices to give promotion. 
from airbnb
where price in (select min(price)
				from airbnb
				group by id)
order by price asc
limit 100
;



select if (`minimum nights` > (select avg(`minimum nights`) from airbnb) and price < 1000 
and `availability 365` > 200, 'İyi','Kötü') as will_be_awarded, count(*) as count
from airbnb
group by will_be_awarded
;


#Company will make a discount for their best partners and this will be on 3 subjects, which are;

# Minimum nights must be more than average
# Price must be less than 1000 dollars 
# Availability must be more than 200 in a year. 

select *
from (select *, if (`minimum nights` > (select avg(`minimum nights`) from airbnb) and price < 1000 
and `availability 365` > 200, 'İyi','Kötü') as will_be_awarded
from airbnb) as award
where will_be_awarded = 'İyi'
;

select *
from airbnb
;



