%% Group7 Exercise 1 Function 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for data filtering

%data must be a table
%filterH are the column handles of the comparing data
%filterH = {'VarName1' 'VarName2' 'VarName3' ... 'VarNameN'}
%filterV must be a cell array of the filter celled variables 
%filterV = {cell_1 cell_2 cell_3 ... cell_N}
%col_name is the table_columns cell array of the columns wanted to
%return,and is skippable
%col_name = {'col1' 'col2' 'col3' ... 'colM'}

function newSample = Group7Exe1Fun1test(data,filterH,filterV,col_name)
    [~,k] = size(filterV);
    v_col = zeros(k,1);
    newSample = data;
    handles = newSample.Properties.VariableNames;
    for hs = 1:k
        v_col(hs) = find(strcmp(filterH(hs),handles));
    end
    %k is the number of variables
    for j = 1:k
        [n, ~] = size(filterV{:,j});
        [m, ~] = size(newSample);
        %ind = zeros(m,1);
        temp_filterV = filterV{1,j};
        if isnumeric(temp_filterV)||isdatetime(temp_filterV)
            ind = zeros(m,n);
            for i = 1:n
                for v = 1:m
                    ind(v,i) = isequal(newSample{v,v_col(j)},temp_filterV(i));
                end
                ind(:,1) = ind(:,1)+ ind(:,i); 
            end
            ind = logical(ind(:,1));
            newSample = newSample(ind,:);
        else
            ind = zeros(m,1);
            %n is the number of specific values of the current variable
            for i = 1:n
                ind = ind + strcmp(newSample{:,v_col(j)},temp_filterV{i});
            end
            ind = logical(ind);
            newSample = newSample(ind,:);
        end
    end
    if nargin < 4
        return
    else
        newSample = newSample(:,col_name);
    end
end