% ----------------------------------------------------------------------- %
% -------------- AIRLINE MARKET ANALYSIS TOOL (AMAT) - v1 --------------- %
% ----------------------------------------------------------------------- %

% The following tool (APAT) can be used to compute a variety of market
% metrics specific to routes and airlines in the US airline industry.
% AMAT leverages open-source data from the US Bureau of Transportation
% Statistics (BTS), namely the Origin and Destination Survey 
% (DB1B - Market). Before using APAT, please make sure to follow the 
% instructions outlined in: https://github.com/andyeske/Airline-Data-Project

% AMAT outputs a total of 8 tables, all of which can be customized using 
% user-defined inputs. These include:

% (1) Daily Revenue by Route and Airline out of a Desired Airport ($): Daily_Revenue_by_Route_and_Airline_Out.xlsx
% (2) PDEW by Route and Airline out of a Desired Airport (# of people): PDEW_by_Route_and_Airline_Out.xlsx
% (3) RPMs by Route and Airline out of a Desired Airport (RPMs): Daily_RPM_by_Route_and_Airline_Out.xlsx
% (4) Average Yield by Route and Airline out of a Desired Airport ($/RPM): Average_Yield_by_Route_and_Airline_Out.xlsx

% (5) Daily Revenue by Route and Airline into a Desired Airport ($): Daily_Revenue_by_Route_and_Airline_In.xlsx
% (6) PDEW by Route and Airline into a Desired Airport (# of people): PDEW_by_Route_and_Airline_In.xlsx
% (7) RPMs by Route and Airline into a Desired Airport (RPMs): Daily_RPM_by_Route_and_Airline_In.xlsx
% (8) Average Yield by Route and Airline into a Desired Airport ($/RPM): Average_Yield_by_Route_and_Airline_In.xlsx

% These tables are sorted in descending order, showing the top routes
% first, according to the sorting preference.

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate (1) through (8), the USER must specify four parameters, which
% include:

% Please input the Desired Airport: 
Desired_Airport = 'BOS';

% Please select the Number of Markets:
% --> This corresponds to the number of markets that will be displayed on
% tables.
Number_Markets = 20;

% Plase select the Desired Sorting preference:
% --> Here, select: Revenue (1) | Passengers (2) | RPM (3) | Yield (4) to
% sort the tables according to each of these metrics.
Desired_Sorting = 2;

% Please input the Desired Airline: 
% --> This is the airline that will be used to sort the rows of the output
% table. You can use the table "Airline Codes" available in 
% https://github.com/andyeske/Airline-Data-Project to find the set of 23 
% US airlines available for selection.
Desired_Airline = 'United';

% Finally, please select the desired table indeces to save:
Save_Tables = [1,2,3,4,5,6,7,8];

% Notes:
% a) Desired_Airline = 'All_Airlines' will sort the tables using the
% aggregate column for all airlines in the US.
% b) Writing [] in Save_Tables will not save any tables, and will simply
% generate these on MATLAB.

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the datasets
DB1B = readtable('DB1B Data.csv'); 
AirlineCodes = readtable('Airline Codes.xlsx');

% Extracting dataset statistics
n_airlines = length(AirlineCodes{:,1});
n_DB1B = length(DB1B{:,1});

% Finding the desired aircraft and airline indeces
Desired_Airline_In = find(strcmp(Desired_Airline,AirlineCodes{:,2}) == 1);
% Default index if a wrong code is inputted
if isempty(Desired_Airline_In)
    Desired_Airline_In = n_airlines + 1;
end

%% ------------------- Step 2: Computing the metrics -------------------- %

% ------------------------- From the DB1B Data -------------------------- %

Unique_O = unique(DB1B{:,2}); % Finding the unique set of origin airports
Unique_D = unique(DB1B{:,3}); % Finding the unique set of destination airports

Desired_Airport_O_in = find(strcmp(Desired_Airport,Unique_O) == 1); % Finding the origin index of the desired airport
Desired_Airport_D_in = find(strcmp(Desired_Airport,Unique_D) == 1); % Finding the destination index of the desired airport

% Processed Destination/Airline datasets
out_Revenue = zeros(length(Unique_D),n_airlines+1); % Revenue out of desired airport ($)
out_Passengers = zeros(length(Unique_D),n_airlines+1); % Passengers out of desired airport (PDEW)
out_RPM = zeros(length(Unique_D),n_airlines+1); % Total revenue passenger-miles out of desired airport (RPM)

