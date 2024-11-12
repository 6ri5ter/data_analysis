%% Group 7 Exercise 1 Program 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
clc
clear 
close all
%% Data Import
data = readtable('ECDC-7Days-Testing.xlsx');
%Columns:  1  country, 2 country_code, 3 year_week, 4 level, 5 region, 6
%region_name, 7 new_cases, 8 tests_done, 9 population, 10 testing_rate, 11
%positivity_rate, 12 testing_data_source
countries = readtable('EuropeanCountries.xlsx','PreserveVariableNames',true);
%table2cell
countries = countries.Country;
alpha=0.05;
%AEMmod25 + 1 = 5,15, We choose country 5 Cyprus.
countryname = countries(5);
%% Sample generation
%Weeks generation
weeks = Group7Exe1Fun2(6,45);
%Data narrowing
cData = Group7Exe1Fun1(data,{'year_week','country','level'},{weeks(:,1),...
    countryname,{'national'}},{'positivity_rate'});
clear countryname
%PR comparing
cPr = cData.positivity_rate;
%Chosen weeks. weeks(1) = week of 2020 and weeks(2) = week of 2021 
weeks = weeks((cPr == max(cPr)),:);
clear cData cPr
disp(['The chosen week of 2020 is: ',weeks{1}]);
disp(['The chosen week of 2021 is: ',weeks{2}]);
%% Week 2020 and Week 2021 Sample 
sample20 = Group7Exe1Fun1(data,{'year_week','country','level'},...
    {weeks(1),countries,{'national'}},{'country','positivity_rate'});
sample21 = Group7Exe1Fun1(data,{'year_week','country','level'},...
    {weeks(2),countries,{'national'}},{'country','positivity_rate'});
clear data
%Missing data check
Group7Exe1Fun3(sample20,countries,1,'2020',weeks{1});
Group7Exe1Fun3(sample21,countries,1,'2021',weeks{2});
clear countries countriesN
%Refining data
sample20 = sort(sample20.positivity_rate);
sample21 = sort(sample21.positivity_rate);
%% Histograms
% figure('Name','A look on the data')
% clf
% histogram(sample20,5,'Normalization','probability')
% legend(weeks{1})
% title('Histogram for fitting assumption')
% xlabel('Positivity Rate')
% ylabel('Relative Frequency')
% figure('Name','A look on the data')
% clf
% histogram(sample21,5,'Normalization','probability')
% legend(weeks{2})
% title('Histogram for fitting assumption')
% xlabel('Positivity Rate')
% ylabel('Relative Frequency')
%% Dist fitting
distnames = {'Exponential';'Extreme Value';'Half Normal';'Nakagami';...
    'Normal';'Rayleigh';'Rician'};
    %'BirnbaumSaunders';'InverseGaussian';'Poisson';'Generalized Pareto';
    %'Lognormal';Gamma';'Logistic';'Loglogistic';
[h20,p20,df20] = Group7Exe1Fun4(sample20,distnames,alpha,'2020');
[h21,p21,df21] = Group7Exe1Fun4(sample21,distnames,alpha,'2021');
%% Conclusion 
% Both disttribuitions show a decent Half Normal fit based on the chi 
% square goodness of fit test. Although the type of the best fitted
% distribution is the same, the 2 distributions are not the same based on
% their parameters. This comment applies onnly for the Country of choice.