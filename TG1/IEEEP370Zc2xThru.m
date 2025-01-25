function [s_side1,s_side2] = IEEEP370Zc2xThru_v14(s_2xthru,s_fix_dut_fix,varargin)
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
% FUNCTION: [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix)
%
% Author: Jason J. Ellison, Published 1/25/2025
% Revision: v14
% 
% IEEEP370Zc2xThru.m creates error boxes from a test fixture 2x thru and
% the fixture-dut-fixture S-parameters.
% 
% Inputs: 
% s_2xthru: an S-parameter object of the 2x thru.
% s_fix_dut_fix: an S-parameter object 
% 
% Outputs: 
% s_side1: an S-parameter object of the error box representing the half of the 2x thru connected to port 1
% s_side2: an S-parameter object of the error box representing the half of the 2x thru connected to port 2
%
% Options:
% options are set using name-value pairs.
% "z0": reference impedance of the S-parameters (double)
%    default: 50
% "bandwidth": max frequency for a fitting function (double)
%    default: 0 (use all S-parameters without fit)
% "view": set to view the de-embedding process (boolean)
%    default: false
% "pullback": a number of discrete points to leave in the fixture
% (interger). This sets both sides.
%    default: 0
% "pullback1": a number of discrete points to leave in the fixture on side
% 1 (interger).
%    default: 0
% "pullback2": a number of discrete points to leave in the fixture on side
% 1 (interger).
%    default: 0
% "side1": set to de-embed the left side errorbox (boolean).
%    default: true
% "side2": set to de-embed the left side errorbox (boolean).
%    default: true
% "NRP": set to enforce the Nyquist Rate Point during de-embedding and to
%    add the appropriote delay to the errorboxes. 
%    default: true
% "leadin": a number of discrete points before t = 0 that are non-zero from
%    calibration error. 
%    default: 1
%
% "enable_hybrid" : uses a subroutine to improve IL accuracy if pullback =
%    0
%    default: false
%
% "Pf": Percentage of the fixture to keep. The number can be set between
%    0.1 and 1. This is another way to use pullback and overwrites pullback's
%    value if is set to something other than 1.
%    default: 1
% 
% Usage:
% 
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix);
% s_deembedded_dut = deembedsparams(s_fix_dut_fix,s_side1,s_side2);
% 
% Examples:
% view the process
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix,"view",1);
%
% de-embed side1 only
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix,"side1",true,"side2",false);
%
% Pullback 10 points
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix,"pullback",10);
%
% Pullback side 1 10 points and side 2 30 points
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix,"pullback1",10,"pullback2",30);
%
% Disable Nyquist Rate Point
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix,"NRP",false);
%
% FUNCTION: [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix)

names = varargin(1:2:end);
values = varargin(2:2:end);

% =========== SET OPTIONS and FLAGS =============
% defaults
z0 = 50;
view = false;
bandwidth_limit = 0;
pullback1 = 0;
pullback2 = 0;
side1 = true;
side2 = true;
flag_DC = false;
flag_DF = false;
NRP_enable = true;
leadin = 1;
enable_hybrid = false;
Pf = 1;

for i = 1:length(names)
    names{i} = validatestring(names{i},["z0","bandwidth","view","pullback","pullback1","pullback2","side1","side2","NRP","leadin","enable_hybrid","Pf"]);
    switch names{i}
        case "z0"
            z0 = values{i};
        case "bandwidth"
            bandwidth_limit = values{i};
        case "view"
            view = values{i};
        case "pullback"
            pullback1 = values{i};
            pullback2 = values{i};
        case "pullback1"
            pullback1 = values{i};
        case "pullback2"
            pullback2 = values{i};
        case "side1"
            side1 = values{i};
        case "side2"
            side2 = values{i};
        case "NRP"
            NRP_enable = values{i};
        case "leadin"
            leadin = values{i};
        case "enable_hybrid"
            enable_hybrid = values{i};     
        case "Pf"
            Pf = values{i};             
    end
end

% =========== CHECK FOR BAD INPUTS =============
p = s_fix_dut_fix.Parameters;
f = s_fix_dut_fix.Frequencies;
% check for DC point
if f(1) == 0
    warning("DC point detected. The included DC point will not be used during extraction.");
    flag_DC = true;
    f = f(2:end);
    p = p(:,:,2:end);
    s_fix_dut_fix = sparameters(p,f);
