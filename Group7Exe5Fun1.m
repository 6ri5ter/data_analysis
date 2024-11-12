function [h,p,stat]=Group7Exe5Fun1(data,SampleMethod,B,alpha)
%Pearson Correlation zero value Test
%CAUTION: data need to have the observations on data(:,i) for i variable
%This function is made for 2 Variables
    n=size(data,1);
    lim=[floor((B+1)*(alpha/2)) (B+1)*(1-alpha/2)];
    %Original sample's Stat
	r0=corr(data(:,1),data(:,2),'Type','Pearson');
    t0=r0.*sqrt((n-2)./(1-r0.^2));
    if  (strcmp(SampleMethod,'Parametric'))
        %Parametric Test
        p=2*(1-tcdf(abs(t0),n-2));
        h=p<alpha;
        stat=r0;
        return
    elseif strcmp(SampleMethod,'Bootstrap')
        %Bootstrap Sample of the Data
        stat=zeros(1,B);
        for iB=1:B
            bootData = [data(unidrnd(n,n,1),1) data(unidrnd(n,n,1),2)];
            %Stat Calculation
            stat(iB)=corr(bootData(:,1),bootData(:,2),'Type','Pearson');
        end
        stat_original=r0;
    elseif  (strcmp(SampleMethod,'Random Perm'))
        %Random Permutation Sample of the Data
        stat=zeros(1,B);
        for iP=1:B
            permData= [data(randperm(n,n)',1) data(:,2)];
            %Stat Calculation
            r=corr(permData(:,1),permData(:,2),'Type','Pearson');
            stat(iP)=r*sqrt((n-2)/(1-r^2));
        end
        stat_original=t0;
    else
        disp('Wrong Sampling Method Used')
        h=0;
        p=NaN;
        stat=NaN;
        return
    end
    %Calculaton of the original samples stat
    %%%
    statA=[stat_original;stat'];
    [statA,place] = sort(statA);
    rank=find(place==1);
    %Strange Finds Handle
    rankA=find(statA==place);
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
