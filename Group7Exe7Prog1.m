%% Group7 Exercise 7 Program 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154

clc
clear
close all
%% Data Read and Init
countrydata=readtable('EuropeanCountries.xlsx','PreserveVariableNames',true);
datatable1=readtable('ECDC-7Days-Testing');
datatable2=readtable('ECDC-14Days-Cases-Deaths');
myCountry=countrydata.Country{5};
target_indicator='deaths';
levelarg='national';
alpha=0.05;
%% Starting weeks of the 2 Periods
startweeks=[{'2021-10'} {'2021-30'}];
startweeksW=[{'2021-W10'} {'2021-W30'}];
%Weeks before the Week we have
maxHysteresis=5; 
Period=16;
%% Loop preallocations
DataX=cell(maxHysteresis,length(startweeks));
DataY=cell(maxHysteresis,length(startweeks));
DataYhat=cell(maxHysteresis,length(startweeks));
tempX=cell(1,length(startweeks));
tempY=cell(1,length(startweeks));
B=cell(maxHysteresis,length(startweeks));
Bci=cell(maxHysteresis,length(startweeks));
RMSE=zeros(maxHysteresis,length(startweeks));
Rsq=zeros(maxHysteresis,length(startweeks));
adjRsq=zeros(maxHysteresis,length(startweeks));
%% Search for the best Hysterisis Model
for Hysteresis=1:maxHysteresis
    for w=1:length(startweeks)
        %Week Generation 
        firstweek=Group7Exe1Fun2(Hysteresis+1,startweeks{w},0);
        weeks=Group7Exe1Fun2(Hysteresis+Period,firstweek{1,2});
        weeks=weeks(:,2);
        firstweekW=Group7Exe1Fun2(Hysteresis+1,startweeksW{w},0);
        weeksW=Group7Exe1Fun2(Hysteresis+Period,firstweekW{1,2});
        weeksW=weeksW(:,2);        
        %Data Handle
        %Data filtering for 'ECDC-7Days-Testing' data
        ExaminedVals1={'country','year_week','level'};
        Filter1={{myCountry},weeksW,{levelarg}};
        ReturnVals1={'year_week','positivity_rate'};
        prdata=Group7Exe1Fun1(datatable1,ExaminedVals1,Filter1,ReturnVals1);
        %Data filtering for 'ECDC-14Days-Cases-Deaths' data
        ExaminedVals2={'country','indicator','year_week'};
        Filter2={{myCountry},{target_indicator},weeks};
        ReturnVals2={'year_week','weekly_count'};
        deathdata=Group7Exe1Fun1(datatable2,ExaminedVals2,Filter2,ReturnVals2);
        %Data to Array
        DataX(Hysteresis,w)={table2array(prdata(:,strcmp(prdata.Properties.VariableNames,ReturnVals1(end))))};
        DataY(Hysteresis,w)={table2array(deathdata(:,strcmp(deathdata.Properties.VariableNames,ReturnVals2(end))))};
        %Linear Regression Model
        %Taking data for the right Hysterisis
        [X,Y] = Group7Exe7Fun1(DataX{Hysteresis,w},DataY{Hysteresis,w},Hysteresis);
        tempX(w)={X};
        tempY(w)={Y};
        Xo=[ones(size(X)) X];
        [b,bci]=regress(Y,Xo,alpha);
        B(Hysteresis,w)={b};
        Bci(Hysteresis,w)={bci};
        Yhat=Xo*b;
        DataYhat(Hysteresis,w)={Yhat};
        %Metric Calculation for each Model
        [RMSE(Hysteresis,w),Rsq(Hysteresis,w),adjRsq(Hysteresis,w)]=Group7Exe7Fun2(Y,...
            Yhat,0);     
    end
    x=[tempX{1} tempX{2}];
    y=[tempY{1} tempY{2}];
    Yhat=[DataYhat{Hysteresis,1} DataYhat{Hysteresis,2}];
    figure('Name',['Model fitting for Hysteresis=',num2str(Hysteresis)],'NumberTitle','off')
    clf
    subplot(2,1,1)
    scatter(x(:,1),y(:,1))
    xlabel('$Positivity$ $rate$','Interpreter','latex','fontsize',12);
    ylabel('$Deaths/million$','interpreter','latex','fontsize',12);
    title(['Scatter Plot for Hysteresis=',num2str(Hysteresis),' for week 1'],...
        'interpreter','latex','fontsize',12)
    grid on
    hold on
    plot(x(:,1),Yhat(:,1))
    subplot(2,1,2)
    scatter(x(:,2),y(:,2))
    xlabel('$Positivity$ $rate$','Interpreter','latex','fontsize',12);
    ylabel('$Deaths/million$','interpreter','latex','fontsize',12);
    title(['Scatter Plot for Hysteresis=',num2str(Hysteresis),' for week 2'],...
        'interpreter','latex','fontsize',12)
    grid on
    hold on
    plot(x(:,2),Yhat(:,2))
