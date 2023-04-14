function [] = process_images(im)
    imgray = rgb2gray(im);
    figure
    imshow(imgray);
    title('gray image');
    %pause(2);
    imbin = imbinarize(imgray);
    figure
    imshow(imbin);
    title('binarized image');
    %pause(2);
    im = edge(imgray, 'sobel');
    figure
    imshow(im);
    title('sobel image');
    %pause(2);

    im = imdilate(im, strel('diamond', 2));
    im = imfill(im, 'holes');
    im = imerode(im, strel('diamond', 10));
    figure
    imshow(im);
    title('eroison image');
    %pause(2);
    boundingBox = get_max_area_bounding_box(im);
    process_and_segment_number_plate(imbin, boundingBox);
end