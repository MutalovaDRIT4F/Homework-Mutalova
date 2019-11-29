--СОЗДАНИЕ ТАБЛИЦЫ public.bond_description
--Удаляем таблицу при ее существовании, чтобы не возникало проблем с дальнейщим исправлением кода
DROP TABLE if exists public.bond_description;

--Создаем таблицу public.bond_description с 51 столбцами с выбором в качестве первичного ключа первого столбца "ISIN, RegCode, NRDCode"
--При определении параметров столбцов были использованы в основном следующие типы данных: text - для столбцов с текстовыми занчениями,
--boolean - для столбцов со значениями 0 и 1 (то есть False и True), varchar(15) я задавала для столбцов с наименованием ISIN, 
--integer, bigint и smallint соответственно для числовых значений в зависимости от их длины, real - для вещественных чисел
--
CREATE TABLE public.bond_description
(
    "ISIN, RegCode, NRDCode" varchar(15) NOT NULL,
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
    "ISINCode" varchar(15) NOT NULL,
    "Status" text COLLATE pg_catalog."default" NOT NULL,
    "HaveDefault" boolean NOT NULL,
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
) --обозначаем первичный ключ
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bond_description
    OWNER to postgres;

--загружаем данные из файла csv формата, предварительно обработав все данные внутри него 
copy public.bond_description  FROM '/Users/diana/Desktop/Семинар/bond_description_task.csv' DELIMITER ';' CSV HEADER;


--ТОЖЕ САМОЕ ПРОДЕЛЫВАЕМ С ОСТАЛЬНЫМИ ДВУМЯ ТАБЛИЦАМИ (ТИПЫ ДАННЫХ ТАМ ТЕ ЖЕ)

--СОЗДАНИЕ ТАБЛИЦЫ public.quotes (первичного ключа нет)
DROP TABLE if exists public.quotes;
CREATE TABLE public.quotes
(
    "ID" character varying(7) COLLATE pg_catalog."default" NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" integer,
    "ASK_SIZE_TOTAL" bigint,
    "AVGE_PRCE" money,
    "BID" real,
    "BID_SIZE" integer,
    "BID_SIZE_TOTAL" bigint,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default",
    "BUYBACKDATE" date,
    "BUYBACKPRICE" money,
    "CBR_LOMBARD" real,
    "CBR_PLEDGE" real,
    "CLOSE" real,
    "CPN" real,
    "CPN_DATE" date,
    "CPN_PERIOD" integer,
    "DEAL_ACC" integer,
    "FACEVALUE" real,
    "ISIN" character varying(15) COLLATE pg_catalog."default",
    "ISSUER" text COLLATE pg_catalog."default",
    "ISSUESIZE" bigint,
    "MAT_DATE" date,
    "MPRICE" money,
    "MPRICE2" money,
    "SPREAD" real,
    "VOL_ACC" bigint,
    "Y2O_ASK" real,
    "Y2O_BID" real,
    "YIELD_ASK" real,
    "YIELD_BID" real
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

copy public.quotes  FROM '/Users/diana/Desktop/Семинар/quotes.csv' DELIMITER ';' CSV HEADER;

--СОЗДАНИЕ ТАБЛИЦЫ public.listing
DROP TABLE if exists public.listing;
CREATE TABLE public.listing
(
    "ID" character varying(7) COLLATE pg_catalog."default",
    "ISIN" character varying(15) COLLATE pg_catalog."default",
    "Platform" text COLLATE pg_catalog."default",
    "Section" text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;

copy public.listing  FROM '/Users/diana/Desktop/Семинар/listing.csv' DELIMITER ';' CSV HEADER;

-- Комментарий:
-- описание преобразования данных до импорта в БД неполное. Исполнение кода приводит к ошибкам импорта из-за несоответствия данных форматам полей.