SELECT *
FROM us_retail_sales
ORDER BY 5;

SELECT sales_month, sales
FROM us_retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
ORDER BY 1;
