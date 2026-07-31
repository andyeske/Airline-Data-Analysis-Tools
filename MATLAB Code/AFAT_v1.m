% ----------------------------------------------------------------------- %
% ------------- AIRLINE FINANCIAL ANALYSIS TOOL (AFAT) - v1 ------------- %
% ----------------------------------------------------------------------- %

% The following tool (AFAT) can be used to compute a variety of financial
% metrics for different airlines in the US airline industry. AFAT leverages 
% open-source data from the US Bureau of Transportation Statistics (BTS), 
% namely the Form 41 Traffic - T-100 Segment (US Carriers Only) dataset, 
% as well as the Form 41 Financial - Schedule P-6 (Cost), 
% Schedule P-1.2 (Revenue), and Schedule P-10 (Employees) datasets. 
% Before using AFAT, please make sure to follow the instructions outlined 
% in: https://github.com/andyeske/Airline-Data-Analysis-Tools

% AFAT outputs a total of 17 tables, which include:

% Cost Tables:
% (1) Unnormalized Decomposed Administrative Cost (USD$): Administrative_Cost_by_Airline.xlsx
% (2) Decomposed Administrative Cost per Available Seat Miles (USD$/ASM): Administrative_CASM_by_Airline.xlsx
% (3) Decomposed Administrative Cost per Seat (USD$): Administrative_Cost_per_Seat_by_Airline.xlsx
% (4) Decomposed Administrative Cost per Revenue Passenger Miles (USD$/RPM): Administrative_Cost_per_RPM_by_Airline.xlsx
% (5) Decomposed Administrative Cost per Passenger (USD$): Administrative_Cost_per_Passenger_by_Airline.xlsx

% Revenue Tables:
% (6) Unnormalized Decomposed Revenue (USD$): Revenue_by_Airline.xlsx
% (7) Decomposed Revenue per Available Seat Miles (USD$/ASM): RASM_by_Airline.xlsx
% (8) Decomposed Revenue per Seat (USD$): Revenue_per_Seat_by_Airline.xlsx
% (9) Decomposed Revenue per Revenue Passenger Miles (USD$/RPM): Yield_by_Airline.xlsx
% (10) Decomposed Revenue per Passenger (USD$): Revenue_per_Passenger_by_Airline.xlsx

% Employee Tables:
% (11) Employee Breakdown: Employees_by_Airline.xlsx
% (12) Available Seat Miles per Employee (ASMs): ASMs_per_Employee_by_Airline.xlsx
% (13) Labor Cost per Employee (USD$): Labor_Cost_per_Employee_by_Airline.xlsx
% (14) Revenue per Employee (USD$): Revenue_per_Employee_by_Airline.xlsx
% (15) Available Seat Miles per Labor Cost (ASMs/USD$): ASMs_per_Labor_Cost_by_Airline.xlsx

% Aggregated Tables:
% (16) Airline Cumulative Financial Statistics: Airline_Cumulative_Financial_Statistics.xlsx
% (17) Airline Profitability Statistics: Airline_Profitability_Statistics.xlsx

% Table (16) contains a summary of (1) - (15), focusing on the total Cost
% (excl. transport-related expenses) and total Revenue (excl. transport-
% related expenses too).
% Table (17) computes the unnormalized profitability of an airline (excl. transport-
% related Cost and Revenue), and normalized by ASMs, seats, RPMs, and
% passengers.

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% Please select the desired table indeces to save:
Save_Tables = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];

% Notes:
% a) Writing [] in Save_Tables will not save any tables.
% b) AFAT can be easily modified to produce more outputs than (1) - (17).

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the datasets
T100 = readtable('T100 Data.csv'); 
P6 = readtable('P6 Data.csv');
P1_2 = readtable('P1.2 Data.csv');
P10 = readtable('P10 Data.csv');
AirlineCodes = readtable('Airline Codes.xlsx');

% Extracting dataset statistics
n_airlines = length(AirlineCodes{:,1});
n_P6 = length(P6{:,1});
n_P1_2 = length(P1_2{:,1});
n_P10 = length(P10{:,1});
year = T100{1,10};

% Eliminating unnecessary entries on T100
T100 = T100(find(T100{:,1} > 0),:); % Non-zero departures
T100 = T100(find(T100{:,2} > 0),:); % Non-zero seats
T100 = T100(find(T100{:,4} > 0),:); % Non-zero distance
n_T100 = length(T100{:,1});


