%--------------------------------------------------------------------------
% This code is developed by Vivek Kumar Singh, PhD. It is requested to cite
% the paper mentioned below, if you are using this code.
%
% V.K. Singh and R.B. Pachori, Multichannel eigenvalue decomposition of 
% Hankel matrix based classification of eye movements from electrooculogram
% ,” IEEE Sensors Letters, vol. 8, no. 7, Art. no. 6008204, 2024.
%--------------------------------------------------------------------------
clc
clearvars
close all

%% Synthetic multichannel signal
Fs = 1000;  % Sampling frequency
t = linspace(0,1,Fs+1); % Sampling instances
N = length(t);
Nc = 3; % Number of channels
Ns = 5; % Total number of distinct frequencies in the signal
A = [1 0.6 0 0.9 0; 0.5 0.54 1 0 0.7; 0.8 0 0 0 1];
f = [10 30 40 60 100];  % Frequencies of the signal components
phi = [0 0 0 pi 0; -pi 0 0 0 pi; 0 0 pi 0 0];
sig_comps = zeros(N,Ns,Nc);
for i = 1:Nc
    for j = 1:Ns
        sig_comps(:,j,i) = A(i,j)*sin(2*pi*f(j)*t + phi(i,j));
    end
end
Signal = squeeze(sum(sig_comps,2));

%% Multichannel eigenvalue decomposition of Hankel matrix
dec_comps = MChEVDHM(Signal,Ns);    % If number of components is known
% dec_comps = MChEVDHM(Signal);   % If number of components is not known

%% Plotting signal, true components, and decomposed components
for i = 1:3
    subplot(6,3,i)
    plot(t,Signal(:,i),'b','LineWidth',1)
    ttl = "Channel " + num2str(i) + " Signal";
    title(ttl)
end
for i = 1:5
    for j = 1:3
        subplot(6,3,3*i+j)
        plot(t,sig_comps(:,i,j),'Color',[0.5 0.5 0.5],'LineWidth',1)
        hold on
        plot(t,dec_comps(:,i,j),'b-.','LineWidth',1)
        hold off
        if i == 2 && j == 1
            ylabel('Amplitude')
        elseif i == 5
            xlabel('Time (s)')
        end
        ttl = "Channel " + num2str(j) + " Component " + num2str(i);
        title(ttl)
    end
end
legend('True','Decomposed')