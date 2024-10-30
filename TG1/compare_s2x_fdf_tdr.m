function [] = compare_s2x_fdf_tdr(s2x,fdf)
% Copyright (c) 2017, IEEE 370 Open Source Authors (See AUTHORS.md)
%
% This work is licensed to The Institute of Electrical and Electronics
% Engineers, Incorporated (IEEE) under one or more contributor license
% agreements.
%
% See the NOTICE file distributed with this work for additional
% information regarding copyright ownership. Use of this file is
% governed by a BSD-style license, the terms of which are as follows:
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%
%   * Redistributions of source code must retain the above copyright
%   notice, this list of conditions, the following disclaimer, and the
%   NOTICE file.
%
%   * Redistributions in binary form must reproduce the above
%   copyright notice, this list of conditions, the following
%   disclaimer in the documentation and/or other materials provided
%   with the distribution, and the NOTICE file.
%
%   * Neither the name of The Institute of Electrical and Electronics
%   Engineers, Incorporated (IEEE) nor the names of its contributors
%   may be used to endorse or promote products derived from this
%   software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
% COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%
% SPDX-License-Identifier: BSD-3-Clause
%
% Syntax: [] = compare_s2x_fdf_tdr(s2x,fdf);
%
% Author: Jason J. Ellison
% Release Date: 7/15/2021
% Version: Original Release (v0)
%
% Inputs: s2x: sparameter object of the 2x-thru
%         fdf: sparameter object of the fixture-dut-fixture
%
% Outputs: a plot for each port is created that compares the impedance of
% the s2x to the fdf. This is part of TG2's deliverables that were missed 
% before release of the standard.   

n = s2x.NumPorts;
fs2x = s2x.Frequencies;
ffdf = fdf.Frequencies;
ts2x_ns = tfromf(fs2x)/1e-9;
tfdf_ns = tfromf(ffdf)/1e-9;

for i = 1:n
    zs2x = zfroms(s2x,i);    
    zfdf = zfroms(fdf,i);
    figure; 
    plot(ts2x_ns,zs2x,'-k');
    hold on;
    plot(tfdf_ns,zfdf,'--r');
    grid on;
    title("Port " + string(i));
    xlabel("time [ns]");
    ylabel("impedance [\Omega]");
    xlim([-0.1 5]);
    legend("2x-Thru","Fixture-DUT-Fixture");
end




function z = zfroms(s,port,f,z0)
% check inputs and add defaults
    if isa(s,"sparameters")
        p = rfparam(s,port,port);
        f = s.Frequencies;
    else
        p = squeeze(s(port,port,:));
    end

    if nargin < 4
        z0 = 50;
    end        

    % make sure f is a column vector
    if size(f,1) == 1
        f = f';
    end
    
    N = length(f);
    filter = blackman(2*N + 1);

    S = makeStep(fftshift(ifft(makeSymmetric([dc(p,f);p]).*fftshift(filter),'symmetric')));
    z = -z0.*(S + 1)./(S - 1);

    if nargout == 0
        tn = tfromf(f)/1e-9;
        figure; plot(tn,z);
    end

function out = blackman(N,alpha)
    % out = blackman(N)
    % N is the number of points of the window
    % reference: https://en.wikipedia.org/wiki/Window_function
    % example of single-sided blackman filter
    %
    % out = blackman(N);
    % out_single_sided = out((N - n + 1):end);
    % where n is the number of points in the single sided spectrum
    %
    %% begin function
    n = (1:N)'; % this is 2*n + 1
    if ~exist('alpha','var')
        alpha = 0.16;
    end
    a0 = (1 - alpha)/2; a1 = 1/2; a2 = alpha/2;
    out = a0 - a1.*cos(2.*pi.*n/N) + a2.*cos(4.*pi.*n/N);
    
function t = tfromf(f)
    n = length(f);
    df = f(2) - f(1);
    t = linspace(-1/(2*df),1/(2*df),2*n + 1); 

function [DCpoint] = DC(s,f)       
        DCpoint = 0.002; % seed for the algorithm
        err = 1; % error seed
        allowedError = 1e-12; % allowable error
        cnt = 0;
        df = f(2) - f(1);
        n = length(f);
        t = linspace(-1/df,1/df,n*2+1);
        [~,ts] = min(abs(t - (-3e-9)));
        Hr = COM_receiver_noise_filter(f,f(end)/2);
        while (err > allowedError)
            h1 = makeStep(fftshift(ifft(makeSymmetric([DCpoint;s.*Hr.']),'symmetric')));
            h2 = makeStep(fftshift(ifft(makeSymmetric([DCpoint+0.001;s.*Hr.']),'symmetric')));
            m = (h2(ts)-h1(ts))/0.001;
            b = h1(ts) - m*DCpoint;
            DCpoint = (0 - b)/m;
            err = abs(h1(ts) - 0);
            cnt = cnt+1;
        end    

function [symmetric] = makeSymmetric(nonsymmetric)
    % [symmetric] = makeSymmetric(nonsymmetric)
    % this takes the nonsymmetric frequency domain input and makes it
    % symmetric.
    %
    % The function assumes the DC point is in the nonsymmetric data

    symmetric_abs = [abs(nonsymmetric); flip(abs(nonsymmetric(2:end)))];
    symmetric_ang = [angle(nonsymmetric); -flip(angle(nonsymmetric(2:end)))];
    symmetric = symmetric_abs.*exp(1i.*symmetric_ang);

function out = simple_filter(f,f0,filter_order)
    out = 1./(1 + 1i.*(f./f0).^filter_order);        
