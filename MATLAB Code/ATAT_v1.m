% ----------------------------------------------------------------------- %
% --------------- AIRLINE TRENDS ANALYSIS TOOL (ATAT) - v1 -------------- %
% ----------------------------------------------------------------------- %

% The following tool (ATAT) can be used to visualize longitudinal (i.e., 
% year-by-year) trends on the outputs generated from the APAT and AFAT
% tools. Before using ATAT, please make sure to follow the instructions 
% outlined in: https://github.com/andyeske/Airline-Data-Analysis-Tools

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate the plots, the USER must specify a few parameters, which
% include:

% Please input the desired variables to visualize: 
% --> These correspond to the output variables/tables from APAT and AFAT, 
% which are listed below.
% --> The user inputs appear below this list.

% APAT (17 variables):
% (1) Total Revenue Passenger Miles (RPMs)
% (2) Total Available Seat Miles (ASMs)
% (3) Total Number of Passengers
% (4) Total Number of Seats
% (5) Average Load Factor (RPMs/ASMs)
% (6) Total Departures (# departures)
% (7) Average Number of Departures per Day (# departures/day assigned)
% (8) Average Number ASMs per Day (ASMs/day assigned)
% (9) Average Aircraft Utilization per Day (block-hr/day assigned)
% (10) Average Number of Seats per Departure (# seats/# departures)
% (11) Average Stage Length (mi)
% (12) Average Passenger Trip Length (mi)
% (13) Average Fuel Intensity per ASMs (L/ASMs)
% (14) Average Fuel Intensity per Distance (L/mi)
% (15) AOC per Block Hour (USD$/block-hr)
% (16) AOC per Seat Hour (USD$/seat-hr)
% (17) AOC per ASMs (USD$/ASM)

% AFAT (19 variables):
% (1) Total (excl. Transport-related) Cost (USD$)
% (2) Total (excl. Transport-related) Cost per Available Seat Miles (USD$/ASM)
% (2.1) Labor Cost per Available Seat Miles (USD$/ASM)
% (2.2) Fuel Cost per Available Seat Miles (USD$/ASM)
% (3) Total (excl. Transport-related) Cost per Seat (USD$)
% (4) Total (excl. Transport-related) Cost per Revenue Passenger Miles (USD$/RPM)
% (5) Total (excl. Transport-related) Cost per Passenger (USD$)
% (6) Total (excl. Transport-related) Revenue (USD$)
% (7) Total (excl. Transport-related) Revenue per Available Seat Miles (USD$/ASM)
% (7.1) Scheduled Passengers Revenue per Available Seat Miles (USD$/ASM)
% (7.2) Baggage Fees Revenue per Available Seat Miles (USD$/ASM)
% (8) Total (excl. Transport-related) Revenue per Seat (USD$)
% (9) Total (excl. Transport-related) Revenue per Revenue Passenger Miles (USD$/RPM)
% (10) Total (excl. Transport-related) Revenue per Passenger (USD$)
% (11) Employee Breakdown
% (12) Available Seat Miles per Employee (ASMs)
% (13) Labor Cost per Employee (USD$)
% (14) Revenue per Employee (USD$)
% (15) Available Seat Miles per Labor Cost (ASMs/USD$)

% Please input the Tool Name:
Tool_Name = 'APAT';
% Please input the Desired Tables corresponding to the selected tool:
%Desired_Tables = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
Desired_Tables = [11];

% Please input the Desired Airline: 
% --> The trends shown will correspond to this airline.
% --> You can use the table "Airline Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of 23 US airlines available for selection.
% --> Writing Desired_Airline = 'All_Airlines' returns the aggregated 
% results for all airlines in the US.
% --> Similarly, writing Desired_Airline = 'FSC', 'Hybrid', 'ULCC', or 
% 'Regional' returns the aggregated results for the set of Full Service
% Carriers, Hybrid Low-Cost Carriers, Ultra Low-Cost Carriers, and
% Regional Airlines, respectively. The airline classification can be 
% found on the "Airline Codes" table.
% --> It it possible to visualize the results from more than one airline 
% simultaneously, by writing their names in the vector below.
Desired_Airline = {'American','Delta','United','JetBlue','Spirit','All Airlines'};

% Please input the Desired Aircraft: 
% --> This is only applicable if Tool_Name = 'APAT' was selected.
% --> You can use the table "Aircraft Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of 46 aircraft types available for selection.
% --> Writing Desired_Aircraft = 'All Aircaft' returns the aggregated 
% results for all aircraft in the US.
Desired_Aircraft = 'A320';

% Please select the range of years to visualize trends of:
% --> The minimum year is 2015.
% --> The maximum year is 2025.
Desired_Years = [2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025];

% Please select whether to save the plots or not:
% --> Options: No (0) | Yes (1)
Save_Tables = 0;

% Notes:
% a) ATAT can be easily modified to visualize more trends, or combination
% of trends, stemming from the data generated from APAT and AFAT.

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the datasets
AircraftCodes = readtable('Aircraft Codes.xlsx');

% Extracting selected parameter statistics
n_selected_tables = length(Desired_Tables);
n_selected_airlines = length(Desired_Airline);
n_selected_years = length(Desired_Years);

% Generating the plots
for k_plot = 1:n_selected_tables

    % Identifying the table number
    table_number = Desired_Tables(k_plot);

    % Creating a matrix to store the results
    plot_results = zeros(n_selected_airlines,n_selected_years);

    % Establishing the year counter
    year_counter = 1;

    for k_year = Desired_Years

        % Identifying the tool
        % APAT Tables
        if strcmp(Tool_Name,'APAT') == 1
    
            % Importing the table
            if table_number == 1 % (1)
                imported_results = readtable(['APAT Outputs/Overview Tables/',num2str(k_year),'/RPMs_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total Revenue Passenger Miles';
                y_str = {'Revenue Passenger Miles','(RPMs)'};
            elseif table_number == 2 % (2)
                imported_results = readtable(['APAT Outputs/Overview Tables/',num2str(k_year),'/ASMs_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total Available Seat Miles';
                y_str = {'Available Seat Miles','(ASMs)'};
            elseif table_number == 3 % (3)
                imported_results = readtable(['APAT Outputs/Overview Tables/',num2str(k_year),'/Passengers_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total Number of Passengers';
                y_str = {'Number of Passengers','(# passengers)'};
            elseif table_number == 4 % (4)
                imported_results = readtable(['APAT Outputs/Overview Tables/',num2str(k_year),'/Seats_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total Number of Seats';
                y_str = {'Number of Seats','(# seats)'};
            elseif table_number == 5 % (5)
                imported_results = readtable(['APAT Outputs/Overview Tables/',num2str(k_year),'/LFs_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Load Factor';
                y_str = {'Average Load Factor','(RPMs/ASMs)'};
            elseif table_number == 6 % (6)
                imported_results = readtable(['APAT Outputs/Overview Tables/',num2str(k_year),'/Departures_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total Number of Departures';
                y_str = {'Number of Departures','(# departures)'};
            elseif table_number == 7 % (7)
                imported_results = readtable(['APAT Outputs/Utilization Metrics Tables/',num2str(k_year),'/Departures_per_Day_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Number of Departures per Day';
                y_str = {'Average Number of Departures per Day','(# depatures/day)'};
            elseif table_number == 8 % (8)
                imported_results = readtable(['APAT Outputs/Utilization Metrics Tables/',num2str(k_year),'/ASMs_per_Day_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Number ASMs per Day';
                y_str = {'Average Number ASMs per Day','(ASMs/day assigned)'};
            elseif table_number == 9 % (9)
                imported_results = readtable(['APAT Outputs/Utilization Metrics Tables/',num2str(k_year),'/Block_Hours_per_Day_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Aircraft Utilization per Day';
                y_str = {'Average Aircraft Utilization per Day','(block-hr/days assigned)'};
            elseif table_number == 10 % (10)
                imported_results = readtable(['APAT Outputs/Utilization Metrics Tables/',num2str(k_year),'/Seats_per_Departures_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Number of Seats per Departure';
                y_str = {'Average Number of Seats per Departure','(# seats/# departures)'};
            elseif table_number == 11 % (11)
                imported_results = readtable(['APAT Outputs/Utilization Metrics Tables/',num2str(k_year),'/ASL_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Stage Length';
                y_str = {'Average Stage Length','(mi)'};
            elseif table_number == 12 % (12)
                imported_results = readtable(['APAT Outputs/Utilization Metrics Tables/',num2str(k_year),'/APTL_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Passenger Trip Length';
                y_str = {'Average Passenger Trip Length','(mi)'};
            elseif table_number == 13 % (13)
                imported_results = readtable(['APAT Outputs/Fuel Consumption Tables/',num2str(k_year),'/Fuel_Consumed_per_ASMs_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Fuel Intensity per ASMs';
                y_str = {'Average Fuel Intensity per ASMs','(L/ASMs)'};
            elseif table_number == 14 % (14)
                imported_results = readtable(['APAT Outputs/Fuel Consumption Tables/',num2str(k_year),'/Fuel_Consumed_per_Distance_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Average Fuel Intensity per Distance';
                y_str = {'Average Fuel Intensity per Distance','(L/mi)'};
            elseif table_number == 15 % (15)  
                imported_results = readtable(['APAT Outputs/Aircraft Operating Costs Tables/',num2str(k_year),'/AOC_per_Block_Hours_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'AOC per Block Hour';
                y_str = {'AOC per Block Hour','(USD$/block-hr)'};
            elseif table_number == 16 % (16)
                imported_results = readtable(['APAT Outputs/Aircraft Operating Costs Tables/',num2str(k_year),'/AOC_per_Seat_Hour_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'AOC per Seat Hour';
                y_str = {'AOC per Seat Hour','(USD$/seat-hr)'};
            elseif table_number == 17 % (17) 
                imported_results = readtable(['APAT Outputs/Aircraft Operating Costs Tables/',num2str(k_year),'/AOC_per_ASMs_by_Aircraft_and_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'AOC per ASMs';
                y_str = {'AOC per ASMs','(USD$/ASM)'};
            end

            % Finding the desired aircraft index
            Desired_Aircraft_In = find(strcmp(Desired_Aircraft,imported_results{:,1}) == 1);
            if isempty(Desired_Aircraft_In) == 1
                Desired_Aircraft_In = length(imported_results{:,1});
            end

            % Iterating through all desired airlines
            for k_airline = 1:n_selected_airlines
                Desired_Airline_In = find(strcmp(char(Desired_Airline{k_airline}),imported_results.Properties.VariableNames) == 1);   
                % Identifying special cases
                if isempty(Desired_Airline_In) == 1
                    Desired_Airline_In = length(imported_results.Properties.VariableNames);
                end
    
                % Extracting the values from the table
                plot_results(k_airline,year_counter) = imported_results{Desired_Aircraft_In,Desired_Airline_In};
            end
    
        % AFAT Tables
        else

            % Importing the table
            if table_number == 1 % (1)
                imported_results = readtable(['AFAT Outputs/Cost Tables/',num2str(k_year),'/Administrative_Cost_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Cost';
                y_str = {'Total (excl. Transport-related) Cost','(USD$)'};
            elseif sum(table_number == [2,2.1,2.2]) > 0 % (2)  
                imported_results = readtable(['AFAT Outputs/Cost Tables/',num2str(k_year),'/Administrative_CASM_by_Airline_',num2str(k_year),'.xlsx']);
                if table_number == 2
                    name_str = 'Total (excl. Transport-related) Cost per Available Seat Miles';
                elseif table_number == 2.1
                    name_str = 'Labor Cost per Available Seat Miles';
                elseif table_number == 2.2
                    name_str = 'Fuel Cost per Available Seat Miles';
                end
                y_str = {'Cost per Available Seat Miles','(USD$/ASM)'};
            elseif table_number == 3 % (3)
                imported_results = readtable(['AFAT Outputs/Cost Tables/',num2str(k_year),'/Administrative_Cost_per_Seat_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Cost per Seat';
                y_str = {'Cost per Seat','(USD$)'};
            elseif table_number == 4 % (4)
                imported_results = readtable(['AFAT Outputs/Cost Tables/',num2str(k_year),'/Administrative_Cost_per_RPM_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Cost per Revenue Passenger Miles';
                y_str = {'Cost per Revenue Passenger Miles','(USD$/RPM)'};
            elseif table_number == 5 % (5)
                imported_results = readtable(['AFAT Outputs/Cost Tables/',num2str(k_year),'/Administrative_Cost_per_Passenger_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Cost per Passenger';
                y_str = {'Cost per Passenger','(USD$)'};
            elseif table_number == 6 % (6)
                imported_results = readtable(['AFAT Outputs/Revenue Tables/',num2str(k_year),'/Revenue_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Revenue';
                y_str = {'Decomposed Revenue','(USD$)'};
            elseif sum(table_number == [7,7.1,7.2]) > 0 % (7) 
                imported_results = readtable(['AFAT Outputs/Revenue Tables/',num2str(k_year),'/RASM_by_Airline_',num2str(k_year),'.xlsx']);
                if table_number == 7
                    name_str = 'Total (excl. Transport-related) Revenue per Available Seat Miles';
                elseif table_number == 7.1
                    name_str = 'Scheduled Passengers Revenue per Available Seat Miles';
                elseif table_number == 7.2
                    name_str = 'Baggage Fees Revenue per Available Seat Miles';
                end
                y_str = {'Revenue per Available Seat Miles','(USD$/ASM)'};
            elseif table_number == 8 % (8)
                imported_results = readtable(['AFAT Outputs/Revenue Tables/',num2str(k_year),'/Revenue_per_Seat_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Revenue per Seat';
                y_str = {'Revenue per Seat','(USD$)'};
            elseif table_number == 9 % (9)
                imported_results = readtable(['AFAT Outputs/Revenue Tables/',num2str(k_year),'/Revenue_per_RPM_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Revenue per Revenue Passenger Miles';
                y_str = {'Revenue per Revenue Passenger Miles','(USD$/RPM)'};
            elseif table_number == 10 % (10)
                imported_results = readtable(['AFAT Outputs/Revenue Tables/',num2str(k_year),'/Revenue_per_Passenger_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Total (excl. Transport-related) Revenue per Passenger';
                y_str = {'Revenue per Passenger','(USD$)'};
            elseif table_number == 11 % (11)
                imported_results = readtable(['AFAT Outputs/Employee Tables/',num2str(k_year),'/Employees_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Employee Breakdown';
                y_str = {'Employee Breakdown','(# employees)'};
            elseif table_number == 12 % (12) 
                imported_results = readtable(['AFAT Outputs/Employee Tables/',num2str(k_year),'/ASMs_per_Employee_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Available Seat Miles per Employee';
                y_str = {'Available Seat Miles per Employee','(ASMs)'};
            elseif table_number == 13 % (13)
                imported_results = readtable(['AFAT Outputs/Employee Tables/',num2str(k_year),'/Labor_Cost_per_Employee_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Labor Cost per Employee';
                y_str = {'Labor Cost per Employee','(USD$)'};
            elseif table_number == 14 % (14)
                imported_results = readtable(['AFAT Outputs/Employee Tables/',num2str(k_year),'/Revenue_per_Employee_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Revenue per Employee';
                y_str = {'Revenue per Employee','(USD$)'};
            elseif table_number == 15 % (15)
                imported_results = readtable(['AFAT Outputs/Employee Tables/',num2str(k_year),'/ASMs_per_Labor_Cost_by_Airline_',num2str(k_year),'.xlsx']);
                name_str = 'Available Seat Miles per Labor Cost';
                y_str = {'Available Seat Miles per Labor Cost','(ASMs/USD$)'};
            end

            % Iterating through all desired airlines
            for k_airline = 1:n_selected_airlines
                Desired_Airline_In = find(strcmp(char(Desired_Airline{k_airline}),imported_results{:,1}) == 1);
                % Identifying special cases
                if isempty(Desired_Airline_In) == 1
                    Desired_Airline_In = length(imported_results{:,1});
                end
    
                % Extracting the values from the table
                if table_number < 12
                    if table_number == 2.1
                        plot_results(k_airline,year_counter) = imported_results{Desired_Airline_In,2};
                    elseif table_number == 2.2
                        plot_results(k_airline,year_counter) = imported_results{Desired_Airline_In,3};
                    elseif table_number == 7.1
                        plot_results(k_airline,year_counter) = imported_results{Desired_Airline_In,2};
                    elseif table_number == 7.2
                        plot_results(k_airline,year_counter) = imported_results{Desired_Airline_In,5};
                    else
                        plot_results(k_airline,year_counter) = imported_results{Desired_Airline_In,end-1};
                    end
                else
                    plot_results(k_airline,year_counter) = imported_results{Desired_Airline_In,end};
                end
            end
    
        end % End Tool Selection

        % Updating the year counter
        year_counter = year_counter + 1;
     
    end % End Year Iteration

    % Creating the figure
    figure
    for k_airline = 1:n_selected_airlines
        plot(Desired_Years,plot_results(k_airline,:),'LineWidth',1)
        hold on
    end
    xlabel('Year')
    ylabel(y_str)
    legend(Desired_Airline,'Location','Southoutside','NumColumns',n_selected_airlines)
    set(gca,'FontSize',15)
    set(gcf, 'Units', 'Normalized', 'Position', [0.2, 0.3, 0.6, 0.4]);

    % Saving the figure
    if Save_Tables == 1
        file_name = [name_str,'.png'];
        saveas(gcf, file_name)
        close(gcf)
    end

end % End Table Iteration