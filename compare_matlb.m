err1_MSE = 0;
err2_MSE = 0;
numberofimage = 20;
factor = 4;
for i=810:820
    filename_original = sprintf('E:\\Data\\original\\rgb\\%d.tif', i);
    ori = imread(filename_original);
    ori = ori(1:end-factor, 1:end-factor,:);
    file_nameresize1 = sprintf('E:\\Data\\rgb\\x4_down\\%d.tif', i);
    filename_resize = imread(file_nameresize1);
    mat = imresize(filename_resize, factor);
    mat = mat(1:end-factor, 1:end-factor,:);
    err1_MSE(i+1) = immse(mat, ori);
    err1_SSIM(i+1) = ssim(mat, ori);
    filename_superresolution = sprintf('E:\\Google Drive\\Thesis\\Code\\Datasample\\result\\rgb\\x4_down\\%d.tif', i);
    al = imread(filename_superresolution);
    err2_MSE(i+1) = immse(al, ori);
    err2_SSIM(i+1) = ssim(al, ori);
end
display('Trung binh do loi MSE cua ham resize Matlab')
res1 = mean(err1_MSE)
display('Trung binh2 do loi MSE cua phuong phap sieu phan giai da anh')
res2 = mean(err2_MSE)
display('Trung binh gia tri tuong quan SSIM cua ham resize Matlab')
res3 = mean(err1_SSIM)
display('Trung binh gia tri tuong quan SSIM cua  phuong phap sieu phan giai da anh')
res4 = mean(err2_SSIM)