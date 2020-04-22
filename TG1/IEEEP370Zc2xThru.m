function [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix,varargin)
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
% FUNCTION: [s_side1,s_side2] = IEEEP3702xThru(s_2xthru,s_fix_dut_fix,Z0,view,bandwidth_limit)
%
% Author: Jason J. Ellison, Published February 5th, 2018
% Revision: v3
% 
% IEEEP370Zc2xThru.m creates error boxes from a test fixture 2x thru and
% the fixture-dut-fixture S-parameters.
% 
% Input: 
% s_2xthru: an S-parameter object of the 2x thru.
% s_fix_dut_fix: an S-parameter object 
% Z0 (optional): Port reference impedance. Default: 50.
% view (optional): set to 1 to view the impedance correction. Default: 0.
% 
% Outputs: 
% s_side1: an S-parameter object of the error box representing the half of the 2x thru connected to port 1
% s_side2: an S-parameter object of the error box representing the half of the 2x thru connected to port 2
% 
% Usage:
% 
% [s_side1,s_side2] = IEEEP370Zc2xThru(s_2xthru,s_fix_dut_fix);
% s_deembedded_dut = deembedsparams(s_fix_dut_fix,s_side1,s_side2);
%
% FUNCTION: [s_side1,s_side2] = IEEEP3702xThru(s_2xthru,s_fix_dut_fix,Z0,view,bandwidth_limit)

if nargin >= 3
    z0 = varargin{1};
else
    z0 = 50;
end

if nargin >= 4
    view = varargin{2};
else
    view = 0;
end

if nargin >= 5
    bandwidth_limit = varargin{3};
else
    bandwidth_limit = 0;
end

if nargin > 5
    warning('Too many inputs. All input arguements after the third are ignored.');
end

p = s_2xthru.Parameters;
f = s_2xthru.Frequencies;

% grabbing S21
s212x = squeeze(p(2,1,:));

% get the attenuation and phase constant per length
beta_per_length = -unwrap(angle(s212x)); 
alpha_per_length = db(s212x)/-8.686;

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



% make the first error box
s_side1 = makeErrorbox(s_fix_dut_fix,s_2xthru,gamma,z0,view);

% reverse the port order of fixture-dut-fixture and 2x thru
p_temp = s_fix_dut_fix.Parameters;
p_temp = p_temp([2 1],[2 1],:);
s_fix_dut_fix_reversed = sparameters(p_temp,f,z0);

p_temp = s_2xthru.Parameters;
p_temp = p_temp([2 1],[2 1],:);
s_2xthru_reversed = sparameters(p_temp,f,z0);

% make the second error box and correct the port order
errorbox_side2 = makeErrorbox(s_fix_dut_fix_reversed,s_2xthru_reversed,gamma,z0,view);
p_temp = errorbox_side2.Parameters;
p_temp = p_temp([2 1],[2 1],:);
s_side2 = sparameters(p_temp,f,z0);

function [DCpoint] = DC(s,f)       
% P370 DC extrapolation technique. See IEEE P370 Annex R
    smn = s;
    t = unwrap(angle(s))./(2.*pi.*f);
    w = 2*pi*f;
    delay = exp(-1i.*w.*t);

    f1 = f(10) ; f2 = f(20);
    real1 = real(smn(10).*delay(10)); real2 = real(smn(20).*delay(20));
    realb = (real1 - real2)/(f1^2 - f2^2);
    reala = (real1 - realb*f1^2);
    
    DCpoint = reala;
    
