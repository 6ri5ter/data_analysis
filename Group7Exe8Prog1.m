%% Group 7 Exercise 8 Program 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
clc
clear 
close all
%% Data import and constants
data = readtable('FullEodyData.xlsx','PreserveVariableNames',true);
%The weeks we start gathering data ,'2020-W45''2021-W20'
%(11/2/20-24/01/21 and 17/05/21-15/08/21)
week = {'2020-W45','2021-W20'}; %Supported input range: 20-W45 to 21-W39
number_of_days = 84;%7*12
daily_pr_days = 30;
plotNum = 2; %For how many models to return the plots? (sorted with
             %descending Radj)
%% Main function 
for i = 1:length(week)
   Group7Exe8Fun2(data,week(i),number_of_days,daily_pr_days,plotNum);
end
%% Conclusions
% We observe that with fitting criterion the adjusted R^2 the best model
% is the same for both periods. And is the PLS regression model. We also
% observe that in both periods according to dimension reduction the models
% tested are ranked PLS < PCR/Stepwise < LASSO < OLS. The OLS is the worst
% overall with the lowest Radj in both periods. 
% On the second period specifically  it is easily noted that all models
% weigh more the 15th previous and the 20th previous day. Generally all
% models show similarities considering predictor weights, reavealling that
% the data may be linearly connected. The similarities on the predictor 
% weights also shows that all the models did a good job at identifying the 
% most important variables.
