%% Group7 Exercise 8 Function 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for creating the independent variables of the model

function previous_dailyPR = Group7Exe8Fun1(data,target_Date,days_back)
    greek_Data = Group7Exe8Fun3(data,target_Date,-(days_back +1),...
        {'NewCases','PCR_Tests','Rapid_Tests'});
    newCases = greek_Data.NewCases(2:(days_back +1));%Discarding the 31st previous day
    tests = greek_Data{:,2} + greek_Data{:,3};
    tests = tests(2:(days_back +1)) - tests(1:days_back);
    previous_dailyPR = newCases./tests;
end