% ----------------------------------------------------------------------- %
% ------------ AIRLINE PERFORMANCE ANALYSIS TOOL (APAT) - v1 ------------ %
% ----------------------------------------------------------------------- %

% The following tool (APAT) can be used to compute a variety of performance
% metrics specific to aircraft and airlines in the US airline industry.
% APAT leverages open-source data from the US Bureau of Transportation
% Statistics (BTS), namely the Form 41 Traffic - T-100 Segment 
% (US Carriers Only) dataset and the Form 41 Financial - Schedule P-5.2 
% dataset. Before using APAT, please make sure to follow the instructions 
% outlined in: https://github.com/andyeske/Airline-Data-Analysis-Tools

% APAT outputs a total of 27 tables, 25 of which are standard, and 2 of 
% which can be customized using user-defined inputs. These tables include:

% Overview Tables (Standard Tables):
% (1) Total Revenue Passenger Miles (RPMs): RPMs_by_Aircraft_and_Airline.xlsx
% (2) Total Available Seat Miles (ASMs): ASMs_by_Aircraft_and_Airline.xlsx
% (3) Total Number of Passengers: Passengers_by_Aircraft_and_Airline.xlsx
% (4) Total Number of Seats: Seats_by_Aircraft_and_Airline.xlsx
% (5) Average Load Factor (RPMs/ASMs): LFs_by_Aircraft_and_Airline.xlsx
% (6) Total Departures (# departures): Departures_by_Aircraft_and_Airline.xlsx

% Utilization Metrics Tables (Standard Tables):
% (7) Average Number of Departures per Day (# departures/day assigned): Departures_per_Day_by_Aircraft_and_Airline.xlsx
% (8) Average Number ASMs per Day (ASMs/day assigned): ASMs_per_Day_by_Aircraft_and_Airline.xlsx
% (9) Average Aircraft Utilization per Day (block-hr/day assigned): Block_Hours_per_Day_by_Aircraft_and_Airline.xlsx
% (10) Average Number of Seats per Departure (# seats/# departures): Seats_per_Departures_by_Aircraft_and_Airline.xlsx
% (11) Average Stage Length (mi): ASL_by_Aircraft_and_Airline.xlsx
% (12) Average Passenger Trip Length (mi): APTL_by_Aircraft_and_Airline.xlsx

% Fuel Consumption Tables (Standard Tables):
% (13) Average Fuel Intensity per ASMs (L/ASMs): Fuel_Consumed_per_ASMs_Aircraft_and_Airline.xlsx
% (14) Average Fuel Intensity per Distance (L/mi): Fuel_Consumed_per_Distance_Aircraft_and_Airline.xlsx

% Aircraft Operating Costs (AOC) Tables (Standard Tables):
% (15) AOC per Block Hour (USD$/block-hr): AOC_per_Block_Hour_by_Aircraft_and_Airline.xlsx
% (16) AOC per Seat Hour (USD$/seat-hr): AOC_per_Seat_Hour_by_Aircraft_and_Airline.xlsx
% (17) AOC per ASMs (USD$/ASM): AOC_per_ASMs_by_Aircraft_and_Airline.xlsx
% (18) Unnormalized Fuel Costs (USD$): Fuel_Costs_by_Aircraft_and_Airline.xlsx
% (19) Unnormalized Maintenance Costs (USD$): Maintenance_Costs_by_Aircraft_and_Airline.xlsx
% (20) Unnormalized Crew Costs (USD$): Crew_Costs_by_Aircraft_and_Airline.xlsx
% (21) Unnormalized Ownership Costs (USD$): Ownership_Costs_by_Aircraft_and_Airline.xlsx
% (22) Unnormalized Other Costs (USD$): Other_Costs_by_Aircraft_and_Airline.xlsx

% Miscellaneous Tables (Standard Tables):
% (23) Total Block Hours (hrs): Block_Hours_by_Aircraft_and_Airline.xlsx
% (24) Total Distance Flown (mi): Distance_Flown_by_Aircraft_and_Airline.xlsx
% (25) Total Days Assigned (daus): Days_Assigned_by_Aircraft_and_Airline.xlsx

% Aggregated Tables (User-Defined Tables):
% (26) Aircraft-specific Statistics: Aircraft_Cumulative_Statistics.xlsx
% (27) Airline-specific Statistics: Airline_Cumulative_Statistics.xlsx

% Tables (20) and (21) contain a summary of (1), (2), (8), (10), (6), (7), 
% (9), (5), (11), (15), (16), and (17), specific to an aircraft (26) or an
% airline (27).

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate (26) and (27), the USER must specify two parameters, which
% include:

% Please input the Desired Airline: 
% --> The aircraft-specific results (26) will correspond only to values of 
% this airline. You can use the table "Airline Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of 24 US airlines available for selection.
% Desired_Airline = 'American';
Desired_Airline = 'All Airlines';

% Please input the Desired Aircraft: 
% --> The airline-specific results (27) will correspond only to values of 
% this aircraft type. You can use the table "Aircraft Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of 46 aircraft types available for selection.
% Desired_Aircraft = 'A320';
Desired_Aircraft = 'All Aircraft';

% Finally, please select the desired table indeces to save:
%Save_Tables = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
Save_Tables = [23,24,25];
%Save_Tables = [20,21];
%Save_Tables = [];

% Notes:
% a) Writing Desired_Aircraft = 'All_Aircaft' or 
% Desired_Airline = 'All_Airlines' returns the aggregated results for all 
% aircraft and airlines in the US, respectively.
% b) The aggregated results are also returned whenever a non-existing 
% airline or aircraft are inputted in Desired_Aircraft or Desired_Airline.
% c) Writing [] in Save_Tables will not save any tables.
% d) APAT can be easily modified to produce more outputs than (1) - (21).

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the datasets
T100 = readtable('T100 Data.csv'); 
P5_2 = readtable('P5.2 Data.csv');
AircraftCodes = readtable('Aircraft Codes.xlsx');
AirlineCodes = readtable('Airline Codes.xlsx');

