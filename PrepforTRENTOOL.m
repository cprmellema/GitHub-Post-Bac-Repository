function [ output ] = PrepforTRENTOOL( spiketimes, fs )
%Preprocesses and prepares data for calculating transfer entropy with
%the trentool toolbox

% From users manual: Table 1
% Input data in TRENTOOL: Fields in a FieldTrip raw data structure (TRENTOOL Version 3.0)
% field name, dimension, data type, units description

[m,n]=size(spiketimes);

% trial {no. trials}[no.
% channels x no.
% samples]
% cell array of double
% arrays
% data for each trial, where each trial
% holds samples from all channels

trial=struct(1);
trial{1}=spiketimes;

% time {no. trials}[1 x
% no. samples]
% cell array of double
% arrays
% seconds time indices for individual trials

% label {no. channels x
% 1}
% cell of strings labels of channels

% fsample scalar integer Hertz sampling rate
% 15

output.fsample=fs;

end

