% Copyright 2024 IEEE 370 open-source project authors (See AUTHORS.md)
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
% FUNCTION: [s1, s2] = asym_2xthru(s2x, Pf)
%
% Author: Jason J. Ellison, Published 1/25/2025
% Revision: original release
% 
% Creates two asymmetric fixture models using the signal flow graph 
% solution. The left model is shorter than the right and the left model is 
% Pf length of the 1x.
% For example: if Pf = 0.5, the left fixture model, s1, will be 0.5 x the
% 1X length and the right model, s2, will be 1.5x the 1X length.  
% Cascading the resulting fixture model together makes the reconstructed
% 2x-thru.
%
% Input 
% s2x: an sparameter object of the 2x-thru
% Pf: a number representing the amount of fixture to remove. This amount is 
% reflected on the left side fixture model, s1.
%
% Output: 
% s1: the shorter left fixture model
% s2: the longer right fixture model
%
% Example:
% s2x = sparameters(filename_s2x); % Use your local file name.
% fdf = sparameters(filename_fdf); % Use your local file name.
% Pf = 0.5;
% [s1, s2] = asym_2xthru(s2x, Pf);
% s1_flipped = sparameters(s1.Parameters([2 1],[2 1],:), s1.Frequencies);
% DUT = deembedsparams(fdf, s1, s1_flipped);
% residual = deembedsparams(s2x, s1, s2);
% reconstructed = cascadesparams(s1, s2);

function [s1, s2] = asym_2xthru(s2x, Pf)

s21 = rfparam(s2x, 2, 1);
s11 = rfparam(s2x, 1, 1);
s22 = rfparam(s2x, 2, 2);

% init21 = rfparam(init1, 2, 1);

f = s2x.Frequencies;
N = length(f);

% initialize the errorboxes
errorbox1 = zeros(2, 2, N);
errorbox2 = zeros(2, 2, N);

% step 1: get X, Actual Pr and the gate locations.
i21 = (ifft(makeSymmetric([dc(s21, f, false); s21]), 'symmetric'));
[~, X] = max(i21);
R = round(X*Pf);
Pf = R/X; % updated Pr
gate_1 = R + N+1;
gate_2 = 2*X - R + N + 1;

% step 2 get e00 for both sides
i11 = ifftshift(ifft(makeSymmetric([dc(s11, f, false);s11]), 'symmetric'));
e00_1_time = i11;
e00_1_time(gate_1:end) = 0;
e00_1_time(gate_1) = -sum(e00_1_time);
e00_1 = fft(fftshift(e00_1_time));
e00_1 = e00_1(2:N+1);

i22 = ifftshift(ifft(makeSymmetric([dc(s22, f, false);s22]), 'symmetric'));
e00_2_time = i22;
e00_2_time(gate_2:end) = 0;
e00_2_time(gate_2) = -sum(e00_2_time);
e00_2 = fft(fftshift(e00_2_time));
e00_2 = e00_2(2:N+1);

% step 3: get e01^1 and e01^2
% these lines use s21 from the fixture

% use s21
alpha = db(s21)/-8.686;

% use attenuation
alpha_p_1 = alpha.*Pf./2;
beta = -unwrap(angle(s21));
beta_p = beta.*Pf./2;

mag = 10.^((alpha_p_1.*-8.686)./20);
ang = -beta_p;
e011 = (mag.*exp(1i.*ang));

% find e01^2 for e11 calculation
alpha_p_2 = alpha.*(2 - Pf)./2;
beta = -unwrap(angle(s21));
beta_p = beta.*(2 - Pf)./2;
mag = 10.^((alpha_p_2.*-8.686)./20);
ang = -beta_p;
e012 = (mag.*exp(1i.*ang));

% step 4: calculate e11
e11_side1 = (s22 - e00_2).*e011./(s21.*e012);
e11_side2 = (s11 - e00_1).*e012./(s21.*e011);


% step 5: Create the error boxes
errorbox1(1, 1, :) = e00_1;
errorbox1(1, 2, :) = e011;
errorbox1(2, 1, :) = e011;
errorbox1(2, 2, :) = e11_side1;
s1 = sparameters(errorbox1, f);

errorbox2(1, 1, :) = e00_2;
errorbox2(1, 2, :) = e012;
errorbox2(2, 1, :) = e012;
errorbox2(2, 2, :) = e11_side2;
s2 = changeSides(sparameters(errorbox2, f));

function [symmetric] = makeSymmetric(nonsymmetric)
% [symmetric] = makeSymmetric(nonsymmetric)
% this takes the nonsymmetric frequency domain input and makes it
% symmetric.
%
% The function assumes the DC point is in the nonsymmetric data

symmetric_abs = [abs(nonsymmetric); flip(abs(nonsymmetric(2:end)))];
symmetric_ang = [angle(nonsymmetric); -flip(angle(nonsymmetric(2:end)))];
symmetric = symmetric_abs.*exp(1i.*symmetric_ang);

function out = changeSides(in)

if isa(in,"sparameters")
    f = in.Frequencies;
    z0 = in.Impedance;
    in = in.Parameters;
    
    n = size(in,1);
    key = [n/2+1:1:n 1:1:n/2];
    out = in(key,key,:);
    out = sparameters(out,f, z0);
else
    n = size(in,1);
    key = [n/2+1:1:n 1:1:n/2];
    out = in(key,key,:);
end

function out = db(in)
out = 20*log10(abs(squeeze(in)));