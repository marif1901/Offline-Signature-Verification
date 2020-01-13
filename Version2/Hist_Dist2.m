function [ cost ] = HistDist2( Nref,vector )
    [Ntest, X] = hist3(vector,[size(Nref,1),size(Nref,2)]);
    Ntest = Ntest / sum(Ntest(:));
    cost=0;
    for i=1:size(Nref,1)
        for j=1:size(Nref,2)
            a=Nref(i,j)-Ntest(i,j);
            b=Nref(i,j)+Ntest(i,j);
            if(b~=0)
                cost=cost+(a*a/b);
            end
        end
    end

end