%% ------------------- Step 2: Computing the metrics -------------------- %

% ------------------------- From the T100 Data -------------------------- %
ASMs = T100{:,2}.*T100{:,4}; % Seats * Distance
RPMs = T100{:,3}.*T100{:,4}; % Passengers * Distance

% Processed Airline datasets
Airline_RPMs = zeros(n_airlines+1,1); % Aircraft/Airline Total RPMs
Airline_ASMs = zeros(n_airlines+1,1); % Aircraft/Airline Total ASMs
Airline_Passengers = zeros(n_airlines+1,1); % Aircraft/Airline Total Passengers
Airline_Seats = zeros(n_airlines+1,1); % Aircraft/Airline Total Seats

% Iterating through all entries of T100
for k = 1:n_T100

    % Finding the airline and aircraft
    Airline = char(T100{k,6}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);

    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0
        
        Airline_RPMs(Airline_In,1) = Airline_RPMs(Airline_In,1) + RPMs(k); % RPMs
        Airline_ASMs(Airline_In,1) = Airline_ASMs(Airline_In,1) + ASMs(k); % ASMs
        Airline_Passengers(Airline_In,1) = Airline_Passengers(Airline_In,1) + T100{k,3}; % Passengers
        Airline_Seats(Airline_In,1) = Airline_Seats(Airline_In,1) + T100{k,2}; % Seats

    end

    % Displaying progress
    if mod(k,1000) == 0
        disp([num2str(round(100*k/n_T100,2)),'%'])
    end

end

% Computing the cumulative metrics
Airline_RPMs(end,1) = sum(Airline_RPMs); 
Airline_ASMs(end,1) = sum(Airline_ASMs); 
Airline_Passengers(end,1) = sum(Airline_Passengers);
Airline_Seats(end,1) = sum(Airline_Seats); 

% Eliminating NaN entries
Airline_RPMs(isnan(Airline_RPMs)) = 0;
Airline_ASMs(isnan(Airline_ASMs)) = 0;
Airline_Passengers(isnan(Airline_Passengers)) = 0;
Airline_Seats(isnan(Airline_Seats)) = 0;


% -------------------------- From the P1_2 Data -------------------------- %

% Processed Airline datasets
Airline_Unnormalized_Revenue = zeros(n_airlines+1,12); % Airline Unnormalized Decomposed Revenue
Airline_Revenue_per_ASM = zeros(n_airlines+1,12); % Airline Decomposed Revenue per Available Seat Miles
Airline_Revenue_per_Seat = zeros(n_airlines+1,12); % Airline Decomposed Revenue per Seat
Airline_Revenue_per_RPM = zeros(n_airlines+1,12); % Airline Decomposed Revenue per Revenue Passenger Miles
Airline_Revenue_per_Passenger = zeros(n_airlines+1,12); % Airline Decomposed Revenue per Passenger

% Iterating through all entries of P1_2
for k = 1:n_P1_2

    % Finding the airline and aircraft
    Airline = char(P1_2{k,12}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);

    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0 
        
        P1_2_vector = P1_2{k,1:11}*1000; P1_2_vector(isnan(P1_2_vector)) = 0;
        Airline_Unnormalized_Revenue(Airline_In,1:10) = Airline_Unnormalized_Revenue(Airline_In,1:10) + P1_2_vector(1:10);
        Airline_Unnormalized_Revenue(Airline_In,12) = Airline_Unnormalized_Revenue(Airline_In,12) + P1_2_vector(11);
        
    end

    % Displaying progress
    if mod(k,100) == 0
        disp([num2str(round(100*k/n_P1_2,2)),'%'])
    end

end

% Computing the cumulative metrics
Airline_Unnormalized_Revenue(end,:) = sum(Airline_Unnormalized_Revenue,1); 
Airline_Unnormalized_Revenue(:,11) = Airline_Unnormalized_Revenue(:,12) - Airline_Unnormalized_Revenue(:,10); % Excluding transport-related

% Computing the normalized metrics
for k = 1:12
    Airline_Revenue_per_ASM(:,k) = round(Airline_Unnormalized_Revenue(:,k)./Airline_ASMs,4);
    Airline_Revenue_per_Seat(:,k) = round(Airline_Unnormalized_Revenue(:,k)./Airline_Seats,2);
    Airline_Revenue_per_RPM(:,k) = round(Airline_Unnormalized_Revenue(:,k)./Airline_RPMs,4);
    Airline_Revenue_per_Passenger(:,k) =round(Airline_Unnormalized_Revenue(:,k)./Airline_Passengers,2);
