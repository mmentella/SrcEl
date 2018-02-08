Inputs: N(24),     //Input Data Length
        MPerc(.4); //Percentage of N to Calculate the Adaptive Filter Length

vars: M(IntPortion(MPerc*N+.5)), //Adaptive Filter Length. Number of Coefficients
      nom(0),den(0),
      j(0), //Sequence Index
      k(0); //Coefficient Index

vars: CT(0),ST(0),z(0);

vars: filt(0),notrend(0);

array: P[20](0),b1[50](0),b2[50](0),am[20](0),aa[20](0),SPECTRUM[50](0);

filt = .0774*c + .0778*c[1] + .0778*c[2] + .0774*c[3] + 1.4847*filt[1] - 1.0668*filt[2] + .2698*filt[3];
if currentbar < 4 then filt = c;

notrend = .95*filt - .95*filt[1] + .9*notrend[1];
if currentbar < 4 then notrend = filt - filt[1];

if currentbar > N then begin

P[0] = 0;

for j = 1 to N begin
 P[0] = P[0] + notrend[j-1]*notrend[j-1];
end;

P[0]    = P[0]/N;
k       = 1;
b1[1]   = notrend;
b2[N-1] = notrend[N-1];

for j = 2 to N - 1 begin
 b1[j]   = notrend[j-1];
 b2[j-1] = notrend[j-1];
end;

while k < M begin

 nom = 0;
 den = 0;
 
 for j = 1 to N - k begin
  nom = nom + b1[j]*b2[j];
  den = den + b1[j]*b1[j] + b2[j]*b2[j];
 end;
 
 am[k] = 2*nom/den;
 P[k] = P[k-1]*(1-am[k]*am[k]);
 
 if k = 1 then begin
 
  k = k + 1;
  for j = 1 to k - 1 begin
   aa[j] = am[j];
  end;
  
  for j = 1 to k begin
   b1[j] = b1[j] - aa[k-1]*b2[j];
   b2[j] = b2[j+1] - aa[k-1]*b1[j+1];
  end;
  
 end else begin
 
  for j = 1 to k - 1 begin
   am[j] = aa[j] - am[k]*aa[k-j];
  end;
  
  k = k + 1;
  for j = 1 to k - 1 begin
   aa[j] = am[j];
  end;
  
  for j = 1 to k begin
   b1[j] = b1[j] - aa[k-1]*b2[j];
   b2[j] = b2[j+1] - aa[k-1]*b1[j+1];
  end;
  
 end;

end;

for j = 6 to 50 begin
 CT = 0;
 ST = 0;
 
 for z = 1 to M begin
  CT = CT + am[z]*cosine(6.283185*z/j);
  ST = ST + am[z]*Sine(6.283185*z/j);
 end;
 
 SPECTRUM[j] = 1/((1+CT)*(1+CT) + ST*ST);
 
end;

end;
