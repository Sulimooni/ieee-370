function [s_side1,s_side2] = IEEEP3702xThru(s_2xthru,varargin)
% Copyright 2017 The Institute of Electrical and Electronics Engineers, Incorporated (IEEE).
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
% Function: [s_side1,s_side2] = IEEEP3702xThru(s_2xthru,response)
%
% Author: Jason J. Ellison, Published February 5th, 2018
% Revision: v13
% 
% IEEEP3702xThru.m creates error boxes from a test fixture 2x thru. 
% 
% Input: 
% s_2xthru--an s parameter object of the 2x thru.
% 
% response (optional)-- Choose impulse or step response to create the e00 transfer function.
%                       0(default) for impulse, 1 for step
% 
% Outputs: 
% s_side1--an s parameter object of the error box representing the half of the 2x thru connected to port 1
% s_side2--an s parameter object of the error box representing the half of the 2x thru connected to port 2
% 
% residual test usage:
% 
% [s_side1,s_side2] = IEEEP3702xThru(s_2xthru);
% s_deembedded_dut = deembedsparams(s_fixture_dut_fixture,s_side1,s_side2);

if nargin >= 2
    response = varargin{1};
else
    response = 0;
end


s2x = s_2xthru;
f = s2x.Frequencies;
fnew = linspace(1e6,f(end),f(end)/1e6);
n = length(fnew);
n_orig = length(f);
npad = n*2+1;
p2x = s2x.Parameters;
p112x = squeeze(p2x(1,1,:));
p212x = squeeze(p2x(2,1,:));

