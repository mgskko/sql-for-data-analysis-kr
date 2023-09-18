SELECT *
FROM us_retail_sales
ORDER BY 5;



SELECT sales_month, sales
FROM us_retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
ORDER BY 1;

SELECT YEAR(SALES_MONTH) AS SALES_YEAR,
    SUM(SALES) AS SALES
FROM US_RETAIL_SALES
WHERE KIND_OF_BUSINESS = 'RETAIL AND FOOD SERVICES SALES, TOTAL'
GROUP BY SALES_YEAR
ORDER BY SALES_YEAR;


SELECT YEAR(sales_month) AS sales_year,
       kind_of_business,
       SUM(sales) AS sales
FROM US_RETAIL_SALES
WHERE kind_of_business IN ('Book stores', 'Sporting goods stores', 'Hobby, toy, and game stores')
GROUP BY sales_year, kind_of_business
ORDER BY sales_year, kind_of_business;

SELECT *
FROM US_RETAIL_SALES

-- 여성 의류업 매출, 남성 의류업 매출 월별 분석

SELECT sales_month, kind_of_business, SALES
FROM US_RETAIL_SALES
WHERE kind_of_business IN ('Men''s clothing stores','Women''s clothing stores')
ORDER BY 1, 2


-- 연별 분석

SELECT YEAR(sales_month) AS sales_year, kind_of_business,
 SUM(SALES) AS SALES
FROM US_RETAIL_SALES
WHERE kind_of_business IN ('Men''s clothing stores','Women''s clothing stores')
GROUP BY 1, 2
ORDER BY 1, 2


-- 두 업종 간 매출 차이, 비율 차이 계산

SELECT
    YEAR(sales_month) AS sales_year,
    SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales ELSE 0 END) AS womens_sales,
    SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales ELSE 0 END) AS mens_sales
FROM
    US_RETAIL_SALES
WHERE
    kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY
    sales_year
ORDER BY
    sales_year;
    
-- 2020년 이전의 데이터만 활용(서브쿼리 사용)

SELECT sales_year,
       womens_sales - mens_sales AS womens_minus_mens,
       mens_sales - womens_sales AS mens_minus_womens
FROM (
    SELECT YEAR(sales_month) AS sales_year,
           SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS womens_sales,
           SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
    FROM US_RETAIL_SALES
    WHERE kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
      AND sales_month <= '2019-12-01'
    GROUP BY 1
) a
ORDER BY 1;

-- 2020년 이전의 데이터만 활용(서브쿼리 사용X)

SELECT YEAR(sales_month) AS sales_year,
           (SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) 
           -
           SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END)) AS womens_minus_mens
    FROM US_RETAIL_SALES
    WHERE kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
      AND sales_month <= '2019-12-01'
    GROUP BY 1
    ORDER BY 1;
