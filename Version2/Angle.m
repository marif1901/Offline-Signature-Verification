function [ feature ] = Angle(I,r)
feature=[];
for i=1:size(I,1)
        b=I{i,1};
        s=size(b,1);
        for k=1:s
            f1=[];
            for w=1:length(r)
                if (s>2*r(w))

                        x0 = b(k,2);
                        y0 = b(k,1);
                        x1=  b(mod(k+r(w)-1,s)+1,2);
                        y1 = b(mod(k+r(w)-1,s)+1,1);
                        x2=  b(mod(k-r(w)-1,s)+1,2);
                        y2 = b(mod(k-r(w)-1,s)+1,1);
                        P0 = [x0,y0];
                        P1 = [x1,y1];
                        P2 = [x2,y2];
                        ang = rad2deg(atan2(abs(det([P2-P0;P1-P0])),dot(P2-P0,P1-P0)));
                        f1=[f1 ang];
                else
                    f1=[f1 0];
                end
            end
            feature=[feature;f1];
         end 
        
end

end

