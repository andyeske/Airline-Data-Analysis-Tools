<a name="back_to_top"></a>
# MIT Airline Data Project

Welcome to the revamped MIT Airline Data Project (ADP)! This open-source repository serves as a continuation of the original [MIT Airline Data Project](https://web.mit.edu/airlinedata/www/default.html) (which ended in 2021), and as such, contains four tools that can be used to compute similar airline industry metrics to those found in the original ADP. The first three tools support the analysis of the operational performance, as well as the visualization of market trends and route statistics, of [23 different airlines](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Airline%20Codes.xlsx) and [36 different aircraft types](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Aircraft%20Codes.xlsx) in the United States. The fourth tool can be used to visualize a variety of aircraft age, engine type, and ownership metrics across sub-fleets, airlines, or the entire US air transportation system. These tools employ publicly available data from the US Department of Transportation (DoT) [Bureau of Transportation Statistics](https://www.transtats.bts.gov/databases.asp?Z1qr_VQ=E&Z1qr_Qr5p=N8vn6v10&f7owrp6_VQF=D) (BTS) and US Federal Aviation Administration (FAA) [Tail Registry](https://registry.faa.gov/aircraftinquiry/search/nnumberinquiry), and are only meant for educational purposes.

## Data Analysis Tools

### Table of Contents

1: [ Airline Performance Analysis Tool (APAT) ](#APAT) <br />
2: [ Airline Market Analysis Tool (AMAT) ](#AMAT) <br />
3: [ Airline Route Analysis Tool (ARAT) ](#ARAT) <br />
4: [ Aircraft Engine Analysis Tool (AEAT) ](#AEAT) <br />

---
<a name="APAT"></a>
### Airline Peformance Analysis Tool (APAT)

**Tool Purpose:** ```APAT``` can be used to compute 19 different system-wide performance metrics, to the aircraft and airline level of granularity, largely grouped under overview, utilization, fuel consumption, and aircraft operating cost metrics. The outputs from ```APAT``` consist of 21 excel data tables, which are displayed below (alongside links to sample tables):

["Overview Metrics" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Overview%20Tables): 
* (1) ```Total Revenue Passenger Miles (RPMs)``` | _RPMs_by_Aircraft_and_Airline.xlsx_
* (2) ```Total Available Seat Miles (ASMs)``` | _ASMs_by_Aircraft_and_Airline.xlsx_ 
* (3) ```Average Load Factor (RPMs/ASMs)``` | _LFs_by_Aircraft_and_Airline.xlsx_ 
* (4) ```Total Departures (# departures)``` | _Departures_by_Aircraft_and_Airline.xlsx_ 

["Utilization Metrics" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Utilization%20Metrics%20Tables):
* (5) ```Average Number of Departures per Day (# departures/day assigned)``` | _Departures_per_Day_by_Aircraft_and_Airline.xlsx_ 
* (6) ```Average Number ASMs per Day (ASMs/day assigned)``` | _ASMs_per_Day_by_Aircraft_and_Airline.xlsx_ 
* (7) ```Average Aircraft Utilization per Day (block-hr/day assigned)``` | _Block_Hours_per_Day_by_Aircraft_and_Airline.xlsx_
* (8) ```Average Number of Seats per Departure (# seats/# departures)``` | _Seats_per_Departures_by_Aircraft_and_Airline.xlsx_ 
* (9) ```Average Stage Length (mi)``` | _ASL_by_Aircraft_and_Airline.xlsx_ 

["Fuel Consumption" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Fuel%20Consumption%20Tables): 
* (10) ```Average Fuel Intensity per ASMs (L/ASMs)``` | _Fuel_Consumed_per_ASMs_Aircraft_and_Airline.xlsx_ 
* (11) ```Average Fuel Intensity per Distance (L/mi)``` | _Fuel_Consumed_per_Distance_Aircraft_and_Airline.xlsx_ 

["Aircraft Operating Costs" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aircraft%20Operating%20Costs%20Tables): 
* (12) ```AOC per Block Hour ($USD/block-hr)``` | _AOC_per_Block_Hour_by_Aircraft_and_Airline.xlsx_ 
* (13) ```AOC per Seat Hour ($USD/seat-hr)``` | _AOC_per_Seat_Hour_by_Aircraft_and_Airline.xlsx_ 
* (14) ```AOC per ASMs ($USD/ASM)``` | _AOC_per_ASMs_by_Aircraft_and_Airline.xlsx_ 
* (15) ```Unnormalized Fuel Costs ($USD)``` | _Fuel_Costs_by_Aircraft_and_Airline.xlsx_ 
* (16) ```Unnormalized Maintenance Costs ($USD)``` | _Maintenance_Costs_by_Aircraft_and_Airline.xlsx_ 
* (17) ```Unnormalized Crew Costs ($USD)``` | _Crew_Costs_by_Aircraft_and_Airline.xlsx_ 
* (18) ```Unnormalized Ownership Costs ($USD)``` | _Ownership_Costs_by_Aircraft_and_Airline.xlsx_ 
* (19) ```Unnormalized Other Costs ($USD)``` | _Other_Costs_by_Aircraft_and_Airline.xlsx_ 

["Aggregated" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables):
* (20)  ```Aircraft-specific Statistics ``` | _Aircraft_Cumulative_Statistics.xlsx_
* (21)  ```Airline-specific Statistics ``` | _Airline_Cumulative_Statistics.xlsx_

Here, Tables (20) and (21) contain a summary of (1), (2), (6), (8), (4), (5), (7), (3), (9), (12), (13), and (14), specific to each of the 36 aircraft types (20) and 23 airlines (21) in the US. By default, Tables (20) and (21) show average results for the entirety of the US airline industry. However, Table (20) can be customized to show the aircraft metrics specific to a single airline, while Table (21) can be modified to show the airline metrics specific to a single aircraft type, as shown in "User Action".

Note: By default, these data tables are computed at the yearly level. In the sample tables provided in this repository, the selected year is 2024. ```APAT``` can be easily adapted to calculate the metrics at a different temporal resolution (e.g., the monthly level).

**Data Inputs:** To use ```APAT```, the user must first download four open-source datasets, which include:
* [BTS T-100 Domestic Segment (US Carriers Only)](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=GDM) dataset. Select "All" for _Filter Geography_, "2024" for _Filter Year_ (or any desired year), and "All Months" for _Filter Month_. For the entries to download, only select a) Departures Performed | b) Seats | c) Passengers | d) Distance | e) Ramp to Ramp Time | f) Unique Carrier | g) Origin | h) Destination | i) Aircraft Type | j) Year | k) Month.
* [BTS Form 41 Schedule P-5.2](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FMK) dataset. Select the same year as above for _Filter Year_, and "All Quarters" for _Filter Period_. For the entries to download, select all.
* Aircraft Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).
* Airline Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).

