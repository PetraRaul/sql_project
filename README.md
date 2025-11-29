# Analýza dostupnosti základních potravin široké veřejnosti

Cílem projektu je připravit datový podklad s názvem *[t_petra_raulimova_project_SQL_primary_final](https://github.com/PetraRaul/sql_project/blob/main/t_petra_raulimova_project_SQL_primary_final.sql)*, na jehož základě bude možné zodopovědět níže uvedené výzkumné otázky, které se týkají dostupnosti potravin široké veřejnosti na základě průměrných příjmů za určité časové období. Pro zodpovězení páté výzkumné otázky je nezbytné připravit dodatečný podkad s názvem *[t_petra_raulimova_project_SQL_secondary_final](https://github.com/PetraRaul/sql_project/blob/main/t_petra_raulimova_project_SQL_secondary_final.sql)*, který obsahuje údaje o HDP, GINI koeficientu a populaci evropských států za stejné časové období jako první podklad (rok 2006 až rok 2018).

## Postup tvorby tabulky *t_petra_raulimova_project_SQL_primary_final*
Tabulku jsem se snažila vytvořit co nejjednodušší, aby měla co nejméně řádků, aby se v ní pokud možno dobře orientovalo a snadno se s daty dále pracovalo. Učinila jsem několik pokusů a nejvíce této mé představě odpovídalo použití *with statement*, kdy jsem si připravila dvě zdrojové tabulky *price_aggregated* a *payroll_aggregated*, které jsem následně vzájemně propojila pomocí sloupce s roky a přidaného sloupce *index*.

***Tvorba podkladu price_aggregated***
+ výchozí tabulky: *czechia_price* a *czechia_price_category*
+ analýza *czechia_price*
    + tabulka obsahuje údaje od roku 2006 do roku 2018
    + roky z údajů ve sloupcích *date_from* a *date_to* jsem porovnala, abych zjistila, že není začátek měření v jednom roce a konec v jiném roce -> jelikož se potvrdil předpoklad, že každé jedno měření začíná a končí ve stejném roce, pracovala jsem dále již jen se sloupcem *date_to*
    + v rámci každého měření je v tabulce ke každé kategorii k dispozici 15 záznamů -> jeden záznam za každý ze 14 krajů a jeden záznam za celou ČR (záznam za celou ČR se nachází vždy na řádku, ve kterém je ve sloupci *region_code* hodnota NULL)
    + údaj o cenách za celou ČR je průměrem hodnot za jednotlivé kraje -> z tohoto důvodu bylo možné vzít do vytvářené finální tabulky pouze data za celou ČR (nebylo nutné vytvářet průměr z hodnot)
    + z dat je možné vysledovat klesající počet měření v jednotlivých letech, od roku 2011 se počet měření ustálil na 12 za rok za celou ČR pro každý produkt zvlášť (kromě položky *Kapr živý*, kde měření probíhala jen v prosinci -> od roku 2010 probíhalo vždy jedno měření za rok)
    + do roku 2014 včetně bylo předmětem měření 26 položek, od roku 2015 byla do měření přidána položka *Jakostní víno bílé*
+ výsledná pomocná tabulka *price_aggregated* má s přihlédnutím k výše uvedeným skutečnostem 342 záznamů (13 let * 26 kategorií + 4 roky * 1 kategorie)

***Tvorba podkladu payroll_aggregated***
+ výchozí tabulky: *czechia_payroll*, *czechia_payroll_calculation*, *czechia_payroll_industry_branch*, *czechia_payroll_unit*, *czechia_payroll_value_type*
+ s tabulkou *[czechia_payroll_unit](https://github.com/PetraRaul/sql_project/blob/main/payroll_units.jpg)* jsem nepracovala, jelikož se její popis v databázi lišil od popisu na stránkách *csu.gov.cz*
+ analýza *czechia_payroll*
    + tabulka obsahuje údaje od roku 2000 do roku 2021 -> pro další analýzu bylo však nezbytné omezit data pouze na období 2006-2018
    + data jsem očistila o údaje, které se týkaly průměrného počtu zaměstnaných osob -> tyto údaje nebyly pro další výpočty použitelné (v mnoha případech zcela chyběly hodnoty)
    + ve sloupci *calculation_code* jsem ze dvou možností vybrala kód 200 -> analýza je tudíž prováděna na průměrných mzdách pro přepočtený počet zaměstnanců (tento údaj mi přijde přesnější, jelikož zohledňuje zkrácené úvazky a pracovní dohody)
    + na základě dat lze říci, že v každém roce proběhla pro každé odvětví 4 měření + 4 měření pro celou ČR -> při 19 odvětvích a jednom údaji za celou ČR lze tedy dopočítat, že celkem proběhlo 80 měření za rok
    + při analýze údajů o mzdách jsem zjistila, že ve výsledné tabulce musím ponechat nejen údaje za jednotlivá odvětví, ale i údaj za celou ČR, jelikož průměrná mzda za celou ČR neodpovídá průměru mezd za jednotlivá odvětví
+ výsledná pomocná tabulka *payroll_aggregated* má se zohledněním výše uvedených skutečností a úprav 260 záznamů (13 let * 19 odvětví + 13 let * údaj ze celou ČR)
  
## Postup tvorby tabulky *t_petra_raulimova_project_SQL_secondary_final*
Tvorba tabulky *t_petra_raulimova_project_SQL_secondary_final* byla méně náročná, než tvorba tabulky z předchozího kroku. Šlo o jednoduché propojení tabulek *economies* a *countries* přes název státu ve sloupcích *country*, vyfiltrování dat pouze za roky 2006 až 2018 a zároveň vyfiltrování dat jen za kontinent Evropa. 

## Výzkumné otázky a odpovědi
V následující části probereme odpovědi na pět výzkumných otázek.

### Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Z dostupných údajů vyplývá, že se mzdy v roce 2018 oproti roku 2006 zvýšily ve všech odvětvích. Nejvyšší nárůst mezd mezi zmiňovanými roky byl zaznamenán v odvětví Informační a komunikační činnosti (nárůst o 20 934,75 CZK) a Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (nárůst o 17 163,25 CZK). Při detailnějším zkoumání dat lze zjistit, že existují pouze tři odvětví, ve kterých mzdy rostly v každém sledovaném roce oproti roku předchozímu (nedošlo u nich v žádném ze sledovaných let k poklesu). Těmito odvětvími jsou: Zpracovatelský průmysl, Zdravotní a sociální péče a Ostatní činnosti. 

| industry_name | total_avg_payroll_change | avg_payroll_increase | avg_payroll_decrease | year_payroll_decrease |
|---------------|-------------------------:|---------------------:|:--------------------:|:---------------------:|
| Zdravotní a sociální péče | 14 821,75 | 14 821,75	| - | - |                 	                      
| Zpracovatelský průmysl | 13 407,75 | 13 407,75 | - | - | 	                    	                      
| Ostatní činnosti | 7 212,75 |	7 212,75 | - | - |	                    	                      

U zbývajících 16 odvětví pak došlo k poklesu alespoň v jednom roce, přičemž „nejkritičtější“ byl z tohoto úhlu pohledu rok 2013, kdy byl pokles mezd zaznamenán hned u 11 odvětví. 

| industry_name | total_avg_payroll_change | avg_payroll_increase | avg_payroll_decrease | year_payroll_decrease 
|---------------|-------------------------:|---------------------:|--------------------:|:---------------------:|
| Peněžnictví a pojišťovnictví | 14 856,25 | 19 340,25 | -4 484,00 | 2013 |           
| Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu |	17 163,25	| 19 794,25 |	-2 631,00 | 2011, 2013, 2015 |    
| Těžba a dobývání | 11 972,25 | 14 305,00 | -2 332,75 | 2009, 2013, 2014, 2016 |
| Profesní, vědecké a technické činnosti	| 14 340,00	| 15 521,50	| -1 181,50	| 2010, 2013 |            
| Informační a komunikační činnosti |	20 934,75 |	21 420,75 |	-486,00 |	2013 |                  
| Činnosti v oblasti nemovitostí | 8 867,00	| 9 352,25 | -485,25	| 2009, 2013 |            
| Stavebnictví | 10 316,25	| 10 786,75	| -470,50	| 2013 |                  
| Kulturní, zábavní a rekreační činnosti |	11 571,50 |	11 869,25 |	-297,75 |	2013 |                  
| Administrativní a podpůrné činnosti |	6 509,50 |	6 720,75 | -211,25	| 2013 |                  
| Velkoobchod a maloobchod; opravy a údržba motorových vozidel |	11 752,75 |	11 946,75 |	-194,00 |	2013 |                  
| Zásobování vodou; činnosti související s odpady a sanacemi |	9 984,75	| 10 086,50	| -101,75	| 2013 |               

Vůbec nejčastěji pak došlo k poklesu mezd mezi jednotlivými roky v odvětví Těžba a dobývání (4x) a Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (3x). Z hlediska hodnoty byl pak nejvýraznější pokles zaznamenán v roce 2013 v odvětví Peněžnictví a pojišťovnictví.

### Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Z výsledků vidíme, že jak v případě mléka, tak v případě chleba se zvýšilo množství, které si za průměrnou mzdu lze koupit v roce 2018 oproti množství, které bylo možné koupit v roce 2006. U mléka si můžeme v roce 2018 nakoupit o 263,79 litrů více, než bylo možné v roce 2006. V případě chleba si můžeme v roce 2018 koupit o 110 kg více, než v roce 2006. Skutečnost, že možné nakoupené množství mléka roste výrazně rychleji, než možné nakoupené množství chleba je dána výraznějším nárůstem kupní ceny chleba (o 50,4%). V roce 2006 byl rozdíl mezi cenami obou potravin 11%, v roce 2018 22%.

### Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
Zde jsem se rozhodla nekomplikovat situaci jednotlivými roky a rovnou jsem porovnala data mezi lety 2006 (pro jakostní víno bílé rokem 2015) a 2018. Nejpomaleji zdražovaly banány žluté, u nichž došlo mezi lety 2006 a 2018 k nárůstu ceny o 7,36 %. Je však nutné zmínit, že existují dvě potraviny, které ve sledovaném období nezdražily, ale naopak zlevnily. Jsou jimi: cukr krystalový (pokles ceny o 27,52 %) a rajská jablka červená kulatá (pokles ceny o 23,07 %).

![Price_development.jpg](https://github.com/PetraRaul/sql_project/blob/main/Price_development.jpg)

### Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Před zodpovězením samotné otázky bych jen zmínila, že jsem z dat vyřadila položku „Jakostní víno bílé“, jelikož u ní máme sledované hodnoty k dispozici až od roku 2015. Pokud bych položku v datech ponechala, nebyla by analýza prováděna na srovnatelných datech. Žádný rok, ve kterém by byl zaznamenán výrazně vyšší růst cen potravin než růst mezd, neexistuje. Obecně lze říci, že ceny potravin rostly rychleji než mzdy pouze v letech 2011, 2012, 2017 a 2013 (v tomto roce dokonce mzdy nepatrně poklesly oproti roku 2012). V letech 2009, 2015 a 2016 pak ceny klesaly, zatímco mzdy rostly – nejmarkantnější rozdíl byl viditelný v roce 2009, kdy ceny klesly o 6,41%, zatímco mzdy vzrostly o 3,37%.

![Price_and_payroll_difference.jpg](https://github.com/PetraRaul/sql_project/blob/main/Price_and_payroll_difference.jpg)

### Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?



