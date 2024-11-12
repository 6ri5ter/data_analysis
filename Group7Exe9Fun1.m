%% Group7 Exercise 9 Function 1
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154

%% Function for crossval of the full 30-day model
function yfit = Group7Exe9Fun1(Xtrain,Ytrain,Xtest)
    n = size(Xtrain,1);
    m = size(Xtest,1);
    Xtrain = [ones(n,1), Xtrain];
    Xtest = [ones(m,1), Xtest];
    co = regress(Ytrain,Xtrain);
    yfit = Xtest*co;
    yfit = sum(yfit,2);
end