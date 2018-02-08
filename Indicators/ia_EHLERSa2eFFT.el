{ Discrete Fourier Transform Copyright (c) 2006 John F. Ehlers }

Inputs:Price((H+L)/2),Window(50),ShowDC(False);

Vars:alpha1(0),HP(0),CleanedData(0),Period(0),n(0),MaxPwr(0),Num(0),Denom(0),DominantCycle(0),Color1(0),Color2(0);

//Arrays are sized to have a maximum Period of 128 bars
Arrays:CosinePart[128](0),SinePart[128](0),Pwr[128](0),DB[128](0);

//Get a detrended version of the data by High Pass Filtering with a 40 Period cutoff
If CurrentBar <= 5 Then Begin
 HP = Price;
 CleanedData = Price;
End;

If CurrentBar > 5 Then Begin
 alpha1 = (1 - Sine(360/40))/Cosine(360/40);
 HP = .5*(1 + alpha1)*(Price - Price[1]) + alpha1*HP[1];
 CleanedData = (HP + 2*HP[1] + 3*HP[2] + 3*HP[3] + 2*HP[4] + HP[5])/12;
End;

//This is the DFT
For Period = 6 to 50 Begin

 CosinePart[Period] = 0;
 SinePart[Period] = 0;
 
 FOR n = 0 to Window - 1 Begin
  CosinePart[Period] = CosinePart[Period] + CleanedData[n]*Cosine(360*n/Period);
  SinePart[Period] = SinePart[Period] + CleanedData[n]*Sine(360*n/Period);
 End;
 
 Pwr[Period] = CosinePart[Period]*CosinePart[Period] + SinePart[Period]*SinePart[Period];
 
End;

//Find Maximum Power Level for Normalization
MaxPwr = Pwr[6];
For Period = 6 to 50 Begin

 If Pwr[Period] > MaxPwr Then MaxPwr = Pwr[Period];

End;

//Normalize Power Levels and Convert to Decibels
For Period = 6 to 50 Begin

 IF MaxPwr > 0 and Pwr[Period] > 0 Then DB[Period] = -10*LOG(.01 / (1-.99*Pwr[Period] / MaxPwr))/Log(10);
 If DB[Period] > 20 then DB[Period] = 20;

End;

//Find Dominant Cycle using CG algorithm
Num = 0;
Denom = 0;

For Period = 6 to 50 Begin

 If DB[Period] < 3 Then Begin
 Num = Num + Period*(3 - DB[Period]);
 Denom = Denom + (3 - DB[Period]);
 End;

End;

If Denom <> 0 then DominantCycle = Num/Denom;

If ShowDC = True Then Plot1(DominantCycle, "S1", RGB(0, 0, 255),0,2);

