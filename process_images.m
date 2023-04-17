function [] = process_images(im)
    % Convert the RGB image to grayscale
    imgray = rgb2gray(im);

    % Display the grayscale image in a new figure 
    figure;
    imshow(imgray);
    title('gray image');  % Set the title of the figure

    % Binarize the grayscale image 
    imbin = imbinarize(imgray);

    % Display the binarized image in a new figure
    figure;
    imshow(imbin);
    title('binarized image');

    % Apply the Sobel edge detection algorithm to the grayscale image
    im = edge(imgray, 'sobel');

    % Display the Sobel edge-detected image
    figure;
    imshow(im);
    title('sobel image');

    % Dilate the edges in the image a diamond-shaped structuring element
    im = imdilate(im, strel('diamond', 2));

    % Fill any holes in the image using the 'imfill' function
    im = imfill(im, 'holes');

    % Erode the image using the 'imerode' function with a diamond-shaped structuring element
    im = imerode(im, strel('diamond', 10));
    
    %pause(2);
    
    
    % Display the eroded image
    figure;
    imshow(im);
    title('erosion image');

    % Get the bounding box of the largest connected component in the image
    boundingBox = get_max_area_bounding_box(im);

    % Process and segment the number plate using the binarized image and the bounding box 
    process_and_segment_number_plate(imbin, boundingBox);    
end
