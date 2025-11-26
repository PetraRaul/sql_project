# Analýza dostupnosti základních potravin široké veřejnosti

Cílem projektu je připravit datový podklad s názvem *t_petra_raulimova_project_SQL_primary_final*, na jehož základě bude možné zodopovědět níže uvedené výzkumné otázky, které se týkají dostupnosti potravin široké veřejnosti na základě průměrných příjmů za určité časové období. Pro zodpovězení páté výzkumné otázky je nezbytné připravit dodatečný podkad s názvem *t_petra_raulimova_project_SQL_secondary_final*, který obsahuje údaje o HDP, GINI koeficientu a populaci evropských států za stejné časové období jako první podklad (roky 2006 - 2018).

## Postup tvorby tabulky *t_petra_raulimova_project_SQL_primary_final*
Tabulku jsem se snažila vytvořit co nejjednodušší, aby měla co nejméně řádků, aby se v ní pokud možno dobře orientovalo a snadno se s daty dále pracovalo. Učinila jsem několik pokusů a nejvíce této mé představě odpovídalo použití *with statement*, kdy jsem si připravila dvě zdrojové tabulky *price_aggregated* a *payroll_aggregated*, které jsem následně vzájemně propojila pomocí sloupce s roky a přidaného sloupce index.

***Tvorba podkladu price_aggregated***
+ výchozí tabulky: *czechia_price* a *czechia_price_category*
+ data od roku 2006 do roku 2018 (tyto roky se staly základem, jelikož data czechia_payroll byla za delší období)
u sloupců date_from a date_to jsem porovnala, že se roky navzájem rovnají (tj. že není začátek měření v jednom roce a konec v jiném roce) -> jelikož se potvrdila hypotéza, že se údaje rovnají, mohla jsem dále pracovat jen s jedním z těchto dvou sloupců (date_to)
v rámci každého měření máme ke každé kategorii k dispozici 15 údajů -> 14 údajů za každý kraj a 1 údaj za celou ČR (údaj za celou ČR se nachází vždy na řádku, ve kterém je ve sloupci region_code hodnota NULL), zároveň platí, že údaj za celou ČR je průměrem hodnot za jednotlivé kraje -> z tohoto důvodu bylo možné vzít do vytvářené tabulky pouze data za celou ČR 
Po odstranění dat za jednotlivé kraje, bylo možné dále vysledovat z dat klesající počet měření v jednotlivých letech, od roku 2011 se počet měření ustálil na 12 za rok za celou ČR pro každý produkt zvlášť
Do roku 2014 včetně bylo předmětem měření 26 potravin. U položky 212101 (název) probíhala měření až od roku 2015 (zohledněno následně v otázce číslo 4), u položky kapr probíhala měření jen v prosinci. 
Výsledná pomocná tabulka (název) má 342 řádků.

***Tvorba podkladu payroll_aggregated***
+ výchozí tabulky: *czechia_payroll*, 
+ s tabulkou czechia_unit jsem nepracovala, jelikož se její popis v databázi lišil od popisu na stránkách gov.
+ data jsem očistila o údaje, které se týkaly počtu zaměstnanců
+ počítám pro přepočtený počet zaměstnanců
+ v tabulce jsou ponechány údaje nejen pro jednotlivá odvětví, ale i údaj za celou ČR, jelikož průměrná mzda za celou ČR bez ohledu na odvětví neodpovídá průměru mezd za jednotlivá odvětví
+ data očištěna na roky 2008 a 2016
+ počet měření v každém roce 4 měření / odvětví
+ počet odvětví 19 + 1 údaj bez odvětví za celou ČR
+ výsledná pomocná tabulka má 260 řádků

## Postup tvorby tabulky *t_petra_raulimova_project_SQL_secondary_final*

## Výzkumné otázky a odpovědi
V následující části probereme odpovědi na pět výzkumných otázek.

### Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Z dostupných údajů vyplývá, že se mzdy v roce 2018 oproti roku 2006 zvýšily ve všech odvětvích. Nejvyšší nárůst mezd mezi zmiňovanými roky byl zaznamenán v odvětví Informační a komunikační činnosti (nárůst o 20 934,75 CZK) a Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (nárůst o 17 163,25 CZK). Při detailnějším zkoumání dat lze zjistit, že existují pouze tři odvětví, ve kterých mzdy rostly v každém sledovaném roce oproti roku předchozímu (nedošlo u nich v žádném ze sledovaných let k poklesu). Těmito odvětvími jsou: Zpracovatelský průmysl, Zdravotní a sociální péče a Ostatní činnosti. 

![Snímek obrazovky 2025-11-26 190935](C:\Users\rauli\Documents\SQL_projekt\Snímek obrazovky 2025-11-26 190935.png)
U zbývajících 16 odvětví pak došlo k poklesu alespoň v jednom roce, přičemž „nejkritičtější“ byl z tohoto úhlu pohledu rok 2013, kdy byl pokles mezd zaznamenán hned u 11 odvětví. 

Vůbec nejčastěji pak došlo k poklesu mezd mezi jednotlivými roky v odvětví Těžba a dobývání (4x) a Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu (3x). Z hlediska hodnoty byl pak nejvýraznější pokles zaznamenán v roce 2013 v odvětví Peněžnictví a pojišťovnictví.

### Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Z výsledků vidíme, že jak v případě mléka, tak v případě chleba se zvýšilo množství, které si za průměrnou mzdu lze koupit v roce 2018 oproti množství, které bylo možné koupit v roce 2006. U mléka si můžeme v roce 2018 nakoupit o 263,79 litrů více, než bylo možné v roce 2006. V případě chleba si můžeme v roce 2018 koupit o 110 kg více, než v roce 2006. Skutečnost, že možné nakoupené množství mléka roste výrazně rychleji, než možné nakoupené množství chleba je dána výraznějším nárůstem kupní ceny chleba (o 50,4%). V roce 2006 byl rozdíl mezi cenami obou potravin 11%, v roce 2018 22%.

### Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
Zde jsem se rozhodla nekomplikovat situaci jednotlivými roky a rovnou jsem porovnala data mezi lety 2006 (pro jakostní víno bílé rokem 2015) a 2018. Nejpomaleji zdražovaly banány žluté, u nichž došlo mezi lety 2006 a 2018 k nárůstu ceny o 7,36 %. Je však nutné zmínit, že existují dvě potraviny, které ve sledovaném období nezdražily, ale naopak zlevnily. Jsou jimi: cukr krystalový (pokles ceny o 27,52 %) a rajská jablka červená kulatá (pokles ceny o 23,07 %). Lze přidat graf.

### Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Před zodpovězením samotné otázky bych jen zmínila, že jsem z dat vyřadila položku „Jakostní víno bílé“, jelikož u ní máme sledované hodnoty k dispozici až od roku 2015. Pokud bych položku v datech ponechala, nebyla by analýza prováděna na srovnatelných datech. Žádný rok, ve kterém by byl zaznamenán výrazně vyšší růst cen potravin než růst mezd, neexistuje. Obecně lze říci, že ceny potravin rostly rychleji než mzdy pouze v letech 2011, 2012, 2017 a 2013 (v tomto roce dokonce mzdy nepatrně poklesly oproti roku 2012). V letech 2009, 2015 a 2016 pak ceny klesaly, zatímco mzdy rostly – nejmarkantnější rozdíl byl viditelný v roce 2009, kdy ceny klesly o 6,41%, zatímco mzdy vzrostly o 3,37%.  Lze přidat graf.

### Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?



