function [ f1 ] = ContourDirF1(I,r)
f1=[];
for i=1:size(I,1)
        b=I{i,1};
        s=size(b,1);
        if (s>r)
            for k=1:s-r
                x1 = b(k,2);
                y1 = b(k,1);
                x2=  b(k+r,2);
                y2 = b(k+r,1);
                V1=x2-x1;
                V2=y2-y1;
                f1=[f1;radtodeg(abs(atan2(V2,V1)))];
            end 
        end
end
end

