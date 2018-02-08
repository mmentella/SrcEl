Inputs: Price(medianprice),N(6);

vars: j(0),k(0),p(0),num(0),den(0),CT(0),ST(0),M(0);

vars: length(0),prevlength(0),MaxPwr(0),color1(0),color2(0),x(0),smooth(0),cycle(0);

array: ef[50](0),eb[50](0),efp[50](0),ebp[50](0),ak[50](0),aa[50](0),SPECTRUM[50](0),DB[50](0);

cleardebug;

value1 = MM.MesaFilter(Price);

//INITIALIZATION
length = iff(prevlength=0,N,prevlength);
M = IntPortion(.25*length+.5);

if currentbar > 0 then begin

for j = 1 to length - 1 begin
 ef[j] = value1[j];
 eb[j] = value1[j-1];
 ak[j] = 0;
 aa[j] = 0;
end;

for k = 1 to M begin
 
 for j = k to length - 1 begin
  efp[j-k+1] = ef[j];
 end;
 
 for j = 1 to length - k begin
  ebp[j] = eb[j];
 end;
 
 num = 0;
 den = 0;
 
 for j = 1 to length - k begin
  num = num + efp[j]*ebp[j];
  den = den + efp[j]*efp[j] + ebp[j]*ebp[j];
 end;
 
 ak[k] = -2*num/den;
 
 for j = 1 to length - k begin
  ef[j] = efp[j] + ak[k]*ebp[j];
  eb[j] = ebp[j] + ak[k]*efp[j];
 end;
 
 if k > 1 then for j = 1 to k - 1 begin
  ak[j] = aa[j] + ak[k]*aa[k-j];
 end;
 
 for j = 1 to k begin
  aa[j] = ak[j];
 end;
 
end;

MaxPwr = -1;

for p = 6 to 50 begin

 CT = 0;
 ST = 0;
 
 for j = 1 to M begin
  CT = CT + ak[j]*cosine(360*j/p);
  ST = ST + ak[j]*Sine(360*j/p);
 end;
 
 SPECTRUM[p] = 1/( (1+CT)*(1+CT) + ST*ST );
 
 if SPECTRUM[p] > MaxPwr then begin MaxPwr = SPECTRUM[p]; prevlength = p; end;
 
end;


//Normalize Power Levels and Convert to Decibels
for p = 6 to 50 Begin

 IF MaxPwr > 0 and SPECTRUM[p] > 0 Then DB[p] = -10*LOG(.01 / (1 - .99*SPECTRUM[p] / MaxPwr))/Log(10);
 If DB[p] > 20 then DB[p] = 20;

end;

