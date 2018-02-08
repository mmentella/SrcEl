Inputs: N(20),     //Input Data Length
        M(4); //Percentage of N to Calculate the Adaptive Filter Length

vars: //M(IntPortion(MPerc*N+.5)), //Adaptive Filter Length. Number of Coefficients
      nom(0),den(0),
      j(0), //Sequence Index
      k(0); //Coefficient Index

vars: CT(0),ST(0),z(0),color1(0),color2(0),x(0);

vars: filt(0),notrend(0),MaxPwr(-1);

array: P[50](0),b1[50](0),b2[50](0),am[50](0),aa[50](0),SPECTRUM[50](0),DB[50](0);

filt = .0774*c + .0778*c[1] + .0778*c[2] + .0774*c[3] + 1.4847*filt[1] - 1.0668*filt[2] + .2698*filt[3];
if currentbar < 4 then filt = c;

notrend = .95*filt - .95*filt[1] + .9*notrend[1];
if currentbar < 2 then notrend = filt - filt[1];

if currentbar > N then begin

P[0] = 0;

for j = 1 to N begin
 P[0] = P[0] + notrend[j-1]*notrend[j-1];
end;

P[0]    = P[0]/N;
k       = 1;
b1[1]   = notrend[N-1];
b2[N-1] = notrend;

for j = 2 to N - 1 begin
 b1[j]   = notrend[N-j];
 b2[j-1] = notrend[N-j];
end;

while k <= M begin

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
  
  for j = 1 to N - k begin
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

x = 0;

for j = 0 to M - 1 begin
 x = x + am[j]*c[j+1];
end;

plot1(x);

