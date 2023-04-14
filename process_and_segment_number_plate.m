function [] = process_and_segment_number_plate(imbin, boundingBox)
    load imgfildata;
    im = imcrop(imbin, boundingBox);
    figure
    imshow(im);
    title('croped image');
    %pause(2);
    % 
    %resize number plate to 240 NaN
    im = imresize(im, [240 NaN]);
    figure
    imshow(im);
    title('resized image');
    %pause(2);
    %clear dust
    im = imopen(im, strel('rectangle', [4 4]));
    figure
    imshow(im);
    title('dust removed image');
    %pause(2);

    im = bwareaopen(~im, 500);

    figure
    imshow(im);
    title('small object removed image');

    % border remover
    [h, w] = size(im);

    picture=im;
    if size(picture,3)==3
      picture=rgb2gray(picture);
    end
    picture = bwareaopen(picture,30);
    figure
    imshow(picture);
    %pause(2)


    picture1=bwareaopen(picture,11000);

    figure,imshow(picture1)
    %pause(2)
    picture2=picture-picture1;
    figure,imshow(picture2)
    %pause(2)
    picture2=bwareaopen(picture2,200);
    figure,imshow(picture2)

    picture2=bwareaopen(picture2,300);
    figure,imshow(picture2)
    title('Segmented');



    img = picture2;
    %imshow(img, []);
    [nrows, ncols, dim] = size(img);
    % Get the slices colums wise split equally
    im1 = img(1:nrows/2+15,:);
    im2 = img((nrows/2)+20:2*nrows/2,:);



    %------------------Upper part-----------------
    [h, w] = size(im1);
    figure 
    imshow(im1);
    %pause(2);
    picture=im1;
    % [~,cc]=size(picture);
    % picture=imresize(picture,[300 500]);

    [L,Ne]=bwlabel(picture);
    propied=regionprops(L,'BoundingBox');
    hold on
    %pause(1)
    for n=1:size(propied,1)
      rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    hold off

    figure
    final_output=[];
    t=[];
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

    %For Separation Upper Part & Lower Part
    final_output=[final_output];


     %------------------lower part-----------------
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