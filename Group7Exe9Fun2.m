function Group7Exe9Fun2(data, week, number_of_days, daily_pr_days)
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
    [~,~,Rpcr,~,Vog] = ...
        Group7Exe8Fun4(array_of_previous_daily_PR,daily_deaths_sample);
    [~,Rlasso,bLasso,~] = ...
        Group7Exe8Fun6(array_of_previous_daily_PR,daily_deaths_sample,300);
    [~,~,Rpls,~,Xs] = ...
        Group7Exe8Fun7(array_of_previous_daily_PR,daily_deaths_sample);
    Rols = ols_mlr_model.Rsquared.Adjusted;
    Rstep = step_mlr_model.Rsquared.Adjusted;
    
    var_step = step_mlr_model.VariableInfo.InModel(1:(end-1));
    BL = bLasso(2:end);
    Xols = array_of_previous_daily_PR;
    Xstep = array_of_previous_daily_PR(:,(var_step ~=0));
    Xpca = array_of_previous_daily_PR*Vog;
%     Xpls = [ones(number_of_days,1) Xs]; to crossval den xreiazetai assous
    Xlasso = array_of_previous_daily_PR(:,(BL ~= 0));
    %% Crossval different models
    v = 5;
    errStep = zeros(v,1);
    errOLS = zeros(v,1);
    errpcr =  zeros(v,1);
    errlasso = zeros(v,1);
    errPLS = zeros(v,1);
    for i =1:v
        errStep(i) = crossval('mse',Xstep,daily_deaths_sample,...
            'Predfun',@Group7Exe9Fun1,'KFold',5);
        errOLS(i) = crossval('mse',Xols,daily_deaths_sample,...
            'Predfun',@Group7Exe9Fun1,'KFold',5);
        errpcr(i) = crossval('mse',Xpca,daily_deaths_sample,...
            'Predfun',@Group7Exe9Fun1,'KFold',5);
        errlasso(i) = crossval('mse',Xlasso,daily_deaths_sample,...
            'Predfun',@Group7Exe9Fun1,'KFold',5);
        errPLS(i) = crossval('mse',Xs,daily_deaths_sample,...
            'Predfun',@Group7Exe9Fun1,'KFold',5);
    end
    RolsCV = (var(daily_deaths_sample) - mean(errOLS))/var(daily_deaths_sample);
    RstepCV = (var(daily_deaths_sample) - mean(errStep))/var(daily_deaths_sample);
    RpcrCV = (var(daily_deaths_sample) - mean(errpcr))/var(daily_deaths_sample);
    RlassoCV = (var(daily_deaths_sample) - mean(errlasso))/var(daily_deaths_sample);
    RplsCV = (var(daily_deaths_sample) - mean(errPLS))/var(daily_deaths_sample);
    Rcv = [RolsCV, RstepCV, RpcrCV, RplsCV, RlassoCV];
    R = [Rols,Rstep,Rpcr,Rpls,Rlasso];
    [R, ind] = sort(R,'descend');
    [Rcv,indCV] = sort(Rcv,'descend'); 
    Models = {'Full OLS';'Stepwise';'PCR';'PLS';'LASSO'};
    Models = Models(indCV);
    name = ['From ', week{1},' through the end of ',weeks{number_of_weeks_for_data}...
    '.'];
    fprintf('%s\n\n',name)
    fprintf('In descending Radj order the models are: \n')
    for i = 1:5
        fprintf('%d) %s model with Radj =  %.3f\n',i,Models{i},Rcv(i))
    end
    fprintf('\n')
end
