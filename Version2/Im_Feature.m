function [ f1,f2 ] = Im_Feature( s,r )
    im=imread(s);
    BW=imcomplement(im2bw(im));
    b = bwboundaries(BW);
    f1=ContourDirF1(b,r);
    f2=ContourDirF2(b,r);
        
end