end
%% Plot of the Normalised Error for Each Model
for Hysteresis=1:maxHysteresis
    %Plot the Errod diagram for Each Case 
    Yreal=[DataY{Hysteresis,1},DataY{Hysteresis,2}];
    Yreal=Yreal((1+Hysteresis):end,:);
    y_hat=[DataYhat{Hysteresis,1},DataYhat{Hysteresis,2}];
    e=Yreal-y_hat;
    se=sum(e.^2)/(size(e,1)-2);
    normE=e./se;
    figure('Name',['Hysteresis:',num2str(Hysteresis)],'NumberTitle','off')
    clf
    subplot(2,1,1)
    scatter(1:size(normE,1),normE(:,1))
    xlabel('$Number$ $of$ $Data$','Interpreter','latex','fontsize',12);
    ylabel('$normError$','interpreter','latex','fontsize',12);
    title(['Error Plot for Hysteresis=',num2str(Hysteresis),...
        ' for week Period ',num2str(1)],'interpreter','latex','fontsize',12)
    grid on
    hold on
    yline(norminv(alpha/2),'--r')
    yline(norminv(1-alpha/2),'--r')
    subplot(2,1,2)
	scatter(1:size(normE,1),normE(:,2))
    xlabel('$Number$ $of$ $Data$','Interpreter','latex','fontsize',12);
    ylabel('$normError$','interpreter','latex','fontsize',12);
    title(['Error Plot for Hysteresis=',num2str(Hysteresis),...
        ' for week Period ',num2str(2)],'interpreter','latex','fontsize',12)
    grid on
    hold on
    yline(norminv(alpha/2),'--r')
    yline(norminv(1-alpha/2),'--r')
end
%% Results based on the RMSE( from Training Test)
[~,ind]=min(RMSE);
disp('Results Based on the RMSE of each model:')
for i=1:length(ind)
    disp(['The best Model for the ',iptnum2ordinal(i),' Period searched',...
        ' came for the model with ',num2str(ind(i)),' week(s) Hysteresis.'])
end
if min(ind(1:end)==ind(1))
    disp('The Results agree!')
else
    disp('The Results do not agree!')
end
%% Plot of the 2 best models on the data
for w=1:length(startweeks)
    Xplot=DataX{ind(w),w};
    Xplot=Xplot(1:16);
    [Xplot,index]=sort(Xplot);
    Yplot=DataY{ind(w),w};
    Yplot=Yplot((ind(w)+1):end);
    Yhatplot=DataYhat{ind(w),w};
    figure('Name',['Best model week period ',num2str(w)],'NumberTitle','off')
    clf
    scatter(Xplot,Yplot(index,:))
    xlabel('$Positivity$ $rate$','Interpreter','latex','fontsize',12);
    ylabel('$Deaths/million$','interpreter','latex','fontsize',12);
    title(['Data Plot for Hysteresis=',num2str(ind(w))]...
        ,'interpreter','latex','fontsize',12)
    grid on
    hold on
    plot(Xplot,sort(Yhatplot))
end
%% Conclusion
% The best models for each period do not match. So we can assume that the
% observed phenomenon dependance varies with time. A more complete 
%(covering more time) model probably would require a combination of 
% hysteresis.  