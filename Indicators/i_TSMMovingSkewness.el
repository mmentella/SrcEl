[LegacyColorValue = TRUE];

{ TSM Moving Skewness
  Copyright 2003-2004, P.J.Kaufman. All rights reserved.
  Based on the article by Dennis McNicholl,
  "Old statistical methods for new tricks in analysis"
  (Futures, April 2002) 
  Also see the book, "Taming Complexit" by Dennis McNicholl }

  inputs: Price(close),MMper(0.1), MDper(0.05){, MSper(1)};
  vars: S(0), D1(0), M(0), dev(0), SMD(0), DMD(0), MD(0), std(0), G1(0), t1(0), t2(0);

  if currentbar <= 1 then begin
		S = price;
		D1 = price;
		SMD = 0;
		DMD = 0;
		G1 = 0;
		end
	else begin

{ calculate the moving mean using exponential smoothing }
	  S = MMper*price + (1 - MMper)*S[1];
{ D is the double smoothing of closing prices }
	  D1 = MMper*S + (1 - MMper)*D1[1];
	  M = ((2 - MMper)*S - D1)/(1 - MMper);

{ calculate the moving deviation MD }
 	 dev = price - M;
	 SMD = MDper*absvalue(dev) + (1 - MDper)*SMD[1];
	 DMD = MDper*SMD + (1 - MDper)*DMD[1];
	 MD = ((2 - MDper)*SMD - DMD)/(1 - MDper);
	 std = 1.25*MD;

{ calculate moving skewness }
	 t1 = {MSper*}power(dev,3) {+ (1 - MSper)*G1[1]};
	 t2 = power(std,3);
	 G1 = t1/t2;
	 plot1(g1,"skewness");
	 plot3(g1[1],"trigger");
	 plot2(0,"Zero");
 	 end;

