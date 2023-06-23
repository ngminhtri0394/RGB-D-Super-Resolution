function rec = reconstruct(s,delta_est,phi_est,factor)
% RECONSTRUCT reconstruct a high resolution image from multiple shifted and rotated low resolution images
%    rec = reconstruct(s,delta_est,phi_est,factor)
%    reconstruct an image with FACTOR times more pixels in both dimensions
%    using cubic interpolation on the pixels from the images in s
%    and using the shift and rotation information from DELTA_EST and PHI_EST

%%
% Matlab code and data to reproduce results from the paper                  
% "A Frequency Domain Approach to Registration of Aliased Images            
% with Application to Super-Resolution"                                     
% Patrick Vandewalle, Sabine Susstrunk and Martin Vetterli                  
% available at http://lcavwww.epfl.ch/reproducible_research/VandewalleSV05/ 
%                                                                           
% Copyright (C) 2005 Laboratory of Audiovisual Communications (LCAV),       
% Ecole Polytechnique Federale de Lausanne (EPFL),                          
% CH-1015 Lausanne, Switzerland                                             
%                                                                           
% This program is free software; you can redistribute it and/or modify it  
% under the terms of the GNU General Public License as published by the     
% Free Software Foundation; either version 2 of the License, or (at your    
% option) any later version. This software is distributed in the hope that  
% it will be useful, but without any warranty; without even the implied     
% warranty of merchantability or fitness for a particular purpose.          
% See the GNU General Public License for more details                       
% (enclosed in the file GPL).                                               
%                                                                           
% Latest modifications: March 10, 2005  
%%                                    

n=length(s);
ss = size(s{1});
if (length(ss)==2) ss=[ss 1]; end
center = (ss+1)/2;
phi_rad = phi_est*pi/180;
h = waitbar(0,'Reconstructing image');
steps = ss(3)*n;
% compute the coordinates of the pixels from the N images, using DELTA_EST and PHI_EST
for k=1:ss(3) % for each color channel
  for i=1:n % for each image
    s_c{i}=s{i}(:,:,k);
    s_c{i} = s_c{i}(:);
    r{i} = [1:factor:factor*ss(1)]'*ones(1,ss(2)); % create matrix with row indices
    c{i} = ones(ss(1),1)*[1:factor:factor*ss(2)]; % create matrix with column indices
    r{i} = r{i}-factor*center(1); % shift rows to center around 0
    c{i} = c{i}-factor*center(2); % shift columns to center around 0
    coord{i} = [c{i}(:) r{i}(:)]*[cos(phi_rad(i)) sin(phi_rad(i)); -sin(phi_rad(i)) cos(phi_rad(i))]; % rotate 
    r{i} = coord{i}(:,2)+factor*center(1)+factor*delta_est(i,1); % shift rows back and shift by delta_est
    c{i} = coord{i}(:,1)+factor*center(2)+factor*delta_est(i,2); % shift columns back and shift by delta_est
    rn{i} = r{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    cn{i} = c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    sn{i} = s_c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
  end

  s_ = []; r_ = []; c_ = []; sr_ = []; rr_ = []; cr_ = [];
  for i=1:n % for each image
    s_ = [s_; sn{i}];
    r_ = [r_; rn{i}];
    c_ = [c_; cn{i}];
  end
  clear s_c r c coord rn cn sn

  % interpolate the high resolution pixels using cubic interpolation
   rec_col = griddata(c_,r_,s_,[1:ss(2)*factor],[1:ss(1)*factor]','cubic'); % option QJ added to make it work 
  rec(:,:,k) = reshape(rec_col,ss(1)*factor,ss(2)*factor);
   waitbar(k*i / steps)
end
rec(isnan(rec))=0;
close(h)