//Plot the Spectrum as a Heatmap
For Period = 6 to 128 Begin
 
 //Convert Decibels to RGB Color for Display
 If DB[Period] > 10 Then Begin
 Color1 = 255*(2 - DB[Period]/10);
 Color2 = 0;
 End;

 If DB[Period] <= 10 Then Begin
 Color1 = 255;
 Color2 = 255*(1 - DB[Period]/10);
 End;
 
 If Period = 6 Then Plot6(6, "S6", RGB(Color1, Color2, 0),0,4);
 If Period = 7 Then Plot7(7, "S7", RGB(Color1, Color2, 0),0,4);
 If Period = 8 Then Plot8(8, "S8", RGB(Color1, Color2, 0),0,4);
 If Period = 9 Then Plot9(9, "S9", RGB(Color1, Color2, 0),0,4);
 If Period = 10 Then Plot10(10, "S10", RGB(Color1, Color2, 0),0,4);
 If Period = 11 Then Plot11(11, "S11", RGB(Color1, Color2, 0),0,4);
 If Period = 12 Then Plot12(12, "S12", RGB(Color1, Color2, 0),0,4);
 If Period = 13 Then Plot13(13, "S13", RGB(Color1, Color2, 0),0,4);
 If Period = 14 Then Plot14(14, "S14", RGB(Color1, Color2, 0),0,4);
 If Period = 15 Then Plot15(15, "S15", RGB(Color1, Color2, 0),0,4);
 If Period = 16 Then Plot16(16, "S16", RGB(Color1, Color2, 0),0,4);
 If Period = 17 Then Plot17(17, "S17", RGB(Color1, Color2, 0),0,4);
 If Period = 18 Then Plot18(18, "S18", RGB(Color1, Color2, 0),0,4);
 If Period = 19 Then Plot19(19, "S19", RGB(Color1, Color2, 0),0,4);
 If Period = 20 Then Plot20(20, "S20", RGB(Color1, Color2, 0),0,4);
 If Period = 21 Then Plot21(21, "S21", RGB(Color1, Color2, 0),0,4);
 If Period = 22 Then Plot22(22, "S22", RGB(Color1, Color2, 0),0,4);
 If Period = 23 Then Plot23(23, "S23", RGB(Color1, Color2, 0),0,4);
 If Period = 24 Then Plot24(24, "S24", RGB(Color1, Color2, 0),0,4);
 If Period = 25 Then Plot25(25, "S25", RGB(Color1, Color2, 0),0,4);
 If Period = 26 Then Plot26(26, "S26", RGB(Color1, Color2, 0),0,4);
 If Period = 27 Then Plot27(27, "S27", RGB(Color1, Color2, 0),0,4);
 If Period = 28 Then Plot28(28, "S28", RGB(Color1, Color2, 0),0,4);
 If Period = 29 Then Plot29(29, "S29", RGB(Color1, Color2, 0),0,4);
 If Period = 30 Then Plot30(30, "S30", RGB(Color1, Color2, 0),0,4);
 If Period = 31 Then Plot31(31, "S31", RGB(Color1, Color2, 0),0,4);
 If Period = 32 Then Plot32(32, "S32", RGB(Color1, Color2, 0),0,4);
 If Period = 33 Then Plot33(33, "S33", RGB(Color1, Color2, 0),0,4);
 If Period = 34 Then Plot34(34, "S34", RGB(Color1, Color2, 0),0,4);
 If Period = 35 Then Plot35(35, "S35", RGB(Color1, Color2, 0),0,4);
 If Period = 36 Then Plot36(36, "S36", RGB(Color1, Color2, 0),0,4);
 If Period = 37 Then Plot37(37, "S37", RGB(Color1, Color2, 0),0,4);
 If Period = 38 Then Plot38(38, "S38", RGB(Color1, Color2, 0),0,4);
 If Period = 39 Then Plot39(39, "S39", RGB(Color1, Color2, 0),0,4);
 If Period = 40 Then Plot40(40, "S40", RGB(Color1, Color2, 0),0,4);
 If Period = 41 Then Plot41(41, "S41", RGB(Color1, Color2, 0),0,4);
 If Period = 42 Then Plot42(42, "S42", RGB(Color1, Color2, 0),0,4);
 If Period = 43 Then Plot43(43, "S43", RGB(Color1, Color2, 0),0,4);
 If Period = 44 Then Plot44(44, "S44", RGB(Color1, Color2, 0),0,4);
 If Period = 45 Then Plot45(45, "S45", RGB(Color1, Color2, 0),0,4);
 If Period = 46 Then Plot46(46, "S46", RGB(Color1, Color2, 0),0,4);
 If Period = 47 Then Plot47(47, "S47", RGB(Color1, Color2, 0),0,4);
 If Period = 48 Then Plot48(48, "S48", RGB(Color1, Color2, 0),0,4);
 If Period = 49 Then Plot49(49, "S49", RGB(Color1, Color2, 0),0,4);
 If Period = 50 Then Plot50(50, "S50", RGB(Color1, Color2, 0),0,4);

End;

