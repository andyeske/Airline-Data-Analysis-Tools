<a name="back_to_top"></a>
# MIT Airline Data Project

Welcome to the revamped MIT Airline Data Project (ADP)! This open-source repository serves as a continuation of the original [MIT Airline Data Project](https://web.mit.edu/airlinedata/www/default.html) (which ended in 2021), and contains three tools that can be used to compute similar airline industry metrics to those found in the original ADP. Each of the tools described below can support the data visualization and subsequent analysis of the operational performance, market trends, and route statistics of [23 different airlines](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Airline%20Codes.xlsx) and [36 different aircraft types](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Aircraft%20Codes.xlsx) in the United States. These tools employ publicly available data from the US [Bureau of Transportation Statistics](https://www.transtats.bts.gov/databases.asp?Z1qr_VQ=E&Z1qr_Qr5p=N8vn6v10&f7owrp6_VQF=D) (BTS), and are only meant for educational purposes.

## Data Visualization and Analysis Tools

### Table of Contents

1: [ Airline Performance Analysis Tool (APAT) ](#APAT) <br />
2: [ Airline Market Analysis Tool (AMAT) ](#AMAT) <br />
2: [ Airline Route Analysis Tool (ARAT) ](#ARAT) <br />

---
<a name="APAT"></a>
### Airline Peformance Analysis Tool (APAT)

**Tool Purpose:** ```APAT``` can be used to compute 19 different system-wide performance metrics, to the aircraft and airline level of granularity, largely grouped under overview, utilization, fuel consumption, and aircraft operating cost metrics. The outputs from ```APAT``` consist of 21 excel data tables, which are displayed below (alongside links to sample tables):

[Overview Metrics](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Overview%20Tables): 
* (1) ```Total Revenue Passenger Miles (RPMs)``` | _RPMs_by_Aircraft_and_Airline.xlsx_
* (2) ```Total Available Seat Miles (ASMs)``` | _ASMs_by_Aircraft_and_Airline.xlsx_ 
* (3) ```Average Load Factor (RPMs/ASMs)``` | _LFs_by_Aircraft_and_Airline.xlsx_ 
* (4) ```Total Departures (# departures)``` | _Departures_by_Aircraft_and_Airline.xlsx_ 

[Utilization Metrics](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Utilization%20Metrics%20Tables):
* (5) ```Average Number of Departures per Day (# departures/day assigned)``` | _Departures_per_Day_by_Aircraft_and_Airline.xlsx_ 
* (6) ```Average Number ASMs per Day (ASMs/day assigned)``` | _ASMs_per_Day_by_Aircraft_and_Airline.xlsx_ 
* (7) ```Average Aircraft Utilization per Day (block-hr/day assigned)``` | _Block_Hours_per_Day_by_Aircraft_and_Airline.xlsx_
* (8) ```Average Number of Seats per Departure (# seats/# departures)``` | _Seats_per_Departures_by_Aircraft_and_Airline.xlsx_ 
* (9) ```Average Stage Length (mi)``` | _ASL_by_Aircraft_and_Airline.xlsx_ 

[Fuel Consumption](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Fuel%20Consumption%20Tables): 
* (10) ```Average Fuel Intensity per ASMs (L/ASMs)``` | _Fuel_Consumed_per_ASMs_Aircraft_and_Airline.xlsx_ 
* (11) ```Average Fuel Intensity per Distance (L/mi)``` | _Fuel_Consumed_per_Distance_Aircraft_and_Airline.xlsx_ 

[Aircraft Operating Costs](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aircraft%20Operating%20Costs%20Tables): 
* (12) ```AOC per Block Hour ($USD/block-hr)``` | _AOC_per_Block_Hour_by_Aircraft_and_Airline.xlsx_ 
* (13) ```AOC per Seat Hour ($USD/seat-hr)``` | _AOC_per_Seat_Hour_by_Aircraft_and_Airline.xlsx_ 
* (14) ```AOC per ASMs ($USD/ASM)``` | _AOC_per_ASMs_by_Aircraft_and_Airline.xlsx_ 
* (15) ```Unnormalized Fuel Costs ($USD)``` | _Fuel_Costs_by_Aircraft_and_Airline.xlsx_ 
* (16) ```Unnormalized Maintenance Costs ($USD)``` | _Maintenance_Costs_by_Aircraft_and_Airline.xlsx_ 
* (17) ```Unnormalized Crew Costs ($USD)``` | _Crew_Costs_by_Aircraft_and_Airline.xlsx_ 
* (18) ```Unnormalized Ownership Costs ($USD)``` | _Ownership_Costs_by_Aircraft_and_Airline.xlsx_ 
* (19) ```Unnormalized Other Costs ($USD)``` | _Other_Costs_by_Aircraft_and_Airline.xlsx_ 

[Aggregated Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables):
* (20)  ```Aircraft-specific Statistics ``` | _Aircraft_Cumulative_Statistics.xlsx_
* (21)  ```Airline-specific Statistics ``` | _Airline_Cumulative_Statistics.xlsx_

Here, Tables (20) and (21) contain a summary of (1), (2), (6), (8), (4), (5), (7), (3), (9), (12), (13), and (14), specific to each of the 36 aircraft types (20) and 23 airlines (21) in the US. By default, Tables (20) and (21) show average results for the entirety of the US airline industry. However, Table (20) can be customized to show the aircraft metrics specific to a single airline, while Table (21) can be modified to show the airline metrics specific to a single aircraft type, as shown in "User Action".

Note: By default, these data tables are computed at the yearly level. In the sample tables provided in this repository, the selected year is 2024. ```APAT``` can be easily adapted to calculate the metrics at a different temporal resolution (e.g., the monthly level).

**Data Inputs:** To use ```APAT```, the user must first download four open-source datasets, which include:
* [BTS T-100 Domestic Segment (US Carriers Only)](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=GDM) dataset. Select "All" for _Filter Geography_, "2024" for _Filter Year_ (or any desired year), and "All Months" for _Filter Month_. For the entries to download, only select a) Departures Performed | b) Seats | c) Passengers | d) Distance | e) Ramp to Ramp Time | f) Unique Carrier | g) Unique Carrier Name | h) Origin | i) Destinaiton | j) Aircraft | k) Month.
* [BTS Form 41 Schedule P-5.2](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FMK) dataset. Select the same year as above for _Filter Year_, and "All Quarters" for _Filter Period_. For the entries to download, select all.
* Aircraft Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).
* Airline Codes dataset, from [Input Data Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Input%20Data%20Tables).

