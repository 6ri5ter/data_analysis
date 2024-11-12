%% Group 7 Exercise 2 Program 1
%Georgios Kassavetakis 9154
%Stergios Grigoriou 9564

% clc
% clear 
% close all
%% Init
alpha=0.05;
B=1000;
Method1='Bootstrap';
Method2='Random Perm';
Method3='Error Test';
%% Data Import
data = readtable('ECDC-7Days-Testing.xlsx');
%Columns:  1  country, 2 country_code, 3 year_week, 4 level, 5 region, 6
%region_name, 7 new_cases, 8 tests_done, 9 population, 10 testing_rate, 11
%positivity_rate, 12 testing_data_source
countries = readtable('EuropeanCountries.xlsx','VariableNamingRule',...
    'preserve');
%table2cell
countries = countries.Country;
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
figure('Name','A look on the data','NumberTitle','off')
clf
histogram(sample20,5,'Normalization','probability')
hold on
histogram(sample21,5,'Normalization','probability')
legend(weeks{1},weeks{2})
title('Histogram for comparison')
xlabel('Positivity Rate')
ylabel('Relative Frequency')
%% Main Part
%Group7Exe2Fun1 is the Kolmogorov Smirnof Test
[h1,p1,stat1,cdfx1,cdfy1]=Group7Exe2Fun1(sample20,sample21,Method1,B,alpha);
[h2,p2,stat2,cdfx2,cdfy2]=Group7Exe2Fun1(sample20,sample21,Method2,B,alpha);
fprintf('\nKolmogorov - Smirnov test returns h = %d for Bootstrap method',...
    h1)
fprintf(' with p-value = %.4f.\n',p1)
fprintf('Kolmogorov - Smirnov test returns h = %d for Random Pemutation method',...
    h2)
fprintf(' with p-value = %.4f.\n',p2)
%% Conclusion
% With a first look on the data we could say that the 2 distributions have
% some similarities but don't exaclty look alike.
% However, the test shows that we can't reject the null hypothesis that the 
% 2 distributions are the same. So we assume they aren't different at a 95%
% statistical significance level. 