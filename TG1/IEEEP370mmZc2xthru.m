function [s_side1,s_side2] = IEEEP370mmZc2xthru(s_2xthru,s_fix_dut_fix,varargin)
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
% FUNCTION: [s_side1,s_side2] = IEEEP370mmZc2xThru(s_2xthru,s_fix_dut_fix)
%
% Author: Jason J. Ellison, Published 1/25/2025
% Revision: v8
% 
% IEEEP370mmZc2xThru.m creates error boxes from a four-port test fixture 2x thru and
% the four-port fixture-dut-fixture S-parameters.
% 
% Input: 
% s_2xthru: an S-parameter object of the 2x thru.
% s_fix_dut_fix: an S-parameter object 
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
% "portOrder": a number indicating the port order. Details below. [1 2 or
%    3]. default: 1
% "NRP": set to enforce the Nyquist Rate Point during de-embedding and to
% add the appropriote delay to the errorboxes. 
%    default: true
% "leadin": a number of discrete points before t = 0 that are non-zero from
% calibration error. 
%    default: 1
%
% "enable_hybrid" : uses a subroutine to improve IL accuracy if pullback =
%    0
%    default: false
%
% "Pf": Percentage of the fixture to keep. The number can be set between
% 0.1 and 1. This is another way to use pullback and overwrites pullback's
% value if is set to something other than 1.
% default: 1
%
% portOrder--defines the port map of the four-port S-parameters.
%   1[default]: 
%       [port 1] --->>>--- [port 2]
%       [port 3] --->>>--- [port 4]
%   2: 
%       [port 1] --->>>--- [port 3]
%       [port 2] --->>>--- [port 4]
%   3: 
%       [port 1] --->>>--- [port 4]
%       [port 2] --->>>--- [port 3]
% 
% Outputs: 
% s_side1: an S-parameter object of the error box representing the half of the 2x thru connected to port 1
% s_side2: an S-parameter object of the error box representing the half of the 2x thru connected to port 2
% 
% Usage:
% 
% [s_side1,s_side2] = IEEEP370mmZc2xThru(s_2xthru,s_fix_dut_fix);
% s_deembedded_dut = deembedsparams(s_fix_dut_fix,s_side1,s_side2);
%
% A comment on deembedding using MATLAB with portOrder 1 or 3:
% MATLAB assumes portOrder 2 in the function deembedsparams. Therefore if
% you are using port order 1 or 3, you need to convert to port order 2
% before using deembedsparams. Here is the code to do that for each
% S-parameter object. 's' is the S-parameter object in the example.
%
% portOrder = 1;
% p = s.Parameters;
% f = s.Frequencies;
% p = p([1 3 2 4],[1 3 2 4],:);
% s = sparameters(p,f);
%
% portOrder = 3;
% p = s.Parameters;
% f = s.Frequencies;
% p = p([1 2 4 3],[1 3 4 3],:);
% s = sparameters(p,f);
%
% FUNCTION: [s_side1,s_side2] = IEEEP370mmZc2xThru(s_2xthru,s_fix_dut_fix)

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
portOrder = 1;
NRP = true;
leadin = 1;
enable_hybrid = false;
Pf = 1;

for i = 1:length(names)
    names{i} = validatestring(names{i},["z0","bandwidth","view","pullback","pullback1","pullback2","side1","side2","portOrder","NRP","leadin","enable_hybrid","Pf"]);
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
        case "portOrder"
            portOrder = values{i};
        case "NRP"
            NRP = values{i};
        case "leadin"
            leadin = values{i};
        case "enable_hybrid"
            enable_hybrid = values{i};
        case "Pf"
            Pf = values{i};            
    end
end

