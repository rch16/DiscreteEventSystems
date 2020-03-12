function [X_obs,T_obs] = observerAutomaton(X_N,T_N,E_N)
%OBSERVERAUTOMATON Construct an observer automaton for a non deterministic
%finite state automaton

% number of states
numStates = size(X_N,1);

% number of events
numEvents = size(E_N,1);

% initialise new transition map
T_obs = zeros(1,3);

% start with a vector of 1s of size N in X_new
% represents that the automata could be in any state
X_new = ones(1,numStates); 

% initialise X_old -> list of lists that have already been considered
X_old = ones(1,numStates);

% define lambda look up function that finds the next state given current state and event
fN = @(state,event) T_N((T_N(:,1)==state & T_N(:,3)==event),2);

% while X_new isn't empty
while size(X_new,1)>0
    % take first item in X_new as current list
    currentList = X_new(1,:);
    % remove currentList (first item) from X_new
    X_new(1,:) = [];
    % apply all events to current list
    for event=1:numEvents
        % for each event, apply results to a new vector
        % -> initialise new list with results of applying events to current list
        % -> represents a new state to be explored
        newList = zeros(1,numStates); 
        
        % iterate over array i.e. each state
        for state=1:numel(currentList)
        
            % find if transition is enabled for current state and event
            nextState = fN(state,event);
            
            % multiply by value of currentList(state) to ensure transition is enabled for currentList
            nextState = nextState*currentList(state);
            
            % if nextState is not empty, transition is enabled for current state
            if(numel(nextState)~=0 & nextState~=0)
                % add a 1 at that location in the new array
                newList(nextState) = 1;
            end

        end
        
        % check if current list is in X_old
        [~,currentPresent] = ismember(X_old,currentList,'rows');
        
        % index is current state for the transition map
        currentState = find(currentPresent,1,'first');
        
        % check if new list is in X_old
        [~,newPresent] = ismember(X_old,newList,'rows');
        
        % find the index of where the new list is present
        newIndex = find(newPresent,1,'first');
        
        if isempty(newIndex)
            % newList is not present in X_old
            % add to X_new to mark as needing exploring
            X_new = [X_new;newList];
            % add to X_old to reserve an index for reference in T_obs
            X_old = [X_old;newList];
            % get index as next state for transition map
            [~,newState]=ismember(newList,X_old,'rows');
        else
            % newList is already in X_old 
            % get index as next state for transition map
            newState = newIndex;
        end
        
        % update new transition map with this transition
        transition = [currentState,newState,event];
        T_obs = [T_obs;transition];

    end   
    
end

X_obs = X_old;

%remove zeros from first row of T_obs (used in Initialisation)
numTransitions = size(T_obs,1);
T_obs = T_obs(2:numTransitions,:);
end

