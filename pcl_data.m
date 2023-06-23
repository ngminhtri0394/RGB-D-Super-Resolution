% focal length x
fx = 525.0;  
% focal length y
fy = 525.0;  
% optical center x
cx = 319.5; 
% optical center y
cy = 239.5;   
%  for the 16-bit PNG files
factor = 5000; 
%Duong dan den file du lieu do sau
depth = imread('Datasample/result/depth/x2/0.tif');
%Duong dan den file du lieu mau
rgb = imread('Datasample/result/rgb/x2/0.tif');

ss = size(depth);
depth= double(depth);
depth(depth == 0) = nan;

% RGB-D camera constants
% do phong to cua anh
mg = 2;
[imh, imw] = size(depth);
center = [imh/2 imw/2];
constant = 525*mg;
MM_PER_M = 5000;

% convert depth image to 3d point clouds
pcloud = zeros(imh,imw,3);
xgrid = ones(imh,1)*(1:imw) - center(1);
ygrid = (1:imh)'*ones(1,imw) - center(2);
pcloud(:,:,1) = xgrid.*depth/constant/MM_PER_M;
pcloud(:,:,2) = ygrid.*depth/constant/MM_PER_M;
pcloud(:,:,3) = depth/MM_PER_M;
x1 = pcloud(:,:,1);
x2 = pcloud(:,:,2);
x3 = pcloud(:,:,3);
% x1_ = x1(:);
% x2_ = x2(:);
% x3_ = x3(:);
% x1t = x1_.*10000;
% x2t = x2_.*10000;
% x3t = x3_.*10000;
% xt = [x1t, x2t, x3t];
% xk = [x1_, x2_, x3_];
% windowsize = 2000;
% rgb_data = reshape(rgb,[],3);
% for n1=min(x1t):windowsize:max(x1t)
%     for n2=min(x2t):windowsize:max(x2t)
%         for n3=min(x3t):windowsize:max(x3t)
%             h = xt((xt(:,1)>n1)&(xt(:,1)<n1+windowsize)&(xt(:,2)>n2)&(xt(:,2)<n2+windowsize)&(xt(:,3)>n3)&(xt(:,3)<n3+windowsize),:); 
%             ss = size(h);
%             if (size(h,1) < 200) && (size(h,1) > 1)
%                 con = (xt(:,1)>n1)&(xt(:,1)<n1+windowsize)&(xt(:,2)>n2)&(xt(:,2)<n2+windowsize)&(xt(:,3)>n3)&(xt(:,3)<n3+windowsize);
%                 xk(con,:) = [];
%                 xt(con,:) = [];
%                 rgb_data(con,:) = [];
%             end
%         end 
%     end
% end
% figure
% pcshow(xk, rgb_data);
figure
pcshow([x1(:), x2(:),x3(:)], reshape(rgb,[],3));