% Processed Origin/Airline datasets
in_Revenue = zeros(length(Unique_O),n_airlines+1); % Revenue into desired airport ($)
in_Passengers = zeros(length(Unique_O),n_airlines+1); % Passengers into desired airport (PDEW)
in_RPM = zeros(length(Unique_O),n_airlines+1); % Total revenue passenger-miles into desired airport (RPM)

% Iterating through all entries of DB1B
for k = 1:n_DB1B

    % Finding the airline
    Airline = char(DB1B{k,4}); Airline_In = find(strcmp(Airline,AirlineCodes{:,1}) == 1);

    % Finding the destination
    Dest = char(DB1B{k,3}); Dest_In = find(strcmp(Dest,Unique_D) == 1);

    % Finding the origin
    Orig = char(DB1B{k,2}); Orig_In = find(strcmp(Orig,Unique_O) == 1);
    
    % Only computing the metrics for those codes where there is data
    if isempty(Airline_In) == 0 
        
        % Populating the "out of desired airport" matrices
        if Orig_In == Desired_Airport_O_in
            out_Revenue(Dest_In,Airline_In) = out_Revenue(Dest_In,Airline_In) + DB1B{k,5}.*DB1B{k,6}; % Passengers * Fare
            out_Passengers(Dest_In,Airline_In) = out_Passengers(Dest_In,Airline_In) + DB1B{k,5}; % Passengers
            out_RPM(Dest_In,Airline_In) = out_RPM(Dest_In,Airline_In) + DB1B{k,5}.*DB1B{k,7}; % Passengers * Distance
        end

        % Populating the "into desired airport" matrices
        if Dest_In == Desired_Airport_D_in
            in_Revenue(Orig_In,Airline_In) = in_Revenue(Orig_In,Airline_In) + DB1B{k,5}.*DB1B{k,6}; % Passengers * Fare
            in_Passengers(Orig_In,Airline_In) = in_Passengers(Orig_In,Airline_In) + DB1B{k,5}; % Passengers
            in_RPM(Orig_In,Airline_In) = in_RPM(Orig_In,Airline_In) + DB1B{k,5}.*DB1B{k,7}; % Passengers * Distance
        end

    end

    % Displaying progress
    if mod(k,1000) == 0
        disp([num2str(round(100*k/n_DB1B,2)),'%'])
    end

end

% Computing the cumulative metrics across all airlines
out_Revenue(:,end) = sum(out_Revenue,2);
out_Passengers(:,end) = sum(out_Passengers,2);
out_RPM(:,end) = sum(out_RPM,2);
in_Revenue(:,end) = sum(in_Revenue,2);
in_Passengers(:,end) = sum(in_Passengers,2);
in_RPM(:,end) = sum(in_RPM,2);

% Computing the yields
out_Yield = out_Revenue./out_RPM;  % Yield out of desired airport ($/RPM)
in_Yield = in_Revenue./in_RPM; % Yield into desired airport ($/RPM)

% Eliminating NaN entries
out_Yield(isnan(out_Yield)) = 0;
in_Yield(isnan(in_Yield)) = 0;

% Correcting the tables for the 10% DB1B sample and the quarterly time scale
% All metrics display the corresponding value / day
out_Revenue = out_Revenue.*10/90; % Total 
out_Passengers = round(out_Passengers.*10/90);
out_RPM = out_RPM.*10/90;
in_Revenue = in_Revenue.*10/90;
in_Passengers = round(in_Passengers.*10/90);
in_RPM = in_RPM.*10/90;

% Identifying the top markets
out_Revenue(1:end,end+1) = 1:length(Unique_D); 
out_Passengers(1:end,end+1) = 1:length(Unique_D); 
out_RPM(1:end,end+1) = 1:length(Unique_D); 
out_Yield(1:end,end+1) = 1:length(Unique_D); 
in_Revenue(1:end,end+1) = 1:length(Unique_O); 
in_Passengers(1:end,end+1) = 1:length(Unique_O); 
in_RPM(1:end,end+1) = 1:length(Unique_O); 
in_Yield(1:end,end+1) = 1:length(Unique_O); 

