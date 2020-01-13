function [ vector ] =GridAngle( I,r )
if(nnz(I==1)==0)
    vector=zeros(1,length(r));
else
    gridbound=bwboundaries(I);
    Grid_Feature=[];
    for m=1:size(gridbound,1)
        b=gridbound{m,1};
        s=size(b,1);
        if (s>2*max(r)+1)
%               for i= max(r)+1 : s-max(r)
%                         AngleArray=zeros(1,length(r));
%                         for j=1:length(r)
%                             x1=  b(i,2);
%                             y1 = b(i,1);
%                             x2 = b(i-r(j),2) ;
%                             y2 = b(i-r(j),1) ;
%                             x3 = b(i+r(j),2) ;
%                             y3 = b(i+r(j),1) ;
%                             V1=[x2-x1 y2-y1];
%                             V2=[x1-x3 y1-y3];
%                             if(norm(V1)~=0 && norm(V2)~=0)
%                                 AngleArray(1,j)=radtodeg(real(acos(dot(V1,V2)/(norm(V1)*norm(V2)))));
%                             else
%                                 AngleArray(1,j)=0;
%                             end
%                         end
%                     Grid_Feature=[Grid_Feature;AngleArray];
%               end
               for k=1:s
                    AngleArray=zeros(1,length(r));
                    for j=1:length(r)
                        x1 = b(k,2);
                        y1 = b(k,1);
                        if(mod(k+r(j)+s,s)>0)
                            p=mod(k+r(j)+s,s);
                        else
                            p=s;
                        end
                        if(mod(k-r(j)+s,s)>0)
                            q=mod(k-r(j)+s,s);
                        else
                            q=s;
                        end
                        x2 = b(p,2);
                        y2 = b(p,1);
                        x3=  b(q,2);
                        y3 = b(q,1);
                        V1=[x2-x1 y2-y1];
                        V2=[x1-x3 y1-y3];
                        if(norm(V1)~=0 && norm(V2)~=0)
                            AngleArray(1,j)=radtodeg(real(acos(dot(V1,V2)/(norm(V1)*norm(V2)))));
                        else
                            AngleArray(1,j)=0;
                        end
                    end
                    Grid_Feature=[Grid_Feature;AngleArray];
               end
        else
            Grid_Feature=[Grid_Feature;zeros(1,length(r))];
        end
    end
    vector=mean(Grid_Feature,1); 
end
end