% Extracting dataset statistics
n_aircraft = length(AircraftCodes{:,1});
n_airlines = length(AirlineCodes{:,1});
n_P5_2 = length(P5_2{:,1});
year = T100{1,10};

% Eliminating unnecessary entries on T100
T100 = T100(find(T100{:,1} > 0),:); % Non-zero departures
T100 = T100(find(T100{:,2} > 0),:); % Non-zero seats
T100 = T100(find(T100{:,4} > 0),:); % Non-zero distance
in_T100 = [];
for k_aircraft = 1:n_aircraft
    in_T100 = [in_T100;find(T100{:,9} == AircraftCodes{k_aircraft,1})];      
end
T100 = T100(in_T100,:);
n_T100 = length(T100{:,1});

% Finding the desired aircraft and airline indeces
Desired_Airline_In = find(strcmp(Desired_Airline,AirlineCodes{:,2}) == 1);
Desired_Aircraft_In = find(strcmp(Desired_Aircraft,AircraftCodes{:,2}) == 1);
% Default index if a wrong code is inputted
if isempty(Desired_Airline_In)
    Desired_Airline_In = n_airlines + 1;
    table_name_airline = ['Airline_Cumulative_Statistics_',num2str(year),'.xlsx'];
else
    table_name_airline = [Desired_Aircraft,'_Airline_Cumulative_Statistics_',num2str(year),'.xlsx'];
end
if isempty(Desired_Aircraft_In)
    Desired_Aircraft_In = n_aircraft + 1;
    table_name_aircraft = ['Aircraft_Cumulative_Statistics_',num2str(year),'.xlsx'];
else
    table_name_aircraft = [Desired_Airline,'_Aircraft_Cumulative_Statistics_',num2str(year),'.xlsx'];
end

%% ------------------- Step 2: Computing the metrics -------------------- %

% ------------------------- From the T100 Data -------------------------- %
ASMs = T100{:,2}.*T100{:,4}; % Seats * Distance
RPMs = T100{:,3}.*T100{:,4}; % Passengers * Distance
Distance = T100{:,1}.*T100{:,4}; % Departures * Distance
Seat_Hours = T100{:,2}.*T100{:,5}./T100{:,1}./60; % Seats * Ramp to Ramp Time / Departures / 60 (minutes)

% Processed Aircraft/Airline datasets
Aircraft_Airline_Block_Hours = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Block Hours
Aircraft_Airline_RPMs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total RPMs
Aircraft_Airline_ASMs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total ASMs
Aircraft_Airline_Departures = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Departures
Aircraft_Airline_Distance_Flown = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Distance Flown
Aircraft_Airline_Passengers = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Passengers
Aircraft_Airline_Seats = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Seats
Aircraft_Airline_Seat_Hours = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Seat Hours

% Iterating through all entries of T100
for k = 1:n_T100

    % Finding the airline and aircraft
    Airline = char(T100{k,6}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);
    Aircraft = T100{k,9}; Aircraft_In = find(Aircraft == AircraftCodes{:,1});

    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0 && isempty(Aircraft_In) == 0
        
        Aircraft_Airline_Block_Hours(Aircraft_In,Airline_In) = Aircraft_Airline_Block_Hours(Aircraft_In,Airline_In) + T100{k,5}/60; % Hours
        Aircraft_Airline_RPMs(Aircraft_In,Airline_In) = Aircraft_Airline_RPMs(Aircraft_In,Airline_In) + RPMs(k); % RPMs
        Aircraft_Airline_ASMs(Aircraft_In,Airline_In) = Aircraft_Airline_ASMs(Aircraft_In,Airline_In) + ASMs(k); % ASMs
        Aircraft_Airline_Departures(Aircraft_In,Airline_In) = Aircraft_Airline_Departures(Aircraft_In,Airline_In) + T100{k,1}; % Departures
        Aircraft_Airline_Distance_Flown(Aircraft_In,Airline_In) = Aircraft_Airline_Distance_Flown(Aircraft_In,Airline_In) + Distance(k); % Miles
        Aircraft_Airline_Passengers(Aircraft_In,Airline_In) = Aircraft_Airline_Passengers(Aircraft_In,Airline_In) + T100{k,3}; % Passengers
        Aircraft_Airline_Seats(Aircraft_In,Airline_In) = Aircraft_Airline_Seats(Aircraft_In,Airline_In) + T100{k,2}; % Seats
        Aircraft_Airline_Seat_Hours(Aircraft_In,Airline_In) = Aircraft_Airline_Seat_Hours(Aircraft_In,Airline_In) + Seat_Hours(k); % Seat-hours

    end

    % Displaying progress
    if mod(k,1000) == 0
        disp([num2str(round(100*k/n_T100,2)),'%'])
    end

end

