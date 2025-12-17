<a name="back_to_top"></a>
# MIT Airline Data Project

Welcome to the revamped MIT Airline Data Project (ADP)! This open-source repository serves as a continuation of the original [MIT Airline Data Project](https://web.mit.edu/airlinedata/www/default.html) (which ended in 2021), and contains three tools that can be used to compute similar airline industry metrics to those found in the original ADP. Each of the tools described below can support the data visualization and subsequent analysis of the operational performance, market trends, and route statistics of [23 different airlines](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Airline%20Codes.xlsx) and [36 different aircraft types](https://github.com/andyeske/Airline-Data-Project/blob/main/Input%20Data%20Tables/Aircraft%20Codes.xlsx) in the United States. These tools employ publicly available data from the US [Bureau of Transportation Statistics](https://www.transtats.bts.gov/databases.asp?Z1qr_VQ=E&Z1qr_Qr5p=N8vn6v10&f7owrp6_VQF=D), and are only meant for educational purposes.

## Data Visualization and Analysis Tools

### Table of Contents

1: [ Airline Performance Analysis Tool (APAT) ](#APAT) <br />
2: [ Airline Market Analysis Tool (AMAT) ](#AMAT) <br />
2: [ Airline Route Analysis Tool (ARAT) ](#ARAT) <br />

---
<a name="APAT"></a>
### Airline Peformance Analysis Tool (APAT)

**Tool Purpose:** ```APAT``` can be used to compute 19 different system-wide performance metrics, to the aircraft and airline level of granularity. As a result, the outputs from APAT consist of 19 excel datatables, which are displayed below (alongside links to sample tables):

[Overview Metrics](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Overview%20Tables): 
* (1) Total Revenue Passenger Miles (RPMs) | _RPMs_by_Aircraft_and_Airline.xlsx_
* (2) Total Available Seat Miles (ASMs) | _ASMs_by_Aircraft_and_Airline.xlsx_ 
* (3) Average Load Factor (RPMs/ASMs) | _LFs_by_Aircraft_and_Airline.xlsx_ 
* (4) Total Departures (# departures) | _Departures_by_Aircraft_and_Airline.xlsx_ 

[Utilization Metrics](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Utilization%20Metrics%20Tables):
* (5) Average Number of Departures per Day (# departures/day assigned) | _Departures_per_Day_by_Aircraft_and_Airline.xlsx_ 
* (6) Average Number ASMs per Day (ASMs/day assigned) | _ASMs_per_Day_by_Aircraft_and_Airline.xlsx_ 
* (7) Average Aircraft Utilization per Day (block-hr/day assigned) | _Block_Hours_per_Day_by_Aircraft_and_Airline.xlsx_
* (8) Average Number of Seats per Departure (# seats/# departures) | _Seats_per_Departures_by_Aircraft_and_Airline.xlsx_ 
* (9) Average Stage Length (mi) | _ASL_by_Aircraft_and_Airline.xlsx_ 

[Fuel Consumption](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Fuel%20Consumption%20Tables): 
* (10) Average Fuel Intensity per ASMs (L/ASMs) | _Fuel_Consumed_per_ASMs_Aircraft_and_Airline.xlsx_ 
* (11) Average Fuel Intensity per Distance (L/mi) | _Fuel_Consumed_per_Distance_Aircraft_and_Airline.xlsx_ 

[Aircraft Operating Costs](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aircraft%20Operating%20Costs%20Tables): 
* (12) AOC per Block Hour (USD$/block-hr) | _AOC_per_Block_Hour_by_Aircraft_and_Airline.xlsx_ 
* (13) AOC per Seat Hour (USD$/seat-hr) | _AOC_per_Seat_Hour_by_Aircraft_and_Airline.xlsx_ 
* (14) AOC per ASMs (USD$/ASM) | _AOC_per_ASMs_by_Aircraft_and_Airline.xlsx_ 
* (15) Unnormalized Fuel Costs (USD$) | _Fuel_Costs_by_Aircraft_and_Airline.xlsx_ 
* (16) Unnormalized Maintenance Costs (USD$) | _Maintenance_Costs_by_Aircraft_and_Airline.xlsx_ 
* (17) Unnormalized Crew Costs (USD$) | _Crew_Costs_by_Aircraft_and_Airline.xlsx_ 
* (18) Unnormalized Ownership Costs (USD$) | _Ownership_Costs_by_Aircraft_and_Airline.xlsx_ 
* (19) Unnormalized Other Costs (USD$) | _Other_Costs_by_Aircraft_and_Airline.xlsx_ 

[Aggregated Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables): <br />

These datatables are by default computed at the yearly level (in the sample tables, for the entirety of 2024), although ```APAT``` can be modified to calculate the metrics at a different temporal resolution (e.g., the monthly level).

**Data Inputs:**

**User Actions:** ```APAT``` can be run as a MATLAB script, with minimal user action. As shown

```Desired_Aircraft = 'A320';```
```Desired_Airline = 'American';```
```Save_Tables = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];```

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
