clc
close all;
clear;
load imgfildata;


% user need to select an image file with the extensions of .jpg, .bmp, .png, or .tif
% The selected file path is stored in the variable 'path', and the selected file name is stored in the variable 'file'
[file, path] = uigetfile({'*.jpg;*.bmp;*.png;*.tif'}, 'Choose an image');
% Concatenates the file name and path into a single string
s = [path, file];

% Reads the image data into the variable
picture = imread(s);

% Stores the number of columns in the variable 
[~, cc] = size(picture);

% Resizes the image to 300x500 pixels 
im = imresize(picture, [300, 500]);

% Displays the loaded image in a new figure 
figure;
imshow(im);
title('Loaded Image'); % Sets the title of the figure 

% Calls the function 'process_images' with an argument to perform further processing
process_images(im);
