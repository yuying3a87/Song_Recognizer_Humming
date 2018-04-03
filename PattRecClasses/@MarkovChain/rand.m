function S=rand(mc,T)
%S=rand(mc,T) returns a random state sequence from given MarkovChain object.
%
%Input:
%mc=    a single MarkovChain object
%T= scalar defining maximum length of desired state sequence.
%   An infinite-duration MarkovChain always generates sequence of length=T
%   A finite-duration MarkovChain may return shorter sequence,
%   if END state was reached before T samples.
%
%Result:
%S= integer row vector with random state sequence,
%   NOT INCLUDING the END state,
%   even if encountered within T samples
%If mc has INFINITE duration,
%   length(S) == T
%If mc has FINITE duration,
%   length(S) <= T
%
%---------------------------------------------
%Code Authors:
%---------------------------------------------

S=[];%space for resulting row vector
nS=mc.nStates;
initcum = cumsum(mc.InitialProb);
r0=randsample(100,1)/100;
S(1)= find(initcum>r0,1);
if size(mc.TransitionProb,2)~=size(mc.TransitionProb,1)+1 %Infinite
    for i = 2:T
       this_step_distribution = mc.TransitionProb(S(i-1),:);
        cumulative_distribution = cumsum(this_step_distribution);
        r = randsample(100,1)/100;
        S(i) = find(cumulative_distribution>=r,1);
    end
else
    for i = 2:T
         this_step_distribution = mc.TransitionProb(S(i-1),:);
        cumulative_distribution = cumsum(this_step_distribution);
        r = randsample(100,1)/100;
        S(i) = find(cumulative_distribution>=r,1);
        if S(i)==nS+1
             S = S(1:end-1);
            break;
        end
    end
end

end




