%% Group7 Exercise 8 Function 3
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for 30 days in a row data filtering

%It takes a date and returns the data of the previous 31 in
%chronological order.
%data must be a table
%date must be datetime
%col_n is the table_columns cell array of the columns wanted to
%return and is skippable
%col_n = {'col1' 'col2' 'col3' ... 'colM'}

function sample = Group7Exe8Fun3(data,date,nofdays,col_n)
    n = size(data,1);
    ind = 0;
    date1 = date;
    if nofdays < 0
        date1 = date + nofdays;
    end
    for i = 1:n
        if isequal(data{i,1},date1)
            ind = i;
        end
    end
        ind2 = ind + abs(nofdays) - 1;
    if nargin < 4
        sample = data(ind:ind2,:);
    else
        sample = data(ind:ind2,col_n);
    end
end