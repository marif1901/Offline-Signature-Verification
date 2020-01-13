function [ feat ] = ContourAngle(I,r,mask)
feat=[];
for i=1:size(I,1)
        b=I{i,1};
        s=size(b,1);
        f1=[];
        if (s>2*r)
            for k=1:s
                x0 = b(k,2);
                y0 = b(k,1);
                x1=  b(mod(k+r-1,s)+1,2);
                y1 = b(mod(k+r-1,s)+1,1);
                x2=  b(mod(k-r-1,s)+1,2);
                y2 = b(mod(k-r-1,s)+1,1);
%                 V1=x2-x1;
%                 V2=y2-y1;
                P0 = [x0,y0];
                P1 = [x1,y1];
                P2 = [x2,y2];
                ang = atan2(abs(det([P2-P0;P1-P0])),dot(P2-P0,P1-P0));
                f1=[f1;ang];
            end 
        end
        feat=[feat;lbp(f1,mask)];
end

end

