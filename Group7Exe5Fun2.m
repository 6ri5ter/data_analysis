function week_pr = Group7Exe5Fun2(g_data,weeks)
    N = height(weeks);
    week_pr = zeros(N,1);
    for i = 1:N
        %% Week managing
        week = weeks{i};
        week_L = length(week);
        prev_week = str2double(week(week_L - 1:week_L)) - 1;
        if prev_week < 10
            if prev_week < 1
                year = str2double(week(1:4)) - 1;
                if year < 2020
                    disp('No data before 2020-W12.') 
                    disp('Please choose a further week.')
                    return
                else
                    year = num2str(year);
                    prev_week = [year,'-W53'];
                end
            else
            prev_week = num2str(prev_week);
            prev_week = [week(1:week_L-2),'0',prev_week];
            end
        else
            prev_week = num2str(prev_week);
            prev_week = [week(1:week_L-2),prev_week];
        end
        %% Data filtering
        Gdata = Group7Exe1Fun1(g_data,{'Week'},{{week}},{'NewCases',...
            'PCR_Tests','Rapid_Tests'});
        %Day seven of the previous week test numbers
        zeroDay =  Group7Exe1Fun1(g_data,{'Week','Day'},{{prev_week},7},...
            {'PCR_Tests','Rapid_Tests'});
        newCases = Gdata.NewCases;
        pcr = Gdata.PCR_Tests;
        rapid = Gdata.Rapid_Tests;
        rapid(isnan(rapid)) = 0;
        clear Gdata
        pcr0 = zeroDay.PCR_Tests;
        rapid0 = zeroDay.Rapid_Tests;
        rapid0(isnan(rapid0)) = 0;
        tests0 = pcr0+rapid0;
        clear zeroDay
        tests = pcr + rapid;
        tests = tests - [tests0; tests(1:6)];
        %% Finding Weekly PR for Greece
        week_pr(i) = sum(newCases)*100/sum(tests);
    end 
end