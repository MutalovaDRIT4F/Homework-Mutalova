--Если бы нам просто нужно было бы выбрать соответствующие данные из таблиц public.quotes (данные о площадке) и 
--public.bond_description (данные об эмитенте), то запрос выглядел бы следующим образом:  
SELECT DISTINCT public.bond_description."IssuerName", public.bond_description."IssuerName_NRD", public.bond_description."IssuerOKPO", public.quotes."BOARDID", public.quotes."BOARDNAME"
FROM public.bond_description INNER JOIN public.quotes
ON public.bond_description."ISINCode" = public.quotes."ISIN";

--Поскольку нам необходимо поместить выбранные данные в таблицу public.listing, то мы вносим изменения в нее с помощью 
--ALTER TABLE, добавляя 5 столбцов с названиями, которые соответствуют названиям добавляемых столбцов 
--задаем параметры новых столбов в соответствии с их изначальными типами данных
ALTER TABLE public.listing 
add column "IssuerName" text COLLATE pg_catalog."default",
add column "IssuerName_NRD" text COLLATE pg_catalog."default",
add column "IssuerOKPO" bigint,
add column "BOARDID" text COLLATE pg_catalog."default",
add column "BOARDNAME" text COLLATE pg_catalog."default";

--Далее обновляем данные таблицы указывая соотвтетствие между новыми столбцами public.listing и добавляемыми столбцами из других таблиц
--с помощью операторов UPDATE и SET
UPDATE public.listing 
SET "IssuerName" = public.bond_description."IssuerName", "IssuerName_NRD" = public.bond_description."IssuerName_NRD", "IssuerOKPO" = public.bond_description."IssuerOKPO" 
FROM public.bond_description
WHERE public.bond_description."ISINCode" = public.listing."ISIN";

UPDATE public.listing
SET "BOARDID" = public.quotes."BOARDID", "BOARDNAME" = public.quotes."BOARDNAME"
FROM public.quotes
WHERE public.quotes."ISIN" = public.listing."ISIN";
