clc; close all; clear all;

mode='vis->ir';
% mode='ir->vis';

VIS = dir ('Nowe/VIS/*.jpg');
VIS=struct2cell(VIS);
VIS=VIS(1,:);
VIS= strcat('Nowe/VIS/',VIS);

IR = dir ('Nowe/IR/*.png');
IR=struct2cell(IR);
IR=IR(1,:);
IR= strcat('Nowe/IR/',IR);

load('Points.mat')
t_concord = fitgeotrans(movingPoints,fixedPoints,'projective');

for i=1:size(VIS,2)
% for i=1:1
    if mode=='vis->ir'
        IM_IR{i} = imread(IR{i});
        IM_VIS{i} = imread(VIS{i});
        IM_VIS{i} = imresize(IM_VIS{i},[240 320]);
    else if mode=='ir->vis'
        IM_VIS{i} = imread(VIS{i});
        IM_IR{i} = imread(IR{i});
        IM_IR{i} = imresize(IM_IR{i},[3264 4896]);
        end
    end
    
    figure
    subplot(1,2,1)
    imshow(IM_VIS{i});
    subplot(1,2,2)
    imshow(IM_IR{i});
    
    Rfixed = imref2d(size(IM_VIS{i}));
    registered = imwarp(IM_IR{i},t_concord,'OutputView',Rfixed);

    figure
    imshowpair(IM_VIS{i},registered,'blend')
end

