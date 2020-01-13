
function [ f] = lbp( f1,mask )
f=[];
for i=1:length(f1)
    a=[];
    b=[];
    for t=1: (mask-1)/2
        if f1(i)-f1(mod(i+t-1,length(f1))+1)>0
            a=[a;1];
        else
            a=[a;0];
        end
        if f1(i)-f1(mod(i-1-t,length(f1))+1)>0
            b=[b;1];
        else
            b=[b;0];
        end
    end
    num=0;
    for q=1:length(a)
        num=num+pow2(2*length(a)-q)*a(q)+pow2(length(b)-q)*b(q);
    end
    f=[f;num];
end
end

