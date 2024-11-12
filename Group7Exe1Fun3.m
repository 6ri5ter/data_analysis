%% Group7 Exercise 1 Function 3
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for missiing data check

%data must be a table
%checkP must be an integer 
%data_col is the column used to compare
%data_cmp are the data used to compare our data and must be a table
%Use ind = for cmp array
function Group7Exe1Fun3(data,data_cmp,data_col,year,week)
    disp(['Missing data check for Year ',year,'.'])
    N = height(data);
    checkP = height(data_cmp);
    ind = zeros(checkP,1);
    if (N < checkP)
        for i = 1:N
            ind = ind + strcmp(data_cmp,data{i,data_col});
        end
        ind = ~logical(ind);
        missingData = data_cmp(ind);
        for i = 1:height(missingData)
            disp(['No data for week ',week,' for ',missingData{i},'.'])
        end
    else
        %ind = uint8.empty;
        disp(['No missing data for year ',year,' and week ',week,'.']) 
    end   
end