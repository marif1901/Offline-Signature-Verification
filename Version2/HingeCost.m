function [ cost ] = HingeCost(a,b,c,d)

    [Nref1, X] = hist(a,12);
    Nref1=Nref1./sum(Nref1);
    [Nref2,C]=hist3(b,[24 24]);
    Nref2 = Nref2 / sum(Nref2(:));
    e=[Hist_Dist1(Nref1,c) Hist_Dist2(Nref2,d)];
    cost=mean(e);

end

