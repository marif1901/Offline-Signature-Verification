function [ f1,f2 ] = Im_Feature( s,r )
    im=imread(s);
    BW=imcomplement(im2bw(im));
    se = strel('disk',1);
    I2 = imdilate(BW,se);
    BW = bwmorph(I2,'remove');
    b = bwboundaries(BW);
    f1=ContourDirF1(b,r);
    f2=ContourDirF2(b,r);
        
end