for p = 6 to 50 Begin
 
 //Convert Decibels to RGB Color for Display
 If DB[p] > 10 Then Begin
 color1 = 255*(2 - DB[p]/10);
 color2 = 0;
 End;

 If DB[p] <= 10 Then Begin
 color1 = 255;
 color2 = 255*(1 - DB[p]/10);
 End;
 {
 If p = 1 Then Plot1(1, "S1", RGB(color1, color2, 0),0,4);
 If p = 2 Then Plot2(2, "S2", RGB(color1, color2, 0),0,4);
 If p = 3 Then Plot3(3, "S3", RGB(color1, color2, 0),0,4);
 If p = 4 Then Plot4(4, "S4", RGB(color1, color2, 0),0,4);
 If p = 5 Then Plot5(5, "S5", RGB(color1, color2, 0),0,4);}
 If p = 6 Then Plot6(6, "S6", RGB(color1, color2, 0),0,4);
 If p = 7 Then Plot7(7, "S7", RGB(color1, color2, 0),0,4);
 If p = 8 Then Plot8(8, "S8", RGB(color1, color2, 0),0,4);
 If p = 9 Then Plot9(9, "S9", RGB(color1, color2, 0),0,4);
 If p = 10 Then Plot10(10, "S10", RGB(color1, color2, 0),0,4);
 If p = 11 Then Plot11(11, "S11", RGB(color1, color2, 0),0,4);
 If p = 12 Then Plot12(12, "S12", RGB(color1, color2, 0),0,4);
 If p = 13 Then Plot13(13, "S13", RGB(color1, color2, 0),0,4);
 If p = 14 Then Plot14(14, "S14", RGB(color1, color2, 0),0,4);
 If p = 15 Then Plot15(15, "S15", RGB(color1, color2, 0),0,4);
 If p = 16 Then Plot16(16, "S16", RGB(color1, color2, 0),0,4);
 If p = 17 Then Plot17(17, "S17", RGB(color1, color2, 0),0,4);
 If p = 18 Then Plot18(18, "S18", RGB(color1, color2, 0),0,4);
 If p = 19 Then Plot19(19, "S19", RGB(color1, color2, 0),0,4);
 If p = 20 Then Plot20(20, "S20", RGB(color1, color2, 0),0,4);
 If p = 21 Then Plot21(21, "S21", RGB(color1, color2, 0),0,4);
 If p = 22 Then Plot22(22, "S22", RGB(color1, color2, 0),0,4);
 If p = 23 Then Plot23(23, "S23", RGB(color1, color2, 0),0,4);
 If p = 24 Then Plot24(24, "S24", RGB(color1, color2, 0),0,4);
 If p = 25 Then Plot25(25, "S25", RGB(color1, color2, 0),0,4);
 If p = 26 Then Plot26(26, "S26", RGB(color1, color2, 0),0,4);
 If p = 27 Then Plot27(27, "S27", RGB(color1, color2, 0),0,4);
 If p = 28 Then Plot28(28, "S28", RGB(color1, color2, 0),0,4);
 If p = 29 Then Plot29(29, "S29", RGB(color1, color2, 0),0,4);
 If p = 30 Then Plot30(30, "S30", RGB(color1, color2, 0),0,4);
 If p = 31 Then Plot31(31, "S31", RGB(color1, color2, 0),0,4);
 If p = 32 Then Plot32(32, "S32", RGB(color1, color2, 0),0,4);
 If p = 33 Then Plot33(33, "S33", RGB(color1, color2, 0),0,4);
 If p = 34 Then Plot34(34, "S34", RGB(color1, color2, 0),0,4);
 If p = 35 Then Plot35(35, "S35", RGB(color1, color2, 0),0,4);
 If p = 36 Then Plot36(36, "S36", RGB(color1, color2, 0),0,4);
 If p = 37 Then Plot37(37, "S37", RGB(color1, color2, 0),0,4);
 If p = 38 Then Plot38(38, "S38", RGB(color1, color2, 0),0,4);
 If p = 39 Then Plot39(39, "S39", RGB(color1, color2, 0),0,4);
 If p = 40 Then Plot40(40, "S40", RGB(color1, color2, 0),0,4);
 If p = 41 Then Plot41(41, "S41", RGB(color1, color2, 0),0,4);
 If p = 42 Then Plot42(42, "S42", RGB(color1, color2, 0),0,4);
 If p = 43 Then Plot43(43, "S43", RGB(color1, color2, 0),0,4);
 If p = 44 Then Plot44(44, "S44", RGB(color1, color2, 0),0,4);
 If p = 45 Then Plot45(45, "S45", RGB(color1, color2, 0),0,4);
 If p = 46 Then Plot46(46, "S46", RGB(color1, color2, 0),0,4);
 If p = 47 Then Plot47(47, "S47", RGB(color1, color2, 0),0,4);
 If p = 48 Then Plot48(48, "S48", RGB(color1, color2, 0),0,4);
 If p = 49 Then Plot49(49, "S49", RGB(color1, color2, 0),0,4);
 If p = 50 Then Plot50(50, "S50", RGB(color1, color2, 0),0,4);

end;


{
for k = 0 to M - 1 begin
 if k = 0 then plot1(ak[k]);
 if k = 1 then plot2(ak[k]);
 if k = 2 then plot3(ak[k]);
 if k = 3 then plot4(ak[k]);
 if k = 4 then plot5(ak[k]);
 if k = 5 then plot6(ak[k]);
 if k = 6 then plot7(ak[k]);
 if k = 7 then plot8(ak[k]);
 if k = 8 then plot9(ak[k]);
 if k = 9 then plot10(ak[k]);
 if k = 10 then plot11(ak[k]);
 if k = 11 then plot12(ak[k]);
 if k = 12 then plot13(ak[k]);
 if k = 13 then plot14(ak[k]);
 if k = 14 then plot15(ak[k]);
end;
}

{
x = 0;

for j = 0 to M - 1 begin
 x = x - ak[j]*c[j+1];
end;

plot1(x);
}

end;