end

% Eliminating NaN entries
Airline_Revenue_per_ASM(isnan(Airline_Revenue_per_ASM)) = 0;
Airline_Revenue_per_Seat(isnan(Airline_Revenue_per_Seat)) = 0;
Airline_Revenue_per_RPM(isnan(Airline_Revenue_per_RPM)) = 0;
Airline_Revenue_per_Passenger(isnan(Airline_Revenue_per_Passenger)) = 0;


% -------------------------- From the P6 Data -------------------------- %

% Processed Airline datasets
Airline_Unnormalized_Cost = zeros(n_airlines+1,12); % Airline Unnormalized Decomposed Administrative Cost
Airline_Cost_per_ASM = zeros(n_airlines+1,12); % Airline Decomposed Administrative Cost per Available Seat Miles
Airline_Cost_per_Seat = zeros(n_airlines+1,12); % Airline Decomposed Administrative Cost per Seat
Airline_Cost_per_RPM = zeros(n_airlines+1,12); % Airline Decomposed Administrative Cost per Revenue Passenger Miles
Airline_Cost_per_Passenger = zeros(n_airlines+1,12); % Airline Decomposed Administrative Cost per Passenger

% Iterating through all entries of P6
for k = 1:n_P6

    % Finding the airline and aircraft
    Airline = char(P6{k,12}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);

    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0 
        
        P6_vector = P6{k,1:11}*1000; P6_vector(isnan(P6_vector)) = 0;
        Airline_Unnormalized_Cost(Airline_In,1:10) = Airline_Unnormalized_Cost(Airline_In,1:10) + P6_vector(1:10);        
        Airline_Unnormalized_Cost(Airline_In,12) = Airline_Unnormalized_Cost(Airline_In,12) + P6_vector(11);
        
    end

    % Displaying progress
    if mod(k,100) == 0
        disp([num2str(round(100*k/n_P1_2,2)),'%'])
    end

end

% Computing the cumulative metrics
Airline_Unnormalized_Cost(end,:) = sum(Airline_Unnormalized_Cost,1); 
Airline_Unnormalized_Cost(:,3) = Airline_Unnormalized_Cost(:,3) - Airline_Unnormalized_Cost(:,2); % Subtracting Fuels from Materials
Airline_Unnormalized_Cost(:,11) = Airline_Unnormalized_Cost(:,12) - Airline_Unnormalized_Cost(:,10); % Excluding transport-related

% Computing the normalized metrics
for k = 1:12
    Airline_Cost_per_ASM(:,k) = round(Airline_Unnormalized_Cost(:,k)./Airline_ASMs,4);
    Airline_Cost_per_Seat(:,k) = round(Airline_Unnormalized_Cost(:,k)./Airline_Seats,2);
    Airline_Cost_per_RPM(:,k) = round(Airline_Unnormalized_Cost(:,k)./Airline_RPMs,4);
    Airline_Cost_per_Passenger(:,k) =round(Airline_Unnormalized_Cost(:,k)./Airline_Passengers,2);
end

% Eliminating NaN entries
Airline_Cost_per_ASM(isnan(Airline_Cost_per_ASM)) = 0;
Airline_Cost_per_Seat(isnan(Airline_Cost_per_Seat)) = 0;
Airline_Cost_per_RPM(isnan(Airline_Cost_per_RPM)) = 0;
Airline_Cost_per_Passenger(isnan(Airline_Cost_per_Passenger)) = 0;


% -------------------------- From the P10 Data -------------------------- %

% Processed Airline datasets
Airline_Employee_Breakdown = zeros(n_airlines+1,17); % Airline Employee Breakdown
ASMs_per_Employee = zeros(n_airlines+1,1); % Available Seat Miles per Employee
Labor_Cost_per_Employee = zeros(n_airlines+1,12); % Labor Cost per Employee
Revenue_per_Employee = zeros(n_airlines+1,12); % Revenue per Employee
ASMs_per_Labor_Cost = zeros(n_airlines+1,12); % Available Seat Miles per Labor Cost

