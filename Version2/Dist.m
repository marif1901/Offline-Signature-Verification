function [ cost ] = Dist( Nref,Ntest )
%     cost=0;
%     for i=1:length(Nref)
%         a=Nref(i)-Ntest(i);
%         b=Nref(i)+Ntest(i);
%         cost=cost+((a*a)/b);
%     end
      cost=pdist2(Nref,Ntest,'cityblock');
end