% Computing the cumulative metrics
Aircraft_Airline_Block_Hours(end,:) = sum(Aircraft_Airline_Block_Hours,1); Aircraft_Airline_Block_Hours(:,end) = sum(Aircraft_Airline_Block_Hours,2);
Aircraft_Airline_RPMs(end,:) = sum(Aircraft_Airline_RPMs,1); Aircraft_Airline_RPMs(:,end) = sum(Aircraft_Airline_RPMs,2);
Aircraft_Airline_ASMs(end,:) = sum(Aircraft_Airline_ASMs,1); Aircraft_Airline_ASMs(:,end) = sum(Aircraft_Airline_ASMs,2);
Aircraft_Airline_Departures(end,:) = sum(Aircraft_Airline_Departures,1); Aircraft_Airline_Departures(:,end) = sum(Aircraft_Airline_Departures,2);
Aircraft_Airline_Distance_Flown(end,:) = sum(Aircraft_Airline_Distance_Flown,1); Aircraft_Airline_Distance_Flown(:,end) = sum(Aircraft_Airline_Distance_Flown,2);
Aircraft_Airline_Passengers(end,:) = sum(Aircraft_Airline_Passengers,1); Aircraft_Airline_Passengers(:,end) = sum(Aircraft_Airline_Passengers,2);
Aircraft_Airline_Seats(end,:) = sum(Aircraft_Airline_Seats,1); Aircraft_Airline_Seats(:,end) = sum(Aircraft_Airline_Seats,2);
Aircraft_Airline_Seat_Hours(end,:) = sum(Aircraft_Airline_Seat_Hours,1); Aircraft_Airline_Seat_Hours(:,end) = sum(Aircraft_Airline_Seat_Hours,2);

% Computing the remainder of the Aircraft/Airline datasets
Aircraft_Airline_LFs = round(100*Aircraft_Airline_RPMs./Aircraft_Airline_ASMs,2); % RPMs / ASMs
Aircraft_Airline_ASLs = round(Aircraft_Airline_Distance_Flown./Aircraft_Airline_Departures); % Total Distance / Departures
Aircraft_Airline_Seats_per_Departure = round(Aircraft_Airline_Seats./Aircraft_Airline_Departures); % Total Seats / Departures
Aircraft_Airline_APTLs = round(Aircraft_Airline_RPMs./Aircraft_Airline_Passengers); % Total Seats / Departures

% Eliminating NaN entries
Aircraft_Airline_Block_Hours(isnan(Aircraft_Airline_Block_Hours)) = 0;
Aircraft_Airline_RPMs(isnan(Aircraft_Airline_RPMs)) = 0;
Aircraft_Airline_ASMs(isnan(Aircraft_Airline_ASMs)) = 0;
Aircraft_Airline_Departures(isnan(Aircraft_Airline_Departures)) = 0;
Aircraft_Airline_Distance_Flown(isnan(Aircraft_Airline_Distance_Flown)) = 0;
Aircraft_Airline_Seats(isnan(Aircraft_Airline_Seats)) = 0;
Aircraft_Airline_Seat_Hours(isnan(Aircraft_Airline_Seat_Hours)) = 0;
Aircraft_Airline_LFs(isnan(Aircraft_Airline_LFs)) = 0;
Aircraft_Airline_ASLs(isnan(Aircraft_Airline_ASLs)) = 0;
Aircraft_Airline_Seats_per_Departure(isnan(Aircraft_Airline_Seats_per_Departure)) = 0;
Aircraft_Airline_APTLs(isnan(Aircraft_Airline_APTLs)) = 0;

% -------------------------- From the P5_2 Data -------------------------- %
Days_Assigned = P5_2{:,48};
Fuel_Consumed = P5_2{:,49};
% Aircraft Operating Cost breakdown, using the categorization from Table 4-3 of
% https://www.faa.gov/sites/faa.gov/files/regulations_policies/policy_guidance/benefit_cost/econ-value-section-4-op-costs.pdf
P5_2_Data = P5_2{:,1:52}; P5_2_Data(isnan(P5_2_Data) == 1) = 0;
Fuel_Vec = [7,8,15]; Fuel_Costs = sum(P5_2_Data(:,Fuel_Vec),2);
Maintenance_Vec = [18,19,20,21,22,23,24,25,26,27,28]; Maintenance_Costs = sum(P5_2_Data(:,Maintenance_Vec),2);
Crew_Vec = [1,2,3,4,12,14]; Crew_Costs = sum(P5_2_Data(:,Crew_Vec),2);
Ownership_Vec = [6,11,9,30,32,33,34,35,36,37,39,40]; Ownership_Costs = sum(P5_2_Data(:,Ownership_Vec),2);
Other_Vec = [5,10,13,16]; Other_Costs = sum(P5_2_Data(:,Other_Vec),2);

% Processed Aircraft/Airline datasets
Aircraft_Airline_Days_Assigned = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Days Assigned
Aircraft_Airline_Fuel_Consumed = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Fuel Consumed
Aircraft_Airline_Fuel_Costs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Fuel Costs
Aircraft_Airline_Maintenance_Costs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Maintenance Costs
Aircraft_Airline_Crew_Costs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Crew Costs
Aircraft_Airline_Ownership_Costs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Ownership Costs
Aircraft_Airline_Other_Costs = zeros(n_aircraft+1,n_airlines+1); % Aircraft/Airline Total Other Costs

