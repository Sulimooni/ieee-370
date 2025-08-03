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

% function pulse = getpulse(dt,data_rate,N,rise_time_per)
% Used by get_delay_time.m
% INPUTS:
%   dt: time interval in seconds. 
%      dt = 1/(2*fmax + df)
%   data_rate: the datarate in Gb/s
%   N: number of frequency points
%   rise_time_per: risetime as percentage of the UI (0 to 0.5)

function [pulse, pulse_time] = getpulse(dt,data_rate,N,rise_time_per) % for debug
% Revision 1:
% [1]: Added error handling so it does not crash when the risetime is too small.
% [2]: Added argument descriptions.

period = round(1/data_rate/1e9/dt); % number of time steps per UI
time_ = 0:dt:(N-1)*dt;

if rise_time_per > 0.9
    rise_time_per = 0.9;
    r_t = round(period*rise_time_per); % risetime in discrete points
    disp("risetime is too short and is set to " + string(r_t*dt) + " seconds.");
end

r_t = round(period*rise_time_per); % risetime in discrete points
v = [0, 0, 1, 1, 0, 0];
offset = r_t*dt;
t = [0, offset, offset+r_t*dt, offset+period*dt, offset+(period+r_t)*dt, time_(end)];
pulse_time = interp1(t,v,time_);

pulse = fft(pulse_time);