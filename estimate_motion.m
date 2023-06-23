function [delta_est, phi_est] = estimate_motion(s,r_max,d_max)
% ESTIMATE_MOTION motion estimation using algorithm by Vandewalle et al.
%    [delta_est, phi_est] = estimate_motion(s,r_max,d_max)
%    R_MAX is the maximum radius in the rotation estimation
%    D_MAX is the number of low frequency components used for shift estimation
%    input images S are specified as S{1}, S{2}, etc.

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

% if (nargin==1) % default values
%    r_max = 0.8;
%    d_max = 8;
% end
% s_r = s;
% tmp_delta_est = [];
% delta_est = [];
% tmp_phi_est = [];
% phi_est = [];
% P = 4;
% for p=1:P
%     nr=length(s);
%     % shift estimation
%     tmp_delta_est{p} = estimate_shift(s_r,d_max);
%     
%     s_t{1} = s_r{1};
%     for i=2:nr
%         s_t{i} = imtranslate(s_r{i},[tmp_delta_est{p}(i,2), tmp_delta_est{p}(i,1)],'cubic');
%     end
%     
%     % rotation estimation
%     [tmp_phi_est{p}, c_est] = estimate_rotation(s_t,[0.1 r_max],0.1);
% 
%     % rotation compensation, required to estimate shifts
%     s_r{1} = s_t{1};
%     for i=2:nr
%         s_r{i} = imrotate(s_t{i},-tmp_phi_est{p}(i),'bicubic','crop');
%     end
% end
% delta_est(1,:) = [0 0];
% for m = 2: length(s)
%     sum = [0;0];
%     for i=1:P
%         mul = [1 0;0 1];
%         for j=i:P
%             mul = mul*[cos(tmp_phi_est{j}(m)) -sin(tmp_phi_est{j}(m)); sin(tmp_phi_est{j}(m)) cos(tmp_phi_est{j}(m))];
%         end
%         sum = sum + mul*[tmp_delta_est{i}(m,1); tmp_delta_est{i}(m,2)]; %[dx dy];
%     end
%     delta_est(m,:) = [sum(1) sum(2)]; 
% end
% phi_est = tmp_phi_est{1};
% for i=2:P
%     phi_est = phi_est + tmp_phi_est{i};
% end

if (nargin==1) % default values
   r_max = 0.8;
   d_max = 8;
end

% rotation estimation
[phi_est, ~] = estimate_rotation(s,[0.1 r_max],0.05);

% rotation compensation, required to estimate shifts
 s2{1} = s{1};
nr=length(s);
for i=2:nr
    s2{i} = imrotate(s{i},-phi_est(i),'bicubic','crop');
end

% shift estimation
delta_est = estimate_shift(s2,d_max);


