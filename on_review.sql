-- ПЕРВОЕ ЗАДАНИЕ --

-- Создание таблицы bond_description
-- В качестве ключа выбрал первый столбец.

-- Table: public.bond_description

-- DROP TABLE public.bond_description;

CREATE TABLE public.bond_description
(
    "ISIN, RegCode, NRDCode" text COLLATE pg_catalog."default" NOT NULL,
    "FinToolType" text COLLATE pg_catalog."default" NOT NULL,
    "SecurityType" text COLLATE pg_catalog."default",
    "SecurityKind" text COLLATE pg_catalog."default",
    "CouponType" text COLLATE pg_catalog."default",
    "RateTypeNameRus_NRD" text COLLATE pg_catalog."default",
    "CouponTypeName_NRD" text COLLATE pg_catalog."default",
    "HaveOffer" boolean NOT NULL,
    "AmortisedMty" boolean NOT NULL,
    "MaturityGroup" text COLLATE pg_catalog."default",
    "IsConvertible" boolean NOT NULL,
    "ISINCode" text COLLATE pg_catalog."default" NOT NULL,
    "Status" text COLLATE pg_catalog."default",
    "HaveDefault" boolean NOT NULL,
    "GuaranteeType" text COLLATE pg_catalog."default",
    "GuaranteeAmount" text COLLATE pg_catalog."default",
    "BorrowerName" text COLLATE pg_catalog."default",
    "BorrowerOKPO" integer,
    "BorrowerSector" text COLLATE pg_catalog."default",
    "BorrowerUID" integer,
    "IssuerName" text COLLATE pg_catalog."default",
    "IssuerName_NRD" text COLLATE pg_catalog."default",
    "IssuerOKPO" integer,
    "NumGuarantors" smallint,
    "EndMtyDate" date,
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)

TABLESPACE pg_default;

ALTER TABLE public.bond_description
    OWNER to postgres;

-- Импортирование данных из исходного файла

\copy public.bond_description  FROM 'C:\Users\taras_000\Desktop\Вышка\IT для финансистов\Облигации\bond_description_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';
 
-- На данном этапе в исходном файле я поменял формат на общий в 133 строке в стоблцах HaveOffer	AmortisedMty,	MaturityGroup,	IsConvertible
-- , а также формат самого файла на "CSV с разделителем запятая".   

    
-- Создание таблицы quotes
-- В качестве ключа выбрал первые два столбца.      
    
-- Table: public.quotes

-- DROP TABLE public.quotes;

CREATE TABLE public.quotes
(
    "ID" integer NOT NULL,
    "TIME" integer NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" real,
    "ASK_SIZE_TOTAL" integer,
    "AVGE_PRCE" real,
    "BID" real,
    "BID_SIZE" real,
    "BID_SIZE_TOTAL" integer,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default",
    "BUYBACKDATE" date,
    "BUYBACKPRICE" real,
    "CBR_LOMBARD" real,
    "CBR_PLEDGE" real,
    "CLOSE" real,
    "CPN" real,
    "CPN_DATE" date,
    "CPN_PERIOD" integer,
    "DEAL_ACC" integer,
    "FACEVALUE" real,
    "ISIN" text COLLATE pg_catalog."default",
    "ISSUER" text COLLATE pg_catalog."default",
    "ISSUESIZE" real,
    "MAT_DATE" date,
    "MPRICE" real,
    "MPRICE2" real,
    "SPREAD" real,
    "VOL_ACC" real,
    "Y2O_ASK" real,
    "Y2O_BID" real,
    "YIELD_ASK" real,
    "YIELD_BID" real,
    CONSTRAINT quotes_pkey PRIMARY KEY ("ID", "TIME")
)

TABLESPACE pg_default;

ALTER TABLE public.quotes
    OWNER to postgres;

-- Импортирование данных из исходного файла

\copy public.quotes  FROM 'C:\Users\taras_000\Desktop\Вышка\IT для финансистов\Облигации\quotes_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- На данном этапе в исходном файле я поменял формат стобца BUYBACKDATE на дату, а также формат самого файла на "CSV с разделителем запятая".

-- Создание таблицы listing
-- В качестве ключа выбрал первый столбец.    

-- Table: public.listing

-- DROP TABLE public.listing;

