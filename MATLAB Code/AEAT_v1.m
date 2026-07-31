% ----------------------------------------------------------------------- %
% -------------- AIRCRAFT ENGINE ANALYSIS TOOL (AEAT) - v1 -------------- %
% ----------------------------------------------------------------------- %

% The following tool (AEAT) can be used to visualize a variety of aircraft
% age and ownership metrics across sub-fleets, airlines, or the entire US
% air transportation system. AEAT leverages open-source data from the US 
% Federal Aviation Administration (FAA), namely the FAA Tail Registry.
% Before using AEAT, please make sure to follow the instructions outlined 
% in: https://github.com/andyeske/Airline-Data-Analysis-Tools

% AEAT outputs a 2-by-2 plot, which includes:

% (1) Top Left: Histogram displaying age distribution of the selected
% aircraft or fleet.
% (2) Top Right: Aircraft survival curve, displaying the probability that
% an aircraft above a certain reference age will continue flying.
% (3) Bottom Left: Piechart displaying the number of aircraft in the fleet 
% (if just a single airline is selected), or number of airlines operating 
% the aircraft (otherwise).
% (4) Bottom Right: Piechart displaying the number of aircraft per engine
% family (e.g., CF-34).

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% The USER must specify the following three parameters, which include:

% Please input the Registration Status
% --> This choice influences whether the displayed data corresponds to
% currently registered aircraft (1) or de-registered aircraft (2)
Registration_Status = 1;

% Please input the Desired Aircraft: 
% --> This choice makes the displayed results aircraft-specific. 
% --> It is possible to input multiple aircraft types, separated by a
%     comma (e.g., Desired_Aircraft = {'B777-200','B777-200ER'})
% --> Leaving this entry blank will display results for all aircraft types 
%     for the Desired Airline.
% --> Permissible aircraft typs include:
%     B717-100 
%     B737-300  | B737-400    | B737-500   | B737-600 | B737-600 | B737-700
%     B737-800  | B737-900    | B737-900ER | B737-8   | B737-9
%     B747-400  | B737-400F   | B747-8     | B747-8F
%     B757-200  | B757-200ER  | B757-200F  | B757-300
%     B767-200  | B767-200ER  | B767-200F  | B767-300 | B767-300ER 
%     B767-300F | B767-400    | B767-400ER
%     B777-200  | B777-200ER  | B777-200LR | B777-300 | B777-300ER | B777F
%     B787-8    | B787-9      | B787-10
%     A319-100  | A320-100    | A320-200   | A320NEO  
%     A321-100  | A321-200    | A320NEO    | A321F
%     A330-200  | A330-200F   | A330-300   | A330-900
%     A340-200  | A340-300    | A340-500   | A340-600
%     A350-900
%     A220-300
%     Q100      | Q200        | Q300       | Q400
%     CRJ-200   | CRJ-550     | CRJ-700    | CRJ-900  | CRJ-1000
%     E135      | E145        | E170       | E190
%     DC-9      | DC-9F       | MD-80      | MD-90
%     DC-10     | DC-10F      | MD-11      | MD-11F
Desired_Aircraft = {};

% Please input the Desired Airline: 
% --> This choice will make the displayed results airline-specific.
% --> It is possible to input multiple airlines, separated by a comma
%     comma (e.g., Desired_Airline = {'DELTA AIR LINES INC','UNITED AIRLINES INC'})
% --> Leaving this entry blank will display results for all US airlines for 
%     the Desired Aircraft.
% --> Example airlines include and are not limited to:
%     ALASKA AIRLINES INC            | AMERICAN AIRLINES INC
%     DELTA AIR LINES INC            | JETBLUE AIRWAYS CORP
%     HAWAIIAN AIRLINES INC          | SKYWEST AIRLINES INC
%     SOUTHWEST AIRLINES CO          | SPIRIT AIRLINES LLC        
%     UNITED AIRLINES INC 
%     FEDERAL EXPRESS CORP           | UNITED PARCEL SERVICE CO
Desired_Airline = {'SPIRIT AIRLINES LLC'};

% Notes:
% a) The use can either leave "Desired_Aircraft" or "Desired_Airline"
% empty, but not both. Otherwise, it will trigger an error.

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 0: Checking empty inputs ------------------- %
if isempty(Desired_Aircraft) && isempty(Desired_Airline)
    error('"Desired_Aircraft" and "Desired_Airline" cannot be both left empty.')
end

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the FAA tail registry data
warning('off','all'); % Turning off import warnings 
if Registration_Status == 1
    opts = detectImportOptions('MASTER.txt');
    opts = setvartype(opts, 'string');
    tail_registry = readtable('MASTER.txt',opts); 
    tail_registry = tail_registry(:,[1,2,3,4,5,7]);
else
    opts = detectImportOptions('DEREG.txt');
    opts = setvartype(opts, 'string');
    tail_registry = readtable('DEREG.txt',opts); 
    tail_registry = tail_registry(:,[1,2,3,11,5,18,23]);
end

