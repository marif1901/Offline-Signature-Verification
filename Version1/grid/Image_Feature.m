function [ Feature ] = Image_Feature(s,r,Grid_size)
        
        im=imread(s);  
        BW=imcomplement(im2bw(im));
        Ithin=bwmorph(BW,'thin',Inf);
        img=(bwmorph(Ithin,'spur'));
        b = bwboundaries(img);
        B=cell2mat(b);
        Ymin=min(B(:,1));
        Ymax=max(B(:,1));
        Xmin=min(B(:,2));
        Xmax=max(B(:,2));
        I=img(Ymin:Ymax,Xmin:Xmax);
        %imshow(I);
        M=nnz(I==1);
        Mr=M/Grid_size;
        count=0;
        Xind=[1];
        Yind=[1];
        for y=1:size(I,1)
            count=count+nnz(I(y,:)==1);
            if(count>=Mr)
                Yind=[Yind y];
                count =0;
            end
            if(length(Yind)==Grid_size)
                break;
            end
        end
        Yind=[Yind size(I,1)];
        count =0;
        for x=1:size(I,2)
            count=count+nnz(I(:,x)==1);
            if(count>=Mr)
                Xind=[Xind x];
                count =0;
            end
            if(length(Xind)==Grid_size)
                break;
            end
        end
        Xind=[Xind size(I,2)];
        Feature=[];
        for i=1:Grid_size
            for j=1:Grid_size
                GridImg=I(Yind(i):Yind(i+1),Xind(j):Xind(j+1));
                %figure,imshow(GridImg)
                Vector=GridAngle(GridImg,r);
                Feature=[Feature;Vector];
            end
        end
end

