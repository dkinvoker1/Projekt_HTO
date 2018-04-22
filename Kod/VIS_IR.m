clc; close all; clear all;

% mode='vis->ir';
mode='ir->vis';

VIS = dir ('VIS/*.jpg');
VIS=struct2cell(VIS);
VIS=VIS(1,:);
VIS= strcat('VIS/',VIS);

IR = dir ('IR/*.png');
IR=struct2cell(IR);
IR=IR(1,:);
IR= strcat('IR/',IR);

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
end
load('Points.mat')

t_concord = fitgeotrans(movingPoints,fixedPoints,'projective');
Rfixed = imref2d(size(IM_VIS{19}));
registered = imwarp(IM_IR{19},t_concord,'OutputView',Rfixed);

figure
imshowpair(IM_VIS{19},registered,'blend')