% Importing the aircraft and engine codes
codes = sheetnames('Tail Registry Aircraft Engine Codes.xlsx');
aircraft_codes = readtable('Tail Registry Aircraft Engine Codes.xlsx','Sheet',codes(1));
engine_codes = readtable('Tail Registry Aircraft Engine Codes.xlsx','Sheet',codes(2));
warning ('on','all'); % Turning on again warnings

%% -------------------- Step 2: Computing the table --------------------- %

% Checking for inputted data

% Finding the aircraft code and creating an initial table
n_aircraft_types = length(Desired_Aircraft);
if n_aircraft_types > 0
    aircraft_tails = [];
    for k_aircraft = 1:n_aircraft_types
        desired_aircraft_in = strcmp(Desired_Aircraft{k_aircraft},aircraft_codes{:,5});
        desired_aircraft_codes = aircraft_codes{desired_aircraft_in,2};
        n_aircraft_codes = length(desired_aircraft_codes);
        
        % Finding the tail numbers corresponding to the aircraft code
        for k_tails = 1:n_aircraft_codes
        
            aircraft_tails = [aircraft_tails;find(strcmp(tail_registry{:,3},desired_aircraft_codes{k_tails}) > 0)];
        
        end
    
    end
    % Note if no aircraft was found
    if isempty(aircraft_tails)
        error('No aircraft on the tail registry meet the selected aircraft criteria.\nPlease check spelling or try a different aircraft.', '')
    end
    aircraft_table = tail_registry(aircraft_tails,:);

else
    disp('Note: no aircraft inputted.')
    disp('Defaulting to displaying aircraft-agnostic information.')
    aircraft_table = [];
end

% Finding the airline code
n_airlines = length(Desired_Airline);
if Registration_Status == 1
    tail_in = 6;
else
    tail_in = 5;
end
if n_airlines > 0 && ~isempty(aircraft_table)
    airline_tails = [];

    % Finding the aircraft corresponding to the airline
    for k_airline = 1:n_airlines
    
        airline_tails = [airline_tails;find(strcmp(aircraft_table{:,tail_in},Desired_Airline{k_airline}) > 0)];
    
    end
     % Note if no airline was found
    if isempty(aircraft_tails)
        error('No airline on the tail registry meet the selected aircraft criteria.\nPlease check spelling or try a different airline.', '')
    end
    aircraft_table = aircraft_table(airline_tails,:);

elseif n_airlines > 0 && isempty(aircraft_table)

    airline_tails = [];

    % Finding the aircraft corresponding to the airline
    for k_airline = 1:n_airlines
    
        airline_tails = [airline_tails;find(strcmp(tail_registry{:,tail_in},Desired_Airline{k_airline}) > 0)];
    
    end
     % Note if no airline was found
    if isempty(aircraft_tails)
        error('No airline on the tail registry meet the selected aircraft criteria.\nPlease check spelling or try a different airline.', '')
    end
    aircraft_table = tail_registry(airline_tails,:);

else
    disp('Note: no airline inputted.')
    disp('Defaulting to displaying airline-agnostic information.')
end

% Cleaning the aircraft table
if Registration_Status == 1
    aircraft_table = aircraft_table(~ismissing(aircraft_table{:,5}),:);
    aircraft_table = aircraft_table(~ismissing(aircraft_table{:,6}),:);

    % Computing the aircraft age and the mean
    aircraft_age = 2026 - str2double(aircraft_table{:,5});
    aircraft_table = [aircraft_table(:,1:4),num2cell(aircraft_age),aircraft_table(:,6)];
    
else
    aircraft_table = aircraft_table(~ismissing(aircraft_table{:,4}),:);
    aircraft_table = aircraft_table(~ismissing(aircraft_table{:,5}),:);
    aircraft_table = aircraft_table(~ismissing(aircraft_table{:,6}),:);
    aircraft_table = aircraft_table(~ismissing(aircraft_table{:,7}),:);

    % Finding the aircraft age
    dereg = round(double(aircraft_table{:,6})./10000);
    reg = round(double(aircraft_table{:,7})./10000);
    aircraft_age = dereg - reg;
    aircraft_table = [aircraft_table(:,1:4),num2cell(aircraft_age),aircraft_table(:,5)];

end

% Correcting for outliers
aircraft_table = aircraft_table(aircraft_table{:,5} < 40,:);

% Calculating the aircraft age statistics
aircraft_age = double(aircraft_table{:,5});
mean_age = mean(aircraft_age);
n_aircraft = length(aircraft_age);
max_age = max(aircraft_age);
year_vec = zeros(1,max_age);

%% ------------------ Step 3: Creating the output plot ------------------ %

