clc
close all;
clear;
load imgfildata;

[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
picture=imread(s);
[~,cc]=size(picture);
im=imresize(picture,[300 500]);

figure 
imshow(im);
title('Loaded Image');

process_images(im);