After downloading the two BTS datasets, unzip them, and rename them to "T100 Data.csv" and "F41 Data.csv", respectively. Place all four datasets under the same folder, alongside the ```APAT``` code, which can be found in the [MATLAB Code](https://github.com/andyeske/Airline-Data-Project/tree/main/MATLAB%20Code).

**User Actions:** ```APAT``` can be run as a MATLAB script, with minimal user action. Data tables (1) - (19) are generated with any user input, while (20) - (21) can be customized to display results specific to a single airline in (20) (see an [American example](https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables/American_Aircraft_Cumulative_Statistics.xlsx)), or specific to a single aircraft type in (21) (see an [A320 example](https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables/A320_Airline_Cumulative_Statistics.xlsx)). To do so, the user must modify the ```Desired_Aircraft``` and ```Desired_Airline``` fields in the "USER DEFINED INPUTS" section of ```APAT```, which is copied below. For example, setting ```Desired_Aircraft = 'A320'``` will generate a Table (21) whose results will be specific to the A320, as opposed to the average in the US fleet of aircraft.

```
% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate (20) and (21), using the "Aircraft Codes" and "Airline Codes" 
% tables in (https://github.com/andyeske/Airline-Data-Project), the USER 
% must select the desired aircraft and airline:
Desired_Aircraft = 'A320';
Desired_Airline = 'American';

% To save the tables under the USER's directory, the USER must select the 
% desired table indeces:
Save_Tables = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];

% Notes:
% a) Writing Desired_Aircraft = 'All_Aircaft' or 
% Desired_Airline = 'All_Airlines' returns the aggregated results for all 
% aircraft and airlines in the US, respectively.
% b) The aggregated results are also returned whenever a non-existing 
% airline or aircraft are inputted in Desired_Aircraft or Desired_Airline.
% c) Writing [] in Save_Tables will not save any tables.
% d) APAT can be easily modified to produce more outputs than (1) - (21).
```

Lastly, the user can specify which tables to save locally by modifying the ```Save_Tables``` field, as shown above.

([ back to top ](#back_to_top))

---
<a name="AMAT"></a>
### Airline Market Analysis Tool (AMAT)

**Tool Purpose:** ```AMAT``` can be used to compute 5 different market analysis metrics, to the origin-destination (OD) pair and airline level of granularity. These metrics include revenue, passengers per day each way (PDEWs), revenue passenger-miles (RPMs), average fare, and average yield. The outputs from ```APAT``` consist of 10 excel data tables, and vary according to whether the ODs are in or out of a desired airport, as displayed below:

["Out of Desired Origin Airport" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/AMAT%20Outputs/Out%20of%20Desired%20Origin%20Airport):
* (1) ```Daily Revenue by OD and Airline out of a Desired Origin Airport ($)``` | _Daily_Revenue_by_OD_and_Airline_Out.xlsx_
* (2) ```PDEW by OD and Airline out of a Desired Origin Airport (# of people)``` | _PDEW_by_OD_and_Airline_Out.xlsx_
* (3) ```Daily RPMs by OD and Airline out of a Desired Origin Airport (RPMs)``` | _Daily_RPM_by_OD_and_Airline_Out.xlsx_
* (4) ```Average Fare by OD and Airline out of a Desired Origin Airport ($)``` | _Average_Fare_by_OD_and_Airline_Out.xlsx_
* (5) ```Average Yield by OD and Airline out of a Desired Origin Airport ($/RPM)``` | _Average_Yield_by_OD_and_Airline_Out.xlsx_  

["Into Desired Destination Airport" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/AMAT%20Outputs/Into%20Desired%20Destination%20Airport):
* (6) ```Daily Revenue by OD and Airline into a Desired Destination Airport ($)``` | _Daily_Revenue_by_OD_and_Airline_In.xlsx_  
* (7) ```PDEW by OD and Airline into a Desired Destination Airport (# of people)``` | _PDEW_by_OD_and_Airline_In.xlsx_
* (8) ```Daily RPMs by OD and Airline into a Desired Destination Airport (RPMs)``` | _Daily_RPM_by_OD_and_Airline_In.xlsx_
* (9) ```Average Fare by OD and Airline into a Desired Destination Airport ($)``` | _Average_Fare_by_OD_and_Airline_In.xlsx_
* (10) ```Average Yield by OD and Airline into a Desired Destination Airport ($/RPM)``` | _Average_Yield_by_OD_and_Airline_In.xlsx_

Sample data tables can be found in the above-listed hyperlinks. The data in these tables correspond to 2025 Q1. The tables were generated using the user parameters shown below.

Note: By default, these data tables are computed using quarterly data, but then collapsed to indicate daily and average metrics. ```AMAT``` can be easily adapted to calculate the metrics at a different temporal resolution (e.g., the monthly level).

**Data Inputs:** To use ```AMAT```, the user must first download three open-source datasets, which include:
* [BTS Origin and Destination Survey (DB1B - Market)](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FHK) dataset. Select the desired state for _Filter Geography_ (e.g., Massachusetts), the desired year for _Filter Year_ (e.g., 2025), and the desired quarter for _Filter Quarter_ (e.g., Quarter 1). For the entries to download, only select a) Quarter | b) Origin | c) Dest | d) RPCarrier | e) Passengers | f) MktFare | g) MktMilesFlown.
* Aircraft Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).
* Airline Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).

