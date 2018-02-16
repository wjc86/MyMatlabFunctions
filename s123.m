%wjc3hg
%2/16/18
%% License 
% Copyright (c) 2018, William Clark
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
function [S]=s123(T,mkplot)
%A function to find principle Stresses from a stress state
%% README
%T is the stress input
%     T can be: 
%       A 3x3 Matrix (Returns 3 principle stresses)
%           [Txx,Txy,Txz;Tyx,Tyy,Tyz;Tzx,Tzy,Tzz]
%       A length 6 vector (column or row) (Returns 3 principle stresses)
%           [Txx,Tyy,Tzz,Txy,Txz,Tyz]
%       A 2x2 Matrix (Returns 2 in-plane principle stresses)
%           [Txx,Txy;Txy,Tyy]
%       A length 3 vector (column or row) (Returns 3 principle stresses)
%           [Txx,Tyy,Txy]

% mkplot enables plotting a mohrs circle in the current plot(default 0)
%
%Default args for plot if no mkplot entered
    switch nargin
        case 1
            mkplot = 0;
    end
 [n,m] = size(T);
%% Getting Principle Stresses
 if (n == 3 && m == 3)
   dim = 3;
   S = sort(eig(T),'descend');
 elseif (n==1 && m==6) || (n==6 && m==1)
     dim = 3;
     S = sort(eig([T(1) T(4) T(5);T(4) T(2) T(6);T(5) T(6) T(3)]));
 elseif (n == 2 && m ==2) 
    dim = 2;
    S = sort(eig(T),'descend');
 elseif (n==1 && m==3) || (n==3 && m==1)
    dim = 2;
    S = sort(eig([T(1) T(3);T(3) T(2)]),'descend');
 else
     error("Input Type Not Supported");
 end
%% Plotting
if mkplot == 1
    if dim == 2
        hold on
        theta = 0:pi/4096:2*pi;
        s1 = S(1);
        s2 = S(2);
         %s1,s2
        c2 = (s1+s2)/2;
        r2 = (s1-s2)/2;
        x2 = c2+r2*cos(theta);
        y2 = r2*sin(theta);
        plot(x2,y2,'b-');
        xlabel("Shear Stress");
        ylabel("Normal Stress");
        title("2D Mohr's Circle");
       
    end
    if dim == 3
        hold on
        s1 = S(1);
        s2 = S(2);
        s3 = S(3);
        theta = 0:pi/4096:2*pi;
        %s1,s3
        c1 = (s1+s3)/2;
        r1 = (s1-s3)/2;
        x1 = c1+r1*cos(theta);
        y1 = r1*sin(theta);
        q = plot(x1,y1,'r-');

        xlabel("Shear Stress");
        ylabel("Normal Stress");
        title("3D Mohr's Circle");


        %s1,s2
        c2 = (s1+s2)/2;
        r2 = (s1-s2)/2;
        x2 = c2+r2*cos(theta);
        y2 = r2*sin(theta);
        w = plot(x2,y2,'b-');

        %s2,s3
        c3 = (s2+s3)/2;
        r3 = (s2-s3)/2;
        x3 = c3+r3*cos(theta);
        y3 = r3*sin(theta);
        r = plot(x3,y3,'g-');
        legend([q w r],"s1<>s3","s1<>s2","s2<>s3");
        hold off
    end
end
end