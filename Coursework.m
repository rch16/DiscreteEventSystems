% - - - - - - - - - - - - - - - QUESTION 3  - - - - - - - - - - - - - - -
% - - - - - Automaton GM - - - - - 
% list of events
E_M = char('n','s','e','w'); 
% list of states
X_M = char('r1','r2','r3','r4','r5','r6','r7'); 
% list of transitions
T_M = [1,2,3;
    2,1,4;
    2,3,2;
    3,2,1;
    3,7,3;
    3,4,2;
    4,3,1;
    4,5,2;
    5,4,1;
    5,6,4;
    6,5,3;
    7,3,4];
% initial state
x0_M = 'r1';

G_M = {E_M,X_M,T_M,x0_M};

% - - - - - Automaton GR - - - - -
% list of events
E_R = char('n','s','e','w','r');
% list of states
X_R = char('N','S','E','W');
% list of transitions (start, finish, event)
T_R = [1,1,1;
    1,3,5;
    2,2,2;
    2,4,5;
    3,3,3;
    3,2,5;
    4,4,4;
    4,1,5];
% initial state
x0_R = 'N';

G_R = {E_R,X_R,T_R,x0_R};

% - - - - - Parallel Composition - - - - -

[E_RM,X_RM,T_RM] = parallelComposition(E_M,X_M,T_M,E_R,X_R,T_R);

% - - - - - - - - - - - - - - - QUESTION 4  - - - - - - - - - - - - - - -

[E_N,X_N,T_N] = partialObservability(E_RM,X_RM,T_RM);

% - - - - - - - - - - - - - - - QUESTION 5  - - - - - - - - - - - - - - -

[X_obs,T_obs] = observerAutomaton(X_N,T_N,E_N);
[rowSums,columnSums,singularVals] = verifyObserver(X_obs);

eventSequence = [1,2,2,1,2,1,2,2,1,2,1];
stateIndex = calculateState(X_obs,T_obs,eventSequence);
state = X_obs(stateIndex,:);

% - - - - - - - - - - - - - - - QUESTION 6  - - - - - - - - - - - - - - -
% new list of states
X_M2 = char('r1','r2','r3','r4','r5','r6','r7'); 
% new list of transitions
T_M2 = [1,2,3;
    2,1,4;
    2,3,2;
    3,2,1;
    3,7,3;
    3,4,2;
    4,3,1;
    4,5,2;
    5,4,1;
    5,6,3;
    6,5,4];

G_M2 = {E_M,X_M2,T_M2,x0_M};

% parallel composition
[E_RM2,X_RM2,T_RM2] = parallelComposition(E_M,X_M2,T_M2,E_R,X_R,T_R);

% partial observability
[E_N2,X_N2,T_N2] = partialObservability(E_RM2,X_RM2,T_RM2);

% observer automaton
[X_obs2,T_obs2] = observerAutomaton(X_N2,T_N2,E_N2);



