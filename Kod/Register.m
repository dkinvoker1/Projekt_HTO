function [  ] = Register( IR, VIS )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load('Points.mat')

t_concord = fitgeotrans(movingPoints,fixedPoints,'projective');
Rfixed = imref2d(size(VIS));
registered = imwarp(IR,t_concord,'OutputView',Rfixed);

figure
imshowpair(VIS,registered,'blend')

end

