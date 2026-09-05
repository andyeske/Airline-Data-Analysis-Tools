% ----------------------------------------------------------------------- %
% -------------- AIRLINE NETWORK ANALYSIS TOOL (ANAT) - v1 -------------- %
% ---------------------- DATA PROCESSING SCRIPT ------------------------- %
% ----------------------------------------------------------------------- %

% The following script is utilized to process open-source data from the US 
% Bureau of Transportation Statistics (BTS), namely the Form 41 Traffic - 
% T-100 Segment (US Carriers Only) dataset. This script outputs a series of
% data tables containing the set of routes flown by each US airline,
% including information such as frequencies, number of passengers, number
% of seats, revenue passenger-miles (RPMs) and available seat-miles (ASMs).

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

% Iterating through all years
for k_year = 1990:2025
    
    % ------------------ Step 1: Importing the datasets ----------------- %
    
    % Importing the datasets
    T100 = readtable(['/Users/andyeske/Downloads/T100 ',num2str(k_year),'.csv']); 
    AirlineCodes = readtable('Airline Codes.xlsx','Sheet','Historical');
    coordinates = readtable('US Airports Coordinates.csv'); 
    
    % Extracting dataset statistics
    n_airlines = length(AirlineCodes{:,1});
    year = T100{1,10};
    
    % Eliminating unnecessary entries on T100
    T100 = T100(find(T100{:,1} > 0),:); % Non-zero departures
    T100 = T100(find(T100{:,2} > 0),:); % Non-zero seats
    T100 = T100(find(T100{:,4} > 0),:); % Non-zero distance
    in_T100 = []; 
    in_airlines = []; 
    for k_airline = 1:n_airlines
        in_unique_airline = find(strcmp(T100{:,6},AirlineCodes{k_airline,1})>0);
        in_T100 = [in_T100;in_unique_airline];
        if ~isempty(in_unique_airline)
            in_airlines = [in_airlines,k_airline];
        end
    end
    T100 = T100(in_T100,:);
    n_T100 = length(T100{:,1});
    n_unique_airlines = length(in_airlines)+1;
    AirlineCodes = AirlineCodes{in_airlines,:};
    AirlineCodes{end+1,1} = 'Total'; 
    AirlineCodes{end,2} = 'Total';
    
    % ------------------- Step 2: Computing the metrics ----------------- %
    
    % ----------------------- From the T100 Data ------------------------ %
    
    Unique_O = unique(T100{:,7}); % Finding the unique set of origin airports
    n_unique_O = length(Unique_O);
    
    % Creating the matrices to store the number of departures, passengers,
    % seats, RPKs and ASKs on each route, for each airline
    airline_Dep = zeros(n_unique_O,n_unique_O,n_unique_airlines);
    airline_Pax = zeros(n_unique_O,n_unique_O,n_unique_airlines);
    airline_Seats = zeros(n_unique_O,n_unique_O,n_unique_airlines);
    airline_RPKs = zeros(n_unique_O,n_unique_O,n_unique_airlines);
    airline_ASKs = zeros(n_unique_O,n_unique_O,n_unique_airlines);
    dom_vs_int = zeros(n_unique_O,n_unique_O);
    
    % Iterating through all routes
    for k_route = 1:n_T100
    
        % Finding the airline index
        airline_in = find(strcmp(T100{k_route,6},AirlineCodes(:,1))>0);
    
        % Finding the origin airport index
        origin_in = find(strcmp(T100{k_route,7},Unique_O)>0);
    
        % Finding the destination airport index
        destination_in = find(strcmp(T100{k_route,8},Unique_O)>0);
    
        % Populating the matrices
        if ~isempty(origin_in) && ~isempty(destination_in)
            airline_Dep(origin_in,destination_in,airline_in) = airline_Dep(origin_in,destination_in,airline_in) + T100{k_route,1};
            airline_Pax(origin_in,destination_in,airline_in) = airline_Pax(origin_in,destination_in,airline_in) + T100{k_route,3};
            airline_Seats(origin_in,destination_in,airline_in) = airline_Seats(origin_in,destination_in,airline_in) + T100{k_route,2};
            airline_RPKs(origin_in,destination_in,airline_in) = airline_RPKs(origin_in,destination_in,airline_in) + T100{k_route,3}.*T100{k_route,4};
            airline_ASKs(origin_in,destination_in,airline_in) = airline_ASKs(origin_in,destination_in,airline_in) + T100{k_route,2}.*T100{k_route,4};
            
            % Making a distinction between domestic and international routes
            if strcmp(T100{k_route,11},'DU')
                dom_vs_int(origin_in,destination_in) = 1;
            else
                dom_vs_int(origin_in,destination_in) = 2;
            end
        
        end
    
    end
    
    % Calculating the totals
    airline_Dep(:,:,end) = sum(airline_Dep,3);
    airline_Pax(:,:,end) = sum(airline_Pax,3);
    airline_Seats(:,:,end) = sum(airline_Seats,3);
    airline_RPKs(:,:,end) = sum(airline_RPKs,3);
    airline_ASKs(:,:,end) = sum(airline_ASKs,3);
    
    % Creating a cell matrix to store the networks of all airlines
    airline_Mat = cell(1,n_unique_airlines);
    
    % Iterating through all airlines
    for k_airline = 1:n_unique_airlines
    
        % Finding the airline routes
        [airline_O,airline_D] = find(airline_Dep(:,:,k_airline) > 10);
        n_OD = length(airline_O);
        network = cell(n_OD,10);
    
        % Populating the network matrix
        network(:,1) = AirlineCodes(k_airline,1);
        network(:,2) = Unique_O(airline_O);
        network(:,3) = Unique_O(airline_D);
        for k_route = 1:n_OD
            network(k_route,4) = num2cell(airline_Dep(airline_O(k_route),airline_D(k_route),k_airline));
            network(k_route,5) = num2cell(airline_Pax(airline_O(k_route),airline_D(k_route),k_airline));
            network(k_route,6) = num2cell(airline_Seats(airline_O(k_route),airline_D(k_route),k_airline));
            network(k_route,7) = num2cell(airline_RPKs(airline_O(k_route),airline_D(k_route),k_airline));
            network(k_route,8) = num2cell(airline_ASKs(airline_O(k_route),airline_D(k_route),k_airline));
    
            if dom_vs_int(airline_O(k_route),airline_D(k_route)) == 1
                network(k_route,9) = {'Domestic'};
            else
                network(k_route,9) = {'International'};
            end
    
        end
        network(:,10) = num2cell(year);
        
        % Creating the table for the routes
        var_names_routes = {'Airline Code','Origin','Destination','Frequencies',...
                            'Passengers','Seats','RPMs','ASMs','Market','Year'};
        year_table_routes = cell2table(network,'VariableNames',var_names_routes);
        airline_Mat(1,k_airline) = {sortrows(year_table_routes, {'Origin','Destination'})};
    
    end
    
    % Saving the tables
    for k_airline = 1:n_unique_airlines
        network = airline_Mat{1,k_airline};
        airline_code = AirlineCodes{k_airline,2};
        writetable(network,['US Airline Networks - ',num2str(year),'.xlsx'],'Sheet',airline_code,'WriteRowNames',true);
    end

end