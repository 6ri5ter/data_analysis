function [X,Y] = Group7Exe7Fun1(dataX,dataY,Hysteresis,Hold_all)
%Function to create the Hysterisis of the Data
%The size Hysteresis+1 is because we want to create an X Matrix
%with the original X values on the 1st Column,
%and for each next Column the  shifted data
    n=size(dataX,1);
    if (nargin > 3)&&(Hold_all)
        X=zeros(n,Hysteresis+1);
        for i=0:(Hysteresis)
            X(:,i+1)=[zeros(i,1);dataX(1:(end-i))];
        end
    else
        X=[zeros(Hysteresis,1);dataX(1:(end-Hysteresis))];
    end
    X=X((1+Hysteresis):end,:);
    Y=dataY((1+Hysteresis):end,:);
end