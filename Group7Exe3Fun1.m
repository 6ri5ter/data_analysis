%% Group7 Exercise 2 Function 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154

%% Function for data processing
%week must be from 2020-W15 to 2021-W50
%greek_data eu_data countries must be tables

function [ci_greek_Weekly_PR,weekly_pr,mu_eu_PR,PR_difference] =...
    Group7Exe3Fun1(week,greek_data,eu_data,countries)
    %% Week managing
    week_L = length(week);
    prev_week = str2double(week(week_L - 1:week_L)) - 1;
    if prev_week < 10
        if prev_week < 1
            year = str2double(week(1:4)) - 1;
            if year < 2020
                disp('No data before 2020-W12.') 
                disp('Please choose a further week.')
                return
            else
                year = num2str(year);
                prev_week = [year,'-W53'];
            end
        else
        prev_week = num2str(prev_week);
        prev_week = [week(1:week_L-2),'0',prev_week];
        end
    else
        prev_week = num2str(prev_week);
        prev_week = [week(1:week_L-2),prev_week];
    end
    %% Data filtering
    Gdata = Group7Exe1Fun1(greek_data,{'Week'},{{week}},{'NewCases',...
        'PCR_Tests','Rapid_Tests'});
    %Day seven of the previous week test numbers
    zeroDay =  Group7Exe1Fun1(greek_data,{'Week','Day'},{{prev_week},7},...
        {'PCR_Tests','Rapid_Tests'});
    newCases = Gdata.NewCases;
    pcr = Gdata.PCR_Tests;
    rapid = Gdata.Rapid_Tests;
    clear Gdata
    pcr0 = zeroDay.PCR_Tests;
    rapid0 = zeroDay.Rapid_Tests;
    clear zeroDay
    %% Finding PR and Weekly PR for Greece
    %daily_pr = zeros(7,1);
    %
    for i = 1:6
        pcr(8-i) = pcr(8-i) - pcr(7-i);
        rapid(8-i) = rapid(8-i) - rapid(7-i);
        %daily_pr(8-i) = newCases(8-i)/(pcr(8-i)+rapid(8-i));
    end
    pcr(1) = pcr(1)- pcr0;
    rapid(1) = rapid(1) - rapid0;
    %daily_pr(1) = newCases(1)/(pcr(1)+rapid(1));
    dailyTests = rapid + pcr;
    weekly_pr = sum(newCases)/sum(dailyTests);
    %% Finding the mean PR of the given 25 EU countries
    eu_pr = Group7Exe1Fun1(eu_data,{'year_week','level','country'},...
        {{week},{'national'},countries},{'new_cases','tests_done'});
    newCases_eu = eu_pr.new_cases;
    newCases_eu = sum(newCases_eu);
    totalTests_eu = eu_pr.tests_done;
    totalTests_eu = sum(totalTests_eu);
    mu_eu_PR = newCases_eu/totalTests_eu;
    %% Comparing greek PR with europe's for the given week.
    ci_greek_Weekly_PR = bootci(10000,(@(newCases,dailyTests)...
        sum(newCases)/sum(dailyTests)),newCases,dailyTests);
    PR_difference = 0;
    if mu_eu_PR < ci_greek_Weekly_PR(1)
        PR_difference = ci_greek_Weekly_PR(1) - mu_eu_PR;
    elseif mu_eu_PR > ci_greek_Weekly_PR(2)
        PR_difference = ci_greek_Weekly_PR(2) - mu_eu_PR;
    end
end