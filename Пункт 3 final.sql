--Добавляем в таблицу listing недостающие значения "ID" (а вместе с ним и "BOARDID", "BOARDNAME", "ISIN") из таблицы quotes

INSERT INTO public.listing
SELECT DISTINCT "ID", "BOARDID", "BOARDNAME", "ISIN" FROM public.quotes 
WHERE public.quotes."ID" not in (SELECT "ID" from public.listing) 
	   
--Присваиваем внешний ключ таблице public.quotes, используя значения. первичного ключа public.listing
ALTER TABLE public.quotes
ADD CONSTRAINT fr_key_1 
FOREIGN KEY("ID") REFERENCES public.listing("ID");
