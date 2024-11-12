%% Group 7 Exercise 3 Program 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154

clc
clear 
close all
%% Data Import
eu_data = readtable('ECDC-7Days-Testing.xlsx');
%Columns:  1  country, 2 country_code, 3 year_week, 4 level, 5 region, 6
%region_name, 7 new_cases, 8 tests_done, 9 population, 10 testing_rate, 11
%positivity_rate, 12 testing_data_source
countries = readtable('EuropeanCountries.xlsx',...
    'VariableNamingRule','preserve');
%table2cell
countries = countries.Country;
countriesN = height(countries);
greek_data = readtable('FullEodyData.xlsx',...
     'VariableNamingRule','preserve');
%choosing our country
countryname = countries(5);
week_iterations = 12;
%We consider the data to end at 2021-W50 as asked
last_week = '2021-W50';
nofWeeksSearched = 30;
%% Finding the asked weeks
% We will check the last nofWeeksSearched weeks of data and pick the week 
% with the max PR for our country A.
weeks = Group7Exe1Fun2(nofWeeksSearched,last_week,0);
weeks = weeks(:,2);
our_country = Group7Exe1Fun1(eu_data,{'country','level','year_week'},...
    {countryname,{'national'},weeks},{'positivity_rate','year_week'});
our_country_PR = our_country.positivity_rate;
ind = find(our_country_PR == max(our_country_PR));
weeks = our_country.year_week{ind};
disp(['The last positivity rate "peak" for ',countryname{1},' is at week ',...
    weeks,'.'])
starting_Week = weeks;
weeks = Group7Exe1Fun2(week_iterations,starting_Week,0);
weeks = weeks(:,2);
disp(['So we choose to investigate from ',weeks{1},' to ',...
    weeks{week_iterations},'.'])
%% Calling the function week_iterations times to return the processed data
%[ci_greek_Weekly_PR,weekly_pr,mu_eu_PR,PR_difference]
ci_greek_Weekly_PR = zeros(2,week_iterations);
greek_weekly_PR = zeros(12,1);
mu_eu_PR = zeros(12,1);
PR_difference = zeros(12,1);
marker = zeros(12,1);
for i = 1:week_iterations
    [ci_greek_Weekly_PR(:,i),greek_weekly_PR(i),mu_eu_PR(i),PR_difference(i)]...
        = Group7Exe3Fun1(weeks{i},greek_data,eu_data,countries);
    if isequal(PR_difference(i),0)
        disp([weeks{i},...
            ': No statistically significant difference (a =0.05).'])
    elseif PR_difference(i) < 0
        diff = abs(PR_difference(i))*100;
        diff = num2str(diff);
        disp([weeks{i},': Greek positivity rate lower than EU average by ',...
            diff,'.'])
        marker(i) = 1;
    else
        diff = PR_difference(i)*100;
        diff = num2str(diff);
        disp([weeks{i},': Greek positivity rate higher than EU average by ',...
            diff,'.'])
        marker(i) = 1;
    end
end
%Marker to mark the significant-difference points on plot
marker = find(logical(marker));
%% Plotting data
figure('Name','Comparison','NumberTitle','off')
clf
hold on
plot(greek_weekly_PR,'-b')
plot(ci_greek_Weekly_PR(1,:),'--k')
plot(ci_greek_Weekly_PR(2,:),'--k')
plot(mu_eu_PR,'-xr','MarkerIndices',marker)
title('Greece vs EU COVID-19 positivity rate')
legend('Greek PR','95% C.I.','','EU PR')
set(gca,'xtick',1:12,'xticklabel',weeks)
xlabel('Examined Weeks')
ylabel('Positivity Rate')
grid on
hold off
%% Conclusion
% In the digramm we can see that for weeks 2021-W18 to 2021-W27 Greek
% positivity rate is statistically significantly higher than EU average.