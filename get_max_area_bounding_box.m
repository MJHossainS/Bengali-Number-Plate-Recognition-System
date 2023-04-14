function [boundingBox] = get_max_area_bounding_box(im)
    Iprops=regionprops(im,'BoundingBox','Area', 'Image');
    area = Iprops.Area;
    count = numel(Iprops);
    maxa= area;
    boundingBox = Iprops.BoundingBox;
    for i=1:count
       if maxa<Iprops(i).Area
           maxa=Iprops(i).Area;
           boundingBox=Iprops(i).BoundingBox;
       end
    end    
end
