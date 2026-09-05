% ----------------------------------------------------------------------- %
% -------------- AIRLINE NETWORK ANALYSIS TOOL (ANAT) - v1 -------------- %
% ----------------------------------------------------------------------- %

% The following tool (ANAT) can be used to visualize historical route 
% networks for different airlines in the US. ANAT leverages processed 
% open-source data from the US Bureau of Transportation Statistics (BTS), 
% namely the Form 41 Traffic - T-100 Segment (US Carriers Only) dataset. 
% Before using ANAT, please make sure to follow the instructions outlined 
% in: https://github.com/andyeske/Airline-Data-Analysis-Tools

% ANAT outputs a map plot displaying the route network of the airline in
% question for a selected year.

% ----------------------------------------------------------------------- %
% ------------------------- USER DEFINED INPUTS ------------------------- %
% ----------------------------------------------------------------------- %

% To generate the plots, the USER must specify a few parameters, which
% include:

% Please input the Desired Year: 
% --> The route network map will correspond to this year.
% --> The minimum year is 1990.
% --> The maximum year is 2025.
Desired_Year = 2025;

% Please input the Desired US Airline: 
% --> The route network map will correspond to this airline.
% --> You can use the table "Airline Codes" available in 
% https://github.com/andyeske/Airline-Data-Analysis-Tools to find the set 
% of US airlines available for selection. Navigate to the "Historical" tab
% to view the set of 47 airlines available for selection.
% --> Writing Desired_Airline = 'Total' returns the aggregated route
% network of all airlines in the US that operated during the selected year.
% --> It it possible to visualize the overlaid route networks of more than 
% one airline simultaneously, by writing their names in the vector below.
Desired_Airline = {'Total'};

% Please input the Desired US Airport: 
% --> The route network map will correspond to flights out of this airport.
% --> You can use the standard IATA 3-letter airport code.
% --> It it possible to visualize the route networks out of multiple
% airports at a time, by writing their names in the vector below.
% --> Leaving the vector empty displays the entire route network.
Desired_Airport = {'DEN'};

% ----------------------------------------------------------------------- %
% ----------------- DO NOT MODIFY CODE FROM HERE ONWARDS ---------------- %
% ----------------------------------------------------------------------- %

%% -------------------- Step 1: Importing the datasets ------------------ %

% Importing the input datasets
AirlineCodes = readtable('Airline Codes.xlsx','Sheet','Historical');
coordinates = readtable('US Airports Coordinates.csv'); 
n_airlines = length(Desired_Airline);

% Extracting dataset statistics and individual airline route networks
network = [];
in_airlines = [];
% Finding the sheetnames
shts = sheetnames(['ANAT Datasets/US Airline Networks - ',num2str(Desired_Year),'.xlsx']);
for k_airlines = 1:n_airlines

    % Finding the airline name
    airline_name = Desired_Airline{k_airlines};
    
    % Checking whether the airline operated during the year
    airline_logic = find(strcmp(shts,airline_name)>0);
    if isempty(airline_logic)
        disp([airline_name,' did not operate in ',num2str(Desired_Year)])
    else
        % Finding the airline index
        in_temp = find(strcmp(airline_name,AirlineCodes{:,2}));
        in_airlines = [in_airlines,in_temp];

        % Finding the airline network
        temp_network = readtable(['ANAT Datasets/US Airline Networks - ',num2str(Desired_Year),'.xlsx'],'Sheet',airline_name);
        network = [network;temp_network];
    end

end
AirlineCodes = AirlineCodes(in_airlines,:);
n_airlines = length(AirlineCodes{:,1});

% Isolating only for routes out of the desired airport
if ~isempty(Desired_Airport)

    % Finding the number of airports
    n_desired_airports = length(Desired_Airport);
    desired_airport_in = [];

    % Iterating through all airports
    for k_desired_airports = 1:n_desired_airports

       temp_in_ori = find(strcmp(Desired_Airport{k_desired_airports},network{:,2})>0);
       temp_in_dest = find(strcmp(Desired_Airport{k_desired_airports},network{:,3})>0);
       desired_airport_in = [desired_airport_in;temp_in_ori;temp_in_dest];

    end

    % Adjusting the network for only these desired airports
    network = network(desired_airport_in,:);
