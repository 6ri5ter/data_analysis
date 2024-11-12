function [RMSE,Rsq,adjRsq] = Group7Exe7Fun2(Y,Yhat,k)
%Function to Return the Models Metrics for comparison
    n=length(Y);
    if n~=length(Yhat)
        disp('Y and Yhat dimentions need to match')
        RMSE=NaN;
        Rsq=NaN;
        adjRsq=NaN;
        return
    end
    %Metrics Calculation
	e = Y-Yhat;
    %Alternative: RMSE=sqrt(sum(e.^2))/sqrt(length(e));
    RMSE=sqrt(var(e)*(length(e)-1)/length(e));
    %Alternative:  Rsq = 1-(sum(e.^2))/(sum((Y-mean(Y)).^2));
    Rsq = 1-(sum(e.^2))/(var(Y)*(length(Y)-1));
    adjRsq=1-((n-1)/(n-(k+1)))*(sum(e.^2)/((n-1)*var(Y)));
end

