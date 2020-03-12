function [stateIndex] = calculateState(X_obs,T_obs,eventSequence)
%CALCULATESTATE calculate resultant state from observer automaton given sequence of events

% start with vector of all 1s as the robot could be in any state
initialVec = ones(1,28);

% find this vector in X_obs
[~,initialState] = ismember(initialVec,X_obs,'rows');

% start with this initial state as the current state
currentState = initialState;

% define a lambda look up function that finds the next state given current state and event
fN = @(state,event) T_obs((T_obs(:,1)==state & T_obs(:,3)==event),2);

% iterate through event sequence
for e = 1:numel(eventSequence)
    % each event causes a transition
    event = eventSequence(e);
    % for current state and event, find next state
    nextState = fN(currentState,event);
    % assign next state as current state and look for next event
    currentState = nextState;
end

stateIndex = currentState;

end