% Iterating through all entries of P6
for k = 1:n_P10

    % Finding the airline and aircraft
    Airline = char(P10{k,3}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);

    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0 
        
        P10_vector = P10{k,8:23}; P10_vector(isnan(P10_vector)) = 0;
        Airline_Employee_Breakdown(Airline_In,1:15) = Airline_Employee_Breakdown(Airline_In,1:15) + P10_vector(1:15);        
        Airline_Employee_Breakdown(Airline_In,17) = Airline_Employee_Breakdown(Airline_In,17) + P10_vector(16);
        
    end

    % Displaying progress
    if mod(k,100) == 0
        disp([num2str(round(100*k/n_P1_2,2)),'%'])
    end

end

% Computing the cumulative metrics
Airline_Employee_Breakdown(end,:) = sum(Airline_Employee_Breakdown,1); 
Airline_Employee_Breakdown(:,16) = Airline_Employee_Breakdown(:,17) - Airline_Employee_Breakdown(:,15); % Excluding transport-related

% Computing the normalized metrics
ASMs_per_Employee = round(Airline_ASMs./Airline_Employee_Breakdown(:,16));
Labor_Cost_per_Employee = round(Airline_Unnormalized_Cost(:,1)./Airline_Employee_Breakdown(:,16));
Revenue_per_Employee = round(Airline_Unnormalized_Revenue(:,11)./Airline_Employee_Breakdown(:,16)); % Excluding transport-related
ASMs_per_Labor_Cost = round(Airline_ASMs./Airline_Unnormalized_Cost(:,1),2);

% Eliminating Inf and NaN entries
ASMs_per_Employee(isnan(ASMs_per_Employee)) = 0; ASMs_per_Employee(isinf(ASMs_per_Employee)) = 0;
Labor_Cost_per_Employee(isnan(Labor_Cost_per_Employee)) = 0; Labor_Cost_per_Employee(isinf(Labor_Cost_per_Employee)) = 0;
Revenue_per_Employee(isnan(Revenue_per_Employee)) = 0; Revenue_per_Employee(isinf(Revenue_per_Employee)) = 0;
ASMs_per_Labor_Cost(isnan(ASMs_per_Labor_Cost)) = 0; ASMs_per_Labor_Cost(isinf(ASMs_per_Labor_Cost)) = 0;


% Creating the aggregated tables for each airline and aircraft
% Airline Cumulative Financial Statistics
Airline_Financial_Aggregated = [Airline_Unnormalized_Cost(:,11),...
                                Airline_Cost_per_ASM(:,11),...
                                Airline_Cost_per_Seat(:,11),...
                                Airline_Cost_per_RPM(:,11),...
                                Airline_Cost_per_Passenger(:,11),...
                                Airline_Unnormalized_Revenue(:,11),...
                                Airline_Revenue_per_ASM(:,11),...
                                Airline_Revenue_per_Seat(:,11),...
                                Airline_Revenue_per_RPM(:,11),...
                                Airline_Revenue_per_Passenger(:,11),...
                                Airline_Employee_Breakdown(:,16),...
                                ASMs_per_Employee,...
                                Labor_Cost_per_Employee,...
                                Revenue_per_Employee,...
                                ASMs_per_Labor_Cost];

% Airline Profitability Statistics
Airline_Profitability_Aggregated = [Airline_Unnormalized_Revenue(:,11) - Airline_Unnormalized_Cost(:,11),...
                                    Airline_Revenue_per_ASM(:,11) - Airline_Cost_per_ASM(:,11),...
                                    Airline_Revenue_per_Seat(:,11) - Airline_Cost_per_Seat(:,11),...
                                    Airline_Revenue_per_RPM(:,11) - Airline_Cost_per_RPM(:,11),...
                                    Airline_Revenue_per_Passenger(:,11) - Airline_Cost_per_Passenger(:,11)];


%% ----------------- Step 3: Creating the output tables ----------------- %

% Creating the table labels
airline_names = [AirlineCodes{:,2};'All Airlines'];
names_Cost = {'Salaries & Benefits','Fuel','Materials (excl. Fuel)',...
                          'Services','Landing Fees','Rentals','Depreciation',...
                          'Amortization','Other Expenses','Transport-related Expenses',...
                          'Total Cost (excl. Transport-related Expenses)','Total Cost'};
