%% Group 7 Exercise 9 Program 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
clc
clear 
close all
tic
%% Data import and constants
data = readtable('FullEodyData.xlsx','VariableNamingRule','preserve');
%The weeks we start gathering data ,'2020-W45''2021-W20'
%(11/2/20-24/01/21 and 17/05/21-15/08/21),'2021-W20'
week = {'2020-W45','2021-W20'}; %Supported input range: 20-W45 to 21-W39
number_of_days = 84;%Whole range of data
daily_pr_days = 30;
for i = 1:length(week)
   Group7Exe9Fun2(data,week(i),number_of_days,daily_pr_days);
end
%% Comments/Conclusions
% The results based on cross validation give a good approximation on how the
% model will generally react. In our case the best model results are the same 
% as in simple fitting with the PLS being the best model on both periods
% again. 
% On the first period Radj is quite good and we can say that our model can
% make some decent predictions. On the second period, we can't say the same
% though. However the PLSR model is still better than all the others, which
% have failed to return good results. In general we can say that there is
% some form of linear correlation between deaths from covid and previous
% days' positivity rates. However a better model probably would rise if 
% either we consider different aspects of the phenomenon (such as hospitalizations,
% age specific data etc) or if we try to combine it with a non linear
% approach.