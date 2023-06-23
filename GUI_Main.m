function GUI_Main(targetimage, targetfullpath, reffullpath, result,type, scale)
% If using rgb, iscolor =1
% If using depthmap, iscolor = 2
iscolor = type;
factor = scale;

figure('Name','Original image')
ori = imread(targetfullpath);
imshow(ori);

image{1} = targetfullpath;
for i=1:size(reffullpath,2)
    image{i+1} = reffullpath{i};
end
for i=1:size(image,2)
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

if iscolor == 2
    im_rec1 = uint16(im_rec1);
end
%Duong dan file ket qua
token = strtok(targetimage,'.');
filename = strcat(result,{'\'},token);
if(iscolor==1)
    filename  = strcat(filename,{'_'},'rgb');
else
    filename  = strcat(filename,{'_'},'depth');
end
if(factor==2)
    filename  = strcat(filename,{'_'},'x2');
else
    filename  = strcat(filename,{'_'},'x4');
end
filename  = strcat(filename,{'.'},'tif');
imwrite(im_rec1(1:end-factor,1:end-factor,:),filename{1},'TIFF')
figure('Name','Scaled image')
imshow(im_rec1(1:end-factor,1:end-factor,:));
h = msgbox('Finished','Result');
display('Ket thuc chuong trinh')
end