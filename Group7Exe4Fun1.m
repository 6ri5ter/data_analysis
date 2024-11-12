function  Countries = Group7Exe4Fun1(CountryList,myCountry)
%Function to Find the 5 countries
    CountryNumber=find(strcmp(myCountry,CountryList)==1);
    if ((CountryNumber-2)<=0)
        %Handle1
        CountryNumber=3;
    elseif ((CountryNumber+2)>length(CountryList))
        %Handle2
        CountryNumber=length(CountryList)-2;
    end
    Countries=CountryList((CountryNumber-2):(CountryNumber+2));
end