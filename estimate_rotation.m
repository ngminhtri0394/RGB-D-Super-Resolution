function [rot_angle, c] = estimate_rotation(a,dist_bounds,precision)
% ESTIMATE_ROTATION estimate rotation parameters using algorithm by Vandewalle et al.
%    [rot_angle, c] = estimate_rotation(a,dist_bounds,precision)
%    DIST_BOUNDS gives the minimum and maximum radius to be used
%    PRECISION gives the precision with which the rotation angle is computed
%    input images A are specified as A{1}, A{2}, etc.

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

nr=length(a);
d=1*pi/180; % width of the angle over which the average frequency value is computed
s = size(a{1})/2;
center=[floor(s(1))+1 floor(s(2))+1]; % center of the image and the frequency domain matrix
x = ones(s(1)*2,1)*[-1:1/s(2):1-1/s(2)]; % X coordinates of the pixels
y = [-1:1/s(1):1-1/s(1)]'*ones(1,s(2)*2); % Y coordinates of the pixels
x=x(:);
y=y(:);
[th,ra] = cart2pol(x,y); % polar coordinates of the pixels
h = waitbar(0,'Processing image registration: estimate rotation');
steps = nr*2*(180/precision);
for k=1:nr
  A{k} = fftshift(abs(fft2(a{k}))); % Fourier transform of the image
  for i=-180/precision:180/precision % for every angle, compute the average value
    i_=i*pi*precision/180; % angle
    % use only the part between angle-d and angle+d, and between dist_bounds(1) and dist_bounds(2)
    v = (th>i_-d)&(th<i_+d)&(ra>dist_bounds(1))&(ra<dist_bounds(2)); 
    if ~(sum(v)>0) % if no values are found that satisfy the above test
        h_A{k}(i+180/precision+1) = 0;
    else
        h_A{k}(i+180/precision+1) = mean(A{k}(v));
    end
    waitbar(i*k / steps);
  end
end
waitbar(1);
% compute the correlation between h_A{1} and h_A{2-4} and set the estimated rotation angle 
% to the maximum found between -30 and 30 degrees
H_A = fft(h_A{1});
rot_angle(1)=0;
c{1}=[];
for k=2:nr
  H_Binv = fft(h_A{k}(end:-1:1));
  H_C = H_A.*H_Binv;
  h_C = real(ifft(H_C));
  [m,ind] = max(h_C(150/precision+1:end-150/precision));
  rot_angle(k) = (ind-30/precision-1)*precision;
  c{k} = h_C;
end
close(h) 