function [h,p,stat]=Group7Exe6Fun1(data1,data2,SampleMethod,B,alpha)
%Pearson Correlation Equality Test
%CAUTION: data need to have the observations on data(:,i) for i variable
%This function is made for 2 Variables
    data=[data1;data2];
    n=size(data1,1);
    m=size(data2,1);
    lim=[floor((B+1)*(alpha/2)) (B+1)*(1-alpha/2)];
    if strcmp(SampleMethod,'Bootstrap')
        %Bootstrap Sample of the Data
        stat=zeros(1,B);
        for iB=1:B
            bootData=data(unidrnd(n+m,n+m,1),:);
            sample1=bootData(1:n,:);
            sample2=bootData((n+1):(n+m),:);
            %Stat Calculation
            r1=corr(sample1(:,1),sample1(:,2),'Type','Pearson');
            r2=corr(sample2(:,1),sample2(:,2),'Type','Pearson');
            stat(iB)=r1-r2;
        end
    elseif  (strcmp(SampleMethod,'Random Perm'))
        %Random Permutation Sample of the Data
        stat=zeros(1,B);
        for iP=1:B
            permData=data(randperm(n+m,n+m)',:);
            sample1=permData(1:n,:);
            sample2=permData((n+1):(n+m),:);
            %Stat Calculation
            r1=corr(sample1(:,1),sample1(:,2),'Type','Pearson');
            r2=corr(sample2(:,1),sample2(:,2),'Type','Pearson');
            stat(iP)=r1-r2;
        end
    else
        disp('Wrong Sampling Method Used')
        h=0;
        p=NaN;
        stat=NaN;
        return
    end
    %Calculaton of the original samples stat
    r1_original=corr(data1(:,1),data1(:,2),'Type','Pearson');
    r2_original=corr(data2(:,1),data2(:,2),'Type','Pearson');
    stat_original=r1_original-r2_original;
    statA=[stat_original;stat'];
    [statA,r] = sort(statA);
    rank=find(r==1);
    %Strange Finds Handle
    rankA=find(statA==stat_original);
    if (length(rankA)==(B+1))
        rank=round(B/2);
    elseif (length(rankA)>=2)
        rank=rankA(unidrnd(length(rankA)));
    end
    %Test
    %P value calculation
    if (rank>0.5*(B+1))
        p=2*(1-rank/(B+1));
    else
        p=2*rank/(B+1);
    end
    if (rank<lim(1))||(rank>lim(2))
        h=1;
    else
        h=0;
    end
end
