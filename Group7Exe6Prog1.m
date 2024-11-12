%% Group7 Exercise 6 Program 1
%Georgios Kassavetakis 9154
%Stergios Grigoriou 9564

clc
clear
close all
%Data Read and Init
countrydata=readtable('EuropeanCountries.xlsx','PreserveVariableNames',true);
datatable=readtable('ECDC-7Days-Testing.xlsx');
g_data = readtable('FullEodyData.xlsx','PreserveVariableNames',true);
myCountry=countrydata.Country{5};
%Number of Top Countries to check for correlation
NofCountries = 2; 
%Test Init
Method1 = 'Bootstrap';
Method2 = 'Random Perm';
B = 10000;
alpha = 0.05;
%% Neighboors and Weeks 
%Taking The 5 Neighboors of my Country
neighbours=Group7Exe4Fun1(countrydata.Country,myCountry);
%Adding Greece
%We can search if Greece is inside or not to put it in the right place
%alphabetically
countries=[neighbours;{'Greece'}];
%Generate Weeks
weeks = Group7Exe1Fun2(13,38);
%% Table generation
sampleC = Group7Exe1Fun1(datatable,{'year_week','country','level'},...
    {weeks(:,2),neighbours,{'national'}},{'country','positivity_rate'});
sampleG = Group7Exe5Fun2(g_data,weeks(:,2));
%% Plot positivity_rate for each country
figure
clf
s2021 = zeros(length(countries),size(sampleG,1));
for i = 1:length(countries)
    if(i < length(countries))
        s2021(i,:) = sampleC(strcmp(sampleC.country,neighbours{i}),...
            2).positivity_rate';
    else
        s2021(i,:) = sampleG';
    end
    plot(1:size(s2021,2),s2021(i,:),'LineWidth',2)
    hold on
end
set(gca,'xtick',1:height(weeks),'xticklabel',weeks(:,2))
ylabel('$Positivity$ $rate$','Interpreter','latex','fontsize',12);
xlabel('$Weeks$','interpreter','latex','fontsize',12);
title('Positivity rate for the 5 neighbours and Greece',...
    'interpreter','latex')
legend(countries)
grid on
%% Pearson Estimator
%Calculate the Correlation r based on the 5 neighbours
r=zeros(length(neighbours),1);
Corrdata=cell(length(neighbours),1);

for i=1:length(neighbours)
    r(i)=diag(corr(s2021(i,:)',s2021(6,:)','Type','Pearson'))';
    Corrdata(i)={s2021([i 6],:)};
    disp(['Pearson Estimator between Greece and ',neighbours{i},' is: ',num2str(r(i)),''])
end
%Find the 2 closest countries
[~,in]=sort(r,'descend','ComparisonMethod','abs');
PairData=cell(NofCountries,1);
PairNeighbours=cell(NofCountries,1);
for i=1:NofCountries
disp(['Pearson Estimator ',iptnum2ordinal(i),' highest value is ',num2str(r(in(i))),''])
disp(['The correlation is calculated between Greece and ',neighbours{in(i)}])
PairData(i)=Corrdata(in(i));
PairNeighbours(i)=neighbours(in(i));
end
h=zeros(NofCountries,1);
p=zeros(NofCountries,1);
Methods={Method1, Method2};
stat=zeros(NofCountries,B);
for m=1:length(Methods)
    [h(m),p(m),stat(m,:)]=Group7Exe6Fun1(PairData{1}',PairData{2}',Methods{m},B,alpha);
end
%% Results of the Tests
Methods={Method1, Method2};
disp(['The ',num2str((1-alpha)*100),'% Significance Results:'])
for m=1:length(Methods)
    disp([char(9),'Results based on the ',Methods{m},' test:'])
    if h(m)
        disp([char(9),char(9),'The 2 correlations',...
            ' have statistically significant difference.'])
    else
        disp([char(9),char(9),'The 2 correlations',...
            ' do not have statistically significant difference.'])
    end
end
%The Correlation equality test results of 95% SI gave that the 2 biggest
%correlations do not statistically differ. 
%The Correlation test results for every sampling method match
%% Conclusion
% Although there is no significant correlation between Greece and Czechia 
% the test points that we cannot reject the hypothesis that Greece has the
% same correlation with both Coratia and Czechia.