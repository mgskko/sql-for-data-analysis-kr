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

-- 두 업종의 비율


SELECT sales_year, 
	womens_sales / mens_sales AS womens_times_of_mens
FROM 
(SELECT YEAR(sales_month) AS sales_year, 
		SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS womens_sales,
		SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
FROM US_RETAIL_SALES
WHERE kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
      AND sales_month <= '2019-12-01'
GROUP BY 1) AS A
ORDER BY 1

-- 두 업종의 비율 차이

SELECT sales_year, 
	(womens_sales / mens_sales - 1) * 100 AS womens_times_of_mens
FROM 
(SELECT YEAR(sales_month) AS sales_year, 
		SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS womens_sales,
		SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
FROM US_RETAIL_SALES
WHERE kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
      AND sales_month <= '2019-12-01'
GROUP BY 1) AS A
ORDER BY 1

-- 전체 대비 비율 계산 pct_total_sales

SELECT sales_month, kind_of_business, (SALES / total_sales)*100 AS pct_total_sales
FROM 
(SELECT A.sales_month, A.kind_of_business, A.SALES, SUM(B.SALES) AS total_sales
FROM US_RETAIL_SALES AS A
JOIN US_RETAIL_SALES AS B
ON A.sales_month = B.sales_month
WHERE A.kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
AND
	B.kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
    GROUP BY 1,2,3
    ) AS AA
    ORDER BY 1,2

    
    
-- 업종별 연 매출 대비 월간 매출 비율

SELECT 
    a.sales_month,
    a.kind_of_business,
    a.sales * 100 / b.yearly_sales AS pct_yearly
FROM
    US_RETAIL_SALES a
JOIN (
    SELECT 
        YEAR(sales_month) AS sales_year,
        kind_of_business,
        SUM(sales) AS yearly_sales
    FROM US_RETAIL_SALES
    WHERE kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
    GROUP BY 1, 2
) b ON
    YEAR(a.sales_month) = b.sales_year
    AND a.kind_of_business = b.kind_of_business
WHERE a.kind_of_business IN ('Men''s clothing stores', 'Women''s clothing stores')
ORDER BY 1, 2;


-- 2019년의 데이터 업종별 연 매출 대비 월간 매출 비율

SELECT 
    sales_year,
    sales,
    (SELECT sales FROM (
        SELECT YEAR(sales_month) AS sales_year, SUM(sales) AS sales
        FROM US_RETAIL_SALES
        WHERE kind_of_business = 'Women''s clothing stores'
        GROUP BY 1
    ) a ORDER BY sales_year LIMIT 1) AS index_sales
FROM (
    SELECT YEAR(sales_month) AS sales_year, SUM(sales) AS sales
    FROM US_RETAIL_SALES
    WHERE kind_of_business = 'Women''s clothing stores'
    GROUP BY 1
) a;

-- 비율 변화

SELECT 
    sales_year,
    sales,
    (SELECT sales FROM (
        SELECT YEAR(sales_month) AS sales_year, SUM(sales) AS sales
        FROM US_RETAIL_SALES
        WHERE kind_of_business = 'Women''s clothing stores'
        GROUP BY 1
    ) a ORDER BY sales_year LIMIT 1) AS index_sales
FROM (
    SELECT YEAR(sales_month) AS sales_year, SUM(sales) AS sales
    FROM US_RETAIL_SALES
    WHERE kind_of_business = 'Women''s clothing stores'
    GROUP BY 1
) a;



-- 시간 윈도우 롤링


SELECT a.sales_month
     , a.sales
     , b.sales_month AS rolling_sales_month
     , b.sales AS rolling_sales
FROM US_RETAIL_SALES a
JOIN US_RETAIL_SALES b ON a.kind_of_business = b.kind_of_business 
  AND b.sales_month BETWEEN DATE_SUB(a.sales_month, INTERVAL 11 MONTH) AND a.sales_month
  AND b.kind_of_business = 'Women''s clothing stores'
WHERE a.kind_of_business = 'Women''s clothing stores'
  AND a.sales_month = '2019-12-01';


-- 집계

SELECT
    a.sales_month,
    a.sales,
    AVG(b.sales) AS moving_avg,
    COUNT(b.sales) AS records_count
FROM
    US_RETAIL_SALES AS a
JOIN
    US_RETAIL_SALES AS b ON a.kind_of_business = b.kind_of_business
    AND b.sales_month BETWEEN DATE_SUB(a.sales_month, INTERVAL 11 MONTH) AND a.sales_month
    AND b.kind_of_business = 'Women''s clothing stores'
WHERE
    a.kind_of_business = 'Women''s clothing stores'
    AND a.sales_month >= '1993-01-01'
GROUP BY
    a.sales_month, a.sales
ORDER BY
    a.sales_month;












