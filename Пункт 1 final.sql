--СОЗДАНИЕ ТАБЛИЦЫ public.bond_description
--Удаляем таблицу при ее существовании, чтобы не возникало проблем с дальнейщим исправлением кода
DROP TABLE if exists public.bond_description;

--Создаем таблицу public.bond_description с 51 столбцами с выбором в качестве первичного ключа первого столбца "ISIN, RegCode, NRDCode"
--При определении параметров столбцов были использованы в основном следующие типы данных: text - для столбцов с текстовыми значениями,
--boolean - для столбцов со значениями 0 и 1 (то есть False и True), 
--integer, bigint и smallint соответственно для числовых значений в зависимости от их длины, real - для вещественных чисел
--
CREATE TABLE public.bond_description
(
    "ISIN, RegCode, NRDCode" text COLLATE pg_catalog."default" NOT NULL,
    "FinToolType" text COLLATE pg_catalog."default",
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
    "Status" text COLLATE pg_catalog."default" NOT NULL,
    "HaveDefault" smallint NOT NULL,
    "IsLombardCBR_NRD" boolean,
    "IsQualified_NRD" boolean,
    "ForMarketBonds_NRD" boolean,
    "MicexList_NRD" text COLLATE pg_catalog."default",
    "Basis" text COLLATE pg_catalog."default",
    "Basis_NRD" text COLLATE pg_catalog."default",
    "Base_Month" text COLLATE pg_catalog."default",
    "Base_Year" text COLLATE pg_catalog."default",
    "Coupon_Period_Base_ID" integer,
    "AccruedintCalcType" boolean NOT NULL,
    "IsGuaranteed" boolean NOT NULL,
    "GuaranteeType" text COLLATE pg_catalog."default",
    "GuaranteeAmount" text COLLATE pg_catalog."default",
    "GuarantVal" bigint,
    "Securitization" text COLLATE pg_catalog."default",
    "CouponPerYear" integer,
    "Cp_Type_ID" smallint,
    "NumCoupons" integer,
    "NumCoupons_M" smallint NOT NULL,
    "NumCoupons_NRD" integer,
    "Country" text COLLATE pg_catalog."default" NOT NULL,
    "FaceFTName" text COLLATE pg_catalog."default" NOT NULL,
    "FaceFTName_M" smallint NOT NULL,
    "FaceFTName_NRD" text COLLATE pg_catalog."default",
    "FaceValue" real NOT NULL,
    "FaceValue_M" smallint NOT NULL,
    "FaceValue_NRD" real,
    "CurrentFaceValue_NRD" real,
    "BorrowerName" text COLLATE pg_catalog."default" NOT NULL,
    "BorrowerOKPO" bigint,
    "BorrowerSector" text COLLATE pg_catalog."default",
    "BorrowerUID" bigint NOT NULL,
    "IssuerName" text COLLATE pg_catalog."default" NOT NULL,
    "IssuerName_NRD" text COLLATE pg_catalog."default",
    "IssuerOKPO" bigint,
    "NumGuarantors" integer NOT NULL,
    "EndMtyDate" date,
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bond_description
    OWNER to postgres;
	
copy public.bond_description  
FROM '/Users/diana/Desktop/Семинар/bond_description_task.csv' DELIMITER ';' CSV HEADER;

-- Форматирование данных: в столбцах “HaveOffer”, “AmortisedMty”, “IsConvertible” меняем формат данных на числовой; «EndMtyDate» меняем формат данных на дату; «CurrentFaceValue_NRD» меняем запятые на точки

-- Сохраняем в формате csv

-- Пробовала ставить ENCODING – работает только без него


--СОЗДАНИЕ ТАБЛИЦЫ public.quotes (в качестве первичного ключа использованы первые 2 столбца)
DROP TABLE if exists public.quotes;

CREATE TABLE public.quotes
(
    "ID" text COLLATE pg_catalog."default" NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" integer,
    "ASK_SIZE_TOTAL" bigint,
    "AVGE_PRCE" real,
    "BID" real,
    "BID_SIZE" integer,
    "BID_SIZE_TOTAL" bigint,
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
    "ISSUESIZE" bigint,
    "MAT_DATE" date,
    "MPRICE" real,
    "MPRICE2" money,
    "SPREAD" real,
    "VOL_ACC" bigint,
    "Y2O_ASK" real,
    "Y2O_BID" real,
    "YIELD_ASK" real,
    "YIELD_BID" real,
	CONSTRAINT quotes_pkey PRIMARY KEY ("ID", "TIME")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

copy public.quotes  FROM '/Users/diana/Desktop/Семинар/quotes.csv' DELIMITER ';' CSV HEADER;

-- Форматирование данных: в столбцах "ACCRUEDINT", "ASK", "AVGE_PRCE", "BID", "BUYBACKPRICE", "CBR_LOMBARD", "CBR_PLEDGE", "CLOSE", "CPN", "FACEVALUE", "MPRICE", "SPREAD", "Y2O_ASK", "Y2O_BID", "YIELD_ASK", "YIELD_BID" заменяем запятые на точки. В «TIME», «CPN_DATE» и «MAT_DATE», «BUYBACKDATE» меняем формат на дату
В «BID», «CLOSE», «AVGE_PRCE», «YIELD_BID», «YIELD_ASK», «ASK»  и всех остальных столбцах, содержащие числа, меняем формат на числовой (почти в каждом находится значение в виде даты), в "ISSUESIZE" и "VOL_ACC" заменяем экспоненциальные значения на числовые

-- Сохраняем в формате csv

-- ENCODING также не сработал



--СОЗДАНИЕ ТАБЛИЦЫ public.listing
DROP TABLE if exists public.listing;

CREATE TABLE public.listing
(
    "ID" text COLLATE pg_catalog."default",
    "ISIN" text COLLATE pg_catalog."default",
    "Platform" text COLLATE pg_catalog."default",
    "Section" text COLLATE pg_catalog."default",
	CONSTRAINT listing_pkey PRIMARY KEY ("ID")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;

copy public.listing  FROM '/Users/diana/Desktop/Семинар/listing_task.csv' DELIMITER ';' CSV HEADER;

--Данные не форматировала 