After downloading the BTS dataset, unzip it, and rename it to "DB1B Data.csv". Place all three datasets under the same folder, alongside the ```AMAT``` code, which can be found in the [MATLAB Code](https://github.com/andyeske/Airline-Data-Project/tree/main/MATLAB%20Code).

**User Actions:** ```AMAT``` can be run as a MATLAB script, with minimal user action. However, the user can modify some of the fields under the "USER DEFINED INPUTS" section of ```AMAT``` to generate custom data tables. For example, setting ```Desired_Airport = 'BOS'```, ```Number_Markets = 20```, ```Desired_Sorting = 2``` and ```Desired_Airline = 'United'``` will generate tables (1) - (5) showing the top 20 ODs out of Boston (origin) by PDEW, tables (6) - (10) showing the top 20 ODs into Boston (destination). All of these tables also report revenue, RPMs, average fare, and yield for all other airlines, but the ODs are sorted specifically for United.

```
% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate (1) through (10), the USER must specify four parameters, which
% include:

% Please input the Desired Airport: 
Desired_Airport = 'BOS';

% Please select the Number of Markets:
% --> This corresponds to the number of markets that will be displayed on
% tables.
Number_Markets = 20;

% Plase select the Desired Sorting preference:
% --> Here, select: Revenue (1) | Passengers (2) | RPM (3) | Fare (4) | 
% Yield (5) to sort the tables according to each of these metrics.
Desired_Sorting = 2;

% Please input the Desired Airline: 
% --> This is the airline that will be used to sort the rows of the output
% table. You can use the table "Airline Codes" available in 
% https://github.com/andyeske/Airline-Data-Project to find the set of 23 
% US airlines available for selection.
Desired_Airline = 'United';

% Finally, please select the desired table indeces to save:
Save_Tables = [1,2,3,4,5,6,7,8,9,10];

% Notes:
% a) Desired_Airline = 'All_Airlines' will sort the tables using the
% aggregate column for all airlines in the US.
% b) Writing [] in Save_Tables will not save any tables.
```

Lastly, the user can specify which tables to save locally by modifying the ```Save_Tables``` field, as shown above.

([ back to top ](#back_to_top))

---
<a name="ARAT"></a>
### Airline Route Analysis Tool (ARAT)

**Tool Purpose:** ```ARAT``` can be used to compute 4 different capacity metrics, to the route and airline/aircraft level of granularity. These metrics include total revenue passenger-miles (RPM), total available seat-miles (ASMs), total passengers, and total departures. The outputs from ```APAT``` consist of 8 excel data tables, and vary according to whether the route metrics are disaggregated to the airline or aircraft level:

["Route and Airline" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/ARAT%20Outputs/Route%20and%20Airline%20Tables):
* (1) ```Total Revenue Passenger Miles by Route and Airline out of a Desired Airport (RPMs)``` | _Total_RPMs_by_Route_and_Airline_Out.xlsx_
* (2) ```Total Available Seat Miles by Route and Airline out of a Desired Airport (ASMs)``` | _Total_ASMs_by_Route_and_Airline_Out.xlsx_
* (3) ```Total Passengers by Route and Airline out of a Desired Airport (# of passsengers)``` | _Total_Passengers_by_Route_and_Airline_Out.xlsx_
* (4) ```Total Departures by Route and Airline out of a Desired Airport (# of departures)``` | _Total_Departures_by_Route_and_Airline_Out.xlsx_

["Route and Aircraft" Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/ARAT%20Outputs/Route%20and%20Aircraft%20Tables):
* (5) ```Total Revenue Passenger Miles by Route and Aircraft out of a Desired Airport (RPMs)``` | _Total_RPMs_by_Route_and_Aircraft_Out.xlsx_
* (6) ```Total Available Seat Miles by Route and Aircraft out of a Desired Airport (ASMs)``` | _Total_ASMs_by_Route_and_Aircraft_Out.xlsx_
* (7) ```Total Passengers by Route and Aircraft out of a Desired Airport (# of passsengers)``` | _Total_Passengers_by_Route_and_Aircraft_Out.xlsx_
* (8) ```Total Departures by Route and Aircraft out of a Desired Airport (# of departures)``` | _Total_Departures_by_Route_and_Aircraft_Out.xlsx_

Sample data tables can be found in the above-listed hyperlinks. The data in these tables corresponds to the entirety of 2024. The tables were generated using the user parameters shown below.

Note: By default, these data tables are computed using annual T100 data. ```ARAT``` can be easily adapted to calculate the metrics at a different temporal resolution (e.g., the monthly level).

**Data Inputs:** To use ```ARAT```, the user must first download three open-source datasets, which include:
* [BTS T-100 Domestic Segment (US Carriers Only)](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=GDM) dataset. Select "All" for _Filter Geography_, "2024" for _Filter Year_ (or any desired year), and "All Months" for _Filter Month_. For the entries to download, only select a) Departures Performed | b) Seats | c) Passengers | d) Distance | e) Ramp to Ramp Time | f) Unique Carrier | g) Origin | h) Destinaiton | i) Aircraft | j) Month.
* Aircraft Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).
* Airline Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).

