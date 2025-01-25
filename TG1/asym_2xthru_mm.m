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
% FUNCTION: [s1, s2] = asym_2xthru_mm(s2x, Pr, port_order)
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
% s2x: an sparameter object of the 4-port 2x-thru
% Pf: a number representing the amount of fixture to remove. This amount is 
% reflected on the left side fixture model, s1.
% port_order:
%   1 [default]: 
%       [port 1] --->>>--- [port 2]
%       [port 3] --->>>--- [port 4]
%   2: 
%       [port 1] --->>>--- [port 3]
%       [port 2] --->>>--- [port 4]
%   3: 
%       [port 1] --->>>--- [port 4]
%       [port 2] --->>>--- [port 3]
%
% Output: 
% s1: the shorter left fixture model
% s2: the longer right fixture model
%
% Example:
% fdf = sparameters(filename_fdf); % Use your local file name.
% s2x = interpolate_sparameters(filename_s2x, fdf.Frequencies); % Use your local file name.
% Pf = 0.5;
% port_order = 1; % odd-even format
% [s1, s2] = asym_2xthru_mm(s2x, Pf, port_order);
% s1_flipped = sparameters(s1.Parameters([2 1 4 3],[2 1 4 3],:), s1.Frequencies);
% 
% % ================== !!NOTE!! ===========================================
% % Using swapPortOrder.m to de-embed these correctly. You will need to
% % save the code below to a file named swapPortOrder.m your path directory 
% % in order for this code to work properly.
% % =======================================================================
% 
% DUT = swapPortOrder(deembedsparams(swapPortOrder(fdf), swapPortOrder(s1), swapPortOrder(s1_flipped)));
% residual = swapPortOrder(deembedsparams(swapPortOrder(s2x), swapPortOrder(s1), swapPortOrder(s2)));
% reconstructed = swapPortOrder(cascadesparams(swapPortOrder(s1), swapPortOrder(s2)));

function [s1, s2] = asym_2xthru_mm(s2x, Pr, port_order)

p = s2x.Parameters;
z0 = s2x.Impedance;
f = s2x.Frequencies;

dd = sparameters(s2sdd(p, port_order), f);
cc = sparameters(s2scc(p, port_order), f);

[s1dd,s2dd] = asym_2xthru(dd, Pr);
[s1cc,s2cc] = asym_2xthru(cc, Pr);

nil = zeros(2, 2, length(f));

s1p = smm2s(s1dd.Parameters, nil,nil,s1cc.Parameters, port_order);
s2p = smm2s(s2dd.Parameters, nil,nil,s2cc.Parameters, port_order);

s1 = sparameters(s1p,f,z0);
s2 = sparameters(s2p,f,z0);

function varargout = swapPortOrder(varargin)
% this function changes the port order of an input s-parameter matrix
% between odd-even and sequential. Odd-even is where the left side, or
% lead-in is an odd number port and the right side or lead-out is an even
% number. Sequential is where the left side or lead-in ports are sequential
% starting at 1 and ending in n/2. Where, n is the number of ports. The
% right side or lead-out ports are n/2+1 to n sequentially.
%
% Example four port:
% odd-even port map is:
% 1 ->>- 2
% 3 ->>- 4
% sequential is:
% 1 ->>- 3
% 2 ->>- 4
%
% If the input is odd-even, the output is sequential
% If the input is sequential, the output is odd-even
n = length(varargin);
varargout = cell(n, 1);

% Here is how the translation of odd-even and sequential works. If we
% consider an 8 port device input is odd-even, then we have
% 1 --> 1
% 2 --> 5
% 3 --> 2
% 4 --> 6
% 5 --> 3
% 6 --> 7
% 7 --> 4
% 8 --> 8
%
% In general this is the odd ports become a sequence from 1 to n/2 and the
% even ports become a sequence from n/2 + 1 to n
%
% If we then consider an 8 port device that is sequential and needs to
% convert to odd-even, we have
% 1 --> 1
% 2 --> 3
% 3 --> 5
% 4 --> 7
% 5 --> 2
% 6 --> 4
% 7 --> 6
% 8 --> 8
%
% In general, the first n/2 ports become a sequence of odd numbers starting
% at 1 and ending in n - 1. The ports starting at n/2 + 1 to n become
% even numbers starting at 2 and ending in n.
%
% In MATLAB, you do this switch by placing the old port in the location of
% the new port. For example, the matrix for converting odd-even to
% sequential for the 8 port device above is...
% [1 5 2 6 3 7 4 8]
%
% sequential to odd-even is...
% [1 3 5 7 2 4 6 8]
%
for i =1:n
    % if the input is an S-parameter, 
    if isa(varargin{i},"sparameters")
        nPorts = varargin{i}.NumPorts;
        test = db(varargin{i}.Parameters(2,1,:));
        if test(1) > -3
            % the ports are odd-even. Make the key for sequential
            key = [ 1:2:nPorts-1 2:2:nPorts ];
        else
            % the ports are sequential. Make the key for odd-even
            key = zeros(1,nPorts);
            key(1:2:nPorts - 1) = 1:nPorts/2;
            key(2:2:nPorts) = nPorts/2+1:1:nPorts;
        end
        varargout{i} = sparameters(varargin{i}.Parameters(key,key,:),varargin{i}.Frequencies);    
    else
        nPorts = size(varargin{i},1);
        test = db(varargin{i}(2,1,:));
        if test(1) > -3
            key = [ 1:2:nPorts-1 2:2:nPorts ];
        else
            key = zeros(1,nPorts);
            key(1:2:nPorts - 1) = 1:nPorts/2;
            key(2:2:nPorts) = nPorts/2+1:1:nPorts;
        end
        varargout{i} = varargin{i}(key,key,:);
    end
end
