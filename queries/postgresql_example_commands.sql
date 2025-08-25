
-- This SQL script removes duplicate rows from the sales_data table based on all columns except the id

select * from sales_data;
WITH ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY invoice_no, stock_code, description, quantity, invoice_date, unit_price, customer_id, country
           ORDER BY id
         ) AS rn
  FROM sales_data
)
DELETE FROM sales_data
WHERE id IN (
  SELECT id FROM ranked WHERE rn > 1
);

-- cleaning country_info table
select * from country_info;
alter table country_info drop column country_p, drop column land_area_p, drop column median_age_p, drop column fertility_rate_p;
select * from country_info;



--

update country_info set country = 'Curacao' where country='CuraÄ‚ďż˝Ă‚Â§ao';
delete from country_info where country='RÄ‚ďż˝Ă‚Â©union';
update country_info set country ='Ivory Coast' where country = 'CÄ‚ďż˝Ă‚Â´te d''Ivoire'; 
SELECT * FROM country_info

-- summany table

create table transaction_summary as
select  invoice_no, customer_id, invoice_date, country, sum(quantity*unit_price) as transaction_value
from sales_data
group by invoice_no, customer_id, invoice_date, country;
select * from transaction_summary;


--- views
create view income_country as
select country, sum(quantity*unit_price) as income,
sum(case when quantity <0 then quantity*unit_price else 0 end) as loss,
sum (case when quantity >0 then quantity * unit_price else 0 end) as revenue
from sales_data
group by country;
select * from income_country;


--

create view income_country as
select sum(unit_price * quantity) as income, country, 
sum(case when quantity > 0 then quantity*unit_price else 0::money END) as revenue,
sum(case when quantity <0 then quantity*unit_price else 0 ::money end) as loss
from sales_data
group by country;
select * from income_country;


--
CREATE VIEW country_miss AS
SELECT DISTINCT sales_data.country
FROM sales_data
LEFT JOIN country_info 
  ON sales_data.country = country_info.country
WHERE country_info.country IS NULL;
select * from country_miss

--
--
update sales_data set status = null;
select * from sales_data;
--

select * from sales_data where unit_price=0.0;
--
select * from sales_data where unit_price<=0 or quantity <=0;
--
update sales_data set status=description where  unit_price<=0 or quantity <=0 and description <> upper(description);
--
update sales_data set status = trim(status);
select * from sales_data;
update sales_data set status='finished' where quantity>0;
select * from sales_data;
--
drop table stock_code
create table stock_code as
select distinct stock_code, description from sales_data
where description =upper(description);
select * from stock_code;
--