% ======= check if 2x-thru is an s2p of s4p ============
% if it is, change port order
if s_2xthru.NumPorts == 2
    temp_p = s_2xthru.Parameters;
    temp_f = s_2xthru.Frequencies;
    temp_out = zeros(4,4,length(temp_f));
    switch portOrder
        case 1
            temp_out([1 2],[1 2],:) = temp_p;
            temp_out([3 4],[3 4],:) = temp_p;            
        case 2
            temp_out([1 3],[1 3],:) = temp_p;
            temp_out([2 4],[2 4],:) = temp_p;                        
        case 3 % if you're reading this, never use this port order =P
            temp_out([1 4],[1 4],:) = temp_p;
            temp_out([2 3],[2 3],:) = temp_p;                        
    end

    s_2xthru = sparameters(temp_out,temp_f);
    clear temp_p temp_f;
end


% =========== CHECK FOR BAD INPUTS =============
p = s_fix_dut_fix.Parameters;
f = s_fix_dut_fix.Frequencies;

p = s_2xthru.Parameters;
f = s_2xthru.Frequencies;
n = length(f);

dd = s2sdd(p,portOrder);
cc = s2scc(p,portOrder);
sdd = sparameters(dd,f,z0*2);
scc = sparameters(cc,f,z0/2);

p_fdf = s_fix_dut_fix.Parameters;
dd_fdf = s2sdd(p_fdf,portOrder);
cc_fdf = s2scc(p_fdf,portOrder);
sdd_fdf = sparameters(dd_fdf,f,100);
scc_fdf = sparameters(cc_fdf,f,25);

options = {"bandwidth",bandwidth_limit,...
           "view",view,...
           "pullback1",pullback1,...
           "pullback2",pullback2,...
           "side1",side1,...
           "side2",side2,...
           "NRP",NRP,...
           "leadin",leadin,...
           "enable_hybrid",enable_hybrid,...
           "Pf",Pf};

[sdd_side1,sdd_side2] = IEEEP370Zc2xThru(sdd,sdd_fdf,"z0",z0*2, options{:});
[scc_side1,scc_side2] = IEEEP370Zc2xThru(scc,scc_fdf,"z0",z0/2, options{:});

%% side 1: define quadrants, convert back to SE, then make error box
dd1x = zeros(2,2,n);
dd1x(1,1,:) = squeeze(sdd_side1.Parameters(1,1,:));
dd1x(1,2,:) = squeeze(sdd_side1.Parameters(1,2,:));
dd1x(2,1,:) = squeeze(sdd_side1.Parameters(2,1,:));
dd1x(2,2,:) = squeeze(sdd_side1.Parameters(2,2,:));

cc1x = zeros(2,2,n);
cc1x(1,1,:) = squeeze(scc_side1.Parameters(1,1,:));
cc1x(1,2,:) = squeeze(scc_side1.Parameters(1,2,:));
cc1x(2,1,:) = squeeze(scc_side1.Parameters(2,1,:));
cc1x(2,2,:) = squeeze(scc_side1.Parameters(2,2,:));

cd = zeros(2,2,n);

errorbox = smm2s(dd1x,cd,cd,cc1x,portOrder);
s_side1 = sparameters(errorbox,f);

%% side 2: define quadrants, convert back to SE, then make error box
dd1x = zeros(2,2,n);
dd1x(1,1,:) = squeeze(sdd_side2.Parameters(1,1,:));
dd1x(1,2,:) = squeeze(sdd_side2.Parameters(1,2,:));
dd1x(2,1,:) = squeeze(sdd_side2.Parameters(2,1,:));
dd1x(2,2,:) = squeeze(sdd_side2.Parameters(2,2,:));

cc1x = zeros(2,2,n);
cc1x(1,1,:) = squeeze(scc_side2.Parameters(1,1,:));
cc1x(1,2,:) = squeeze(scc_side2.Parameters(1,2,:));
cc1x(2,1,:) = squeeze(scc_side2.Parameters(2,1,:));
cc1x(2,2,:) = squeeze(scc_side2.Parameters(2,2,:));

cd = zeros(2,2,n);

errorbox = smm2s(dd1x,cd,cd,cc1x,portOrder);
s_side2 = sparameters(errorbox,f);
