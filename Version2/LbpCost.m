function [ cost ] = LbpCost(a,b,c,d)
    [Nref1, X] = hist(a);
    Nref1=Nref1./sum(Nref1);
    
    [Nref2, X] = hist(b);
    Nref2=Nref2./sum(Nref2);
    e=[Hist_Dist(Nref1,c) Hist_Dist(Nref2,d)];
    cost=mean(e);
end