end

%% --------------------- Step 2: Creating the plots --------------------- %

% Colors
water = [199,235,251]./255;
north_am = [238,238,238]./255;
united_states = [243,205,160]./255;
airline_colors = hsv(n_airlines);   

% Map Plot
figure
ax = gca;
patch([-128,-63,-63,-128],[23,23,51,51],water,'FaceAlpha', 0.3); hold on
borders('United States','FaceColor',united_states,'LineWidth',1,'EdgeColor',[0.7 0.7 0.7]); hold on
borders('Canada','FaceColor',north_am,'LineWidth',0.5,'EdgeColor',[0.7 0.7 0.7]); hold on
borders('Mexico','FaceColor',north_am,'LineWidth',0.5,'EdgeColor',[0.7 0.7 0.7]); hold on
plot([-128,-63,-63,-128,-128],[23,23,51,51,23],'k','LineWidth',1); hold on

% Map Limits
ylim([23,51])
xlim([-128,-63])

box off
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];
set(ax, 'XTickLabel', []); 
set(ax, 'YTickLabel', []); 

% Finding the domestic network
domestic_in = find(strcmp(network{:,9},'Domestic')>0);
network = network(domestic_in,:);

% Finding the distinct airlines and their indeces
n_airline_routes = [];
unique_airline_codes = AirlineCodes{:,1};
unique_airline_names = AirlineCodes{:,2};
for k_airline = 1:n_airlines
    airline_in = find(strcmp(unique_airline_codes{k_airline},network{:,1}));
    n_airline_routes = [n_airline_routes,airline_in(1)];
end

% Finding the set of unique airports served
unique_airports = unique([network{:,2};network{:,3}]);
n_airports = length(unique_airports);

% Selecting departures as the metric to plot
metric = network{:,4};
n_routes = length(metric);
max_metric = max(metric);
airport_metric = zeros(n_airports,3);

% Ploting the routes
for k_route = 1:n_routes
    
    % Finding the airport names
    ori_name = network{k_route,2};
    dest_name =  network{k_route,3};

    % Finding the airport indeces
    ori_in = find(strcmp(ori_name,coordinates{:,1}) > 0);
    dest_in =  find(strcmp(dest_name,coordinates{:,1}) > 0);
    airport_ori_in = find(strcmp(ori_name,unique_airports) > 0);
    airport_dest_in = find(strcmp(dest_name,unique_airports) > 0);

    % Finding the airport coordinates
    origin_lat = coordinates{ori_in(1),2};
    origin_lon = coordinates{ori_in(1),3};
    dest_lat = coordinates{dest_in(1),2};
    dest_lon = coordinates{dest_in(1),3};

    % Finding the airline code and index
    airline_code = network{k_route,1};
    airline_in = find(strcmp(airline_code,AirlineCodes{:,1})>0);

    % Establishing the line thickness and plotting
    line_thickness = 0.5 + 3*metric(k_route)./max_metric;
    h(k_route) = plot([origin_lon dest_lon],[origin_lat dest_lat],'LineWidth',line_thickness,'Color',airline_colors(airline_in,:));

    % Populating the airport metric
    airport_metric(airport_ori_in,1) = airport_metric(airport_ori_in,1) + metric(k_route);
    airport_metric(airport_dest_in,1) = airport_metric(airport_dest_in,1) + metric(k_route);
    airport_metric(airport_ori_in,2) = origin_lat;
    airport_metric(airport_ori_in,3) = origin_lon;
    airport_metric(airport_dest_in,2) = dest_lat;
    airport_metric(airport_dest_in,3) = dest_lon;

end

