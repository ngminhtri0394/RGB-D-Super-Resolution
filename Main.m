% If using rgb, iscolor =1
% If using depthmap, iscolor = 0
iscolor = 1;
factor = 4;
numberofimage = 820;
for k=810:numberofimage
    for h=1:4
        index = k+h;
        %Duong dan file dau vao
        image{h} = sprintf('E:\\Data\\rgb\\x4_down\\%d.tif', index-1);
    end
    
    for i=1:4
        if iscolor == 1
            im{i} = double(imread(image{i}))/256;
        else
            im{i} = double(imread(image{i}));
            lr = double(imread(image{i}));
        end
        im_part{i} = im{i};
        if iscolor == 1
            im{i} = rgb2gray(im{i});
        end
    end
    
    
    [delta_est1, phi_est1] = estimate_motion(im,0.8,10); % motion estimation
    im_rec1 = reconstruct(im_part,delta_est1,phi_est1,factor); % signal reconstruction

    if iscolor == 0
        im_rec1 = uint16(im_rec1);
    end
    %Duong dan file ket qua
    filename = sprintf('E:\\Google Drive\\Thesis\\Code\\Datasample\\result\\rgb\\x4_down\\%d.tif', k);
    imwrite(im_rec1(1:end-factor,1:end-factor,:),filename,'TIFF')
end
display('Ket thuc chuong trinh')