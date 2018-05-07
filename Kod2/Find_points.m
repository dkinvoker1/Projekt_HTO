function [  ] = Find_points( IR, VIS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[movingPoints,fixedPoints] =cpselect(IR,VIS,'Wait',true);
save('Points.mat','movingPoints','fixedPoints')

end

