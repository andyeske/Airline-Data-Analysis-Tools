% ----------------------------------------------------------------------- %
% ------------ AIRCRAFT ASSIGNMENT ANALYSIS TOOL (AAAT) - v1 ------------ %
% ----------------------------------------------------------------------- %

% The following tool (AAAT) can be used to examine the assignment of 
% aircraft across an airline's network in the US. In particular, the tool 
% returns the routes that the aircraft of choice was assigned to, in 
% addition to metrics such as Route Distance, Number of Departures, 
% Number of Passengers, Number of Seats, Revenue Passenger-Miles (RPMs) and 
% Available Seat-Miles (ASMs). AAAT leverages open-source data from the US 
% Bureau of Transportation Statistics (BTS), namely the 
% Form 41 Traffic - T-100 Segment (US Carriers Only) dataset. 
% Before using AAAT, please make sure to follow the instructions outlined 
% in: https://github.com/andyeske/Airline-Data-Analysis-Tools

% AAAT outputs a single table, which can be customized using user-defined 
% inputs. This table is:

% (1) Aircraft Assignment Table: Aircraft_Assignment_(Desired_Aircraft)_(Desired_Airline)_20XX.xlsx

% Notes:
% a) "Desired_Aircraft" and "Desired_Airline" are user-defined inputs.
% b) 20XX corresponds to the year of the inputted T100 data.
% c) The set of routes is ranked according to the number of departures.
% d) Metrics are reported for both route directions (i.e., AAA -> BBB and
% BBB -> AAA).

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate Table (1), the USER must specify four parameters, which
% include:

% Please input the Desired Airline: 
% --> You can use the table "Airline Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of 23 US airlines available for selection.
Desired_Airline = 'United';

% Please input the Desired Aircraft: 
% --> You can use the table "Aircraft Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of 46 aircraft types available for selection.
Desired_Aircraft = 'B787-8';

% Finally, please select whether to save the table:
% Options: No (0) | Yes (1)
Save_Table = 1;

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the datasets
T100 = readtable('T100 Data.csv'); 
AircraftCodes = readtable('Aircraft Codes.xlsx');
AirlineCodes = readtable('Airline Codes.xlsx');

% Extracting dataset statistics
n_aircraft = length(AircraftCodes{:,1});
n_airlines = length(AirlineCodes{:,1});

% Eliminating unnecessary entries on T100
T100 = T100(find(T100{:,1} > 0),:); % Non-zero departures
T100 = T100(find(T100{:,2} > 0),:); % Non-zero seats
T100 = T100(find(T100{:,4} > 0),:); % Non-zero distance
T100_year = T100{1,10};

%% ------------------- Step 2: Computing the metrics -------------------- %

% ------------------------- From the T100 Data -------------------------- %

% Finding the airline and aircraft index
Airline_In = find(strcmp(Desired_Airline,AirlineCodes{:,2}) == 1);
Aircraft_In = find(strcmp(Desired_Aircraft,AircraftCodes{:,2}) == 1);
Airline_In_FAA = AirlineCodes{Airline_In,1};
Aircraft_In_FAA = AircraftCodes{Aircraft_In,1};

% Finding the airline and aircraft indeces in the T100 dataset
Airline_T100 = find(strcmp(Airline_In_FAA,T100{:,6}) == 1);
Aircraft_T100 = find(Aircraft_In_FAA == T100{:,9});
Combined_T100 = intersect(Airline_T100,Aircraft_T100);

% Adjusting the T100 dataset to only focus on the desired indeces
T100 = T100(Combined_T100,:);
n_T100 = length(T100{:,1});

% Finding the unique set of routes
routes = cell2table([T100{:,7},T100{:,8}],'VariableNames',{'Origin','Destination'});
unique_routes = unique(routes);
[n_unique,~] = size(unique_routes);

% Creating a matrix to store the results for the unique set of routes
metrics_M = zeros(n_unique,5);

% Iterating through all unique routes
for k_route = 1:n_unique

    % Finding the origin and destination airports
    origin = char(unique_routes{k_route,1});
    destination = char(unique_routes{k_route,2});
    origin_vec = strcmp(origin,routes{:,1});
    destination_vec = strcmp(destination,routes{:,2});

    % Route index
    route_in = find(origin_vec.*destination_vec > 0);

    total_departures = sum(T100{route_in,1});
    total_distance = sum(T100{route_in,1}.*T100{route_in,4});

    metrics_M(k_route,1) = total_distance/total_departures; % Route Distance
    metrics_M(k_route,2) = sum(T100{route_in,1}); % Number of Departures
    metrics_M(k_route,3) = sum(T100{route_in,3}); % Number of Passengers
    metrics_M(k_route,4) = sum(T100{route_in,2}); % Number of Seats
    metrics_M(k_route,5) = sum(T100{route_in,3}.*T100{route_in,4}); % Revenue Passenger-Miles (RPMs)
    metrics_M(k_route,6) = sum(T100{route_in,2}.*T100{route_in,4}); % Available Seat-Miles (ASMs)

end

% Adding columns to the table
unique_routes = addvars(unique_routes,...
                metrics_M(:,1), metrics_M(:,2), metrics_M(:,3), ...
                metrics_M(:,4), metrics_M(:,5), metrics_M(:,6), ...
                'After', 'Destination',...
                'NewVariableNames',...
                {'Route Distance', 'Number of Departures',...
                'Number of Passengers','Number of Seats',...
                'RPMs','ASMs'});

% Sorting the table
unique_routes = sortrows(unique_routes, 4, 'descend'); 

%Saving the output tables
table_name = ['Aircraft_Assignment_',Desired_Aircraft,'_',Desired_Airline,'_',num2str(T100_year),'.xlsx'];
if sum(Save_Table == 1) > 0, writetable(unique_routes,table_name,'Sheet',1,'WriteRowNames',true), end % (1)