names_revenue = {'Scheduled Passengers','Mail','Freight','Baggage Fees'....
                            'Charter Passengers','Charter Property','Reservation & Cancellation Fees',...
                            'Miscellaneous Revenue','Public Service Subsidies',...
                            'Transport-related Revenue','Total Revenue (excl. Transport-related Revenue)',...
                            'Total Revenue'};
names_employees = {'Managers','Pilots & Copilots','Other Flight Personnel',...
                              'General Service Employees','Maintenance Employees',...
                              'Aircraft Traffic Employees','General Traffic Employees',...
                              'Aircraft Control Employees','Passenger Handling Employees',...
                              'Cargo Handling Employees','Trainees & Instructors',...
                              'Statistical Employees','Traffic Soliciters',...
                              'Other Employees','Transport-related Employees',...
                              'Total Employees (excl. Transport-related Employees)',...
                              'Total Employees'};
names_aggregated = {'Total Cost (excl. Transport-related Expenses)',...
                    'Cost per Available Seat Miles','Cost per Seat',...
                    'Cost per RPM','Cost per Passenger',...
                    'Total Revenue (excl. Transport-related Expenses)',...
                    'Revenue per Available Seat Miles','Revenue per Seat',...
                    'Revenue per RPM','Revenue per Passenger',...
                    'Total Employees','ASMs per Employee',...
                    'Labor Cost per Employee','Revenue per Employee',...
                    'ASMs per Labor Cost'};

names_aggregated2 = {'Total Profit (excl. Transport-related Expenses)',...
                    'Profit per Available Seat Miles','Profit per Seat',...
                    'Profit per RPM','Profit per Passenger'};


% Cost Tables
Unnormalized_Cost_Table = array2table(Airline_Unnormalized_Cost); % Unnormalized Decomposed Administrative Cost (1)
Unnormalized_Cost_Table.Properties.VariableNames = names_Cost; Unnormalized_Cost_Table.Properties.RowNames = airline_names;
Cost_ASMs_Table = array2table(Airline_Cost_per_ASM); % Decomposed Administrative Cost per Available Seat Miles (2)
Cost_ASMs_Table.Properties.VariableNames = names_Cost; Cost_ASMs_Table.Properties.RowNames = airline_names;
Cost_Seats_Table = array2table(Airline_Cost_per_Seat); % Decomposed Administrative Cost per Seat (3)
Cost_Seats_Table.Properties.VariableNames = names_Cost; Cost_Seats_Table.Properties.RowNames = airline_names;
Cost_RPMs_Table = array2table(Airline_Cost_per_RPM); % Decomposed Administrative Cost per Revenue Passenger Miles (4)
Cost_RPMs_Table.Properties.VariableNames = names_Cost; Cost_RPMs_Table.Properties.RowNames = airline_names;
Cost_Passengers_Table = array2table(Airline_Cost_per_Passenger); % Decomposed Administrative Cost per Passenger (5)
Cost_Passengers_Table.Properties.VariableNames = names_Cost; Cost_Passengers_Table.Properties.RowNames = airline_names;

% Revenue Tables
Unnormalized_Revenue_Table = array2table(Airline_Unnormalized_Revenue); % Unnormalized Decomposed Revenue (6)
Unnormalized_Revenue_Table.Properties.VariableNames = names_revenue; Unnormalized_Revenue_Table.Properties.RowNames = airline_names;
Revenue_ASMs_Table = array2table(Airline_Revenue_per_ASM); % Decomposed Revenue per Available Seat Miles (7)
Revenue_ASMs_Table.Properties.VariableNames = names_revenue; Revenue_ASMs_Table.Properties.RowNames = airline_names;
Revenue_Seats_Table = array2table(Airline_Revenue_per_Seat); % Decomposed Revenue per Seat (8)
Revenue_Seats_Table.Properties.VariableNames = names_revenue; Revenue_Seats_Table.Properties.RowNames = airline_names;
Revenue_RPMs_Table = array2table(Airline_Revenue_per_RPM); % Decomposed Revenue per Revenue Passenger Miles (9)
Revenue_RPMs_Table.Properties.VariableNames = names_revenue; Revenue_RPMs_Table.Properties.RowNames = airline_names;
Revenue_Passengers_Table = array2table(Airline_Revenue_per_Passenger); % Decomposed Revenue per Passenger (10)
Revenue_Passengers_Table.Properties.VariableNames = names_revenue; Revenue_Passengers_Table.Properties.RowNames = airline_names;