% get the DC point of p112x and p212x and interpolate
p112xDC = DC(p112x,f);
p112x = [p112xDC; p112x];
p112x = interp1([0;f],p112x,[0 fnew].','spline');

p212xDC = DC(p212x,f);
p212x = [p212xDC; p212x];
p212x = interp1([0;f],p212x,[0 fnew].');
p112x = makeSymmetric(p112x);
p212x = makeSymmetric(p212x);

% convert p112x and p212x to time
t112x = ifft(p112x,'symmetric');
t212x = ifft(p212x,'symmetric');

% convert t112x and t212x to step response
t112xStep = makeStep(fftshift(t112x));
t212xStep = makeStep(fftshift(t212x));

% find the mid point of the trace in z
[~,mid_z] = min(abs(t212xStep-0.5));

if response == 1 % use step response
    % make the t112xStep t111xStep
    t111xStep = zeros(n*2 + 1,1);
    t111xStep((n+1):mid_z) = t112xStep((n+1):mid_z);
    t111xStep = ifftshift(t111xStep);

    % convert t111xStep to t111x
    t111x = t111xStep - [0 ; t111xStep(1:end-1)];
    
elseif response == 0 % use impulse response
    % make the t112x, t111x
    t112xs = fftshift(t112x);
    t111x = zeros(n*2 + 1,1);
    t111x(1:mid_z) = t112xs(1:mid_z);
    
    t111x = ifftshift(t111x);
end

% convert to p111x
p111x = fft(t111x);

% calculate the p221x and p211x
p221x = (p112x - p111x)./p212x;

% the choice of sign in the sqrt is important. Use the sign that captures the proper angle.
p211x = zeros(npad,1);
p211x(1) = sqrt(p212x(1).*(1-p221x(1).^2));
test = sqrt(p212x.*(1-p221x.^2));
k = 1;
for i = 2:npad
    if angle(test(i)) - angle(test(i-1)) > 0
        k = k*-1;
    end
    p211x(i) = k*sqrt(p212x(i).*(1-p221x(i).^2));
end

% convert errorbox elements to original frequency vector
p111x = p111x(2:length(fnew)+1);
p111x = interp1(fnew,p111x,f,'spline');

p211x = p211x(2:length(fnew)+1);
p211x = interp1(fnew,p211x,f,'spline');

p221x = p221x(2:length(fnew)+1);
p221x = interp1(fnew,p221x,f,'spline');

% create the error box and make the s-parameter block
errorbox = zeros(2,2,n_orig);
errorbox(1,1,:) = p111x;
errorbox(2,1,:) = p211x;
errorbox(1,2,:) = p211x;
errorbox(2,2,:) = p221x;

s_side1 = sparameters(errorbox,f);

s2x = s_2xthru;
f = s2x.Frequencies;
fnew = linspace(1e6,f(end),f(end)/1e6);
n = length(fnew);
n_orig = length(f);
npad = n*2+1;
p2x = s2x.Parameters;
p112x = squeeze(p2x(2,2,:));
p212x = squeeze(p2x(1,2,:));

% get the DC point of p112x and p212x and interpolate
p112xDC = DC(p112x,f);
p112x = [p112xDC; p112x];
p112x = interp1([0;f],p112x,[0 fnew].','spline');

p212xDC = DC(p212x,f);
p212x = [p212xDC; p212x];
p212x = interp1([0;f],p212x,[0 fnew].');
p112x = makeSymmetric(p112x);
p212x = makeSymmetric(p212x);

% convert p112x and p212x to time
t112x = ifft(p112x,'symmetric');
t212x = ifft(p212x,'symmetric');

% convert t112x and t212x to step response
t112xStep = makeStep(fftshift(t112x));
t212xStep = makeStep(fftshift(t212x));

% find the mid point of the trace in z
[~,mid_z] = min(abs(t212xStep-0.5));

if response == 1 % use step response
    % make the t112xStep t111xStep
    t111xStep = zeros(n*2 + 1,1);
    t111xStep((n+1):mid_z) = t112xStep((n+1):mid_z);
    t111xStep = ifftshift(t111xStep);

    % convert t111xStep to t111x
    t111x = t111xStep - [0 ; t111xStep(1:end-1)];
    
elseif response == 0 % use impulse response
    % make the t112x, t111x
    t112xs = fftshift(t112x);
    t111x = zeros(n*2 + 1,1);
    t111x(1:mid_z) = t112xs(1:mid_z);
    
    t111x = ifftshift(t111x);
end

% convert to p111x
p111x = fft(t111x);

% calculate the p221x and p211x
p221x = (p112x - p111x)./p212x;

% the choice of sign in the sqrt is important. Use the sign that captures the proper angle.
p211x = zeros(npad,1);
p211x(1) = sqrt(p212x(1).*(1-p221x(1).^2));
test = sqrt(p212x.*(1-p221x.^2));
k = 1;
for i = 2:npad
    if angle(test(i)) - angle(test(i-1)) > 0
        k = k*-1;
    end
    p211x(i) = k*sqrt(p212x(i).*(1-p221x(i).^2));
end

% convert errorbox elements to original frequency vector
p111x = p111x(2:length(fnew)+1);
p111x = interp1(fnew,p111x,f,'spline');

p211x = p211x(2:length(fnew)+1);
p211x = interp1(fnew,p211x,f,'spline');

p221x = p221x(2:length(fnew)+1);
p221x = interp1(fnew,p221x,f,'spline');

% create the error box and make the s-parameter block
errorbox = zeros(2,2,n_orig);
errorbox(1,1,:) = p111x;
errorbox(2,1,:) = p211x;
errorbox(1,2,:) = p211x;
errorbox(2,2,:) = p221x;

s_side2 = sparameters(errorbox([2 1],[2 1],:),f);

function [symmetric] = makeSymmetric(nonsymmetric)
    % [symmetric] = makeSymmetric(nonsymmetric)
    % this takes the nonsymmetric frequency domain input and makes it
    % symmetric.
    %
    % The function assumes the DC point is in the nonsymmetric data

    symmetric_abs = [abs(nonsymmetric); flip(abs(nonsymmetric(2:end)))];
    symmetric_ang = [angle(nonsymmetric); -flip(angle(nonsymmetric(2:end)))];
    symmetric = symmetric_abs.*exp(1i.*symmetric_ang);

function [DCpoint] = DC(s,f)       
    % find the real dc point. The equation is y = a*x^2+b.
    N = 2; % N can be changed to improve DC point accuracy. Larger numbers for short structures. Small numbers for long structures
    x = f(1:N);
    y = real(s(1:N));

    X = [ones(N,1) x.^2];
    t = (X'*X)\X'*y;
    DCpoint = t(1);

function [step] = makeStep(impulse)
    ustep = ones(length(impulse),1);    
    step = conv(ustep,impulse);
    step = step(1:length(impulse));