%% Group7 Exercise 8 Function 4
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for fitting the best PCR model (Radj)

function [bTrue,Ypred,Radj,PCquant,Vog] = Group7Exe8Fun4(X,Y)
    % PCA analysis on predictor data
    Xcent = X - mean(X) ;
    [V,scores] = pca(Xcent);
    n = size(Xcent,2);
    Radj = zeros(n,1);
    models = cell(n,1);
    for i = 1:n
        models{i} = fitlm(scores(:,1:i),Y);
        Radj(i) = models{i}.Rsquared.Adjusted;
    end
    PCquant = find(Radj == max(Radj));
    Vog = V(:,1:PCquant);
    model = models{Radj == max(Radj)};
    b = model.Coefficients.Estimate;
    bTrue = [b(1);Vog*b(2:end)];
    Radj = Radj(PCquant);
    Ypred = model.predict;
end