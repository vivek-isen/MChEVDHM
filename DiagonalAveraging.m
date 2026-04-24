function SignalComponent = DiagonalAveraging(X1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
% X1   :   Symmetric matrix corresponding to significant eigenvalue pair
%-------------------------------------------------------------------------
% Output parameters
% SignalComponent   :   Signal corresponding to the input symmetric matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author   :   Vivek Kumar Singh, PhD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[K, ~] = size(X1);
N = 2 * K - 1;
SignalComponent = zeros(N, 1);
for i = 1 : N
    if(i < K)
        for j = 1:i
            SignalComponent(i, 1) = SignalComponent(i, 1) + X1(j,...
                i - j + 1);
        end
        SignalComponent(i, 1) = SignalComponent(i, 1) / i;
    else
        for j = i - K + 1 : K
            SignalComponent(i, 1) = SignalComponent(i, 1) + X1(j,...
                i - j + 1);
        end
        SignalComponent(i, 1) = SignalComponent(i, 1) / (N - i + 1);
    end
end
end
