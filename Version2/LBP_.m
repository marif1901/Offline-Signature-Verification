function [ feat,feat2 ] = LBP_(BW,I,r,wind)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    max_y=size(BW,1);
    max_x=size(BW,2);
    feat=[];
    n=2.^(0:(r^2-1));
    for i=1:size(I,1)
        if length(I{i})>100
            b=I{i};
            s=length(b);
            for k=1:s
                y = b(k,1);
                x = b(k,2);
                t=(r-1)/2;
                bit=[];
                for i=-t:t 
                    y1=y+i;
                    for j=-t:t
                        x1=x+j;
                        if x1 >0 && x1 < max_x+1 && y1 >0 && y1 <max_y+1
%                           num=n(1)*BW(y+1,x-1)+n(2)*BW(y+1,x)+n(3)*BW(y+1,x+1)+n(4)*BW(y,x+1)+n(5)*BW(y-1,x+1)+n(6)*BW(y-1,x)+n(7)*BW(y-1,x-1)+n(8)*BW(y,x-1);
                            bit=[bit;BW(y1,x1)];
                        else
                            bit=[bit;0];
                        end
                    end
                end
                num=n*bit;
                feat=[feat;num];
            end
        end
    end
    feat2=ContourAngle(I,r,wind);



end