% Iterating through all entries of P5_2
for k = 1:n_P5_2

    % Finding the airline and aircraft
    Airline = char(P5_2{k,54}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);
    Aircraft = P5_2{k,52}; Aircraft_In = find(Aircraft == AircraftCodes{:,1});

    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0 && isempty(Aircraft_In) == 0
        
        Aircraft_Airline_Days_Assigned(Aircraft_In,Airline_In) = Aircraft_Airline_Days_Assigned(Aircraft_In,Airline_In) + 1000*Days_Assigned(k); % Days
        Aircraft_Airline_Fuel_Consumed(Aircraft_In,Airline_In) = Aircraft_Airline_Fuel_Consumed(Aircraft_In,Airline_In) + 1000*Fuel_Consumed(k); % Gallons
        Aircraft_Airline_Fuel_Costs(Aircraft_In,Airline_In) = Aircraft_Airline_Fuel_Costs(Aircraft_In,Airline_In) + 1000*Fuel_Costs(k); % $Dollars
        Aircraft_Airline_Maintenance_Costs(Aircraft_In,Airline_In) = Aircraft_Airline_Maintenance_Costs(Aircraft_In,Airline_In) + 1000*Maintenance_Costs(k); % $Dollars
        Aircraft_Airline_Crew_Costs(Aircraft_In,Airline_In) = Aircraft_Airline_Crew_Costs(Aircraft_In,Airline_In) + 1000*Crew_Costs(k); % $Dollars
        Aircraft_Airline_Ownership_Costs(Aircraft_In,Airline_In) = Aircraft_Airline_Ownership_Costs(Aircraft_In,Airline_In) + 1000*Ownership_Costs(k); % $Dollars
        Aircraft_Airline_Other_Costs(Aircraft_In,Airline_In) = Aircraft_Airline_Other_Costs(Aircraft_In,Airline_In) + 1000*Other_Costs(k); % $Dollars

    end

    % Displaying progress
    if mod(k,100) == 0
        disp([num2str(round(100*k/n_P5_2,2)),'%'])
    end

end

% Computing the cumulative metrics
Aircraft_Airline_Days_Assigned(end,:) = sum(Aircraft_Airline_Days_Assigned,1); Aircraft_Airline_Days_Assigned(:,end) = sum(Aircraft_Airline_Days_Assigned,2);
Aircraft_Airline_Fuel_Consumed(end,:) = sum(Aircraft_Airline_Fuel_Consumed,1); Aircraft_Airline_Fuel_Consumed(:,end) = sum(Aircraft_Airline_Fuel_Consumed,2);
Aircraft_Airline_Fuel_Costs(end,:) = sum(Aircraft_Airline_Fuel_Costs,1); Aircraft_Airline_Fuel_Costs(:,end) = sum(Aircraft_Airline_Fuel_Costs,2);
Aircraft_Airline_Maintenance_Costs(end,:) = sum(Aircraft_Airline_Maintenance_Costs,1); Aircraft_Airline_Maintenance_Costs(:,end) = sum(Aircraft_Airline_Maintenance_Costs,2);
Aircraft_Airline_Crew_Costs(end,:) = sum(Aircraft_Airline_Crew_Costs,1); Aircraft_Airline_Crew_Costs(:,end) = sum(Aircraft_Airline_Crew_Costs,2);
Aircraft_Airline_Ownership_Costs(end,:) = sum(Aircraft_Airline_Ownership_Costs,1); Aircraft_Airline_Ownership_Costs(:,end) = sum(Aircraft_Airline_Ownership_Costs,2);
Aircraft_Airline_Other_Costs(end,:) = sum(Aircraft_Airline_Other_Costs,1); Aircraft_Airline_Other_Costs(:,end) = sum(Aircraft_Airline_Other_Costs,2);
Aircraft_Airline_AOC = Aircraft_Airline_Fuel_Costs + Aircraft_Airline_Maintenance_Costs + Aircraft_Airline_Crew_Costs + Aircraft_Airline_Ownership_Costs + Aircraft_Airline_Other_Costs;

% Eliminating NaN entries
Aircraft_Airline_Days_Assigned(isnan(Aircraft_Airline_Days_Assigned)) = 0;
Aircraft_Airline_Fuel_Consumed(isnan(Aircraft_Airline_Fuel_Consumed)) = 0;
Aircraft_Airline_Fuel_Costs(isnan(Aircraft_Airline_Fuel_Costs)) = 0;
Aircraft_Airline_Maintenance_Costs(isnan(Aircraft_Airline_Maintenance_Costs)) = 0;
Aircraft_Airline_Crew_Costs(isnan(Aircraft_Airline_Crew_Costs)) = 0;
Aircraft_Airline_Ownership_Costs(isnan(Aircraft_Airline_Ownership_Costs)) = 0;
Aircraft_Airline_Other_Costs(isnan(Aircraft_Airline_Other_Costs)) = 0;
Aircraft_Airline_AOC(isnan(Aircraft_Airline_AOC)) = 0;

