Inputs: NoS(1);

Vars: TH(0),TL(0),YC(0),YO(0),YH(0),YL(0),ATRVal(0);
	
{*********SET UP*********}

if Date <> Date[1] then begin
	
	YC = Close of data(2);
	YO = Open of data(2);
	YH = High of data(2);
	YL = Low of data(2);
	
	if YC < YO then begin
		TH = (YH + YC + 2*YL)/2 - YL;
		TL = (YH + YC + 2*YL)/2 - YH;
	end;
	
	if YC > YO then begin
		TH = (2*YH + YC + YL)/2 - YL;
		TL = (2*YH + YC + YL)/2 - YH;
	end;
	
	if YC = YO then begin
		TH = (YH + 2*YC + YL)/2 - YL;
		TL = (YH + 2*YC + YL)/2 - YH;
	end;

end;


{*********ENTRY*********}

if Close > TH then Buy("EL") NoS shares next bar at TH+ATRVal stop;
if Close < TL then Sellshort("ES") NoS shares next bar at TL-ATRVal stop;
