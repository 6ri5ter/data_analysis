%% Group7 Exercise 8 Function 5
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for finding adjR^2

function r = Group7Exe8Fun5(n,k,Ytrue,Ypred)
 r = 1-((n-1)/(n-k-1))*(sum((Ytrue-Ypred).^2))/sum((Ytrue-mean(Ypred)).^2);
end