end

% check for bad frequency vector
df = f(2) - f(1);
tol = 0.1; % allow a tolerance of 0.1 hertz from delta-f to starting f (prevent non-issues from precision)
if abs(f(1) - df) > tol
    warning('Non-uniform frequency vector detected. A spline interpolated S-parameter matrix will be created for this calculation. The output results will be re-interpolated to the original vector.');
    flag_DF = true;
    forg = f;
    % interpolate S-parameters if the frequency vector is not acceptable
    if mod(f(end),f(1)) == 0
        fnew = f(1):f(1):f(end);
    else
        fnew = f(1):f(1):(f(end) - mod(f(end),f(1)));
    end
    s_fix_dut_fix = interpolate_sparameters(s_fix_dut_fix,fnew);
end

% if the frequency vector needed to change, adjust the 2x-thru
if or(flag_DC,flag_DF)
    s_2xthru = interpolate_sparameters(s_2xthru,fnew);
end

% check if 2x-thru is not the same frequency vector as the
% fixture-dut-fixture
if ~isequal(s_2xthru.Frequencies,s_fix_dut_fix.Frequencies)
    s_2xthru = interpolate_sparameters(s_2xthru,s_fix_dut_fix.Frequencies);
    warning("2x-thru does not have the same frequency vector as the fixture-dut-fixture. Interpolating to fix problem");
end

% =========== Enforce Nyquist Rate Point ==
if NRP_enable
    [s_fix_dut_fix,TD] = NRP(s_fix_dut_fix);
    [s_2xthru,~] = NRP(s_2xthru,-TD);
end

% === Remove Lead-in Points ===============
if leadin > 0
    [~,temp1,temp2] = peelNPointsLossless(shiftNPoints(s_fix_dut_fix,leadin),leadin);
    leadin1 = shiftOnePort(temp1,-leadin,1,z0);
    leadin2 = shiftOnePort(temp2,-leadin,2,z0);
end

% =========== CALCULATE GAMMA =============
p = s_2xthru.Parameters;
f = s_2xthru.Frequencies;

% grabbing S21
s212x = squeeze(p(2,1,:));

% get the attenuation and phase constant per length
beta_per_length = -unwrap(angle(s212x)); 
attenuation = abs(rfparam(s_2xthru,2,1)).^2./(1 - abs(rfparam(s_2xthru,1,1)).^2);
alpha_per_length = (10.*log10(attenuation))/-8.686;

if bandwidth_limit == 0
    % divide by 2*n + 1 to get prop constant per descrete unit length
    gamma = alpha_per_length + 1i.*beta_per_length; % gamma without DC