After downloading the BTS dataset, unzip it, and rename it to "T100 Data.csv". Place all three datasets under the same folder, alongside the ```ARAT``` code, which can be found in the [MATLAB Code](https://github.com/andyeske/Airline-Data-Project/tree/main/MATLAB%20Code).

**User Actions:** ```ARAT``` can be run as a MATLAB script, with minimal user action. However, the user can modify some of the fields under the "USER DEFINED INPUTS" section of ```ARAT``` to generate custom data tables. For example, setting ```Origin_Airport = 'BOS'``` will display the top routes out of that airport. Specifying ```Number_Routes = 20``` will generate tables that show only the top 20 routes. Finally, inputting ```Destination_Airport = 'MIA'``` will amend the route from ```Origin_Airport``` to ```Destination_Airport``` should it not be listed already in the top 20 routes.

```
% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate (1) through (8), the USER must specify four parameters, which
% include:

% Please input the Desired Origin Airport: 
Origin_Airport = 'BOS';

% Please select the Number of Routes:
% --> This corresponds to the number of routes that will be displayed on
% tables.
Number_Routes = 20;

% Please input the Desired Destination Airport: 
% --> In case the route from 'Origin_Airport' to 'Destination_Airport' is
% not included in the tables already, specifiying will amend it to the
% tables (unless the route segment does not currently exist).
Destination_Airport = 'MIA';

% Finally, please select the desired table indeces to save:
Save_Tables = [1,2,3,4,5,6,7,8];

% Notes:
% a) Writing [] in Save_Tables will not save any tables.
```

Lastly, the user can specify which tables to save locally by modifying the ```Save_Tables``` field, as shown above.

---
<a name="AEAT"></a>
### Aircraft Engine Analysis Tool (AEAT)

**Tool Purpose:** ```AEAT``` can be used to to visualize a variety of aircraft age, engine type, and ownership metrics across sub-fleets, airlines, or the entire US air transportation system. Sample plots generated by the tool can be seen in **Figure 1 - Figure 3**.

**Data Inputs:** To use ```AEAT```, the user must first download two open-source datasets, which include:
* [FAA Aircraft Registration Database](https://www.faa.gov/licenses_certificates/aircraft_certification/aircraft_registry/releasable_aircraft_download).
* Tail Registry Aircraft and Engines Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).

After downloading the FAA dataset, unzip it, and extract the "MASTER.txt" and "DEREG.txt" files. Place these two text files, as well as the excel file, under the same folder, alongside the ```AEAT``` code, which can be found in the [MATLAB Code](https://github.com/andyeske/Airline-Data-Project/tree/main/MATLAB%20Code).

**User Actions:** ```AEAT``` can be run as a MATLAB script, with minimal user action. The user can modify some of the fields under the "USER DEFINED INPUTS" section of ```AEAT``` to generate custom plots. For example:

* Setting ```Desired_Aircraft = {'A319-100','A320-200','A321-200'}``` and ```Desired_Airline = {}``` will result in **Figure 1**, which displays metrics specific to the A320 family, across all US airlines.

<p align="left">
<img src="https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/AEAT%20Outputs/A320%20Family.jpg" width="500"> 

**Figure 1:** _A320 Family Age and Ownership Metrics (as of June 2026)_.
</p>

* Setting ```Desired_Aircraft = {'A319-100','A320-200','A321-200'}``` and ```Desired_Airline = {'AMERICAN AIRLINES INC'}``` will result in **Figure 2**, which displays the same information as before, but specific to American. The difference is in the lower bottom plot, which now displays the number of aircraft of the A320 family within American's fleet.

<p align="left">
<img src="https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/AEAT%20Outputs/American%20Airlines%20-%20A320%20Family.jpg" width="500"> 

**Figure 2:** _A320 Family Age and Ownership Metrics specific for American (as of June 2026)_.
</p>

* Setting ```Desired_Aircraft = {}``` and ```Desired_Airline = {'AMERICAN AIRLINES INC'}``` will result in **Figure 3**, which displays fleet-wide information specific to American. 

<p align="left">
<img src="https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/AEAT%20Outputs/American%20Airlines.jpg" width="500"> 

**Figure 3:** _A320 Family Age and Ownership Metrics specific for American (as of June 2026)_.
</p>

```
% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% The USER must specify the following three parameters, which include:

% Please input the Registration Status
% --> This choice influences whether the displayed data corresponds to
% currently registered aircraft (1) or de-registered aircraft (2)
Registration_Status = 1;

% Please input the Desired Aircraft: 
% --> This choice makes the displayed results aircraft-specific. 
% --> It is possible to input multiple aircraft types, separated by a
%     comma (e.g., Desired_Aircraft = {'B777-200','B777-200ER'})
% --> Leaving this entry blank will display results for all aircraft types 
%     for the Desired Airline.
% --> Permissible aircraft typs include:
%     B717-100 
%     B737-300  | B737-400    | B737-500   | B737-600 | B737-600 | B737-700
%     B737-800  | B737-900    | B737-900ER | B737-8   | B737-9
%     B747-400  | B737-400F   | B747-8     | B747-8F
%     B757-200  | B757-200ER  | B757-200F  | B757-300
%     B767-200  | B767-200ER  | B767-200F  | B767-300 | B767-300ER 
%     B767-300F | B767-400    | B767-400ER
%     B777-200  | B777-200ER  | B777-200LR | B777-300 | B777-300ER | B777F
%     B787-8    | B787-9      | B787-10
%     A319-100  | A320-100    | A320-200   | A320NEO  
%     A321-100  | A321-200    | A320NEO    | A321F
%     A330-200  | A330-200F   | A330-300   | A330-900
%     A340-200  | A340-300    | A340-500   | A340-600
%     A350-900
%     A220-300
%     Q100      | Q200        | Q300       | Q400
%     CRJ-200   | CRJ-550     | CRJ-700    | CRJ-900  | CRJ-1000
%     E135      | E145        | E170       | E190
%     DC-9      | DC-9F       | MD-80      | MD-90
%     DC-10     | DC-10F      | MD-11      | MD-11F
Desired_Aircraft = {'A319-100','A320-200','A321-200'};

% Please input the Desired Airline: 
% --> This choice will make the displayed results airline-specific.
% --> It is possible to input multiple airlines, separated by a comma
%     comma (e.g., Desired_Airline = {'DELTA AIR LINES INC','UNITED AIRLINES INC'})
% --> Leaving this entry blank will display results for all US airlines for 
%     the Desired Aircraft.
% --> Example airlines include and are not limited to:
%     ALASKA AIRLINES INC            | AMERICAN AIRLINES INC
%     DELTA AIR LINES INC            | JETBLUE AIRWAYS CORP
%     HAWAIIAN AIRLINES INC          | SKYWEST AIRLINES INC
%     SOUTHWEST AIRLINES CO          | SPIRIT AIRLINES LLC        
%     UNITED AIRLINES INC 
%     FEDERAL EXPRESS CORP           | UNITED PARCEL SERVICE CO
Desired_Airline = {'DELTA AIR LINES INC','UNITED AIRLINES INC'};

% Notes:
% a) The use can either leave "Desired_Aircraft" or "Desired_Airline"
% empty, but not both. Otherwise, it will trigger an error.
```

([ back to top ](#back_to_top))

## Author

Andy Eskenazi, Department of Aeronautics and Astronautics, <br />
Massachusetts Institute of Technology, 2025 <br />
