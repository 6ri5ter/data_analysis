function [h,p,stat,Fx,Fy]=Group7Exe2Fun1(data1,data2,SampleMethod,B,alpha)
%Kolmogorov-Smirnov Dist Equality Test
    data=[data1;data2];
    n=length(data1);
    m=length(data2);
    lim=[floor((B+1)*(alpha/2)) (B+1)*(1-alpha/2)];
    if strcmp(SampleMethod,'Bootstrap')
        %Bootstrap Sample of the Data
        bootData=zeros(n+m,B);
        stat=zeros(1,B);
        for iB=1:B
            bootData(:,iB) = data(unidrnd(n+m,n+m,1));
            sample1=sort(bootData(1:n,iB));
            sample2=sort(bootData((n+1):(n+m),iB));
            bootData=sort(bootData);
            %Stat Calculation
            Fx=zeros(n+m,1);
            Fy=zeros(n+m,1);
            for x=1:(n+m)
                Fx(x)=sum(sample1<=bootData(x,iB))/n;
                Fy(x)=sum(sample2<=bootData(x,iB))/m;
            end
            stat(iB)=max(abs(Fx-Fy));
        end
    elseif  (strcmp(SampleMethod,'Random Perm'))
        %Random Permutation Sample of the Data
        permData=zeros(n+m,B);
        stat=zeros(1,B);
        for iP=1:B
            permData(:,iP) = data(randperm(n+m,n+m)');
            sample1=sort(permData(1:n,iP));
            sample2=sort(permData((n+1):(n+m),iP));
            permData=sort(permData);
            %Stat Calculation
            Fx=zeros(n+m,1);
            Fy=zeros(n+m,1);
            for x=1:(n+m)
                Fx(x)=sum(sample1<=permData(x,iP))/n;
                Fy(x)=sum(sample2<=permData(x,iP))/m;
            end
            stat(iP)=max(abs(Fx-Fy));
        end
    else
        disp('Wrong Sampling Method Used')
        h=0;
        p=NaN;
        stat=NaN;
        return
    end
    %Calculaton of the original samples stat
    Fx0=zeros(n+m,1);
    Fy0=zeros(n+m,1);
    data=sort(data);
    for x=1:(n+m)
            Fx0(x)=sum(data1<=data(x))/n;
            Fy0(x)=sum(data2<=data(x))/m;
    end
    stat_original=max(abs(Fx0-Fy0));
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