% Sorting according to Revenue (1), Passengers (2), RPM (3), or Yield (4)
if Desired_Sorting == 1 % Sort routes by Revenue

    % Out of desired airport
    out_Revenue_Sorted = sortrows(out_Revenue,Desired_Airline_In,'descend'); out_Revenue_Sorted = out_Revenue_Sorted(1:Number_Markets,:);
    sorted_rows_out = out_Revenue_Sorted(:,end);
    out_Passengers_Sorted = out_Passengers(sorted_rows_out,:);
    out_RPM_Sorted = out_RPM(sorted_rows_out,:);
    out_Yield_Sorted = out_Yield(sorted_rows_out,:);

    % Into desired airport
    in_Revenue_Sorted = sortrows(in_Revenue,Desired_Airline_In,'descend'); in_Revenue_Sorted = in_Revenue_Sorted(1:Number_Markets,:);
    sorted_rows_in = in_Revenue_Sorted(:,end);
    in_Passengers_Sorted = in_Passengers(sorted_rows_in,:);
    in_RPM_Sorted = in_RPM(sorted_rows_in,:);
    in_Yield_Sorted = in_Yield(sorted_rows_in,:);

elseif Desired_Sorting == 2 % Sort routes by Passengers

    % Out of desired airport
    out_Passengers_Sorted = sortrows(out_Passengers,Desired_Airline_In,'descend'); out_Passengers_Sorted = out_Passengers_Sorted(1:Number_Markets,:);
    sorted_rows_out = out_Passengers_Sorted(:,end);
    out_Revenue_Sorted = out_Revenue(sorted_rows_out,:);
    out_RPM_Sorted = out_RPM(sorted_rows_out,:);
    out_Yield_Sorted = out_Yield(sorted_rows_out,:);

    % Into desired airport
    in_Passengers_Sorted = sortrows(in_Passengers,Desired_Airline_In,'descend'); in_Passengers_Sorted = in_Passengers_Sorted(1:Number_Markets,:);
    sorted_rows_in = in_Passengers_Sorted(:,end);
    in_Revenue_Sorted = in_Revenue(sorted_rows_in,:);
    in_RPM_Sorted = in_RPM(sorted_rows_in,:);
    in_Yield_Sorted = in_Yield(sorted_rows_in,:);

elseif Desired_Sorting == 3 % Sort routes by RPM

    % Out of desired airport
    out_RPM_Sorted = sortrows(out_RPM,Desired_Airline_In,'descend'); out_RPM_Sorted = out_RPM_Sorted(1:Number_Markets,:);
    sorted_rows_out = out_RPM_Sorted(:,end);
    out_Passengers_Sorted = out_Passengers(sorted_rows_out,:);
    out_Revenue_Sorted = out_Revenue(sorted_rows_out,:);
    out_Yield_Sorted = out_Yield(sorted_rows_out,:);

    % Into desired airport
    in_RPM_Sorted = sortrows(in_RPM,Desired_Airline_In,'descend'); in_RPM_Sorted = in_RPM_Sorted(1:Number_Markets,:);
    sorted_rows_in = in_RPM_Sorted(:,end);
    in_Passengers_Sorted = in_Passengers(sorted_rows_in,:);
    in_Revenue_Sorted = in_Revenue(sorted_rows_in,:);
    in_Yield_Sorted = in_Yield(sorted_rows_in,:);

else % Sort routes by Yield

    % Out of desired airport
    out_Yield_Sorted = sortrows(out_Yield,Desired_Airline_In,'descend'); out_Yield_Sorted = out_Yield_Sorted(1:Number_Markets,:);
    sorted_rows_out = out_Yield_Sorted(:,end);
    out_Passengers_Sorted = out_Passengers(sorted_rows_out,:);
    out_RPM_Sorted = out_RPM(sorted_rows_out,:);
    out_Revenue_Sorted = out_Revenue(sorted_rows_out,:);

    % Into desired airport
    in_Yield_Sorted = sortrows(in_Yield,Desired_Airline_In,'descend'); in_Yield_Sorted = in_Yield_Sorted(1:Number_Markets,:);
    sorted_rows_in = in_Yield_Sorted(:,end);
    in_Passengers_Sorted = in_Passengers(sorted_rows_in,:);
    in_RPM_Sorted = in_RPM(sorted_rows_in,:);
    in_Revenue_Sorted = in_Revenue(sorted_rows_in,:);

end

% Adding the last row to each table to show the total for each airline
% Out of desired airport
out_Revenue_Sorted(end+1,:) = sum(out_Revenue,1); out_Revenue_Sorted = out_Revenue_Sorted(:,1:(end-1));
out_Passengers_Sorted(end+1,:) = sum(out_Passengers,1); out_Passengers_Sorted = out_Passengers_Sorted(:,1:(end-1));
out_RPM_Sorted(end+1,:) = sum(out_RPM,1); out_RPM_Sorted = out_RPM_Sorted(:,1:(end-1));
out_Yield_Sorted(end+1,1:(end-1)) = out_Revenue_Sorted(end,:)./out_RPM_Sorted(end,:); out_Yield_Sorted = out_Yield_Sorted(:,1:(end-1));
out_Yield_Sorted(isnan(out_Yield_Sorted)) = 0;