function [DCpoint] = DC2(s,f)       
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
            h1 = makeStep(fftshift(ifft(makeSymmetric([DCpoint;s.*Hr.']),'symmetric')));
            h2 = makeStep(fftshift(ifft(makeSymmetric([DCpoint+0.001;s.*Hr.']),'symmetric')));
            m = (h2(ts)-h1(ts))/0.001;
            b = h1(ts) - m*DCpoint;
            DCpoint = (0 - b)/m;
            err = abs(h1(ts) - 0);
            cnt = cnt+1;
        end    
    
function errorbox = makeErrorbox(s_dut,s2x,gamma,z0,view)
    % extract the mid point of the 2x thru
    s212x = squeeze(s2x.Parameters(2,1,:));
    f = s2x.Frequencies;
    n = length(f);
    DC21 = DC(s212x,f);
    t212x = ifft(makeSymmetric([DC21;s212x]),'symmetric'); 
    [~,x] = max(t212x);
    
    % define the relative length 
    l = 1/(2*x);
    
    % define the reflection of the fixture-dut-fixture to be mimicked
    s11_dut = squeeze(s_dut.Parameters(1,1,:));       
    
    % peel the fixture away and create the fixture reflection model
    for i = 1:x
        % convert fixture-dut-fixture reflection to time, t112x
%         DC11 = DC(s11_dut,f);
        DC11 = DC2(s11_dut,f.');
%         DC11 = 0;
        t112x = ifft(makeSymmetric([DC11;s11_dut]),'symmetric'); 
        
        % get the step response of t112x. Shift is needed for makeStep to
        % work prpoerly.
        t112xStep = makeStep(fftshift(t112x));

        % construct the transmission line;
        zl = -z0.*(t112xStep + 1)./(t112xStep - 1);
        zl = ifftshift(zl); % <-- impedance. Shift again to get the first point
        
        % use lossy port extension equation D12 
        TL = zeros(2,2,n); 
        TL(1,1,:) = squeeze(((zl(1).^2 - z0.^2).*sinh(gamma.*l))./((zl(1).^2 + z0.^2).*sinh(gamma.*l) + 2.*z0.*zl(1).*cosh(gamma.*l)));
        TL(2,1,:) = (2.*z0.*zl(1))./((zl(1).^2 + z0.^2).*sinh(gamma.*l)+2.*z0.*zl(1).*cosh(gamma.*l));
        TL(1,2,:) = (2.*z0.*zl(1))./((zl(1).^2 + z0.^2).*sinh(gamma.*l)+2.*z0.*zl(1).*cosh(gamma.*l));   
        TL(2,2,:) = ((zl(1).^2 - z0.^2).*sinh(gamma.*l))./((zl(1).^2 + z0.^2).*sinh(gamma.*l) + 2.*z0.*zl(1).*cosh(gamma.*l));                

        if i == 1
            % start the errorbox
            errorbox = sparameters(TL,f,z0);
            
            % peel the TL away
            abcd_errorbox = s2abcd(errorbox.Parameters,z0);
            abcd_dut = s2abcd(s_dut.Parameters,z0);            
            for j = 1:n
                abcd_dut(:,:,j) = abcd_errorbox(:,:,j)\abcd_dut(:,:,j);
            end% peel the TL away
            s_dut_ = abcd2s(abcd_dut,z0); % convert the new peeled dut from ABCD to S-parameters
            s_dut = sparameters(s_dut_,f,z0);
            
            % view the correction
            if view == 1
                zlo = zl;
                t = linspace(0,1/(f(2) - f(1)),n*2+1)./1e-9; % time in ns
                figure('color','black'); 
                plot(t,zlo); hold on; % plot the fix-dut-fix impedance
                
                % calculate the impedance of the errorbox
                s11_eb = squeeze(errorbox.Parameters(1,1,:));
                DC11 = 0;
                eb112x = ifft(makeSymmetric([DC11;s11_eb]),'symmetric');
                
                % get the step response of eb112x
                eb112xStep = makeStep(fftshift(eb112x));
                
                % convert to impedance
                zleb = -z0.*(eb112xStep + 1)./(eb112xStep - 1);
                zleb = ifftshift(zleb); % <-- impedance   
                plot(t,zleb); 
                plot([t(x) t(x)],[-1000 1000],'--r');
                
                % plot properties
                axis([0 t(x*2) z0*0.8 z0*1.2]); grid on; 
                a = gca;
                set(a,'Color','k');
                b = 0.7; value = [b b b]; set(a,'XColor',value); set(a,'YColor',value);
                set(a,'GridAlpha',0.3);
                xlabel('time [ns]','color',value); ylabel('impedance','color',value); 
                legend({'Fixture-DUT-Fixture','Fixture Model','End of Fixture'},'Location','eastoutside','TextColor',value); 
                drawnow;
            end
            
        else
            % add to the errorbox
            s_TL = sparameters(TL,f,z0);
            errorbox = cascadesparams(errorbox,s_TL);
            
            % peel the TL away
            abcd_errorbox = s2abcd(s_TL.Parameters,z0);
            abcd_dut = s2abcd(s_dut.Parameters,z0);
            for j = 1:n
                abcd_dut(:,:,j) = abcd_errorbox(:,:,j)\abcd_dut(:,:,j);
            end% peel the TL away
            s_dut_ = abcd2s(abcd_dut,z0); % convert the new dut from ABCD to S-parameters            
            s_dut = sparameters(s_dut_,f,z0);
            
            if view == 1
                hold off; plot(t,zlo,'g'); hold on; % plot the fix-dut-fix impedance
                
                % calculate the impedance of the errorbox
                s11_eb = squeeze(errorbox.Parameters(1,1,:));
                DC11 = 0;
                eb112x = ifft(makeSymmetric([DC11;s11_eb]),'symmetric');
                
                % get the step response of eb112x
                eb112xStep = makeStep(fftshift(eb112x));
                
                % convert to impedance
                zleb = -z0.*(eb112xStep + 1)./(eb112xStep - 1);
                zleb = ifftshift(zleb); % <-- impedance   
                plot(t,zleb,'y'); 
                plot([t(x) t(x)],[-1000 1000],'--r');
                
                % plot properties
                axis([0 t(x*2) z0*0.8 z0*1.2]); grid on; 
                a = gca;
                set(a,'Color','k');
                b = 0.7; value = [b b b]; set(a,'XColor',value); set(a,'YColor',value);
                set(a,'GridAlpha',0.3);
                xlabel('time [ns]','color',value); ylabel('impedance','color',value); 
                legend({'Fixture-DUT-Fixture','Fixture Model','End of Fixture'},'Location','eastoutside','TextColor',value); 
                drawnow;
            end
        end
        
        % next s11_dut
        s11_dut = squeeze(s_dut.Parameters(1,1,:));
              
    end
    
    % incorperate the transmission parameter of the 2x thru for the
    % complete error box.
    errorbox = hybrid(errorbox,s2x,z0);
    close all;
    
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