% Plotting the Airports
max_metric = max(airport_metric(:,1));
for k_airport = 1:n_airports

    % Only adding a label at those airports that saw service
    if airport_metric(k_airport,1) > 0
        % Finding the airport name
        airport_name = unique_airports{k_airport,1};
    
        % Finding the airport coordinates
        airport_lat = airport_metric(k_airport,2);
        airport_lon = airport_metric(k_airport,3);
            
        % Creating the airport marker
        circle_size = 5 + 15*airport_metric(k_airport,1)./max_metric;
        plot(airport_lon,airport_lat,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerSize',circle_size)
    end

end

% Adding the airport labels
for k_airport = 1:n_airports

    % Only adding a label at those airports that saw service
    if airport_metric(k_airport,1) > 0
        % Finding the airport name
        airport_name = unique_airports{k_airport,1};
    
        % Finding the airport coordinates
        airport_lat = airport_metric(k_airport,2);
        airport_lon = airport_metric(k_airport,3);

        % Check whether the airport name is one of the Desired Airports
        airport_in = find(strcmp(airport_name,Desired_Airport) > 0);
            
        % Adding the airport names if they saw more than 100 daily
        % departures
        if airport_metric(k_airport,1) > 100*365 || ~isempty(airport_in)
           text(airport_lon-2,airport_lat,airport_name,'HorizontalAlignment','center',...
            'FontSize',15,'FontWeight','bold','Color',[0 0 0])  
        end
         
    end
      
end

% Unique Routes and Key Metrics
n_unique_routes = size(unique(network(:,2:3),'rows'));
n_unique_routes = n_unique_routes(1);
total_departures = round(sum(network{:,4})/1000,3,'significant');
total_passengers = round(sum(network{:,5})/(10^6),3,'significant');
total_seats = round(sum(network{:,6})/(10^6),3,'significant');
total_RPMs = round(sum(network{:,7})/(10^9),3,'significant');
total_ASMs = round(sum(network{:,8})/(10^9),3,'significant');
LF = round(100.*sum(network{:,7})./sum(network{:,8}),3,'significant');
if ~isempty(Desired_Airport)
    n_unique_routes = round(n_unique_routes/2);
    total_departures = round(sum(network{:,4})/1000,3,'significant');
    total_passengers = round(sum(network{:,5})/(10^6)/2,3,'significant');
    total_seats = round(sum(network{:,6})/(10^6)/2,3,'significant');
    total_RPMs = round(sum(network{:,7})/(10^9)/2,3,'significant');
    total_ASMs = round(sum(network{:,8})/(10^9)/2,3,'significant');
end

% Establishing the legend
legend(h(n_airline_routes),unique_airline_names,'Location','NorthEast','FontSize',15);

% Year Annotation
text(-64,24,['\bfYear:\rm ',num2str(Desired_Year)],'FontSize',15,'HorizontalAlignment','Right',...
    'EdgeColor', 'black','BackgroundColor','white','LineWidth', 1)

% Key Metrics Annotation

text(-127,27.5,{'\bfKey metrics:\rm',...    
            ['\bfTotal unique routes:\rm ',num2str(n_unique_routes)],...
            ['\bfTotal departures:\rm ',num2str(total_departures),' (thousand)'],...
            ['\bfTotal passengers:\rm ',num2str(total_passengers),' (million)'],...
            ['\bfTotal seats:\rm ',num2str(total_seats),' (million)'],...
            ['\bfTotal RPMs:\rm ',num2str(total_RPMs),' (billion)'],...
            ['\bfTotal ASMs:\rm ',num2str(total_ASMs),' (billion)'],...
            ['\bfAverage LF:\rm ',num2str(LF),'%']},...
            'FontSize',15,'HorizontalAlignment','left',...
            'EdgeColor', 'black','BackgroundColor','white','LineWidth', 1)

set(gcf, 'Units', 'Normalized', 'Position', [0.1, 0.15, 0.8, 0.7]);