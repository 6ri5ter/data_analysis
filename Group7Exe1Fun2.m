%% Group 7 Exercise 1 Function 2
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Week generator

%nofweeks (int > 0) declares how many weeks to generate.
%week (int or 'NNNN-WNN' or 'NNNN-NN') is the starting week.
%Set control = 0 for descending cell array of weeks.
%The function returns weeks of 2019/2020 on the first column and weeks of 
%2020/2021 on the second.
%Stay between the range of 2020-W15 and 2021-W50
function weeks = Group7Exe1Fun2(nofweeks,week,control)
    weeks = {};
    if(nargin < 3)
        control = true;
    end
    if control
        if isnumeric(week)
            weeks = ifnumW(week,nofweeks,1);
        elseif ischar(week)
            len = length(week);
            weeknum = betweenYears(week,len);
            if len == 8 
                weektype = true;
            elseif len == 7
                weektype = false;
            else
                disp(['Week must be either a carachter array (depending ',...
                    'the form it has in the data either NNNN-WNN or NNNN',...
                    '-NN) or numerical.'])
                return
            end
            if isnan(weeknum)
                return
            end
            weeks = ifnumW(weeknum,nofweeks,weektype);
        else
            disp('Week must be either numerical or charachter array')
            return
        end
    else
        if isnumeric(week)
            week = week - nofweeks + 1;
            weeks = ifnumW(week,nofweeks,1);
        elseif ischar(week)
            len = length(week);
            weeknum = betweenYears(week,len) - nofweeks + 1;
            if len == 8 
                weektype = true;
            elseif len == 7
                weektype = false;
            else
                disp(['Week must be either a carachter array (depending ',...
                    'the form it has in the data either NNNN-WNN or NNNN',...
                    '-NN) or numerical.'])
                return
            end
            weeks = ifnumW(weeknum,nofweeks,weektype);
        else
            disp('Week must be either numerical or charachter array')
            return
        end
    end
    %% Main function
    function weeks = ifnumW(weekf,nowf,type)
        weeks = {nowf,2};
        controlv = false;
        if type 
            year1 = '2021-W';
            year2 = '2020-W';
            year3 = '2019-W';
        else
            year1 = '2021-';
            year2 = '2020-';
            year3 = '2019-';
        end
        if weekf < 1
            k = 0;
            t_week1 = 53 + weekf;
            for i = 1 : nowf
                t_week = t_week1 + i - 1;
                %We consider the year 2020 to end at 53th week.
                if t_week > 53 && ~controlv
                    t_week1 = 1;
                    t_week = 1;
                    t_week = num2str(t_week);
                    t_week = ['0',t_week];
                    weeks{i,1} = [year2,t_week];
                    weeks{i,2} = [year1,t_week];
                    controlv = true;
                    k = i;
                elseif controlv 
                    t_week = t_week -k + 1;
                    if t_week > 50
                        disp('Out of weeks range')
                    end
                    if t_week < 10
                        t_week = num2str(t_week);
                        t_week = ['0',t_week];
                    else
                        t_week = num2str(t_week);
                    end
                    weeks{i,1} = [year2,t_week];
                    weeks{i,2} = [year1,t_week];
                else
                    if t_week < 10
                        t_week = num2str(t_week);
                        t_week = ['0',t_week];

                    else
                        t_week = num2str(t_week);
                    end
                    weeks{i,1} = [year3,t_week];
                    weeks{i,2} = [year2,t_week];
                end
            end
        else
            for i = 1 : nowf
                t_week = weekf + i - 1;
                %We consider the year 2021 to end at 50th week.
                if t_week > 50
                    t_week = 1 - i;
                    weekf = 0;
                end
                if t_week < 10
                    t_week = num2str(t_week);
                    t_week = ['0',t_week];
                end
                t_week = num2str(t_week);
                weeks{i,1} = [year2,t_week];
                weeks{i,2} = [year1,t_week];
            end
        end
    end
    %% Managing year-passing

    function week_num = betweenYears(weekarg,lenarg)
        year = str2double(weekarg(1:4));
        if year == 2020
            week_num = str2double(weekarg((lenarg-1):lenarg)) - 53;
        elseif year == 2021
            week_num = str2double(weekarg((lenarg-1):lenarg));
        else
            disp('Week must be from 2020-W15 to 2021-W50.')
            week_num = NaN;
            return
        end
    end
end