{

for j = 6 to 50 begin
 CT = 0;
 ST = 0;
 
 for z = 1 to M begin
  CT = CT + am[z]*cosine(6.283185*z/j);
  ST = ST + am[z]*Sine(6.283185*z/j);
 end;
 
 SPECTRUM[j] = 1/((1+CT)*(1+CT) + ST*ST);
 
 //if SPECTRUM[j] > MaxPwr then MaxPwr = SPECTRUM[j];
{
If j = 1 Then Plot1(SPECTRUM[j]);
If j = 2 Then Plot2(SPECTRUM[j]);
If j = 3 Then Plot3(SPECTRUM[j]);
If j = 4 Then Plot4(SPECTRUM[j]);
If j = 5 Then Plot5(SPECTRUM[j]);
If j = 6 Then Plot6(SPECTRUM[j]);
If j = 7 Then Plot7(SPECTRUM[j]);
If j = 8 Then Plot8(SPECTRUM[j]);
If j = 9 Then Plot9(SPECTRUM[j]);
If j = 10 Then Plot10(SPECTRUM[j]);
If j = 11 Then Plot11(SPECTRUM[j]);
If j = 12 Then Plot12(SPECTRUM[j]);
If j = 13 Then Plot13(SPECTRUM[j]);
If j = 14 Then Plot14(SPECTRUM[j]);
If j = 15 Then Plot15(SPECTRUM[j]);
If j = 16 Then Plot16(SPECTRUM[j]);
If j = 17 Then Plot17(SPECTRUM[j]);
If j = 18 Then Plot18(SPECTRUM[j]);
If j = 19 Then Plot19(SPECTRUM[j]);
If j = 20 Then Plot20(SPECTRUM[j]);
If j = 21 Then Plot21(SPECTRUM[j]);
If j = 22 Then Plot22(SPECTRUM[j]);
If j = 23 Then Plot23(SPECTRUM[j]);
If j = 24 Then Plot24(SPECTRUM[j]);
If j = 25 Then Plot25(SPECTRUM[j]);
If j = 26 Then Plot26(SPECTRUM[j]);
If j = 27 Then Plot27(SPECTRUM[j]);
If j = 28 Then Plot28(SPECTRUM[j]);
If j = 29 Then Plot29(SPECTRUM[j]);
If j = 30 Then Plot30(SPECTRUM[j]);
If j = 31 Then Plot31(SPECTRUM[j]);
If j = 32 Then Plot32(SPECTRUM[j]);
If j = 33 Then Plot33(SPECTRUM[j]);
If j = 34 Then Plot34(SPECTRUM[j]);
If j = 35 Then Plot35(SPECTRUM[j]);
If j = 36 Then Plot36(SPECTRUM[j]);
If j = 37 Then Plot37(SPECTRUM[j]);
If j = 38 Then Plot38(SPECTRUM[j]);
If j = 39 Then Plot39(SPECTRUM[j]);
If j = 40 Then Plot40(SPECTRUM[j]);
If j = 41 Then Plot41(SPECTRUM[j]);
If j = 42 Then Plot42(SPECTRUM[j]);
If j = 43 Then Plot43(SPECTRUM[j]);
If j = 44 Then Plot44(SPECTRUM[j]);
If j = 45 Then Plot45(SPECTRUM[j]);
If j = 46 Then Plot46(SPECTRUM[j]);
If j = 47 Then Plot47(SPECTRUM[j]);
If j = 48 Then Plot48(SPECTRUM[j]);
If j = 49 Then Plot49(SPECTRUM[j]);
If j = 50 Then Plot50(SPECTRUM[j]);
}
end;
{
for j = 1 to M begin
 if j = 1 then plot1(am[j]);
 if j = 2 then plot2(am[j]);
 if j = 3 then plot3(am[j]);
 if j = 4 then plot4(am[j]);
 if j = 5 then plot5(am[j]);
 if j = 6 then plot6(am[j]);
 if j = 7 then plot7(am[j]);
 if j = 8 then plot8(am[j]);
 if j = 9 then plot9(am[j]);
 if j = 10 then plot10(am[j]);
end;
}
{
//Normalize Power Levels and Convert to Decibels
For j = 6 to 50 Begin

 IF MaxPwr > 0 and SPECTRUM[j] > 0 Then DB[j] = -10*LOG(.01 / (1 -.99*SPECTRUM[j] / MaxPwr))/Log(10);
 If DB[j] > 20 then DB[j] = 20;

End;


//Plot the Spectrum as a Heatmap
For j = 6 to 50 Begin
 
 //Convert Decibels to RGB Color for Display
 If DB[j] > 10 Then Begin
 Color1 = 255*(2 - DB[j]/10);
 Color2 = 0;
 End;

 If DB[j] <= 10 Then Begin
 Color1 = 255;
 Color2 = 255*(1 - DB[j]/10);
 End;
 
 If j = 6 Then Plot6(6, "S6", RGB(Color1, Color2, 0),0,4);
 If j = 7 Then Plot7(7, "S7", RGB(Color1, Color2, 0),0,4);
 If j = 8 Then Plot8(8, "S8", RGB(Color1, Color2, 0),0,4);
 If j = 9 Then Plot9(9, "S9", RGB(Color1, Color2, 0),0,4);
 If j = 10 Then Plot10(10, "S10", RGB(Color1, Color2, 0),0,4);
 If j = 11 Then Plot11(11, "S11", RGB(Color1, Color2, 0),0,4);
 If j = 12 Then Plot12(12, "S12", RGB(Color1, Color2, 0),0,4);
 If j = 13 Then Plot13(13, "S13", RGB(Color1, Color2, 0),0,4);
 If j = 14 Then Plot14(14, "S14", RGB(Color1, Color2, 0),0,4);
 If j = 15 Then Plot15(15, "S15", RGB(Color1, Color2, 0),0,4);
 If j = 16 Then Plot16(16, "S16", RGB(Color1, Color2, 0),0,4);
 If j = 17 Then Plot17(17, "S17", RGB(Color1, Color2, 0),0,4);
 If j = 18 Then Plot18(18, "S18", RGB(Color1, Color2, 0),0,4);
 If j = 19 Then Plot19(19, "S19", RGB(Color1, Color2, 0),0,4);
 If j = 20 Then Plot20(20, "S20", RGB(Color1, Color2, 0),0,4);
 If j = 21 Then Plot21(21, "S21", RGB(Color1, Color2, 0),0,4);
 If j = 22 Then Plot22(22, "S22", RGB(Color1, Color2, 0),0,4);
 If j = 23 Then Plot23(23, "S23", RGB(Color1, Color2, 0),0,4);
 If j = 24 Then Plot24(24, "S24", RGB(Color1, Color2, 0),0,4);
 If j = 25 Then Plot25(25, "S25", RGB(Color1, Color2, 0),0,4);
 If j = 26 Then Plot26(26, "S26", RGB(Color1, Color2, 0),0,4);
 If j = 27 Then Plot27(27, "S27", RGB(Color1, Color2, 0),0,4);
 If j = 28 Then Plot28(28, "S28", RGB(Color1, Color2, 0),0,4);
 If j = 29 Then Plot29(29, "S29", RGB(Color1, Color2, 0),0,4);
 If j = 30 Then Plot30(30, "S30", RGB(Color1, Color2, 0),0,4);
 If j = 31 Then Plot31(31, "S31", RGB(Color1, Color2, 0),0,4);
 If j = 32 Then Plot32(32, "S32", RGB(Color1, Color2, 0),0,4);
 If j = 33 Then Plot33(33, "S33", RGB(Color1, Color2, 0),0,4);
 If j = 34 Then Plot34(34, "S34", RGB(Color1, Color2, 0),0,4);
 If j = 35 Then Plot35(35, "S35", RGB(Color1, Color2, 0),0,4);
 If j = 36 Then Plot36(36, "S36", RGB(Color1, Color2, 0),0,4);
 If j = 37 Then Plot37(37, "S37", RGB(Color1, Color2, 0),0,4);
 If j = 38 Then Plot38(38, "S38", RGB(Color1, Color2, 0),0,4);
 If j = 39 Then Plot39(39, "S39", RGB(Color1, Color2, 0),0,4);
 If j = 40 Then Plot40(40, "S40", RGB(Color1, Color2, 0),0,4);
 If j = 41 Then Plot41(41, "S41", RGB(Color1, Color2, 0),0,4);
 If j = 42 Then Plot42(42, "S42", RGB(Color1, Color2, 0),0,4);
 If j = 43 Then Plot43(43, "S43", RGB(Color1, Color2, 0),0,4);
 If j = 44 Then Plot44(44, "S44", RGB(Color1, Color2, 0),0,4);
 If j = 45 Then Plot45(45, "S45", RGB(Color1, Color2, 0),0,4);
 If j = 46 Then Plot46(46, "S46", RGB(Color1, Color2, 0),0,4);
 If j = 47 Then Plot47(47, "S47", RGB(Color1, Color2, 0),0,4);
 If j = 48 Then Plot48(48, "S48", RGB(Color1, Color2, 0),0,4);
 If j = 49 Then Plot49(49, "S49", RGB(Color1, Color2, 0),0,4);
 If j = 50 Then Plot50(50, "S50", RGB(Color1, Color2, 0),0,4);

End;
}
}
end;
