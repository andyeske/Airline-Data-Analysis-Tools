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

**Tool Purpose:** ```APAT``` can be used to compute a variety of performance metrics, a sample of which are contained in this repository. These metrics include:

[Overview Metrics](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Overview%20Tables):
* (1) Total Revenue Passenger Miles (RPMs) - Excel Name: RPMs_by_Aircraft_and_Airline.xlsx
* (2) Total Available Seat Miles (ASMs) - Excel Name: ASMs_by_Aircraft_and_Airline.xlsx
* (3) Average Load Factor (RPMs/ASMs) - Excel Name: LFs_by_Aircraft_and_Airline.xlsx
* (4) Total Departures (# departures) - Excel Name: Departures_by_Aircraft_and_Airline.xlsx

[Utilization Metrics](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Utilization%20Metrics%20Tables):
* (5) Average Number of Departures per Day (# departures/day assigned) - Excel Name: Departures_per_Day_by_Aircraft_and_Airline.xlsx
* (6) Average Number ASMs per Day (ASMs/day assigned) - Excel Name: ASMs_per_Day_by_Aircraft_and_Airline.xlsx
* (7) Average Aircraft Utilization per Day (block-hr/day assigned) - Excel Name: Block_Hours_per_Day_by_Aircraft_and_Airline.xlsx
* (8) Average Number of Seats per Departure (# seats/# departures) - Excel Name: Seats_per_Departures_by_Aircraft_and_Airline.xlsx
* (9) Average Stage Length (mi) - Excel Name: ASL_by_Aircraft_and_Airline.xlsx

[Fuel Consumption](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Fuel%20Consumption%20Tables):
* (10) Average Fuel Intensity per ASMs (L/ASMs) - Excel Name: Fuel_Consumed_per_ASMs_Aircraft_and_Airline.xlsx
* (11) Average Fuel Intensity per Distance (L/mi) - Excel Name: Fuel_Consumed_per_Distance_Aircraft_and_Airline.xlsx

[Aircraft Operating Costs](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aircraft%20Operating%20Costs%20Tables):
* (12) AOC per Block Hour (USD$/block-hr) - Excel Name: AOC_per_Block_Hour_by_Aircraft_and_Airline.xlsx
* (13) AOC per Seat Hour (USD$/seat-hr) - Excel Name: AOC_per_Seat_Hour_by_Aircraft_and_Airline.xlsx
* (14) AOC per ASMs (USD$/ASM) - Excel Name: AOC_per_ASMs_by_Aircraft_and_Airline.xlsx
* (15) Unnormalized Fuel Costs (USD$) - Excel Name: Fuel_Costs_by_Aircraft_and_Airline.xlsx
* (16) Unnormalized Maintenance Costs (USD$) - Excel Name: Maintenance_Costs_by_Aircraft_and_Airline.xlsx
* (17) Unnormalized Crew Costs (USD$) - Excel Name: Crew_Costs_by_Aircraft_and_Airline.xlsx
* (18) Unnormalized Ownership Costs (USD$) - Excel Name: Ownership_Costs_by_Aircraft_and_Airline.xlsx
* (19) Unnormalized Other Costs (USD$) - Excel Name: Other_Costs_by_Aircraft_and_Airline.xlsx

[Aggregated Tables](https://github.com/andyeske/Airline-Data-Project/tree/main/Output%20Data%20Tables/APAT%20Outputs/Aggregated%20Tables):

In terms of temporal resolution, each of these metrics can be 

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
