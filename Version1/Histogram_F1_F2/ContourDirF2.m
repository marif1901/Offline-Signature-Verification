function [ vector ] =ContourDirF2(I,r)
vector=[];
for i=1:size(I,1)
        b=I{i,1};
        s=size(b,1);
            for k=r+1:s-r
                x1 = b(k,2);
                y1 = b(k,1);
                x2 = b(k+r,2);
                y2 = b(k+r,1);
                x3=  b(k-r,2);
                y3 = b(k-r,1);
                V1=x2-x1;
                V2=y2-y1;
                V3=x3-x1;
                V4=y3-y1;
                phi1=mod(radtodeg(atan2(V2,V1)),360);
                phi2=mod(radtodeg(atan2(V4,V3)),360);
%                 if(phi2>phi1)
                vector=[vector;phi1 phi2];
        end
end

end

