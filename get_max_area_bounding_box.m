% This function takes an image as input and returns the bounding box of the largest connected component in the image
function [boundingBox] = get_max_area_bounding_box(im)

    % Use the 'regionprops' function to get the properties of connected components in the image, including the bounding box and area
    Iprops = regionprops(im, 'BoundingBox', 'Area', 'Image');

    % Get the area of the connected components
    area = Iprops.Area;

    % Count the number of connected components
    count = numel(Iprops);

    % Initialize 'maxa' to the area of the first connected component
    maxa = area;

    % Initialize 'boundingBox' to the bounding box of the first connected component
    boundingBox = Iprops.BoundingBox;

    % Loop through all connected components and find the one with the largest area
    for i = 1:count
        if maxa < Iprops(i).Area
            % If the area of the current connected component is larger than the current maximum area, update 'maxa' and 'boundingBox'
            maxa = Iprops(i).Area;
            boundingBox = Iprops(i).BoundingBox;
        end
    end

end
