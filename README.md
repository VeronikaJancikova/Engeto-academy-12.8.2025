# SQL Project - Engeto academy

Tato průvodní listina popisuje SQL projekt zadaný v rámci kurzu Datová akademie.


# Zadání projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

# Datové sady, které je možné použít pro získání vhodného datového podkladu

## Primární tabulky:
1. *czechia_payroll* – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
2. *czechia_payroll_calculation* – Číselník kalkulací v tabulce mezd.
3. *czechia_payroll_industry_branch* – Číselník odvětví v tabulce mezd.
4. *czechia_payroll_unit* – Číselník jednotek hodnot v tabulce mezd.
5. *czechia_payroll_value_type* – Číselník typů hodnot v tabulce mezd.
6. *czechia_price* – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
7. *czechia_price_category* – Číselník kategorií potravin, které se vyskytují v našem přehledu.

## Číselníky sdílených informací o ČR:

1. *czechia_region* – Číselník krajů České republiky dle normy CZ-NUTS 2.
2. *czechia_district* – Číselník okresů České republiky dle normy LAU.

## Dodatečné tabulky:

1. *countries* - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
2. *economies* - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

## Výzkumné otázky

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

## Výstupy z projektu

Pomozte kolegům s daným úkolem. Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. 

Tabulky pojmenujte:
t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky. Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! Záleží na tom, co říkají data.

Na svém GitHub účtu vytvořte veřejný repozitář, kam uložíte všechny informace k projektu – hlavně SQL skript generující výslednou tabulku, popis mezivýsledků (průvodní listinu) ve formátu markdown (.md) a informace o výstupních datech (například kde chybí hodnoty apod.).
Neupravujte data v primárních tabulkách! Pokud bude potřeba transformovat hodnoty, dělejte tak až v tabulkách nebo pohledech, které si nově vytváříte.


# Vypracování projektu

## Postup tvorby tabulek
### 1. Primary table

Zde jsem začala vytvořením SQL pro každou jednotlivou výzkumnou otázku, abych si ověřila, která data (sloupce) ze zdrojových tabulek budu skutečně ve výsledné tabulce potřebovat, a která data budou zbytečná.
Mým cílem bylo poskytnout data tak, aby byla ve výsledku přehledná a koncovému uživateli srozumitelná a snadno odprezentovatelná.
Jakmile se mi podařilo postupně zodpovědět všechny 4 výzkumné otázky, přistoupila jsem k vytvoření samotné primary tabulky a úpravě původních SQL dotazů. Následně jsem si ověřila, že dotazy správně fungují i s primary tabulkou, pojmenovanou jako **t_veronika_jancikova_project_SQL_primary_final**.
1. Výzkumná otázka č. 1 - 
Zde jsem měla největší problém s porovnáním výsledků meziročně, k tomu jsem se rozhodla použít fuknci LAG. Ta porovnává hodnotu s předchozím rokem, čímž určuje meziroční rozdíl v průměrné mzdě.
Z výsledku lze vidět, která odvětví rostla nejrychleji a která naopak zaznamenala pokles mezd.
2. Výzkumná otázka č. 2 - 
Zde jsem jako základ použila již spočítanou průměrnou mzdu z otázky č. 1 - toto je votvořeno jako CTE, které předvybere jen průměrně mzdy. 
Dále jsem našla průměrnou cenu mléka a chleba a spojila mzdy a ceny podle roku. Následně jsem vytvořila nové sloupce s výpočtem pro litry mléka a počet chleba.
Výsledek názorně ukazuje vývoj kupní síly – tedy, zda si lidé za mzdu mohli dovolit více nebo méně základních potravin než dříve.
3. Výzkumná otázka č. 3 - 
	V tomto dotazu porovnávám průměrné roční ceny všech kategorií potravin a procentuální meziroční změnu pro každou z nich.
4. Výzkumná otázka č. 4 - 
V této části jsou spočítány meziroční procentuální nárůsty průměrných cen potravin a mezd.  
Jako první krok jsem tyto nárůsty spočítala samostatně, ve druhém kroku jsem je použila jako CTE a následně jsem oba výsledky porovnala podle roku.


### 2. Secondary table
Pro poslední výzkumnou otázku jsem vytvořila tabulku **t_veronika_jancikova_project_SQL_secondary_final**

