function elementary_comps = MChEVDHM(multich_signal,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameter:
% multich_signal    :   multi-channel multicomponent signal, each channel
%                       signal as column vector
%-------------------------------------------------------------------------
% Output parameter:
% elementary_comps: mode-aligned elementary components with dimension
% (N*N_modes*N_channel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Vivek Kumar Singh, PhD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N, NCh] = size(multich_signal);    % Length of each channel and #channels
if rem(N,2) == 0
    error("Signal must have odd number of samples!")
end

% Obtaining Hankel matrices for each channel signals
K = (N+1)/2;
X_Sig = zeros(K,K,NCh);
for i = 1:NCh
    X_Sig(:,:,i) = hankel(multich_signal(1:K,i),...
        multich_signal(end-K+1:end,i));
end

% Sum of Hankel matrices and eigenvalue decomposition of it
X = sum(X_Sig,3);
[V, L] = eig(X);

% Identification of number of significant eigenvectors
if size(varargin) == 1
    Ns = varargin{1};
else
    Ns = 0;
    for i = 1:K/2
        if abs(L(i,i)) > 0.1*max(abs(L))
            Ns = Ns + 1;
        end
    end
end

% Extraction of mode-aligned significant elementary components
elementary_comps = zeros(N,Ns,NCh);
for i = 1:NCh
    for j = 1:Ns
        eval1 = V(:,j)'*(squeeze(X_Sig(:,:,i))*V(:,j));
        eval2 = V(:,end-j+1)'*(squeeze(X_Sig(:,:,i))*V(:,end-j+1));
        if all(abs(eval1) > 0.1*max(abs(L))) &&...
                all(abs(eval2) > 0.1*max(abs(L)))
            X = eval1*V(:,j)*V(:,j)'+eval2*V(:,K-j+1)*V(:,K-j+1)';
            elementary_comps(:,j,i) = DiagonalAveraging(X);
        end
    end
end
end