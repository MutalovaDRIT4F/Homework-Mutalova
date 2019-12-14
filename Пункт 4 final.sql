-- Запрашиваем основные данные "IssuerName", nun_ratio, "ISIN", которые нам нужны
SELECT "IssuerName", nun_ratio, "ISIN"
FROM 
-- Составляем подзапрос, который объединяет всех эмитентов, чью облигации торгуются на Московской Бирже в режиме основных торгов и 
--значения nun_ratio по всем. облигациям
(SELECT "IssuerName", S1."ISIN", (SS1::real / SS2::real) AS nun_ratio
FROM (SELECT DISTINCT "IssuerName", "ISIN" FROM public.listing 
	  WHERE "Platform" = 'Московская Биржа ' AND "Section" = ' Основной' AND "IssuerName" IS NOT NULL) AS S1
INNER JOIN (
-- Здесь мы рассчитываем показатель nun_ratio, предварительно посчитав количество дней отсутствия "ASK" по каждой бумаге и
--количество дней, когда по бумаге рассматривалось значение "ASK"
	(SELECT COUNT ("ASK") AS SS1, "ISIN" AS ISIN FROM public.quotes WHERE "ASK" = 0 OR "ASK" IS NULL GROUP BY "ISIN") AS B1 
	INNER JOIN  
	(SELECT COUNT("ISIN") AS SS2, "ISIN" FROM public.quotes GROUP BY "ISIN") AS B2
	 ON ISIN = B2."ISIN") AS S2
ON S1."ISIN" = ISIN) AS S3
--Производим группировку по эмитенту и облигации
GROUP BY "ISIN", "IssuerName", nun_ratio
HAVING nun_ratio < 0.1;