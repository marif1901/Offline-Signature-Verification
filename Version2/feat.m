function [ pattern ] = feat( s,r )
    im=imread(s);
    BW=imcomplement(im2bw(im));
    b = bwboundaries(BW);
    %pattern=Angle(b,r);
    pattern=ContourDirF2(b,r);
end

