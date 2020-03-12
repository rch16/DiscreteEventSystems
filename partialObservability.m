function [E_N,X_N,T_N] = partialObservability(E_RM,X_RM,T_RM)

% - - - - - - - - - - updating state space - - - - - - - - - - 
% doesn't change
X_N = X_RM;

% - - - - - - - - - - updating event set - - - - - - - - - - 
% events n,s,e,w get replaced by m
numEvents = size(E_RM,1);
E = [];
for i = 1:numEvents
    if E_RM(i) == 'r'
        E = [E;'r'];
    else
        E = [E;'m'];
    end
end
% E_N = E;
% so that event set doesn't have several repated 'm', remove repeats
E_N = unique(E,'stable');

% - - - - - - - - - - updating transition map - - - - - - - - - - 
% events 1,2,3,4 get replaced by 1 
% event 5 gets replaced by 2
numTransitions = size(T_RM,1);
T_N = [];
for i = 1:numTransitions
    transition = T_RM(i,:);
    state = transition(:,1);
    newState = transition(:,2);
    if transition(:,3) == 5
        T_N = [T_N;state,newState,2];
    else
        T_N = [T_N;state,newState,1];
    end
end
end

