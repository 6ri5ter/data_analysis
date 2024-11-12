%% Group 7 Exercise 4 Program 1
%Georgios Kassavetakis 9154
%Stergios Grigoriou 9564

clc
clear
close all

countrydata = readtable('EuropeanCountries.xlsx',...
    'PreserveVariableNames',true);
datatable = readtable('ECDC-7Days-Testing.xlsx');
myCountry = countrydata.Country{5};
alpha = 0.05;
B = 10000;
Method1 = 'Bootstrap';
Method2 = 'Random Perm';
%% Neighboors and Weeks 
%Taking The 5 Neighboors of my Country
neighbours = Group7Exe4Fun1(countrydata.Country,myCountry);
%Generate Weeks
weeks =  Group7Exe1Fun2(9,42,1);
%% Sample Generation
sample20 = Group7Exe1Fun1(datatable,{'year_week','country','level'},...
    {weeks(:,1),neighbours,{'national'}},{'country','positivity_rate'});
sample21 = Group7Exe1Fun1(datatable,{'year_week','country','level'},...
    {weeks(:,2),neighbours,{'national'}},{'country','positivity_rate'});
%% Main part
h=zeros(length(neighbours),2);
p=zeros(length(neighbours),2);
for n=1:length(neighbours)
    %% Country selection
    sample0 =  Group7Exe1Fun1(sample20,{'country'},{neighbours(n)},...
    {'positivity_rate'});
    sample1 =  Group7Exe1Fun1(sample21,{'country'},{neighbours(n)},...
    {'positivity_rate'});
	%% Kolomogorov-Smirnov Test
    [h(n,1),p(n,1),~,~,~]=Group7Exe2Fun1(sample0.positivity_rate,...
        sample1.positivity_rate,Method1,B,alpha);
    [h(n,2),p(n,2),~,~,~]=Group7Exe2Fun1(sample0.positivity_rate,...
        sample1.positivity_rate,Method2,B,alpha);
    %% Prints
    disp([neighbours{n},':'])
    fprintf('Kolmogorov - Smirnov test returns h = %d for Bootstrap method',...
    h(n,1))
    fprintf(' with p-value = %.4f.\n',p(n,1))
    fprintf('Kolmogorov - Smirnov test returns h = %d for Random Pemutation method',...
    h(n,2))
    fprintf(' with p-value = %.4f.\n\n',p(n,2))
    %% Hists
    figure('Name','Comparison','NumberTitle','off')
    histogram(sample0.positivity_rate,'Normalization','probability')
    hold on
    histogram(sample1.positivity_rate,'Normalization','probability')
    title(neighbours{n})
    xlabel('Positivity Rate')
    ylabel('Relative Frequency')
    legend('2020','2021')
end
%% Conclusion
% For the given periods we conclude that of the 5 countries studied only
% for Denmark we can't reject the null hypothesis that the distribution is
% the same. So we can conclude that generally speaking the positivity rates
% at the last 2 months of 2021 are statistically different (@95% signifi- 
% cance level) from those of 2020.