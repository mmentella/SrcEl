{************************************************************

	System		: _KAMA
	
	Last Edit	: 1/4/98

	Provided By	: Bob Fulks

	Description	: This system uses the Kaufman Adaptive Moving 
       Average. It is an EasyLanguage version of the system 
       published in the Bonus Issue 1998 of TASC, page 35. 
       Note that the article description has errors in the 
       algebraic equations but the spreadsheet formulas seem 
       to be correct.

*************************************************************}

Inputs: Length(10), FiltrPct(15);

Vars: AMA(Close), Filter(0), AMAlo(Close), AMAhi(Close);

AMA = _AMA(Close, Length);

Filter = FiltrPct * StdDev(AMA - AMA[1], Length) / 100;

AMAlo = iff(AMA < AMA[1], AMA, AMAlo[1]);
AMAhi = iff(AMA > AMA[1], AMA, AMAhi[1]);

if AMA - AMAlo > Filter then Buy This Bar ;
if AMAhi - AMA > Filter then sellshort This Bar ;
