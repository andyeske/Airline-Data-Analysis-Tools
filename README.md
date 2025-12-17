<a name="back_to_top"></a>
# MIT Airline Data Project

Welcome to the revamped MIT Airline Data Project (ADP)! This open-source repository serves as a continuation of the original [MIT Airline Data Project](https://web.mit.edu/airlinedata/www/default.html) (which ended in 2021), and contains three tools that can be used to compute similar airline industry metrics to those found in the original ADP. Each of the tools described below can support the data visualization and subsequent analysis of the operational performance, market trends, and route statistics for [23 different airlines](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Airline%20Codes.xlsx) in the United States, as well as [36 different aircraft types](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Aircraft%20Codes.xlsx). These tools employ publicly available data from the US [Bureau of Transportation Statistics](https://www.transtats.bts.gov/databases.asp?Z1qr_VQ=E&Z1qr_Qr5p=N8vn6v10&f7owrp6_VQF=D), and are only meant for educational purposes.

## Data Visualization and Analysis Tools

### Table of Contents

1: [ Airline Performance Analysis Tool (APAT) ](#APAT) <br />
2: [ Airline Market Analysis Tool (AMAT) ](#AMAT) <br />
2: [ Airline Route Analysis Tool (ARAT) ](#ARAT) <br />

---
<a name="APAT"></a>
### Airline Peformance Analysis Tool (APAT)

**Tool Purpose:** ```APAT``` can be used to compute a variety of performance metrics, including:

**Data Inputs:**

**User Actions:** ```APAT``` can be run as a MATLAB script, with minimal user action. As shown

```
% ---------------------------------------- %
% Airline Performance Analysis Tool (APAT) - v1
% ---------------------------------------- %
% The following tool (APAT) can be used to compute a variety of performance
% metrics specific to aircraft and airlines in the US airline industry.
% APAT leverages open-source data from the US Bureau of Transportation
% Statistics (BTS), namely the T-100 Domestic Segment (US Carriers Only)
% dataset and the Form 41 Schedule P-5.2 dataset. Before using APAT, please
% make sure to follow the instructions outlined in: 

% APAT outputs a total of 21 tables, 19 of which are standard, and 2 of 
% which could be customized using user-defined inputs. These include:

% Overview Tables (Standard Tables)
% (1) Total Revenue Passenger Miles (RPMs): RPMs_by_Aircraft_and_Airline.xlsx
% (2) Total Available Seat Miles (ASMs): ASMs_by_Aircraft_and_Airline.xlsx
% (3) Average Load Factor (RPMs/ASMs): LFs_by_Aircraft_and_Airline.xlsx
% (4) Total Departures (# departures): Departures_by_Aircraft_and_Airline.xlsx

% Utilization Metrics Tables (Standard Tables)
% (5) Average Number of Departures per Day (# departures/day assigned): Departures_per_Day_by_Aircraft_and_Airline.xlsx
% (6) Average Number ASMs per Day (ASMs/day assigned): ASMs_per_Day_by_Aircraft_and_Airline.xlsx
% (7) Average Aircraft Utilization per Day (block-hr/day assigned): Block_Hours_per_Day_by_Aircraft_and_Airline.xlsx
% (8) Average Number of Seats per Departure (# seats/# departures): Seats_per_Departures_by_Aircraft_and_Airline.xlsx
% (9) Average Stage Length (mi): ASL_by_Aircraft_and_Airline.xlsx

% Fuel Consumption Tables (Standard Tables)
% (10) Average Fuel Intensity per ASMs (L/ASMs): Fuel_Consumed_per_ASMs_Aircraft_and_Airline.xlsx
% (11) Average Fuel Intensity per Distance (L/mi): Fuel_Consumed_per_Distance_Aircraft_and_Airline.xlsx

% Aircraft Operating Costs (AOC) Tables (Standard Tables)
% (12) AOC per Block Hour (USD$/block-hr): AOC_per_Block_Hour_by_Aircraft_and_Airline.xlsx
% (13) AOC per Seat Hour (USD$/seat-hr): AOC_per_Seat_Hour_by_Aircraft_and_Airline.xlsx
% (14) AOC per ASMs (USD$/ASM): AOC_per_ASMs_by_Aircraft_and_Airline.xlsx
% (15) Unnormalized Fuel Costs (USD$): Fuel_Costs_by_Aircraft_and_Airline.xlsx
% (16) Unnormalized Maintenance Costs (USD$): Maintenance_Costs_by_Aircraft_and_Airline.xlsx
% (17) Unnormalized Crew Costs (USD$): Crew_Costs_by_Aircraft_and_Airline.xlsx
% (18) Unnormalized Ownership Costs (USD$): Ownership_Costs_by_Aircraft_and_Airline.xlsx
% (19) Unnormalized Other Costs (USD$): Other_Costs_by_Aircraft_and_Airline.xlsx

% Aggregated Tables (User-Defined Tables)
% (20) Aircraft-specific Statistics: Aircraft_Cumulative_Statistics.xlsx
% (21) Airline-specific Statistics: Airline_Cumulative_Statistics.xlsx
% Tables (20) and (21) contain a summary of (1), (2), (6), (8), (4), (5), 
% (7), (3), (9), (12), (13), and (14), specific to an aircraft (20) or an
% airline (21).

% To generate (20) and (21), using the "Aircraft Codes" and "Airline Codes" 
% tables in (), the USER must select the desired aircraft and airline:
%Desired_Aircraft = 'All_Aircraft';
%Desired_Airline = 'All_Airlines';
Desired_Aircraft = 'A320';
Desired_Airline = 'American';

% To save the tables under the USER's directoty, the USER must select the 
% desired table indeces:
Save_Tables = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];

% Notes:
% a) Writing 'All_Aircaft' in Desired_Aircraft or 'All_Airlines' in 
% Desired_Airline returns the aggregated results for all aircraft and 
% airlines in the US, respectively
% b) The aggregated results are also returned whenever a non-existing 
% airline or aircraft are inputted in Desired_Aircraft or Desired_Airline.
% c) Writing [] in Save_Tables will not save any tables, and will simply
% generate these on MATLAB.
% d) APAT can be easily modified to produce more outputs than (1) - (21).
% ---------------------------------------- %
```

**Sample Outputs:** 

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