CREATE TABLE public.listing
(
    "ID" integer NOT NULL,
    "ISIN" text COLLATE pg_catalog."default" NOT NULL,
    "Platform" text COLLATE pg_catalog."default" NOT NULL,
    "Section" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT listing_pkey PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;

-- Импортирование данных из исходного файла

\copy public.listing  FROM 'C:\Users\taras_000\Desktop\Вышка\IT для финансистов\Облигации\listing_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- На данном этапе я только поменял формат самого файла на "CSV с разделителем запятая".


-- ВТОРОЕ ЗАДАНИЕ --

-- Создаём в таблице listing поля с данными эмитента

ALTER TABLE public.listing
    ADD COLUMN "BorrowerName" text,
    ADD COLUMN "BorrowerOKPO" integer,
    ADD COLUMN "BorrowerSector" text,
    ADD COLUMN "BorrowerUID" integer,
    ADD COLUMN "IssuerName" text,
    ADD COLUMN "IssuerName_NRD" text,
    ADD COLUMN "IssuerOKPO" integer;

-- Импортируем данные об эмитентах из таблицы bond_description в созданные пустые поля в таблице listing.
-- В качестве условия я выбрал совпадение ISIN-кодов эмитентов из обеих таблиц.

UPDATE listing
SET "BorrowerName"=bond_description."BorrowerName",
"BorrowerOKPO"=bond_description."BorrowerOKPO",
"BorrowerSector"=bond_description."BorrowerSector",
"BorrowerUID"=bond_description."BorrowerUID",
"IssuerName"=bond_description."IssuerName",
"IssuerName_NRD"=bond_description."IssuerName_NRD",
"IssuerOKPO"=bond_description."IssuerOKPO"
FROM bond_description
WHERE listing."ISIN"=bond_description."ISINCode"

-- Создаем в таблице listing поля с информацией о площадке.

ALTER TABLE public.listing
    ADD COLUMN "BOARDID" text,
    ADD COLUMN "BOARDNAME" text;

-- Импортируем данные о площадках из таблицы quotes в созданные пустые поля в таблице listing.
-- В качестве условия я выбрал совпадение ISIN-кодов эмитентов из обеих таблиц.

UPDATE listing
SET "BOARDID"=quotes."BOARDID",
"BOARDNAME"=quotes."BOARDNAME"
FROM quotes
WHERE listing."ISIN"=quotes."ISIN"

-- ТРЕТЬЕ ЗАДАНИЕ --

-- Далее свяжем таблицы listing и bond_description с помощью ID.
-- Для этого в таблице bond_description создадим поле ID.

ALTER TABLE public.bond_description
    ADD COLUMN "ID" integer;

-- Импортируем в это поле значения ID из таблицы listing при условии, что ISIN-коды значений совпадают.

UPDATE bond_description
SET "ID"=listing."ID"
FROM listing
WHERE bond_description."ISIN, RegCode, NRDCode"=listing."ISIN"

-- Присваиваем полю ID в таблице bond_descrption внешний ключ из таблицы listing.

ALTER TABLE public.bond_description
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("ID") REFERENCES public.listing ("ID");


-- ЧЕТВЕРТОЕ ЗАДАНИЕ --

-- Далее составим запрос, который вытягивает все бумаги с уникальным значением кода ISIN,
-- названием эмитента и показателем nun_ration при условиях, что бумаги торгуются на Московской бирже
-- в основном секторе, а значение показателя nun_ration больше 0,9.

SELECT "IssuerName" AS issuer, q2."ISIN", nun_ratio
FROM
(SELECT subq1."ISIN", subq1.all_ask, subq2.not_null_ask, (subq2.not_null_ask::real / subq1.all_ask::real) AS nun_ratio
FROM (
	SELECT "ISSUER", "ISIN", COUNT("ISIN") AS all_ask
	FROM public.quotes
	GROUP BY "ISSUER", "ISIN") AS subq1
-- Подзапрос второго уровня, который группирует из таблицы quotes все значения по столбцу ISIN и считает количество 
--строчек с каждым ISIN-кодом. 
INNER JOIN (
	SELECT "ISSUER", "ISIN", COUNT("ISIN") AS not_null_ask
	FROM public.quotes
	WHERE "ASK" IS NOT NULL
	GROUP BY "ISSUER", "ISIN") AS subq2
--Подзапрос второго уровня, который группирует из таблицы quotes все значения по столбцу ISIN и считает количество 
-- строчек с каждым ISIN-кодом при условии, что поле ASK не пустое.
ON subq1."ISIN"=subq2."ISIN") AS q1
-- Подзапрос первого уровня, который соединяет пересечение результатов вышестоящих подзапросов второго уровня, а также
-- добавляет к нему поле со значением nun_ratio, которое является вещественным числом.
INNER JOIN (
	SELECT *
	FROM public.listing
	WHERE ("Platform"='Московская Биржа ') AND ("Section"=' Основной') AND ("IssuerName" IS NOT NULL)) AS q2
-- Подзапрос первого уровня, который фильтрует значения из таблицы listing при условии, что поле эмитента не пустое,
-- основная секция и площадка - Московская биржа.
ON q1."ISIN"=q2."ISIN"
GROUP BY issuer, q2."ISIN", nun_ratio
HAVING q1.nun_ratio >0.9
-- В итоге получется объединение запросов первого уровня, а также группировка по полям issuer и ISIN при условии,
-- что коэффициент nun_ratio больше 0,9. Результат: 558 значений.