After downloading the two BTS datasets, unzip them, and rename them to "T100 Data.csv" and "F41 Data.csv", respectively. Place all four datasets under the same folder, alongside the ```APAT```, which can be found in the [MATLAB Code](https://github.com/andyeske/Airline-Data-Project/tree/main/MATLAB%20Code).

**User Actions:** ```APAT``` can be run as a MATLAB script, with minimal user action. Data tables (1) - (19) are generated with any user input, while (20) - (21) can be customized to display results specific to a single airline in (20) (see an [American example](https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables/American_Aircraft_Cumulative_Statistics.xlsx)), or specific to a single aircraft type in (21) (see an [A320 example](https://github.com/andyeske/Airline-Data-Project/blob/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables/A320_Airline_Cumulative_Statistics.xlsx)). To do so, the user must modify the ```Desired_Aircraft``` and ```Desired_Airline``` fields in the "USER DEFINED INPUTS" section of ```APAT```, which is copied below. For example, setting ```Desired_Aircraft == 'A320'``` will generate a Table (21) whose results will be specific to the A320, as opposed to the average in the US fleet of aircraft.

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
% c) Writing [] in Save_Tables will not save any tables, and will simply
% generate these on MATLAB.
% d) APAT can be easily modified to produce more outputs than (1) - (21).
```

Lastly, the user can opt to save the tables (1) through (21). For this, it must modify the ```Save_Tables``` field to include the desired table numbers. In the example, all 21 tables would be saved.

([ back to top ](#back_to_top))

---
<a name="AMAT"></a>
### Airline Market Analysis Tool (AMAT)

Coming Soon!

([ back to top ](#back_to_top))

---
<a name="ARAT"></a>
### Airline Route Analysis Tool (ARAT)

Coming Soon!

([ back to top ](#back_to_top))

## Author

Andy Eskenazi, Department of Aeronautics and Astronautics, <br />
Massachusetts Institute of Technology, 2025 <br />
