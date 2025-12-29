% ----------------------------------------------------------------------- %
% --------------- AIRLINE ROUTE ANALYSIS TOOL (ARAT) - v1 --------------- %
% ----------------------------------------------------------------------- %

% The following tool (ARAT) can be used to compute a variety of capacity
% metrics specific to the route segment and airline/aircraft in the 
% US airline industry. ARAT leverages open-source data from the US Bureau 
% of Transportation Statistics (BTS), namely the T-100 Domestic Segment 
% (US Carriers Only) dataset. Before using ARAT, please make sure to follow the 
% instructions outlined in: https://github.com/andyeske/Airline-Data-Project

% ARAT outputs a total of 8 tables, all of which can be customized using 
% user-defined inputs. These include:

% (1) Total Revenue Passenger Miles by Route and Airline out of a Desired Airport (RPMs): Total_RPMs_by_Route_and_Airline_Out.xlsx
% (2) Total Available Seat Miles by Route and Airline out of a Desired Airport (ASMs): Total_ASMs_by_Route_and_Airline_Out.xlsx
% (3) Total Passengers by Route and Airline out of a Desired Airport (# of passsengers): Total_Passengers_by_Route_and_Airline_Out.xlsx
% (4) Total Departures by Route and Airline out of a Desired Airport (# of departures): Total_Departures_by_Route_and_Airline_Out.xlsx

% (5) Total Revenue Passenger Miles by Route and Aircraft out of a Desired Airport (RPMs): Total_RPMs_by_Route_and_Aircraft_Out.xlsx
% (6) Total Available Seat Miles by Route and Aircraft out of a Desired Airport (ASMs): Total_ASMs_by_Route_and_Aircraft_Out.xlsx
% (7) Total Passengers by Route and Aircraft out of a Desired Airport (# of passsengers): Total_Passengers_by_Route_and_Aircraft_Out.xlsx
% (8) Total Departures by Route and Aircraft out of a Desired Airport (# of departures): Total_Departures_by_Route_and_Aircraft_Out.xlsx

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

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the datasets
T100 = readtable('T100 Data.csv'); 
F41 = readtable('F41 Data.csv');
AircraftCodes = readtable('Aircraft Codes.xlsx');
AirlineCodes = readtable('Airline Codes.xlsx');

% Extracting dataset statistics
n_aircraft = length(AircraftCodes{:,1});
n_airlines = length(AirlineCodes{:,1});

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

%% ------------------- Step 2: Computing the metrics -------------------- %

% ------------------------- From the T100 Data -------------------------- %

Unique_O = unique(T100{:,7}); % Finding the unique set of origin airports
Unique_D = unique(T100{:,8}); % Finding the unique set of destination airports

Desired_Airport_O_in = find(strcmp(Origin_Airport,Unique_O) == 1); % Finding the origin index of the desired origin airport

% Processed Destination/Airline datasets
out_RPM_airline = zeros(length(Unique_D),n_airlines+1); % Total revenue passenger-miles out of desired origin airport by airline (RPM)
out_ASM_airline = zeros(length(Unique_D),n_airlines+1); % Total available seat-miles out of desired origin airport by airline (ASM)
out_Passengers_airline = zeros(length(Unique_D),n_airlines+1); % Total passengers out of desired origin airport by airline (# of passengers)
out_Departures_airline = zeros(length(Unique_D),n_airlines+1); % Total departures out of desired origin airport by airline (# of departures)

% Processed Destination/Aircraft datasets
out_RPM_aircraft = zeros(length(Unique_D),n_aircraft+1); % Total revenue passenger-miles out of desired origin airport by aircraft (RPM)
out_ASM_aircraft = zeros(length(Unique_D),n_aircraft+1); % Total available seat-miles out of desired origin airport by aircraft (ASM)
out_Passengers_aircraft = zeros(length(Unique_D),n_aircraft+1); % Total passengers out of desired origin airport by aircraft (# of passengers)
out_Departures_aircraft = zeros(length(Unique_D),n_aircraft+1); % Total departures out of desired origin airport by aircraft (# of departures)

% Iterating through all entries of T100
for k = 1:n_T100

    % Finding the airline and aircraft
    Airline = char(T100{k,6}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);
    Aircraft = T100{k,9}; Aircraft_In = find(Aircraft == AircraftCodes{:,1});
    Orig = char(T100{k,7}); Orig_In = find(strcmp(Orig,Unique_O) == 1);
    Dest = char(T100{k,8}); Dest_In = find(strcmp(Dest,Unique_D) == 1); 

    % Populating the "out of desired airport" matrices
    if Orig_In == Desired_Airport_O_in

        % Only computing the metrics for those codes where there is data
        if isempty(Airline_In) == 0 && isempty(Dest_In) == 0
         
            % Airline/Route Datasets
            out_RPM_airline(Dest_In,Airline_In) = out_RPM_airline(Dest_In,Airline_In) + T100{k,3}*T100{k,4}; % RPMs
            out_ASM_airline(Dest_In,Airline_In) = out_ASM_airline(Dest_In,Airline_In) + T100{k,2}*T100{k,4}; % ASMs
            out_Passengers_airline(Dest_In,Airline_In) = out_Passengers_airline(Dest_In,Airline_In) + T100{k,3}; % Passengers
            out_Departures_airline(Dest_In,Airline_In) = out_Departures_airline(Dest_In,Airline_In) + T100{k,1}; % Departures
    
        end
    
        % Only computing the metrics for those codes where there is data
        if isempty(Aircraft_In) == 0 && isempty(Dest_In) == 0
         
            % Aircraft/Route Datasets
            out_RPM_aircraft(Dest_In,Aircraft_In) = out_RPM_aircraft(Dest_In,Aircraft_In) + T100{k,3}*T100{k,4}; % RPMs
            out_ASM_aircraft(Dest_In,Aircraft_In) = out_ASM_aircraft(Dest_In,Aircraft_In) + T100{k,2}*T100{k,4}; % ASMs
            out_Passengers_aircraft(Dest_In,Aircraft_In) = out_Passengers_aircraft(Dest_In,Aircraft_In) + T100{k,3}; % Passengers
            out_Departures_aircraft(Dest_In,Aircraft_In) = out_Departures_aircraft(Dest_In,Aircraft_In) + T100{k,1}; % Departures
    
        end
    end

    % Displaying progress
    if mod(k,1000) == 0
        disp([num2str(round(100*k/n_T100,2)),'%'])
    end

end

% Computing the cumulative metrics
% Airline/Route Datasets
out_RPM_airline(:,end) = sum(out_RPM_airline,2); out_RPM_airline(:,end+1) = 1:length(Unique_D)'; % (1)
out_ASM_airline(:,end) = sum(out_ASM_airline,2); out_ASM_airline(:,end+1) = 1:length(Unique_D)'; % (2)
out_Passengers_airline(:,end) = sum(out_Passengers_airline,2); out_Passengers_airline(:,end+1) = 1:length(Unique_D)'; % (3)
out_Departures_airline(:,end) = sum(out_Departures_airline,2); out_Departures_airline(:,end+1) = 1:length(Unique_D)'; % (4)
% Airline/Route Datasets
out_RPM_aircraft(:,end) = sum(out_RPM_aircraft,2); out_RPM_aircraft(:,end+1) = 1:length(Unique_D)'; % (5)
out_ASM_aircraft(:,end) = sum(out_ASM_aircraft,2); out_ASM_aircraft(:,end+1) = 1:length(Unique_D)'; % (6)
out_Passengers_aircraft(:,end) = sum(out_Passengers_aircraft,2); out_Passengers_aircraft(:,end+1) = 1:length(Unique_D)'; % (7)
out_Departures_aircraft(:,end) = sum(out_Departures_aircraft,2); out_Departures_aircraft(:,end+1) = 1:length(Unique_D)'; % (8)

% Sorting the tables
% Airline/Route Datasets
out_RPM_airline_sorted = sortrows(out_RPM_airline,n_airlines+1,'descend'); out_RPM_airline_sorted = out_RPM_airline_sorted(1:Number_Routes,:); % (1)
out_ASM_airline_sorted = sortrows(out_ASM_airline,n_airlines+1,'descend'); out_ASM_airline_sorted = out_ASM_airline_sorted(1:Number_Routes,:); % (2)
out_Passengers_airline_sorted = sortrows(out_Passengers_airline,n_airlines+1,'descend'); out_Passengers_airline_sorted = out_Passengers_airline_sorted(1:Number_Routes,:); % (3)
out_Departures_airline_sorted = sortrows(out_Departures_airline,n_airlines+1,'descend'); out_Departures_airline_sorted = out_Departures_airline_sorted(1:Number_Routes,:); % (4)
% Aircraft/Route Datasets
out_RPM_aircraft_sorted = sortrows(out_RPM_aircraft,n_aircraft+1,'descend'); out_RPM_aircraft_sorted = out_RPM_aircraft_sorted(1:Number_Routes,:); % (5)
out_ASM_aircraft_sorted = sortrows(out_ASM_aircraft,n_aircraft+1,'descend'); out_ASM_aircraft_sorted = out_ASM_aircraft_sorted(1:Number_Routes,:); % (6)
out_Passengers_aircraft_sorted = sortrows(out_Passengers_aircraft,n_aircraft+1,'descend'); out_Passengers_aircraft_sorted = out_Passengers_aircraft_sorted(1:Number_Routes,:); % (7)
out_Departures_aircraft_sorted = sortrows(out_Departures_aircraft,n_aircraft+1,'descend'); out_Departures_aircraft_sorted = out_Departures_aircraft_sorted(1:Number_Routes,:); % (8)

% Appending the desired route
Desired_Airport_D_in = find(strcmp(Destination_Airport,Unique_D) == 1); % Finding the index of the desired destination airport
% Airline/Route Datasets
if sum(out_RPM_airline_sorted(:,end) == Desired_Airport_D_in) == 0
    out_RPM_airline_sorted(end+1,:) = out_RPM_airline(Desired_Airport_D_in,:); % (1)
end
if sum(out_ASM_airline_sorted(:,end) == Desired_Airport_D_in) == 0
    out_ASM_airline_sorted(end+1,:) = out_ASM_airline(Desired_Airport_D_in,:); % (2)
end
if sum(out_Passengers_airline_sorted(:,end) == Desired_Airport_D_in) == 0
    out_Passengers_airline_sorted(end+1,:) = out_Passengers_airline(Desired_Airport_D_in,:); % (3)
end
if sum(out_Departures_airline_sorted(:,end) == Desired_Airport_D_in) == 0
    out_Departures_airline_sorted(end+1,:) = out_Departures_airline(Desired_Airport_D_in,:); % (4)
end
% Airline/Route Datasets
if sum(out_RPM_aircraft_sorted(:,end) == Desired_Airport_D_in) == 0
    out_RPM_aircraft_sorted(end+1,:) = out_RPM_aircraft(Desired_Airport_D_in,:); % (5)
end
if sum(out_ASM_aircraft_sorted(:,end) == Desired_Airport_D_in) == 0
    out_ASM_aircraft_sorted(end+1,:) = out_ASM_aircraft(Desired_Airport_D_in,:); % (6)
end
if sum(out_Passengers_aircraft_sorted(:,end) == Desired_Airport_D_in) == 0
    out_Passengers_aircraft_sorted(end+1,:) = out_Passengers_aircraft(Desired_Airport_D_in,:); % (7)
end
if sum(out_Departures_aircraft_sorted(:,end) == Desired_Airport_D_in) == 0
    out_Departures_aircraft_sorted(end+1,:) = out_Departures_aircraft(Desired_Airport_D_in,:); % (8)
end

% Computing the remaining cumulative metrics
% Airline/Route Datasets
out_RPM_airline_sorted(end+1,:) = sum(out_RPM_airline,1); % (1)
out_ASM_airline_sorted(end+1,:) = sum(out_ASM_airline,1); % (2)
out_Passengers_airline_sorted(end+1,:) = sum(out_Passengers_airline,1); % (3)
out_Departures_airline_sorted(end+1,:) = sum(out_Departures_airline,1); % (4)
% Airline/Route Datasets
out_RPM_aircraft_sorted(end+1,:) = sum(out_RPM_aircraft,1); % (5)
out_ASM_aircraft_sorted(end+1,:) = sum(out_ASM_aircraft,1); % (6)
out_Passengers_aircraft_sorted(end+1,:) = sum(out_Passengers_aircraft,1); % (7)
out_Departures_aircraft_sorted(end+1,:) = sum(out_Departures_aircraft,1); % (8)

% ----------------- Step 3: Creating the output tables ----------------- %

% Creating the table labels
airline_names = [AirlineCodes{:,2};'All Airlines'];
aircraft_names = [AircraftCodes{:,2};'All Aircraft'];

% Overview Tables
% Airline/Route Datasets
RPM_Out_Airline_Table = array2table(out_RPM_airline_sorted(:,1:(end-1))); % (1)
OD_names = [Unique_D(out_RPM_airline_sorted(1:(end-1),end));'All ODs'];
RPM_Out_Airline_Table.Properties.VariableNames = airline_names; RPM_Out_Airline_Table.Properties.RowNames = OD_names;

ASM_Out_Airline_Table = array2table(out_ASM_airline_sorted(:,1:(end-1))); % (2)
OD_names = [Unique_D(out_ASM_airline_sorted(1:(end-1),end));'All ODs'];
ASM_Out_Airline_Table.Properties.VariableNames = airline_names; ASM_Out_Airline_Table.Properties.RowNames = OD_names;

Passengers_Out_Airline_Table = array2table(out_Passengers_airline_sorted(:,1:(end-1))); % (3)
OD_names = [Unique_D(out_Passengers_airline_sorted(1:(end-1),end));'All ODs'];
Passengers_Out_Airline_Table.Properties.VariableNames = airline_names; Passengers_Out_Airline_Table.Properties.RowNames = OD_names;

Departures_Out_Airline_Table = array2table(out_Departures_airline_sorted(:,1:(end-1))); % (4)
OD_names = [Unique_D(out_Departures_airline_sorted(1:(end-1),end));'All ODs'];
Departures_Out_Airline_Table.Properties.VariableNames = airline_names; Departures_Out_Airline_Table.Properties.RowNames = OD_names;

% Aircraft/Route Datasets
RPM_Out_Aircraft_Table = array2table(out_RPM_aircraft_sorted(:,1:(end-1))); % (5)
OD_names = [Unique_D(out_RPM_aircraft_sorted(1:(end-1),end));'All ODs'];
RPM_Out_Aircraft_Table.Properties.VariableNames = aircraft_names; RPM_Out_Aircraft_Table.Properties.RowNames = OD_names;

ASM_Out_Aircraft_Table = array2table(out_ASM_aircraft_sorted(:,1:(end-1))); % (6)
OD_names = [Unique_D(out_ASM_aircraft_sorted(1:(end-1),end));'All ODs'];
ASM_Out_Aircraft_Table.Properties.VariableNames = aircraft_names; ASM_Out_Aircraft_Table.Properties.RowNames = OD_names;

Passengers_Out_Aircraft_Table = array2table(out_Passengers_aircraft_sorted(:,1:(end-1))); % (7)
OD_names = [Unique_D(out_Passengers_aircraft_sorted(1:(end-1),end));'All ODs'];
Passengers_Out_Aircraft_Table.Properties.VariableNames = aircraft_names; Passengers_Out_Aircraft_Table.Properties.RowNames = OD_names;

Departures_Out_Aircraft_Table = array2table(out_Departures_aircraft_sorted(:,1:(end-1))); % (8)
OD_names = [Unique_D(out_Departures_aircraft_sorted(1:(end-1),end));'All ODs'];
Departures_Out_Aircraft_Table.Properties.VariableNames = aircraft_names; Departures_Out_Aircraft_Table.Properties.RowNames = OD_names;

%% Saving the output tables
% Airline/Route Datasets
if sum(Save_Tables == 1) > 0, writetable(RPM_Out_Airline_Table,'Total_RPMs_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (1)
if sum(Save_Tables == 2) > 0, writetable(ASM_Out_Airline_Table,'Total_ASMs_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (2)
if sum(Save_Tables == 3) > 0, writetable(Passengers_Out_Airline_Table,'Total_Passengers_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (3)
if sum(Save_Tables == 4) > 0, writetable(Departures_Out_Airline_Table,'Total_Departures_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (4)

% Aircraft/Route Datasets
if sum(Save_Tables == 5) > 0, writetable(RPM_Out_Aircraft_Table,'Total_RPMs_by_Route_and_Aircraft_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (5)
if sum(Save_Tables == 6) > 0, writetable(ASM_Out_Aircraft_Table,'Total_ASMs_by_Route_and_Aircraft_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (6)
if sum(Save_Tables == 7) > 0, writetable(Passengers_Out_Aircraft_Table,'Total_Passengers_by_Route_and_Aircraft_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (7)
if sum(Save_Tables == 8) > 0, writetable(Departures_Out_Aircraft_Table,'Total_Departures_by_Route_and_Aircraft_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (8)