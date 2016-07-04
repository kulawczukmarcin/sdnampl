#Zbiory
set NODES;
set LINKS within (NODES cross NODES);
set DEMANDS within (NODES cross NODES);
set FREQS;

#parametry
param h {DEMANDS} >= 0; 									#parametr demand
param a {v in NODES, (i,j) in LINKS} binary :=
      if (i = v) then 1 else 0;								#parametr originates
param b {v in NODES, (i,j) in LINKS} binary :=
      if (j = v) then 1 else 0;								#parametr terminates 	  
param k >= 0; 												#parametr max_in

#warunki dla paramterow
check: sum {(i,j) in LINKS} (if (i=j) then 1 else 0) = 0;     # warunek braku petli (lacza z v do v)
check: sum {(n,m) in DEMANDS} (if (n=m) then 1 else 0) = 0;   # warunek braku petli w zapotrzebowaniach (zapotrzebowania z v do v)

#zmienne
var x {(i,j) in LINKS, (n,m) in DEMANDS} >=0,  <= h[n,m];	# zmienna LigthPath
var f {(i,j) in LINKS, l in FREQS} binary;				# zmienna UsedFreq
var M;


minimize LoadBalancing: M;

subject to Max_Cost{(i,j) in LINKS}: 
	sum {(n,m) in DEMANDS} x[i,j,n,m] <= M ;


subject to Kirchhoff{v in NODES, (n,m) in DEMANDS}:
	(sum {(i,j) in LINKS} a[v,i,j]*x[i,j,n,m])
	- (sum {(i,j) in LINKS} b[v,i,j]* x[i,j,n,m]) = 
	(if v = n then h[n,m] else if v = m then -h[n,m] else 0);
	
subject to MaxFreqs{v in NODES, l in FREQS}:
	(sum {(i,j) in LINKS} b[v,i,j]*f[i,j,l]) <= k;


subject to FreqUsed{(i,j) in LINKS}:
	(sum {(n,m) in DEMANDS} x[i,j,n,m]) = (sum {l in FREQS} f[i,j,l]);


