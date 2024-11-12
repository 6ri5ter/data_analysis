%% Group7 Exercise 5 Program 1
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
levelarg='national';
%Test Init
Method1='Parametric';
Method2='Bootstrap';
Method3='Random Perm';
B=10000;
alpha=[0.05 0.01];
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
for i=1:length(countries)
    if(i<length(countries))
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
% Corrdata=cell(length(neighbours),1);
hP=zeros(length(neighbours),length(alpha));
hB=zeros(length(neighbours),length(alpha));
hR=zeros(length(neighbours),length(alpha));
pP=zeros(length(neighbours),length(alpha));
pB=zeros(length(neighbours),length(alpha));
pR=zeros(length(neighbours),length(alpha));
for i=1:length(neighbours)
    r(i)=corr(s2021(i,:)',s2021(6,:)','Type','Pearson');
%     Corrdata(i)=s2021([i 6],:);
    disp(['Pearson Estimator between Greece and ',neighbours{i},' is: ',num2str(r(i)),''])
    %Test
    for j=1:length(alpha)
    [hP(i,j),pP(i,j),~]=Group7Exe5Fun1(s2021([i 6],:)',Method1,B,alpha(j));
    [hB(i,j),pB(i,j),~]=Group7Exe5Fun1(s2021([i 6],:)',Method2,B,alpha(j));
    [hR(i,j),pR(i,j),~]=Group7Exe5Fun1(s2021([i 6],:)',Method3,B,alpha(j));
    end
end
%% Results of the Tests
Methods={Method1,Method2,Method3};
for j=1:length(alpha)
    disp(['The ',num2str((1-alpha(j))*100),'% Significance Results:'])
    n={neighbours(logical(hP(:,j))), neighbours(logical(hB(:,j))),...
        neighbours(logical(hR(:,j)))};
    for m=1:length(Methods)
        disp([char(9),'Results based on the ',Methods{m},' test'])
        pairs=n{m};
        for i=1:size(pairs,1)
        disp([char(9),char(9),'The pair Greece-',pairs{i},...
            ' has statistically non zero correlation'])
        end
    end
end
%% Conclusion
% Greece's positivity rate has statistically significant non zero 
% correlation with that of Croatia. (@99% significance level). However, no
% correlation with other countries is observed.
% On the diagram we observe that both Croatian and Greek PR peaks at the 
% same periods. 