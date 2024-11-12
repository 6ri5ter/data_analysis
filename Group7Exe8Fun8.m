function Group7Exe8Fun8(b,var_in)
    
    fprintf('Formula: y ~ %.2f',b(1))
    
    if nargin < 2
        N = length(b) - 1;
        for i = 1:N
            varN = ['x',num2str(i)];
            if b(i+1) < 0 
                fprintf(' %.1f*%s',b(i+1),varN)
            elseif b(i+1) > 0 
                fprintf(' +%.1f*%s',b(i+1),varN)
            end
        end
    else
        N = length(var_in); 
        i = 1;
        for counter = 1:N
            varN = ['x',num2str(counter)];
            if i <= length(b) && var_in(counter) && b(i+1) < 0
                fprintf(' %.1f*%s',b(i+1),varN)
                i = i + 1;
            elseif i <= length(b) && var_in(counter) && b(i+1) > 0 
                fprintf(' +%.1f*%s',b(i+1),varN)
                i = i + 1;
            end
        end
    end
    fprintf('\n\n')
end