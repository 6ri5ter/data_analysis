%% Group7 Exercise 8 Function 2
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for duplication

function Group7Exe8Fun2(data, week, number_of_days, daily_pr_days,plotNum)
number_of_weeks_for_data = ceil(number_of_days / 7) + 6;
week1 = week{1};
year = str2double(week1(1:4));
if year == 2020
    week1 = str2double(week1(7:8)) - 6 - 53;
else
    week1 = str2double(week1(7:8)) - 6;
end
weeks = Group7Exe1Fun2(number_of_weeks_for_data,week1);
weeks = weeks(:,2);
% Keeping the needed data for the current week
data = Group7Exe1Fun1(data,{'Week'},{weeks});
starting_Date = Group7Exe1Fun1(data,{'Week','Day'},{week,1},{'Date'});
starting_Date = starting_Date.Date;
dates = datetime;%Creating the days of interest
for i = 1:number_of_days
    dates(i,1) = starting_Date + i - 1;
end
%% Creating the samples
death_table = Group7Exe8Fun3(data,starting_Date,number_of_days,...
    {'New_Deaths'});
daily_deaths_sample = death_table.New_Deaths;
array_of_previous_daily_PR = zeros(number_of_days,daily_pr_days);
for i = 1:number_of_days
    temp = Group7Exe8Fun1(data,dates(i),daily_pr_days);
    array_of_previous_daily_PR(i,:) = temp'*100; 
end
%% Fitting the models
%MSE = (1-Radj)*var(Y)
ols_mlr_model = fitlm(array_of_previous_daily_PR,daily_deaths_sample);
step_mlr_model = stepwiselm(array_of_previous_daily_PR,...
    daily_deaths_sample,'Upper','linear','Verbose',0,'Criterion',...
    'adjrsquared');
[bTruePCR,PCR_predictions,Rpcr,PCquant] = ...
    Group7Exe8Fun4(array_of_previous_daily_PR,daily_deaths_sample);
[lassoPredictions,Rlasso,bLasso,vars] = ...
    Group7Exe8Fun6(array_of_previous_daily_PR,daily_deaths_sample,300);
[bPLS,PLS_predictions,Rpls,PLScomp] = ...
    Group7Exe8Fun7(array_of_previous_daily_PR,daily_deaths_sample);
Rols = ols_mlr_model.Rsquared.Adjusted;
Rstep = step_mlr_model.Rsquared.Adjusted;
RMSEols = ols_mlr_model.RMSE;
RMSEstep = step_mlr_model.RMSE;
RMSEpcr = sqrt((1-Rpcr)*var(daily_deaths_sample));
RMSElasso = sqrt((1-Rlasso)*var(daily_deaths_sample));
RMSEpls = sqrt((1-Rpls)*var(daily_deaths_sample));
var_step = step_mlr_model.VariableInfo.InModel(1:(end-1));
%% Prints
name = ['From ', week{1},' through the end of ',weeks{number_of_weeks_for_data}...
    '.'];
disp(name)
fprintf('\nFull OLS model with %d predictors:\n',daily_pr_days)
fprintf('RMSE = %.2f,   Adjusted R^2: %.3f\n',RMSEols,Rols)
Group7Exe8Fun8(ols_mlr_model.Coefficients.Estimate)
fprintf('Stepwise model with %d predictors:\n',...
    (length(step_mlr_model.Coefficients.Estimate)-1))
fprintf('RMSE = %.2f,   Adjusted R^2: %.3f\n',RMSEstep,Rstep)
Group7Exe8Fun8(step_mlr_model.Coefficients.Estimate,var_step)
fprintf('PCR model with %d PCs:\n',PCquant)
fprintf('RMSE = %.2f,   Adjusted R^2: %.3f\n',RMSEpcr,Rpcr)
Group7Exe8Fun8(bTruePCR)
fprintf('PLS model with %d components:\n',PLScomp)
fprintf('RMSE = %.2f,   Adjusted R^2: %.3f\n',RMSEpls,Rpls)
Group7Exe8Fun8(bPLS)
fprintf('LASSO model with %d predictors:\n',vars)
fprintf('RMSE = %.2f,   Adjusted R^2: %.3f\n',RMSElasso,Rlasso)
Group7Exe8Fun8(bLasso)
R = [Rols,Rstep,Rpcr,Rpls,Rlasso];
Models = {'Full OLS';'Stepwise';'PCR';'PLS';'LASSO'};
%Sorting according to Rsquared adjusted
[R,ind] = sort(R,'descend');
Models = Models(ind);
Best = Models{1};
fprintf('The best model for this period of time is the %s model!\n\n',Best);
%% Plots
%Calculating residuals
ResOLS = ols_mlr_model.Residuals.Pearson;
ResStep = step_mlr_model.Residuals.Pearson;
ResPCR = (daily_deaths_sample - PCR_predictions)/sqrt((1/...
    (number_of_days-1-PCquant))*sum((daily_deaths_sample - ...
    PCR_predictions).^2));
ResPLS = (daily_deaths_sample - PLS_predictions)/sqrt((1/...
    (number_of_days-1-PLScomp))*sum((daily_deaths_sample - ...
    PLS_predictions).^2));
ResLASSO = (daily_deaths_sample - lassoPredictions)/sqrt((1/...
    (number_of_days-1-vars))*sum((daily_deaths_sample - ...
    lassoPredictions).^2));
Res = [ResOLS, ResStep, ResPCR, ResPLS, ResLASSO];
Ypre = [ols_mlr_model.predict, step_mlr_model.predict, PCR_predictions,...
    PLS_predictions, lassoPredictions];
Res = Res(:,ind);
Ypre = Ypre(:,ind);
%Plotting the plotNum first models
for i = 1:plotNum
    figure('Name',name)
    tiledlayout(2,1)
    nexttile
    plot(daily_deaths_sample)
    hold on
    plot(Ypre(:,i))
    xlabel('Days')
    ylabel('Deaths')
    legend('Actual','Predicted')
    grid on
    title(['The no',num2str(i),' best model is the ',Models{i},...
        ' model with Radj = ',num2str(R(i))])
    nexttile
    stem(Res(:,i))
    xlabel('Days')
    ylabel('Standarized Error')
    hold on
    yline(2,'r')
    yline(-2,'r')
    title('Standarized Residuals')
end
end