% Employee Tables
Employee_Breakdown_Table = array2table(Airline_Employee_Breakdown); % Employee Breakdown (11)
Employee_Breakdown_Table.Properties.VariableNames = names_employees; Employee_Breakdown_Table.Properties.RowNames = airline_names;
ASMs_Employee_Table = array2table(ASMs_per_Employee); % Available Seat Miles per Employee (12)
ASMs_Employee_Table.Properties.VariableNames = {'ASMs per Employee'}; ASMs_Employee_Table.Properties.RowNames = airline_names;
Cost_Employee_Table = array2table(Labor_Cost_per_Employee); % Labor Cost per Employee (13)
Cost_Employee_Table.Properties.VariableNames = {'Labor Cost per Employee'}; Cost_Employee_Table.Properties.RowNames = airline_names;
Revenue_Employee_Table = array2table(Revenue_per_Employee); % Revenue per Employee (14)
Revenue_Employee_Table.Properties.VariableNames = {'Revenue per Employee'}; Revenue_Employee_Table.Properties.RowNames = airline_names;
ASMs_Cost_Table = array2table(ASMs_per_Labor_Cost); % Available Seat Miles per Labor Cost (15)
ASMs_Cost_Table.Properties.VariableNames = {'ASMs per Labor Cost'}; ASMs_Cost_Table.Properties.RowNames = airline_names;

% Aggregated Tables:
Financial_Statistics_Table = array2table(Airline_Financial_Aggregated); % Airline Cumulative Financial Statistics (16)
Financial_Statistics_Table.Properties.VariableNames = names_aggregated;
Financial_Statistics_Table.Properties.RowNames = airline_names;
Profitability_Statistics_Table = array2table(Airline_Profitability_Aggregated); % Airline Profitability Statistics (17)
Profitability_Statistics_Table.Properties.VariableNames = names_aggregated2;
Profitability_Statistics_Table.Properties.RowNames = airline_names;

% Saving the output tables
if sum(Save_Tables == 1) > 0, writetable(Unnormalized_Cost_Table,['Administrative_Cost_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (1)
if sum(Save_Tables == 2) > 0, writetable(Cost_ASMs_Table,['Administrative_CASM_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (2)
if sum(Save_Tables == 3) > 0, writetable(Cost_Seats_Table,['Administrative_Cost_per_Seat_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (3)
if sum(Save_Tables == 4) > 0, writetable(Cost_RPMs_Table,['Administrative_Cost_per_RPM_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (4)
if sum(Save_Tables == 5) > 0, writetable(Cost_Passengers_Table,['Administrative_Cost_per_Passenger_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (5)

if sum(Save_Tables == 6) > 0, writetable(Unnormalized_Revenue_Table,['Revenue_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (6)
if sum(Save_Tables == 7) > 0, writetable(Revenue_ASMs_Table,['RASM_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (7)
if sum(Save_Tables == 8) > 0, writetable(Revenue_Seats_Table,['Revenue_per_Seat_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (8)
if sum(Save_Tables == 9) > 0, writetable(Revenue_RPMs_Table,['Revenue_per_RPM_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (9)
if sum(Save_Tables == 10) > 0, writetable(Revenue_Passengers_Table,['Revenue_per_Passenger_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (10)

if sum(Save_Tables == 11) > 0, writetable(Employee_Breakdown_Table,['Employees_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (11)
if sum(Save_Tables == 12) > 0, writetable(ASMs_Employee_Table,['ASMs_per_Employee_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (12)
if sum(Save_Tables == 13) > 0, writetable(Costs_Employee_Table,['Labor_Cost_per_Employee_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (13)
if sum(Save_Tables == 14) > 0, writetable(Revenue_Employee_Table,['Revenue_per_Employee_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (14)
if sum(Save_Tables == 15) > 0, writetable(ASMs_Cost_Table,['ASMs_per_Labor_Cost_by_Airline_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (15)

if sum(Save_Tables == 16) > 0, writetable(Financial_Statistics_Table,['Airline_Cumulative_Financial_Statistics_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (16)
if sum(Save_Tables == 17) > 0, writetable(Profitability_Statistics_Table,['Airline_Profitability_Statistics_',num2str(year),'.xlsx'],'Sheet',1,'WriteRowNames',true), end % (17)