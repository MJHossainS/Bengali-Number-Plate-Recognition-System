% This function takes a binary image `imbin` and a bounding box `boundingBox` as input
function [] = process_and_segment_number_plate(imbin, boundingBox)
    % Load the image file data
    load imgfildata;

    % Crop the license plate from the original binary image using the bounding box
    im = imcrop(imbin, boundingBox);

    % Display the cropped license plate 
    figure;
    imshow(im);
    title('Cropped Image');

    % Resize the license plate to have a height of 240 pixels and a proportional width 
    im = imresize(im, [240 NaN]);

    % Display the resized license plate 
    figure;
    imshow(im);
    title('Resized Image');

    % Remove small dust particles from the license plate and a rectangle element of size 4x4
    im = imopen(im, strel('rectangle', [4 4]));

    % Display the dust-removed license plate
    figure;
    imshow(im);
    title('Dust-Removed Image');

    % Remove small connected objects from the inverted license plate with a threshold of 500 pixels
    im = bwareaopen(~im, 500);

    % Display the small object-removed license plate 
    figure;
    imshow(im);
    title('Small Object-Removed Image');

    % Remove the border of the license plate by converting it to grayscale, thresholding it, and performing connected component analysis
    [h, w] = size(im);
    picture = im;
    if size(picture, 3) == 3
        picture = rgb2gray(picture);
    end
    picture = bwareaopen(picture, 30);
    figure;
    imshow(picture);

    % Remove large connected components from the binary image using a threshold of 11000 pixels
    picture1 = bwareaopen(picture, 11000);
    figure;
    imshow(picture1);

    % Subtract the large connected components from the binary image to get the license plate characters
    picture2 = picture - picture1;
    figure;
    imshow(picture2);

    % Remove small connected components from the license plate characters using a threshold of 200 pixels
    picture2 = bwareaopen(picture2, 200);
    figure;
    imshow(picture2);

    % Remove small connected components from the license plate characters using a threshold of 300 pixels
    picture2 = bwareaopen(picture2, 300);
    figure;
    imshow(picture2);
    title('Segmented');

    % Assign the segmented image to a separate variable
    img = picture2;

    % Get the size of the variable
    [nrows, ncols, dim] = size(img);

    % Split the license plate into two equal slices(upper part and lower part)
    im1 = img(1:nrows/2+15,:);
    im2 = img((nrows/2)+20:2*nrows/2,:);



    %------------------Upper part-----------------
    % Get the height and width of the upper part of license plate
    [h, w] = size(im1);

    % Display the the upper part of license plate
    figure 
    imshow(im1);

    % Assign the upper part of license plate to the variable 'picture'
    picture = im1;

    % Label the connected components 
    [L, Ne] = bwlabel(picture);

    % Get the properties of the labeled regions
    propied = regionprops(L,'BoundingBox');

    % Display the bounding boxes of the regions 
    hold on
    for n = 1:size(propied,1)
        rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    hold off

    % Create a figure to display the segmented characters
    figure
    final_output = [];
    t = [];
    for n = 1:Ne
        % Get the row and column indices of the labeled region
        [r, c] = find(L == n);

        % Crop the region from 'picture' and resize it to 42x24 pixels
        n1 = picture(min(r):max(r),min(c):max(c));
        n1 = imresize(n1,[42,24]);

        % Display the segmented character
        figure
        imshow(n1)

        % Compute the correlation coefficients between the segmented character and the characters in imgfildata
        x = [];
    totalLetters=size(imgfile,2); % Get the total number of reference images
    for k=1:totalLetters    
        y=corr2(imgfile{1,k},n1); % Compare the segmented character with each reference image using correlation
        x=[x y]; % Store the correlation values in a vector
    end
    t=[t max(x)]; % Store the maximum correlation value for this character
    if max(x)>.45 % Check if the maximum correlation value is greater than the threshold
        z=find(x==max(x)); % Get the index of the reference image with the highest correlation
        out=cell2mat(imgfile(2,z)); % Get the corresponding character label from the reference image
    final_output=[final_output out]; % Add the character label to the final output
    end
    end

    %For Separation Upper Part & Lower Part
    final_output=[final_output];


     %------------------lower part-----------------
     %will do similar things for the lower part of the license plate here
    [h, w] = size(im2);
    figure 
    imshow(im2);
    picture=im2;


    [L,Ne]=bwlabel(picture);
    propied=regionprops(L,'BoundingBox');
    hold on
    %pause(1)
    for n=1:size(propied,1)
      rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    hold off

    %figure
    %final_output=[];
    %t=[];
    for n=1:Ne
      [r,c] = find(L==n);
      n1=picture(min(r):max(r),min(c):max(c));
      n1=imresize(n1,[42,24]);
      figure
      imshow(n1)
    %   %pause(2)
      x=[ ];

    totalLetters=size(imgfile,2);

     for k=1:totalLetters

        y=corr2(imgfile{1,k},n1);
        x=[x y];

     end
     t=[t max(x)];
     if max(x)>.45
     z=find(x==max(x));
     out=cell2mat(imgfile(2,z));

    final_output=[final_output out];
    end
    end
    
    text_to_speech(final_output)
end
