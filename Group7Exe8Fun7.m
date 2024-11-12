%% Group7 Exercise 8 Function 7
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for fitting plsr model (adjR^2)

function [bTrue,ypre,R,ncomp,Xs] = Group7Exe8Fun7(X,Y)
    [m,n] = size(X);
    Radj = zeros(n,1);
    yfitPLS = zeros(m,n);
%     Xloadings = cell(n,1);
%     Yloadings = cell(n,1);
    Xscores = cell(n,1);
%     Yscores = cell(n,1);
    betaPLS = cell(n,1);
    for i = 1:n
        [~,~,Xscores{i},~,betaPLS{i}] = plsregress(X,Y,i,'cv',5);
        yfitPLS(:,i) = [ones(m,1) X]*betaPLS{i};
        Radj(i) = Group7Exe8Fun5(m,i,Y,yfitPLS(:,i));
    end
    %Optimizing for adjusted R^2
    ind = find(Radj == max(Radj));
    ypre = yfitPLS(:,ind);
    R = Radj(ind);
    ncomp = ind;
    bTrue = betaPLS{ind};
    Xs = Xscores{ind};
end