% ------------------- From the T100 Data and P5_2 Data ------------------- %
Aircraft_Airline_Departures_per_Day = round(Aircraft_Airline_Departures./Aircraft_Airline_Days_Assigned,2); % Departures / Days Assigned
Aircraft_Airline_ASMs_per_Day = round(Aircraft_Airline_ASMs./Aircraft_Airline_Days_Assigned); % Departures / Days Assigned
Aircraft_Airline_Block_Hours_per_Day = round(Aircraft_Airline_Block_Hours./Aircraft_Airline_Days_Assigned,2); % Block Hours / Days Assigned
Aircraft_Airline_AOC_per_Block_Hours = round(Aircraft_Airline_AOC./Aircraft_Airline_Block_Hours,2); % AOC / Block Hours
Aircraft_Airline_AOC_per_ASMs = round(Aircraft_Airline_AOC./Aircraft_Airline_ASMs,3); % AOC / ASMs
Aircraft_Airline_AOC_per_Seat_Hours = round(Aircraft_Airline_AOC./Aircraft_Airline_Seat_Hours,2); % AOC / Seat Hours
Aircraft_Airline_Fuel_Consumed_per_ASMs = round(Aircraft_Airline_Fuel_Consumed./Aircraft_Airline_ASMs,3); % Fuel Consumed / ASMs
Aircraft_Airline_Fuel_Consumed_per_Distance = round(Aircraft_Airline_Fuel_Consumed./Aircraft_Airline_Distance_Flown,2); % Fuel Consumed / Total Distance

% Eliminating NaN entries
Aircraft_Airline_Departures_per_Day(isnan(Aircraft_Airline_Departures_per_Day)) = 0;
Aircraft_Airline_ASMs_per_Day(isnan(Aircraft_Airline_ASMs_per_Day)) = 0;
Aircraft_Airline_Block_Hours_per_Day(isnan(Aircraft_Airline_Block_Hours_per_Day)) = 0;
Aircraft_Airline_AOC_per_Block_Hours(isnan(Aircraft_Airline_AOC_per_Block_Hours)) = 0;
Aircraft_Airline_AOC_per_ASMs(isnan(Aircraft_Airline_AOC_per_ASMs)) = 0;
Aircraft_Airline_AOC_per_Seat_Hours(isnan(Aircraft_Airline_AOC_per_Seat_Hours)) = 0;
Aircraft_Airline_Fuel_Consumed_per_ASMs(isnan(Aircraft_Airline_Fuel_Consumed_per_ASMs)) = 0;
Aircraft_Airline_Fuel_Consumed_per_Distance(isnan(Aircraft_Airline_Fuel_Consumed_per_Distance)) = 0;

% Eliminating Inf entries
Aircraft_Airline_Departures_per_Day(isinf(Aircraft_Airline_Departures_per_Day)) = 0;
Aircraft_Airline_ASMs_per_Day(isinf(Aircraft_Airline_ASMs_per_Day)) = 0;
Aircraft_Airline_Block_Hours_per_Day(isinf(Aircraft_Airline_Block_Hours_per_Day)) = 0;
Aircraft_Airline_AOC_per_Block_Hours(isinf(Aircraft_Airline_AOC_per_Block_Hours)) = 0;
Aircraft_Airline_AOC_per_ASMs(isinf(Aircraft_Airline_AOC_per_ASMs)) = 0;
Aircraft_Airline_AOC_per_Seat_Hours(isinf(Aircraft_Airline_AOC_per_Seat_Hours)) = 0;
Aircraft_Airline_Fuel_Consumed_per_ASMs(isinf(Aircraft_Airline_Fuel_Consumed_per_ASMs)) = 0;
Aircraft_Airline_Fuel_Consumed_per_Distance(isinf(Aircraft_Airline_Fuel_Consumed_per_Distance)) = 0;



% Creating the aggregated tables for each airline and aircraft
Aircraft_Aggregated = [Aircraft_Airline_RPMs(:,Desired_Airline_In),... % (1)
                       Aircraft_Airline_ASMs(:,Desired_Airline_In),... % (2)
                       Aircraft_Airline_ASMs_per_Day(:,Desired_Airline_In),... % (6)
                       Aircraft_Airline_Seats_per_Departure(:,Desired_Airline_In),... % (8)
                       Aircraft_Airline_Departures(:,Desired_Airline_In),... % (4)
                       Aircraft_Airline_Departures_per_Day(:,Desired_Airline_In),... % (5)
                       Aircraft_Airline_Block_Hours_per_Day(:,Desired_Airline_In),... % (7)
                       Aircraft_Airline_LFs(:,Desired_Airline_In),... % (3)
                       Aircraft_Airline_ASLs(:,Desired_Airline_In),... % (9)
                       Aircraft_Airline_AOC_per_Block_Hours(:,Desired_Airline_In),... % (12)
                       Aircraft_Airline_AOC_per_Seat_Hours(:,Desired_Airline_In),... % (13)
                       Aircraft_Airline_AOC_per_ASMs(:,Desired_Airline_In)]; % (14)