% Into desired airport
in_Revenue_Sorted(end+1,:) = sum(in_Revenue,1); in_Revenue_Sorted = in_Revenue_Sorted(:,1:(end-1));
in_Passengers_Sorted(end+1,:) = sum(in_Passengers,1); in_Passengers_Sorted = in_Passengers_Sorted(:,1:(end-1));
in_RPM_Sorted(end+1,:) = sum(in_RPM,1); in_RPM_Sorted = in_RPM_Sorted(:,1:(end-1));
in_Yield_Sorted(end+1,1:(end-1)) = in_Revenue_Sorted(end,:)./in_RPM_Sorted(end,:); in_Yield_Sorted = in_Yield_Sorted(:,1:(end-1));
in_Yield_Sorted(isnan(in_Yield_Sorted)) = 0;

%% ----------------- Step 3: Creating the output tables ----------------- %

% Creating the table labels
airline_names = [AirlineCodes{:,2};'All Airlines'];
route_names_O = [Unique_O(sorted_rows_in);'All Routes'];
route_names_D = [Unique_D(sorted_rows_out);'All Routes'];

% Overview Tables
% Out of desired airport
Revenue_Out_Table = array2table(out_Revenue_Sorted); % (1)
Revenue_Out_Table.Properties.VariableNames = airline_names; Revenue_Out_Table.Properties.RowNames = route_names_D;
Passengers_Out_Table = array2table(out_Passengers_Sorted); % (2)
Passengers_Out_Table.Properties.VariableNames = airline_names; Passengers_Out_Table.Properties.RowNames = route_names_D;
RPM_Out_Table = array2table(out_RPM_Sorted); % (3)
RPM_Out_Table.Properties.VariableNames = airline_names; RPM_Out_Table.Properties.RowNames = route_names_D;
Yield_Out_Table = array2table(out_Yield_Sorted); % (4)
Yield_Out_Table.Properties.VariableNames = airline_names; Yield_Out_Table.Properties.RowNames = route_names_D;

% Into desired airport
Revenue_In_Table = array2table(in_Revenue_Sorted); % (5)
Revenue_In_Table.Properties.VariableNames = airline_names; Revenue_In_Table.Properties.RowNames = route_names_O;
Passengers_In_Table = array2table(in_Passengers_Sorted); % (6)
Passengers_In_Table.Properties.VariableNames = airline_names; Passengers_In_Table.Properties.RowNames = route_names_O;
RPM_In_Table = array2table(in_RPM_Sorted); % (7)
RPM_In_Table.Properties.VariableNames = airline_names; RPM_In_Table.Properties.RowNames = route_names_O;
Yield_In_Table = array2table(in_Yield_Sorted); % (8)
Yield_In_Table.Properties.VariableNames = airline_names; Yield_In_Table.Properties.RowNames = route_names_O;

% Saving the output tables
% Out of desired airport
if sum(Save_Tables == 1) > 0, writetable(Revenue_Out_Table,'Daily_Revenue_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (1)
if sum(Save_Tables == 2) > 0, writetable(Passengers_Out_Table,'PDEW_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (2)
if sum(Save_Tables == 3) > 0, writetable(RPM_Out_Table,'Daily_RPM_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (3)
if sum(Save_Tables == 4) > 0, writetable(Yield_Out_Table,'Average_Yield_by_Route_and_Airline_Out.xlsx','Sheet',1,'WriteRowNames',true), end % (4)

% Into desired airport
if sum(Save_Tables == 5) > 0, writetable(Revenue_In_Table,'Daily_Revenue_by_Route_and_Airline_In.xlsx','Sheet',1,'WriteRowNames',true), end % (5)
if sum(Save_Tables == 6) > 0, writetable(Passengers_In_Table,'PDEW_by_Route_and_Airline_In.xlsx','Sheet',1,'WriteRowNames',true), end % (6)
if sum(Save_Tables == 7) > 0, writetable(RPM_In_Table,'Daily_RPM_by_Route_and_Airline_In.xlsx','Sheet',1,'WriteRowNames',true), end % (7)
if sum(Save_Tables == 8) > 0, writetable(Yield_In_Table,'Average_Yield_by_Route_and_Airline_In.xlsx','Sheet',1,'WriteRowNames',true), end % (8)