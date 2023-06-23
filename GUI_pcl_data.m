function GUI_pcl_data(filergb, filedepth, focallength,depthfactor, scalefactor,windowsize,alpha)
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
depth = imread(filedepth);
%Duong dan den file du lieu mau
rgb = imread(filergb);

ss = size(depth);
depth= double(depth);
depth(depth == 0) = nan;

% RGB-D camera constants
% do phong to cua anh
mg = 2;
[imh, imw] = size(depth);
center = [imh/2 imw/2];
constant = focallength*scalefactor;
MM_PER_M = depthfactor;

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
x1_ = x1(:);
x2_ = x2(:);
x3_ = x3(:);
x1t = x1_.*10000;
x2t = x2_.*10000;
x3t = x3_.*10000;
xt = [x1t, x2t, x3t];
xk = [x1_, x2_, x3_];
rgb_data = reshape(rgb,[],3);
tm1 = min(x1t):windowsize:max(x1t);
tm2 = min(x2t):windowsize:max(x2t);
tm3 = min(x3t):windowsize:max(x3t);

h = waitbar(0,'Processing noise points');
steps = size(tm1,2)*size(tm2,2)*size(tm3,2);
ti = 0;
tj = 0;
tk = 0;
for n1=min(x1t):windowsize:max(x1t)
    ti = ti +1;
    for n2=min(x2t):windowsize:max(x2t)
        tj = tj+1;
        for n3=min(x3t):windowsize:max(x3t)
            tk = tk+1;
            waitbar(ti*tj*tk/steps);
            h = xt((xt(:,1)>n1)&(xt(:,1)<n1+windowsize)&(xt(:,2)>n2)&(xt(:,2)<n2+windowsize)&(xt(:,3)>n3)&(xt(:,3)<n3+windowsize),:); 
            ss = size(h);
            if (size(h,1) < alpha) && (size(h,1) > 1)
                con = (xt(:,1)>n1)&(xt(:,1)<n1+windowsize)&(xt(:,2)>n2)&(xt(:,2)<n2+windowsize)&(xt(:,3)>n3)&(xt(:,3)<n3+windowsize);
                xk(con,:) = [];
                xt(con,:) = [];
                rgb_data(con,:) = [];
            end
        end 
    end
end
close(h);
figure
pcshow(xk, rgb_data);