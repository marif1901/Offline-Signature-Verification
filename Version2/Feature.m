function [ pattern ] = Feature( s,r,mask )
    im=imread(s);
    BW=imcomplement(im2bw(im));
%     se = strel('disk',1);
%     I2 = imdilate(BW,se);
%     BW2 = bwmorph(I2,'remove');
    b = bwboundaries(BW);
    pattern=ContourAngle(b,r,mask);
end

