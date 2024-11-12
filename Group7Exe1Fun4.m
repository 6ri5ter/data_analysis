%% Group7 Exercise 1 Function 4
%Stergios Grigoriou 9564
%Georgios Kassavetakis 9154
%% Function for distribution fitting test

%sample must be numerical vector
%distnames is a cell array
%alpha is a double with range (0,1)
function [h,p,df,pd] = Group7Exe1Fun4(sample,distnames,alpha,year)
    nBin = round(sqrt(length(sample)));
    h=zeros(length(distnames),1);
    p=zeros(length(distnames),1);
    df=zeros(length(distnames),1);
    pd = cell(length(distnames),1);
    for i=1:length(distnames)
        pd{i} = fitdist(sample,distnames{i});
        [h(i),p(i),stat] = chi2gof(sample,'NBins',nBin,'CDF',pd{i},'Alpha',...
            alpha,'EMin',3);
        df(i) = stat.df;
    end
    [p,indP] = sort(p,'descend');
    chosen_dist = distnames(indP(1:3));
%     figureTitle = [year,': alternative distributions fitted.'];
%     figure('Name',figureTitle,'NumberTitle','off')
%     tiledlayout(2,1)
%     for i = 1:2
%         nexttile
%         histfit(sample,nBin,chosen_dist{i+1})
%         pstr = num2str(p(i+1));
%         g_title = [chosen_dist{i+1},' p = ',pstr];
%         title(g_title)
%     end
%     figureTitle = [year,': chosen distribution.'];
%     figure('Name',figureTitle,'NumberTitle','off')
%     histfit(sample,nBin,chosen_dist{1})
%     pstr = num2str(p(1));
%     g_title = [chosen_dist{1},' p = ',pstr];
%     title(g_title)
end