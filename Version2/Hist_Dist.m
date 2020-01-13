function [ cost ] = Hist_Dist( Nref,vector )
    [Ntest, X] = hist(vector);
    Ntest=Ntest./sum(Ntest);
    cost=0;
    for i=1:length(Nref)
        a=Nref(i)-Ntest(i);
        b=Nref(i)+Ntest(i);
        cost=cost+((a*a)/b);
    end
%      cost=pdist2(Nref,Ntest,'cityblock');
end

