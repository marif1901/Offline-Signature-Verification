function [ cost ] = Hist_Dist1( Nref,vector )
    [Ntest, X] = hist(vector,length(Nref));
    Ntest=Ntest./sum(Ntest);
    cost=0;
    for i=1:length(Nref)
        a=Nref(i)-Ntest(i);
        b=Nref(i)+Ntest(i);
        cost=cost+(a*a/b);
    end
end