else
    % fit the attenuation up to the limited bandwidth
    [~,bwl_x] = min(abs(f - bandwidth_limit));
    X = [sqrt(f(1:bwl_x)) f(1:bwl_x) f(1:bwl_x).^2];
    b = (X'*X)\X'*alpha_per_length(1:bwl_x);
    alpha_per_length_fit = b(1).*sqrt(f) + b(2).*f + b(3).*f.^2;
    % divide by 2*n + 1 to get prop constant per descrete unit length
    gamma = alpha_per_length_fit + 1i.*beta_per_length; % gamma without DC
end

% =========== EXTRACT ERRORBOXES =============
% make the both error box


s_side1 = thru(s_fix_dut_fix);
s_side2 = thru(s_fix_dut_fix);
if and(and(isequal(pullback1,pullback2),side1),side2)
    [s_side1,s_side2] = makeErrorbox_v7(s_fix_dut_fix,s_2xthru,gamma,z0,view,pullback1,enable_hybrid,Pf);
elseif and(side1,side2)
    s_side1 = makeErrorbox_v8(s_fix_dut_fix,s_2xthru,gamma,z0,view,pullback1,enable_hybrid, Pf);
    s_side2 = makeErrorbox_v8(changeSides(s_fix_dut_fix),s_2xthru,gamma,z0,view,pullback2,enable_hybrid, Pf);
    s_side2 = changeSides(s_side2);
elseif side1
    s_side1 = makeErrorbox_v8(s_fix_dut_fix,s_2xthru,gamma,z0,view,pullback1,enable_hybrid, Pf);
elseif side2
    s_side2 = makeErrorbox_v8(changeSides(s_fix_dut_fix),s_2xthru,gamma,z0,view,pullback2,enable_hybrid, Pf);
    s_side2 = changeSides(s_side2);
else
    warning("no output because no output was requested");
end



% =========== INTERPOLATE TO ORIGINAL FREQUENCY IF NEEDED =============
% revert back to original frequency vector
if flag_DF
    s_side1 = interpolate_sparameters(s_side1,forg);
    s_side2 = interpolate_sparameters(s_side2,forg);
end

% add DC back in
if flag_DC
   s_side1 = add_dc(s_side1);
   s_side2 = add_dc(s_side2);
end

% remove lead in
if leadin > 0
    if side1
        s_side1 = cascadesparams(leadin1,s_side1);
    end
    if side2
        s_side2 = cascadesparams(s_side2,leadin2);
    end
end

% if Nyquist Rate Point enfocement is enabled.
if NRP_enable
    if side1 % if side 1 is enabled
        s_side1 = NRP(s_side1,TD,1);
    end
    if side2 % if side 2 is enabled
        s_side2 = NRP(s_side2,TD,2);
    end
end

% ========= END ===========

% ========= FUNCTIONS ===========
function out = thru(in)
    f = in.Frequencies;
    n = length(f);
    p = zeros(2,2,n);
    p(2,1,:) = 1;
    p(1,2,:) = 1;
    out = sparameters(p,f);


function out = interpolate_sparameters(in,fnew)
    p = in.Parameters;
    f = in.Frequencies;
    pnew = zeros(2,2,length(fnew));
    for i = 1:2
        for j = 1:2
            pnew(i,j,:) = interp1(f,squeeze(p(i,j,:)),fnew,'spline');
        end
    end
    p = pnew;
    out = sparameters(p,fnew);

function out = add_dc(in)
   p = in.Parameters;
   f = in.Frequencies;
   
   n = length(f);
   pnew = zeros(2,2,n + 1);
   pnew(:,:,2:end) = p;
   pnew(1,1,1) = dc_interp(squeeze(p(1,1,:)),f);
   pnew(1,2,1) = dc_interp(squeeze(p(1,2,:)),f);
   pnew(2,1,1) = dc_interp(squeeze(p(2,1,:)),f);
   pnew(2,2,1) = dc_interp(squeeze(p(2,2,:)),f);
   
   f = [0;f];
   out = sparameters(pnew,f);

function dc = dc_interp(sin,f)
% enforces symmetric upon the first 10 points and interpolates the DC
% point.
if size(f,1) == 1
    f = f';
end
sp = sin(1:10);
fp = f(1:10);

snp = [conj(flip(sp)) ; sp];
fnp = [-flip(fp) ; fp];
fnew = [-flip(fp) ; 0; fp];
snew = interp1(fnp,snp,fnew,'spline');
dc = real(snew(11));    
    
function [DCpoint] = DC2(s,f)
    if size(f,1) == 1
        f = f';
    end
    DCpoint = 0.002; % seed for the algorithm
    err = 1; % error seed
    allowedError = 1e-10; % allowable error
    cnt = 0;
    df = f(2) - f(1);
    n = length(f);
    t = linspace(-1/df,1/df,n*2+1);
    [~,ts] = min(abs(t - (-3e-9)));
    Hr = COM_receiver_noise_filter(f,f(end)/2);
    while (err > allowedError)
        h1 = makeStep(fftshift(ifft(makeSymmetric([DCpoint;s.*Hr]),'symmetric')));
        h2 = makeStep(fftshift(ifft(makeSymmetric([DCpoint+0.001;s.*Hr]),'symmetric')));
        m = (h2(ts)-h1(ts))/0.001;
        b = h1(ts) - m*DCpoint;
        DCpoint = (0 - b)/m;
        err = abs(h1(ts) - 0);
        cnt = cnt+1;
    end

function [errorbox1,errorbox2] = makeErrorbox_v7(s_dut,s2x,gamma,z0,view,pullback,enable_hybrid,Pf)
f = s2x.Frequencies;
n = length(f);
s212x = rfparam(s2x,2,1);

% extract midpoint of 2x-thru
DC21 = dc_interp(s212x,f);
[~,x] = max(ifft(makeSymmetric([DC21;s212x]),'symmetric'));

% define relative length
l = 1/(2*x);

% if Pf is set, overwrite pullback
if Pf ~= 1
    R = round(x*Pf);
    pullback = x - R;
end


% define the reflections to be mimicked
s11dut = rfparam(s_dut,1,1);
s22dut = rfparam(s_dut,2,2);

% peel the fixture away and create the fixture model
for i = 1:x-pullback
    zline1 = getz(s11dut,f,z0);
    zline2 = getz(s22dut,f,z0);
    TL1 = makeTL(zline1,z0,gamma,l);
    TL2 = makeTL(zline2,z0,gamma,l);
    if i == 1           
        errorbox1 = TL1;
        errorbox2 = TL2;
        [~,z1] = getz(s11dut,f,z0);
        [~,z2] = getz(s22dut,f,z0);
    else
        errorbox1 = cascadesparams(errorbox1,TL1);
        errorbox2 = cascadesparams(errorbox2,TL2);
    end
    
    s_dut = removeTL(s_dut,TL1,TL2,z0);
    s11dut = rfparam(s_dut,1,1);
    s22dut = rfparam(s_dut,2,2);
    
    if view
        if i == 1

            handle = figure;
        end
        [~,zeb1] = getz(squeeze(errorbox1(1,1,:)),f,z0);
        [~,zeb2] = getz(squeeze(errorbox2(1,1,:)),f,z0);
        [~,zdut1] = getz(s11dut,f,z0);
        [~,zdut2] = getz(s22dut,f,z0);
        figure(handle);
        subplot(2,2,1);
        plot(z1); hold on; plot(zeb1);
        xlim([1 x]);
        hold off
        subplot(2,2,2);
        plot(z2); hold on; plot(zeb2);
        xlim([1 x]);
        hold off;
        
        subplot(2,2,3);
        plot(ifftshift(zdut1));
        xlim([n-100 n+x*2+10]);
        hold off;
        
        subplot(2,2,4);
        plot(ifftshift(zdut2));
        xlim([n-100 n+x*2+10]);
        hold off;        
    end

end

% if pullback was used, hybrid cannot be used.
if pullback ~= 0
    enable_hybrid = false;
end

% close(wait_handle);
errorbox1 = sparameters(errorbox1,f,z0);
errorbox2 = sparameters(changeSides(errorbox2),f,z0);
if enable_hybrid
    errorbox1 = hybrid(errorbox1,s2x,z0);
    errorbox2 = changeSides(hybrid(changeSides(errorbox2), changeSides(s2x), z0));
end
    
function errorbox = hybrid(errorbox,s2x,z0)
    % taking the errorbox created by peeling and using it only for e00 and e11
    
    % grab s11 and s22 of errorbox model
    s11_errorbox = errorbox; clear errorbox;
    s111x = squeeze(s11_errorbox.Parameters(1,1,:));
    s221x = squeeze(s11_errorbox.Parameters(2,2,:));
    
    % grab s21 of the 2x thru measurement
    s212x = squeeze(s2x.Parameters(2,1,:));
    f = s2x.Frequencies;
    
    % the choice of sign in the sqrt is important. Use the sign that captures the proper angle.
    s211x = zeros(length(f),1);
    s211x(1) = sqrt(s212x(1).*(1-s221x(1).^2));
    test = sqrt(s212x.*(1-s221x.^2));
    k = 1;
    for i = 2:length(f)
        if angle(test(i)) - angle(test(i-1)) > 0
            k = k*-1;
        end
        s211x(i) = k*sqrt(s212x(i).*(1-s221x(i).^2));
    end
    
    % create the error box and make the s-parameter block
    errorbox_ = zeros(2,2,length(f));
    errorbox_(1,1,:) = s111x;
    errorbox_(2,1,:) = s211x;
    errorbox_(1,2,:) = s211x;
    errorbox_(2,2,:) = s221x;
    errorbox = sparameters(errorbox_,f,z0);  

function errorbox = makeErrorbox_v8(s_dut,s2x,gamma,z0,view,pullback, enable_hybrid, Pf)
f = s2x.Frequencies;
s212x = rfparam(s2x,2,1);

% extract midpoint of 2x-thru
DC21 = dc_interp(s212x,f);
[~,x] = max(ifft(makeSymmetric([DC21;s212x]),'symmetric'));

% if Pf is set, overwrite pullback
if Pf ~= 1
    R = round(x*Pf);
    pullback = x - R;
end


% define relative length
l = 1/(2*x);

% define the reflections to be mimicked
s11dut = rfparam(s_dut,1,1);

% peel the fixture away and create the fixture model
for i = 1:x-pullback 
    zline1 = getz(s11dut,f,z0);
    TL1 = makeTL(zline1,z0,gamma,l);
    if i == 1           
        errorbox = TL1;
        [~,z1] = getz(s11dut,f,z0);
    else
        errorbox = cascadesparams(errorbox,TL1);
    end
    
    s_dut = removeTL_side1(s_dut,TL1,z0);
    s11dut = rfparam(s_dut,1,1);
    
    if view
        if i == 1
            handle = figure;
        end
        [~,zeb1] = getz(squeeze(errorbox(1,1,:)),f,z0);
        figure(handle);
        plot(z1); hold on; plot(zeb1);
        xlim([1 x]);
        hold off     
    end

end

% close(wait_handle);
errorbox = sparameters(errorbox,f,z0);

% if pullback was used, hybrid cannot be used.
if pullback ~= 0
    enable_hybrid = false;
end

if enable_hybrid
    errorbox = hybrid(errorbox,s2x,z0);
end

function out = removeTL(in,TL1,TL2,z0)
    abcd_TL1 = s2abcd(TL1,z0);
    abcd_TL2 = s2abcd(TL2,z0);
    abcd_in = s2abcd(in.Parameters,z0);
    f = in.Frequencies;
    n = length(TL1);
    for j = 1:n
        abcd_in(:,:,j) = abcd_TL1(:,:,j)\abcd_in(:,:,j)/abcd_TL2(:,:,j);
    end% peel the TL away
    out_ = abcd2s(abcd_in,z0); % convert the new peeled dut from ABCD to S-parameters
    out = sparameters(out_,f,z0);
    
function out = removeTL_side1(in,TL,z0)
    abcd_TL = s2abcd(TL,z0);
    abcd_in = s2abcd(in.Parameters,z0);
    f = in.Frequencies;
    n = length(TL);
    for j = 1:n
        abcd_in(:,:,j) = abcd_TL(:,:,j)\abcd_in(:,:,j);
    end% peel the TL away
    out_ = abcd2s(abcd_in,z0); % convert the new peeled dut from ABCD to S-parameters
    out = sparameters(out_,f,z0);

function [zl,z] = getz(s,f,z0)
    if size(f,1) == 1
        f = f';
    end
    DC11 = DC2(s,f);
    t112x = ifft(makeSymmetric([DC11;s]),'symmetric'); 

    % get the step response of t112x. Shift is needed for makeStep to
    % work prpoerly.
    t112xStep = makeStep(fftshift(t112x));

    % construct the transmission line;
    z = -z0.*(t112xStep + 1)./(t112xStep - 1);
    z = ifftshift(z); % <-- impedance. Shift again to get the first point
    zl = z(1);

function TL = makeTL(zline,z0,gamma,l)
    n = length(gamma);
    TL = zeros(2,2,n); 
    TL(1,1,:) = ((zline.^2 - z0.^2).*sinh(gamma.*l))./((zline.^2 + z0.^2).*sinh(gamma.*l) + 2.*z0.*zline.*cosh(gamma.*l));
    TL(2,1,:) = (2.*z0.*zline)./((zline.^2 + z0.^2).*sinh(gamma.*l)+2.*z0.*zline.*cosh(gamma.*l));
    TL(1,2,:) = (2.*z0.*zline)./((zline.^2 + z0.^2).*sinh(gamma.*l)+2.*z0.*zline.*cosh(gamma.*l));   
    TL(2,2,:) = ((zline.^2 - z0.^2).*sinh(gamma.*l))./((zline.^2 + z0.^2).*sinh(gamma.*l) + 2.*z0.*zline.*cosh(gamma.*l));                
    

    
function [step] = makeStep(impulse)
    % make the step function per Signals and Systems, S. Haykin. Chapter 
    ustep = ones(length(impulse),1);    
    step = conv(ustep,impulse);
    step = step(1:length(impulse));
    
function [symmetric] = makeSymmetric(nonsymmetric)
    % [symmetric] = makeSymmetric(nonsymmetric)
    % this takes the nonsymmetric frequency domain input and makes it
    % symmetric.
    %
    % The function assumes the DC point is in the nonsymmetric data
    symmetric_abs = [abs(nonsymmetric); flip(abs(nonsymmetric(2:end)))];
    symmetric_ang = [angle(nonsymmetric); -flip(angle(nonsymmetric(2:end)))];
    symmetric = symmetric_abs.*exp(1i.*symmetric_ang);    
    
function Hr = COM_receiver_noise_filter(f,fr)
    % reciever filter in COM defined by eq 93A-20
    if size(f,1) == 1
        f = f';
    end
    f = f/1e9;
    fdfr = f./fr;
    Hr = 1./(1 - 3.414214.*(fdfr).^2 + fdfr.^4 + 1i.*2.613126.*(fdfr - fdfr.^3)); % eq 93A-20    
    
function out = changeSides(in)
    if isa(in,"sparameters")
        p = in.Parameters;
        f = in.Frequencies;
        n = size(p,1);
        key = [n/2+1:1:n 1:1:n/2];
        out = sparameters(p(key,key,:),f);
    else
        n = size(in,1);
        key = [n/2+1:1:n 1:1:n/2];
        out = in(key,key,:);    
    end
    
function [out,TD] = NRP(in,TD,port)
     [p, f, n, X] = decomposeSparameters(in);
     fend = f(end);
     if nargin == 1
         TD = zeros(X,1);
         for i = 1:X
            theta0 = angle(p(i,i,end));
            if theta0 < -pi/2
                theta = -pi - theta0;
            elseif theta0 > pi/2
                theta = pi - theta0;
            else
                theta = -theta0;
            end
            TD(i) = -theta/(2*pi*fend);
            pd = zeros(X,X,n);
            delay = exp(-1i.*2.*pi.*f.*TD(i)/2);
            if i == 1
                pd(i + X/2,i,:) = delay;
                pd(i,i + X/2,:) = delay;             
                pout = cascadesparams(pd,p);            
            elseif i <= X/2
                pd(i + X/2,i,:) = delay;
                pd(i,i + X/2,:) = delay;                         
                pout = cascadesparams(pd,pout);
            else
                pd(i - X/2,i,:) = delay;
                pd(i,i - X/2,:) = delay;    
                pout = cascadesparams(pout,pd);
            end
         end
         out = sparameters(pout,f);
     end
     if nargin >= 2
         pd = zeros(X,X,n);
         if nargin == 3
            i = port;
            delay = exp(1i.*2.*pi.*f.*TD(i)/2);
            if i <= X/2
                pd(i + X/2,i,:) = delay;
                pd(i,i + X/2,:) = delay;                         
                pout = cascadesparams(pd,p);
            else
                pd(i - X/2,i,:) = delay;
                pd(i,i - X/2,:) = delay;    
                pout = cascadesparams(p,pd);
            end
         else
             for i = 1:X
                delay = exp(1i.*2.*pi.*f.*TD(i)/2);
                if i == 1
                    pd(i + X/2,i,:) = delay;
                    pd(i,i + X/2,:) = delay;             
                    pout = cascadesparams(pd,p);            
                elseif i <= X/2
                    pd(i + X/2,i,:) = delay;
                    pd(i,i + X/2,:) = delay;                         
                    pout = cascadesparams(pd,pout);
                else
                    pd(i - X/2,i,:) = delay;
                    pd(i,i - X/2,:) = delay;    
                    pout = cascadesparams(pout,pd);
                end
             end
         end
         out = sparameters(pout,f);
     end

function out = shiftOnePort(in,N,port,z0)
    [p,f,n,X] = decomposeSparameters(in);
    Omega0 = pi/n;
    Omega = (Omega0:Omega0:pi).';
    delay = exp(-N.*1i.*Omega/2);
    pd = zeros(2,2,n);
    if port <= X/2
        pd(port,port + X/2,:) = delay;
        pd(port + X/2,port,:) = delay;
        out = sparameters(cascadesparams(pd,p),f,z0);
    else
        pd(port,port - X/2,:) = delay;
        pd(port - X/2,port,:) = delay;
        out = sparameters(cascadesparams(p,pd),f,z0);
    end

function [p,f,n,X] = decomposeSparameters(in)
    if nargout >= 1; p = in.Parameters; end
    if nargout >=2;  f = in.Frequencies;end
    if nargout >=3;  n = length(f); end
    if nargout > 3;  X = in.NumPorts; end   

function out = shiftNPoints(in,N)
    [p,f,n,X] = decomposeSparameters(in);
    Omega0 = pi/n;
    Omega = (Omega0:Omega0:pi).';
    delay = exp(-N.*1i.*Omega/2);
    pd = zeros(2,2,n);
    for port = 1:X
        if port <= X/2
            pd(port,port + X/2,:) = delay;
            pd(port + X/2,port,:) = delay;
            p = cascadesparams(pd,p);
        else
            pd(port,port - X/2,:) = delay;
            pd(port - X/2,port,:) = delay;
            out = sparameters(cascadesparams(p,pd),f);
        end
    end

function [out,eb1,eb2] = peelNPointsLossless(in,N)
    % assume in is an S-parameter object
    [p,f,n,~] = decomposeSparameters(in);
    abcd = s2abcd(p,50);
    Omega0 = pi/n;
    Omega = Omega0:Omega0:pi;
    betal = Omega/2;
    
    for i = 1:N
        % get the S11 vector in time
        h1 = makeStep(fftshift(ifft(makeSymmetric([dc(squeeze(p(1,1,:)),f);squeeze(p(1,1,:))]),"symmetric")));
        % get the S22 vector in time
        h2 = makeStep(fftshift(ifft(makeSymmetric([dc(squeeze(p(2,2,:)),f);squeeze(p(2,2,:))]),"symmetric")));
        % calculate impedance
        z1 = -50.*(h1+1)./(h1-1); z1 = ifftshift(z1);
        z2 = -50.*(h2+1)./(h2-1); z2 = ifftshift(z2);
        % create a single point error box
        z10 = z1(1);
        z20 = z2(1);
        
        % this is the transmission line to be removed
        ABCD1 = getABCD(z10,betal);
        ABCD2 = getABCD(z20,betal);
        
        % remove the errorboxes
        for j = 1:n
            abcd(:,:,j) = ABCD1(:,:,j)\abcd(:,:,j)/ABCD2(:,:,j);            
        end
        p = abcd2s(abcd,50);
        % capture the errorboxes from side 1 and 2
        if i == 1
            eb1 = ABCD1;
            eb2 = ABCD2;
        else
            for j = 1:n
                eb1(:,:,j) = eb1(:,:,j)*ABCD1(:,:,j);
                eb2(:,:,j) = ABCD2(:,:,j)*eb2(:,:,j);
            end
        end
    
    end
    % outputs
    eb1 = sparameters(abcd2s(eb1,50),f); %  verified 
    eb2 = sparameters(abcd2s(eb2,50),f);  % verified
    out = sparameters(abcd2s(abcd,50),f); % verified    

function ABCD = getABCD(z0,betal)
    y0 = 1/z0;
    A = cos(betal);
    B = 1i.*(z0).*sin(betal);
    C = 1i.*y0.*sin(betal);
    ABCD = zeros(2,2,length(betal));
    ABCD(1,1,:) = A;
    ABCD(1,2,:) = B;
    ABCD(2,1,:) = C;
    ABCD(2,2,:) = A; 

 function [DCpoint] = dc(s,f) 
% both s and f are assumed to be column vectors. enforce.
if size(s,1) == 1
    s = s';
end
if size(f,1) == 1
    f = f';
end
        % [DCpoint] = dc(s,f) 
        % force a dc point for reflection coefficient
        DCpoint = 0.002; % seed for the algorithm
        err = 1; % error seed
        allowedError = 1e-10; % allowable error
        cnt = 0;
        df = f(2) - f(1);
        n = length(f);
        t = linspace(-1/df,1/df,n*2+1);
        [~,ts] = min(abs(t - (-3e-9)));
        Hr = simple_filter(f,f(end)/2,2);
        while (err > allowedError)
            h1 = makeStep(fftshift(real(ifft(makeSymmetric([DCpoint;s.*Hr])))));
            h2 = makeStep(fftshift(real(ifft(makeSymmetric([DCpoint+0.001;s.*Hr])))));
            m = (h2(ts)-h1(ts))/0.001;
            b = h1(ts) - m*DCpoint;
            DCpoint = (0 - b)/m;
            err = abs(h1(ts) - 0);
            cnt = cnt+1;
        end  

  function out = simple_filter(f,f0,filter_order)
    out = 1./(1 + 1i.*(f./f0).^filter_order); 
    
