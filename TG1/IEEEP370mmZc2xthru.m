function [s_side1,s_side2] = IEEEP370mmZc2xthru(s_2xthru,s_fix_dut_fix,varargin)
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
% FUNCTION: [s_side1,s_side2] = IEEEP370mmZc2xThru(s_2xthru,s_fix_dut_fix,portOrder)
%
% Author: Jason J. Ellison, Published January 12th, 2018
% Revision: v0
% 
% IEEEP370mmZc2xThru.m creates error boxes from a four-port test fixture 2x thru and
% the four-port fixture-dut-fixture S-parameters.
% 
% Input: 
% s_2xthru: an S-parameter object of the 2x thru.
% s_fix_dut_fix: an S-parameter object 
% portOrder[OPTIONAL]--defines the port map of the four-port S-parameters.
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
% [s_side1,s_side2] = IEEEP370mmZc2xThru(s_2xthru,s_fix_dut_fix,2);
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
% FUNCTION: [s_side1,s_side2] = IEEEP370mmZc2xThru(s_2xthru,s_fix_dut_fix,portOrder)
if nargin == 3
    portOrder = varargin{1};
else
    portOrder = 1;
end

if nargin > 3
    warning('Too many inputs. All input arguements after the third are ignored.');
end

p = s_2xthru.Parameters;
f = s_2xthru.Frequencies;
n = length(f);

dd = s2sdd(p,portOrder);
cc = s2scc(p,portOrder);
sdd = sparameters(dd,f,100);
scc = sparameters(cc,f,25);

p_fdf = s_fix_dut_fix.Parameters;
dd_fdf = s2sdd(p_fdf,portOrder);
cc_fdf = s2scc(p_fdf,portOrder);
sdd_fdf = sparameters(dd_fdf,f,100);
scc_fdf = sparameters(cc_fdf,f,25);

[sdd_side1,sdd_side2] = IEEEP370Zc2xThru(sdd,sdd_fdf,100);
[scc_side1,scc_side2] = IEEEP370Zc2xThru(scc,scc_fdf,25);

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