Airline_Aggregated = [Aircraft_Airline_RPMs(Desired_Aircraft_In,:)',... % (1)
                       Aircraft_Airline_ASMs(Desired_Aircraft_In,:)',... % (2)
                       Aircraft_Airline_ASMs_per_Day(Desired_Aircraft_In,:)',... % (6)
                       Aircraft_Airline_Seats_per_Departure(Desired_Aircraft_In,:)',... % (8)
                       Aircraft_Airline_Departures(Desired_Aircraft_In,:)',... % (4)
                       Aircraft_Airline_Departures_per_Day(Desired_Aircraft_In,:)',... % (5)
                       Aircraft_Airline_Block_Hours_per_Day(Desired_Aircraft_In,:)',... % (7)
                       Aircraft_Airline_LFs(Desired_Aircraft_In,:)',... % (3)
                       Aircraft_Airline_ASLs(Desired_Aircraft_In,:)',... % (9)
                       Aircraft_Airline_AOC_per_Block_Hours(Desired_Aircraft_In,:)',... % (12)
                       Aircraft_Airline_AOC_per_Seat_Hours(Desired_Aircraft_In,:)',... % (13)
                       Aircraft_Airline_AOC_per_ASMs(Desired_Aircraft_In,:)']; % (14)

% Additional Datasets (Non-Output)
Aircraft_Aggregated_v2 = [Aircraft_Airline_Seats_per_Departure(:,Desired_Airline_In),... % (8)
                          Aircraft_Airline_AOC_per_Block_Hours(:,Desired_Airline_In),... % (12)
                          Aircraft_Airline_AOC_per_Seat_Hours(:,Desired_Airline_In),... % (13)
                          Aircraft_Airline_AOC_per_ASMs(:,Desired_Airline_In),... % (14)
                          Aircraft_Airline_ASLs(:,Desired_Airline_In),... % (9)
                          Aircraft_Airline_Block_Hours_per_Day(:,Desired_Airline_In)]; % (7)

Airline_Aggregated_v2 = [Aircraft_Airline_Crew_Costs(Desired_Aircraft_In,:)'./Aircraft_Airline_Block_Hours(Desired_Aircraft_In,:)',... % (17)
                         Aircraft_Airline_Fuel_Costs(Desired_Aircraft_In,:)'./Aircraft_Airline_Block_Hours(Desired_Aircraft_In,:)',... % (15) 
                         Aircraft_Airline_Maintenance_Costs(Desired_Aircraft_In,:)'./Aircraft_Airline_Block_Hours(Desired_Aircraft_In,:)',... % (16)
                         Aircraft_Airline_Ownership_Costs(Desired_Aircraft_In,:)'./Aircraft_Airline_Block_Hours(Desired_Aircraft_In,:)',... % (18)
                         Aircraft_Airline_Other_Costs(Desired_Aircraft_In,:)'./Aircraft_Airline_Block_Hours(Desired_Aircraft_In,:)',... % (19)
                         Aircraft_Airline_AOC(Desired_Aircraft_In,:)'./Aircraft_Airline_Block_Hours(Desired_Aircraft_In,:)'];
Airline_Aggregated_v2(isnan(Airline_Aggregated_v2)) = 0; 

Airline_Aggregated_v3 = [Aircraft_Airline_ASLs(Desired_Aircraft_In,:)',... % (9)
                         Aircraft_Airline_Seats_per_Departure(Desired_Aircraft_In,:)',... % (8)
                         Aircraft_Airline_Departures_per_Day(Desired_Aircraft_In,:)',... % (5)
                         Aircraft_Airline_Block_Hours_per_Day(Desired_Aircraft_In,:)',... % (7)
                         Aircraft_Airline_ASMs_per_Day(Desired_Aircraft_In,:)',... % (6)
                         Aircraft_Airline_AOC_per_Block_Hours(Desired_Aircraft_In,:)',... % (12)
                         Aircraft_Airline_AOC_per_Seat_Hours(Desired_Aircraft_In,:)',... % (13)
                         Aircraft_Airline_AOC_per_ASMs(Desired_Aircraft_In,:)']; % (14)

%% ----------------- Step 3: Creating the output tables ----------------- %

% Creating the table labels
airline_names = [AirlineCodes{:,2};'All Airlines'];
aircraft_names = [AircraftCodes{:,2};'All Aircraft'];
aggregated_names = {'RPMs';'ASMs';'ASMs per Day';'Seats per Departure';'Departures';'Departures per Day';...
                    'Block Hours per Day';'LFs';'ASLs';'AOC per Block Hours';'AOC per Seat Hours';'AOC per ASMs'};

% Overview Tables
RPMs_Table = array2table(Aircraft_Airline_RPMs); % Aircraft/Airline Total RPMs (1)
RPMs_Table.Properties.VariableNames = airline_names; RPMs_Table.Properties.RowNames = aircraft_names;
ASMs_Table = array2table(Aircraft_Airline_ASMs); % Aircraft/Airline Total ASMs (2)
ASMs_Table.Properties.VariableNames = airline_names; ASMs_Table.Properties.RowNames = aircraft_names;
Passengers_Table = array2table(Aircraft_Airline_Passengers); % Aircraft/Airline Total Passengers (3)
Passengers_Table.Properties.VariableNames = airline_names; Passengers_Table.Properties.RowNames = aircraft_names;
Seats_Table = array2table(Aircraft_Airline_Seats); % Aircraft/Airline Total Seats (4)
Seats_Table.Properties.VariableNames = airline_names; Seats_Table.Properties.RowNames = aircraft_names;
LFs_Table = array2table(Aircraft_Airline_LFs); % Aircraft/Airline Total LFs (5)
LFs_Table.Properties.VariableNames = airline_names; LFs_Table.Properties.RowNames = aircraft_names;
Departures_Table = array2table(Aircraft_Airline_Departures); % Aircraft/Airline Total Departures (6)
Departures_Table.Properties.VariableNames = airline_names; Departures_Table.Properties.RowNames = aircraft_names;

% Utilization Metrics Tables
Departures_per_Day_Table = array2table(Aircraft_Airline_Departures_per_Day); % Aircraft/Airline Departures per Day (7)
Departures_per_Day_Table.Properties.VariableNames = airline_names; Departures_per_Day_Table.Properties.RowNames = aircraft_names;
ASMs_per_Day_Table = array2table(Aircraft_Airline_ASMs_per_Day); % Aircraft/Airline ASMs per Day (8)
ASMs_per_Day_Table.Properties.VariableNames = airline_names; ASMs_per_Day_Table.Properties.RowNames = aircraft_names;
Block_Hours_per_Day_Table = array2table(Aircraft_Airline_Block_Hours_per_Day); % Aircraft/Airline Block Hours per Day (9)
Block_Hours_per_Day_Table.Properties.VariableNames = airline_names; Block_Hours_per_Day_Table.Properties.RowNames = aircraft_names;
Seats_per_Departure_Table = array2table(Aircraft_Airline_Seats_per_Departure); % Aircraft/Airline Total Block Hours (10)
Seats_per_Departure_Table.Properties.VariableNames = airline_names; Seats_per_Departure_Table.Properties.RowNames = aircraft_names;
ASLs_Table = array2table(round(Aircraft_Airline_ASLs)); % Aircraft/Airline Average Stage Lengths (11)
ASLs_Table.Properties.VariableNames = airline_names; ASLs_Table.Properties.RowNames = aircraft_names;
APTLs_Table = array2table(round(Aircraft_Airline_APTLs)); % Aircraft/Airline Average Passenger Trip Lenghts (12)
APTLs_Table.Properties.VariableNames = airline_names; APTLs_Table.Properties.RowNames = aircraft_names;

% Fuel Consumption Tables
Fuel_Consumed_per_ASMs_Table = array2table(Aircraft_Airline_Fuel_Consumed_per_ASMs); % Aircraft/Airline Fuel Consumed per ASMs (13)
Fuel_Consumed_per_ASMs_Table.Properties.VariableNames = airline_names; Fuel_Consumed_per_ASMs_Table.Properties.RowNames = aircraft_names;
Fuel_Consumed_per_Distance_Table = array2table(Aircraft_Airline_Fuel_Consumed_per_Distance); % Aircraft/Airline Fuel Consumed per Distance (14)
Fuel_Consumed_per_Distance_Table.Properties.VariableNames = airline_names; Fuel_Consumed_per_Distance_Table.Properties.RowNames = aircraft_names;

% Aircraft Operating Cost Tables 
AOC_per_Block_Hours_Table = array2table(Aircraft_Airline_AOC_per_Block_Hours); % Aircraft/Airline AOC per Block Hours (15)
AOC_per_Block_Hours_Table.Properties.VariableNames = airline_names; AOC_per_Block_Hours_Table.Properties.RowNames = aircraft_names;
AOC_per_Seat_Hour_Table = array2table(Aircraft_Airline_AOC_per_Seat_Hours); % Aircraft/Airline AOC per Seat Hours (16)
AOC_per_Seat_Hour_Table.Properties.VariableNames = airline_names; AOC_per_Seat_Hour_Table.Properties.RowNames = aircraft_names;
AOC_per_ASMs_Table = array2table(Aircraft_Airline_AOC_per_ASMs); % Aircraft/Airline AOC per ASMs (17)
AOC_per_ASMs_Table.Properties.VariableNames = airline_names; AOC_per_ASMs_Table.Properties.RowNames = aircraft_names;
Fuel_Costs_Table = array2table(round(Aircraft_Airline_Fuel_Costs)); % Aircraft/Airline Fuel Costs (18)
Fuel_Costs_Table.Properties.VariableNames = airline_names; Fuel_Costs_Table.Properties.RowNames = aircraft_names;
Maintenance_Costs_Table = array2table(round(Aircraft_Airline_Maintenance_Costs)); % Aircraft/Airline Maintenance Costs (19)
Maintenance_Costs_Table.Properties.VariableNames = airline_names; Maintenance_Costs_Table.Properties.RowNames = aircraft_names;
Crew_Costs_Table = array2table(round(Aircraft_Airline_Crew_Costs)); % Aircraft/Airline Crew Costs (20)
Crew_Costs_Table.Properties.VariableNames = airline_names; Crew_Costs_Table.Properties.RowNames = aircraft_names;
Ownership_Costs_Table = array2table(round(Aircraft_Airline_Ownership_Costs)); % Aircraft/Airline Ownership Costs (21)
Ownership_Costs_Table.Properties.VariableNames = airline_names; Ownership_Costs_Table.Properties.RowNames = aircraft_names;
Other_Costs_Table = array2table(round(Aircraft_Airline_Other_Costs)); % Aircraft/Airline Other Costs (22)
Other_Costs_Table.Properties.VariableNames = airline_names; Other_Costs_Table.Properties.RowNames = aircraft_names;

% Miscellaneous Tables
Block_Hours_Table = array2table(round(Aircraft_Airline_Block_Hours)); % Aircraft/Airline Total Block Hours (23)
Block_Hours_Table.Properties.VariableNames = airline_names; Block_Hours_Table.Properties.RowNames = aircraft_names;
Distance_Flown_Table = array2table(round(Aircraft_Airline_Distance_Flown)); % Aircraft/Airline Total Distance Flown (24)
Distance_Flown_Table.Properties.VariableNames = airline_names; Distance_Flown_Table.Properties.RowNames = aircraft_names;
Days_Assigned_Table = array2table(round(Aircraft_Airline_Days_Assigned)); % Aircraft/Airline Total Days Assigned (25)
Days_Assigned_Table.Properties.VariableNames = airline_names; Days_Assigned_Table.Properties.RowNames = aircraft_names;

% Aggregated Tables
Aircraft_Table = array2table(Aircraft_Aggregated); % Aircraft Cumulative Statistics (26)
Aircraft_Table.Properties.VariableNames = aggregated_names; Aircraft_Table.Properties.RowNames = aircraft_names;
Aircraft_Table = Aircraft_Table(find(Aircraft_Table{:,1} > 0),:); % Non-zero entries
Airline_Table = array2table(Airline_Aggregated); % Airline Cumulative Statistics (27)
Airline_Table.Properties.VariableNames = aggregated_names; Airline_Table.Properties.RowNames = airline_names;
Airline_Table = Airline_Table(find(Airline_Table{:,1} > 0),:); % Non-zero entries

% Aggregated Tables - V2 (Non-Output Tables)
Aircraft_Table_v2 = array2table(Aircraft_Aggregated_v2); % Aircraft Cumulative Statistics - V2
Aircraft_Table_v2.Properties.VariableNames = {'Seats per Departure';'AOC per Block Hours';'AOC per Seat Hours';'AOC per ASMs';'ASLs';'Block Hours per Day'};
Aircraft_Table_v2.Properties.RowNames = aircraft_names;
Aircraft_Table_v2 = Aircraft_Table(find(Aircraft_Table{:,1} > 0),:); % Non-zero entries
Airline_Table_v2 = array2table(Airline_Aggregated_v2); % Airline Cumulative Statistics - V2
Airline_Table_v2.Properties.VariableNames = {'Crew Costs';'Fuel Costs';'Maintenance Costs';'Ownership Costs';'Other Costs';'Total AOC'}; 
Airline_Table_v2.Properties.RowNames = airline_names;
Airline_Table_v2 = Airline_Table_v2(find(Airline_Table_v2{:,1} > 0),:); % Non-zero entries
Airline_Table_v3 = array2table(Airline_Aggregated_v3); % Airline Cumulative Statistics - V3
Airline_Table_v3.Properties.VariableNames = {'ASLs';'Seats per Departure';'Departures per Day';'Block Hours per Day';'ASMs per Day';'AOC per Block Hours';'AOC per Seat Hours';'AOC per ASMs'}; 
Airline_Table_v3.Properties.RowNames = airline_names;
Airline_Table_v3 = Airline_Table_v3(find(Airline_Table_v3{:,1} > 0),:); % Non-zero entries

% Saving the output tables
if sum(Save_Tables == 1) > 0, writetable(RPMs_Table,['RPMs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (1)
if sum(Save_Tables == 2) > 0, writetable(ASMs_Table,['ASMs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (2)
if sum(Save_Tables == 3) > 0, writetable(Passengers_Table,['Passengers_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (3)
if sum(Save_Tables == 4) > 0, writetable(Seats_Table,['Seats_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (4)
if sum(Save_Tables == 5) > 0, writetable(LFs_Table,['LFs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (5)
if sum(Save_Tables == 6) > 0, writetable(Departures_Table,['Departures_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (6)

if sum(Save_Tables == 7) > 0, writetable(Departures_per_Day_Table,['Departures_per_Day_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (7)
if sum(Save_Tables == 8) > 0, writetable(ASMs_per_Day_Table,['ASMs_per_Day_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (8)
if sum(Save_Tables == 9) > 0, writetable(Block_Hours_per_Day_Table,['Block_Hours_per_Day_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (9)
if sum(Save_Tables == 10) > 0, writetable(Seats_per_Departure_Table,['Seats_per_Departures_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (10)
if sum(Save_Tables == 11) > 0, writetable(ASLs_Table,['ASL_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (11)
if sum(Save_Tables == 12) > 0, writetable(APTLs_Table,['APTL_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (12)

if sum(Save_Tables == 13) > 0, writetable(Fuel_Consumed_per_ASMs_Table,['Fuel_Consumed_per_ASMs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (13)
if sum(Save_Tables == 14) > 0, writetable(Fuel_Consumed_per_Distance_Table,['Fuel_Consumed_per_Distance_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (14)

if sum(Save_Tables == 15) > 0, writetable(AOC_per_Block_Hours_Table,['AOC_per_Block_Hours_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (15)
if sum(Save_Tables == 16) > 0, writetable(AOC_per_Seat_Hour_Table,['AOC_per_Seat_Hour_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (16)
if sum(Save_Tables == 17) > 0, writetable(AOC_per_ASMs_Table,['AOC_per_ASMs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (17)
if sum(Save_Tables == 18) > 0, writetable(Fuel_Costs_Table,['Fuel_Costs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (18)
if sum(Save_Tables == 19) > 0, writetable(Maintenance_Costs_Table,['Maintenance_Costs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (19)
if sum(Save_Tables == 20) > 0, writetable(Crew_Costs_Table,['Crew_Costs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (20)
if sum(Save_Tables == 21) > 0, writetable(Ownership_Costs_Table,['Ownership_Costs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (21)
if sum(Save_Tables == 22) > 0, writetable(Other_Costs_Table,['Other_Costs_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (22)

if sum(Save_Tables == 23) > 0, writetable(Block_Hours_Table,['Block_Hours_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (23)
if sum(Save_Tables == 24) > 0, writetable(Distance_Flown_Table,['Distance_Flown_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (24)
if sum(Save_Tables == 25) > 0, writetable(Days_Assigned_Table,['Days_Assigned_by_Aircraft_and_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (25)

if sum(Save_Tables == 26) > 0, writetable(Aircraft_Table,table_name_aircraft,'Sheet',1,'WriteRowNames',true), end % (26)
if sum(Save_Tables == 27) > 0, writetable(Airline_Table,table_name_airline,'Sheet',1,'WriteRowNames',true), end % (27)