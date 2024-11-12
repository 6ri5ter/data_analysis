%% Group7 Exercise 8 Function 6
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for finding fitting lasso model (adjR^2)

function [ypre,r,bTrue,vars] = Group7Exe8Fun6(X,Y,m)
    [B,fi] = lasso(X,Y,'NumLambda',m);
    yl = fi.Intercept + X*B;
    subR = sum((Y-yl).^2)./sum((Y-mean(yl)).^2);
    r = zeros(m,1);
    [v,n] = size(X);
    idx = zeros(n,1);
    bestlasso = zeros(n,m);
    A = unique(fi.DF);
    for i = A(2:length(A))
        subRtemp = 1 - subR*(v-1)/(v-i-1);
        %Optimize for adjusted Rsquared
        bestlasso(i,:) = max(subRtemp(fi.DF == i));
        idx(i) = find(subRtemp == bestlasso(i,:));
        ypre = fi.Intercept(idx(i)) + X*B(:,idx(i));
        r(i) = Group7Exe8Fun5(v,i,Y,ypre);
    end
    idx = idx(r == max(r));
    %Returning adjusted Rsquared, dimension of predictors, predicted
    %responses
    r = max(r);
    vars = fi.DF(idx);
    ypre = fi.Intercept(idx) + X*B(:,idx);
    bTrue = [fi.Intercept(idx);B(:,idx)];
end