5. Výzkumná otázka č. 5 - 
Tady jsem se rozhodla omezit výsledky pouze na Českou republiku, protože údaje o cenách potravin a mzdách máme pouze pro ČR. Ponechání všech ostatních zemí z tabuky *countries* by jen prodloužilo výslednou tabulku, ve které by se tak zobrazovaly i nerelevantní informace (prázdné sloupce). 
V reálu bych na toto upozornila a zpracovala podle požadavku zadavatele, podle potřeby bych všechny země z tabulky *countries* připojila.


## Výzkumné otázky
### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Výsledek je viditelný ve sloupci *rozdil_od_predchoziho_roku*. Kladná hodnota znamená, že mzdy rostou. Záporná hodnota znamená, že mzdy oproti předchozímu roku klesly.
Pokud se výsledek seřadí dle rozdílu vzestupně (což SQL k tomuto úkolu dělá), je na předních místech vidět seznam odvětví, ve kterých mzdy klesly o několik tisíc.
Největší pokles tak postihlo těchto 5 odvětví:
- Peněžnictví a pojišťovnictví
- Činnosti v oblasti nemovitostí
- Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu
- Ubytování, stravování a pohostinství
- Těžba a dobývání

Naopak z nějvětšího nárůstu se mohla těšit následující odvětví:
- Zdravotní a sociální péče
- Peněžnictví a pojišťovnictví
- Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu
- Informační a komunikační činnosti

Zajímavé je sledovat změny v letech 2019-2021 či okolo roku 2013.
V letech 2020 a 2021 zaznamenal nárůst obor zdravotní péče, což mohlo být způsobeno pandelmií koronaviru, kdy byla enormně zvýšena potřeba zdravotnického personálu.
Zároveň v roce 2020 zaznamenaly pokles obory Činnosti v oblasti nemovitostí a Ubytování, stravování a pohostinství, což mohlo být opět způsobeno pandemií a s ní spojenými lockdowny, zákazy cestování a ubytovávání.
Oproti tomu v roce 2013 nastal pokles v oblasti Peněžnictví a pojišťovnictví, což mohla způsobit recese, která v té době probíhala.
Ovšem vyhledem k množství zpracovaných záznamů je celkový trend spíše vzestupný.

### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Ve výsledné tabulce vidíme, že prvním rokem srovnání je rok 2006, posledním rokem je rok 2018.
Za průměrnou mzdu jsme tedy v těchto dvou letech mohli nakoupit následovně:


|Druh potraviny                |2006                          |2018                         |
|----------------|-------------------------------|-----------------------------|
|kg chleba|1282            |1340            |
|l mléka          |1432            |1639           |

Vidíme, že v průběhu let rostla průměrná mzda, a spolu s ní počet kg chleba či litrů mléka, které jsme si za tuto mzdu mohli koupit.

### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Ve výsledku tohoto dotazu vidíme dvě kategorie zboží, jejichž ceny rostly nejpomaleji,
a to Cukr krystalový (pokles ceny o -1,92 %) a Rajská jablka červená kulatá (pokles ceny o -0,74 %).

### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Prvním rokem měření je rok 2007, posledním pak rok 2018. 
Ve výsledné tabulce je vidět, že v tomto období nenastal rok, ve kterém by byl meziroční nárůst cen potravin o více než 10 % vyšší než nárůst mezd.
Největší rozdíl nastal v roce 2013, a to o 7,04 %.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Z výsledku vyplývá, že v obdobích výraznějšího hospodářského růstu dochází ke zvyšování mezd spíše **se zpožděním jednoho roku**, což naznačuje, že mzdy reagují na ekonomický růst postupně.
Toto se týká například let 2006–2007 a 2016–2018, kdy výraznější růst HDP v jednom roce předcházel vyššímu růstu mezd v roce následujícím.
V případě cen potravin je vztah k růstu HDP slabší. Ceny potravin jsou ovlivněny i dalšími faktory, (inflace, ceny energií), a jejich růst tedy nelze přímo vysvětlit pouze změnami HDP.
Růst HDP má tedy spíše nepřímý a zpožděný vliv na mzdy, zatímco vliv na ceny potravin je omezený a kolísavý.
