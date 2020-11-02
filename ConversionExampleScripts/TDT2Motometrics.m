% clc;
% clear all;

load('Example.mat');   %Matlab file from TDT
Period = Example.streams.Wav1.fs;
Nstims = 18;
Ntrials = 10;
Ntotal = Nstims.*Ntrials;
Nchannels = 1;

Tstart = uint32(Example.epocs.Ep1_.onset.*Period);
T0 = (Tstart(2) - Tstart(1));
M = zeros(T0+1, Nchannels, Ntotal);

for i = 1:Ntotal-1
 for j = 1:Nchannels
    
     sig = Example.streams.Wav1.data(j,Tstart(i):Tstart(i) + T0);
     M(:,j,i) = sig; 
 end
end

Data.values = M;
Data.interval = 1./Period;

save session.mat Data