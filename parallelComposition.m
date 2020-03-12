function [E_AB,X_AB,T_AB] = parallelComposition(E_A,X_A,T_A,E_B,X_B,T_B)
%PARALLELCOMPOSITION Compute the parallel composition of Automatons A and B

a = size(X_A,1);
b = size(X_B,1);

% - - - - - - - - - Create a new set of events - - - - - - - - - 
% generate set of events common to A and B
commonEvents = intersect(E_A,E_B,'stable');         % string form
numCommon = size(commonEvents,1);
common = [];                                        % number form
for n=1:numCommon
    common = [common,n];
end
% generate union of events from A and B
E_AB = union(E_A,E_B,'stable');

% - - - - - - - - - - - - New state space - - - - - - - - - - - -
% generate arrays to iterate over 
[gridA,gridB] = meshgrid(1:a,1:b);
X = [gridA(:) gridB(:)];                        % states in numbered form 
X_AB = strcat(X_A(X(:,1),:),",",X_B(X(:,2),:)); % states in string form

% - - - - - - - - - - - New Transition Matrix - - - - - - - - - - -
% T = (start, end, event) -> mapping event transitions
% initialise new transition matrix
T_AB = []; 
% define lambda look up functions that find the next state given current state and event
fA = @(state,event) T_A((T_A(:,1)==state & T_A(:,3)==event),2);
fB = @(state,event) T_B((T_B(:,1)==state & T_B(:,3)==event),2);
% iterate over states in X_AB
for i = 1:size(X,1)
    currentState = i;
    state = X(i,:);    % current state of combined automata
    stateA = state(1); % current state from automata A
    stateB = state(2); % current state from automata B
    
    % for T_A and T_B, get indexes of transitions that occur in the current state
    idxA = find(T_A(:,1)==stateA);
    idxB = find(T_B(:,1)==stateB);
    
    % using these indices, get the enabled transitions
    enabledA = T_A(idxA,:);
    enabledB = T_B(idxB,:);
    
    % transition = (start, end, event) therefore get enabled events from 3rd element in array
    gammaA = enabledA(:,3);
    gammaB = enabledB(:,3);
    
    % - - - - - CASE 1: transitions enabled in A and B simultaneously - - - - - 
    commonEnabled = intersect(gammaA,gammaB);
    % check that this is not empty
    if(numel(commonEnabled)~=0)
        % iterate over commonEnabled
        for j = 1:numel(commonEnabled)
            event = commonEnabled(j);
            nextStateA = fA(stateA,event);
            nextStateB = fB(stateB,event);
            % form combined state
            nextState = find(X(:,1)==nextStateA & X(:,2)==nextStateB);
            % add to transition matrix
            transition = [currentState,nextState,event];
            T_AB = [T_AB;transition];
        end
    end
    
    % - - - - - CASE 2: transitions enabled in A but not B -> private to A - - - - - 
    privateA = setdiff(gammaA,common);
    % check that this is not empty
    if(numel(privateA)~=0)
        % iterate over privateA
        for j = 1:numel(privateA)
            event = privateA(j);
            nextStateA = fA(stateA,event);
            nextStateB = stateB; % doesn't change
            % form combined state
            nextState = find(X(:,1)==nextStateA & X(:,2)==nextStateB);
            % add to transition matrix
            transition = [currentState,nextState,event];
            T_AB = [T_AB;transition];
        end
    end
    
    
    % - - - - - CASE 3: transitions enabled in B but not A -> private to B - - - - - 
    privateB = setdiff(gammaB,common);
     % check that this is not empty
    if(numel(privateB)~=0)
        % iterate over privateB
        for j = 1:numel(privateB)
            event = privateB(j);
            nextStateA = stateA; % doesn't change
            nextStateB = fB(stateB,event);
            % form combined state
            nextState = find(X(:,1)==nextStateA & X(:,2)==nextStateB);
            % add to transition matrix
            transition = [currentState,nextState,event];
            T_AB = [T_AB;transition];
        end
    end
    
    
end

end