if n_aircraft > 0
    % Creating the tiled plot
    t = tiledlayout(2,2);
    
    % Computing the age histogram
    nexttile
    histogram(aircraft_age,20,'FaceColor',[0.8 0.8 0.8]);
    xline(mean_age,'--k',['Mean Age = ',num2str(round(mean_age,1)),' years'],...
        'LineWidth',2,'FontSize',12,'LabelVerticalAlignment', 'middle','LabelHorizontalAlignment','center')
    ylabel('Number of Aircraft')
    xlabel('Aircraft Age (years)')
    title('Aircraft Age Distribution')
    set(gca,'FontSize',15)
    
    % Computing the cumulative age histogram
    nexttile
    for k_years = 1:max_age
            
        year_vec(k_years) = 100*sum(aircraft_age >= k_years)/n_aircraft;
    
    end
    plot(1:max_age,year_vec,'o-','Color',[0.4 0.4 0.4],'LineWidth',1)
    xlabel('Reference Age (years)')
    ylabel('Fleet with Age >= Reference Age (%)')
    title('Aircraft Survival Curve')
    set(gca,'Fontsize',15)
    
    % Computing the airline piechart
    nexttile
    if n_airlines ~= 1
        [count,airlines] = groupcounts(aircraft_table{:,6});
        count_per = count/n_aircraft;
        disp_names = find(count_per > 0.05);
        others = find(count_per <= 0.05); cum_count_others = sum(count(others));
        if cum_count_others > 0 
            data = [count(disp_names);cum_count_others]';
            legends = {airlines{disp_names},'OTHERS'};
        else
            data = count(disp_names)';
            legends = {airlines{disp_names}};
        end
        p = piechart(data,legends,'LegendVisible','on','FontSize',15,'Colororder', hsv(length(data)));
        p.LabelStyle = "data";
        p.Title = 'Aircraft Owners';

    elseif n_airlines == 1

        [count,aircraft_num] = groupcounts(aircraft_table{:,3});
        aircraft_types = [];
        count_adapted = [];
        for k_aircraft = 1:length(aircraft_num)
            legends_in = find(strcmp(aircraft_num(k_aircraft),aircraft_codes{:,2}) > 0);
            aircraft_types = [aircraft_types;aircraft_codes{legends_in,5}];
            if ~isempty(legends_in)
                count_adapted = [count_adapted,count(k_aircraft)];
            end
        end
        [data,aircraft_groups] = groupsummary(count_adapted',string(aircraft_types),"sum");
        data_per = data/sum(data);
        disp_names = find(data_per > 0.015);
        others = find(data_per <= 0.015); cum_data_others = sum(data(others));
        if cum_data_others > 0 
            data = [data(disp_names);cum_data_others]';
            aircraft_groups = string({aircraft_groups{disp_names},'Other Aircraft'});
        end
        p = piechart(data,aircraft_groups,'LegendVisible','on','FontSize',15,'Colororder', hsv(length(data)));
        p.LabelStyle = "data";
        p.Title = 'Number of Aircraft in Fleet';

    end

    % Computing the engine piechart
    nexttile
    [count,engine_num] = groupcounts(aircraft_table{:,4});
    engine_num = double(engine_num);
    engine_types = [];
    count_adapted = [];
    for k_engines = 1:length(engine_num)
        legends_in = find(engine_num(k_engines) == engine_codes{:,2});
        engine_types = [engine_types;engine_codes{legends_in,5}];
        if ~isempty(legends_in)
            count_adapted = [count_adapted,count(k_engines)];
        end
    end
    [data,engine_groups] = groupsummary(count_adapted',string(engine_types),"sum");
    data_per = data/sum(data);
    disp_names = find(data_per > 0.015);
    others = find(data_per <= 0.015); cum_data_others = sum(data(others));
    if cum_data_others > 0 
        data = [data(disp_names);cum_data_others]';
        engine_groups = string({engine_groups{disp_names},'Other Engines'});
    end
    p = piechart(data,engine_groups,'LegendVisible','on','FontSize',15,'Colororder', hsv(length(data)));
    p.LabelStyle = "data";
    p.Title = 'Number of Aircraft with Engine Type';
    
    % Creating the title vector
    aircraft_title_vec = []; airline_title_vec = [];
    for k_aircraft = 1:n_aircraft_types
        if k_aircraft < n_aircraft_types(end)
            aircraft_title_vec = [aircraft_title_vec,Desired_Aircraft{k_aircraft},' | '];
        else
            aircraft_title_vec = [aircraft_title_vec,Desired_Aircraft{k_aircraft}];
        end
    end
    for k_airline = 1:n_airlines
        if k_airline < n_airlines(end)
            airline_title_vec = [airline_title_vec,Desired_Airline{k_airline},' | '];
        else
            airline_title_vec = [airline_title_vec,Desired_Airline{k_airline}];
        end
    end
    if isempty(Desired_Airline)
        airline_str = 'Airline = All US Airlines';
    else
        airline_str = ['Airline = ',airline_title_vec];
    end
    if isempty(Desired_Aircraft)
        aircraft_str = 'Aircraft Type = All Types in Fleet';
    else
        aircraft_str = ['Aircraft Type = ',aircraft_title_vec];
    end
    if Registration_Status == 1
        fleet_str = ['Current Fleet Count = ',num2str(n_aircraft),' Aircraft'];
        title(t,{airline_str,aircraft_str,fleet_str},'FontSize',18)
    else
        fleet_str = ['Retired Fleet Count = ',num2str(n_aircraft),' Aircraft'];
        title(t,{airline_str,aircraft_str,fleet_str},'FontSize',18)
    end
    set(gcf, 'Units', 'Normalized', 'Position', [0.02, 0.1, 0.96, 0.8]);   
end