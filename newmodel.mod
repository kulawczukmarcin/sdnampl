### ALGEBRAIC FORMULATION ###
set NODES;
set ARCS within NODES cross NODES;

# the amount of flow produced at node
param b {N}; 
# cost?
param c {A} >= 0;

# subject to bounds on the flows along the arcs,
# lij ≤ xij ≤ uij
param l {A} >= 0;
param u {(i,j) in A} >= l[i,j];

var Flow {(i,j) in A}
	>= l[i,j], <= u[i,j];

minimize Total_Cost; minimize Total_Cost:
	sum {(i,j) in A} c[i,j] * Flow[i,j];

# kirchoff?
subject to Balance {i in N}:		
	sum {(i,j) in A} Flow[i,j] -
	sum {(j,i) in A} Flow[j,i] = b[i];
