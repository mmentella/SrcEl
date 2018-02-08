{********** - WS RB 2.0 - ************
 Engine: RB - Willy
 Author: Willy Sacco
 Year: 2010
 Market: CAC
 TimeFrame: 2 + 60 min.
 BackBars: 100
 Update: 18 Oct 2010
**************************************}

Inputs: NoS(2);

Inputs: f1(0.37), f2L(0.18), f2S(0.21), f3L(0.3), f3S(0.95), xDiv(2.5), CowPerc(0.81);
{Inputs: Reverse$L(1500),Reverse$S(1500);}
//Inputs: Length(45), Min$Range(1200){, Reverse$Loss(999999)};

Inputs: OpenTime(0900), CloseTime(2100);
vars: OnlyLong(true),OnlyShort(true),DaysOff(true);

{ Money Management Inputs }
Inputs: MoneyMng(True);
Inputs: StopL(2000), StopS(600);
Inputs: StopDaily(1300);
Inputs: BrkL(600), BrkS(600);
Inputs: ModL1(1400), ModS1(2000);
Inputs: PrfTrgtL(3000), PrfTrgtS(3800);

Inputs: TRStartL(1100), TRLevelL(1000);
	 {TRStartS(999999), TRLevelS(999999);}


{ Money Management Vars }
Vars: MaxCP(0);
Vars: StopVal(0), StopMin(0), StopMax(999999), PercStop(0);
Vars: TotalGain(0), YestTotalGain(0), DailyGain(0);
Vars: EnableTrade(True), DayTrade(False), DataTrue(False);


{ Money Management Constants }
Vars: ContractCost( ( Slippage + Commission ) * 2.5 );
Vars: NumContracts( Ceiling( Nos / 2 ) );


{ Strategy Constants }
Vars: {RangeMin( Min$Range / BigPointValue ),} StartTime(1000), StopTime(2050), Div(0);
{Vars: ReverseL( Reverse$L / BigPointValue ),ReverseS( Reverse$S / BigPointValue );}


{ Strategy Variables }
Vars: SetupS(0,Data2), SetupL(0,Data2), EnterL(0,Data2), EnterS(0,Data2), BreakL(0,Data2), BreakS(0,Data2);
Vars: DayLowest(0,Data2), DayHighest(9999,Data2);
Vars: Count(0), Cow(0), CowLen(6), AtrVal(0), RangeFilter(False,Data2);
Arrays: Vet[5](0,Data2);

{ Daily Condition }
if Date > Date[1] then begin
	EnableTrade = True;
	{if PercStop <> 0 then begin
       	StopMax = Close[1] * ( 1 + PercStop );
       	StopMin = Close[1] * ( 1 - PercStop );
       end;}
end;
if Date = EntryDate then begin
	EnableTrade = False;
	DayTrade = True;
end;


Div = MaxList( xDiv,1 );
DailyGain = GT.DailyGain( OpenTime );


if BarStatus(2) = 2 then begin

	if Date of Data2 > Date[1] of Data2 then begin
		
		//-------CALCOLO "MUCCHETTA"-------
		for Count = 0 to ( CowLen - 2 ) begin

			Vet[Count] = Vet[Count + 1];
			
		end;
		
		Vet[CowLen - 1] = DayHighest[1] - DayLowest[1];
		
		Cow = array_sum( Vet, 0, CowLen - 2 ) / ( CowLen - 1 );
		//---------------------------------
		RangeFilter = ( DayHighest[1] - DayLowest[1] ) >= ( Cow * CowPerc );

		DayHighest = High of Data2;
		DayLowest = Low of Data2;

		SetupS = DayHighest[1] + f1 * ( Close[1] of Data2 - DayLowest[1] );
		SetupL = DayLowest[1] - f1 * ( DayHighest[1] - Close[1] of Data2 );
		EnterL = ( ( 1 + f2S ) / 2 ) * ( DayLowest[1] + Close[1] of Data2 ) - f2S * DayHighest[1];
		EnterS = ( ( 1 + f2L ) / 2 ) * ( DayHighest[1] + Close[1] of Data2 ) - f2L * DayLowest[1];
		BreakL = SetupS + f3L * ( SetupS - SetupL );
		BreakS = SetupL - f3S * ( SetupS - SetupL );

	end
	else begin

		if High of Data2 > DayHighest then DayHighest = High of Data2;
		if Low of Data2 < DayLowest then DayLowest = Low of Data2;
		
	end;
	
end;

DataTrue = DaysOff;
//DataTrue = True;

if not DataTrue then begin

	if marketposition > 0 then sell nos shares next bar at market;
	if marketposition < 0 then buytocover nos shares next bar at market;

end;


if OpenTime <= Time and Time < CloseTime then begin   { Day operations hours }


	if MoneyMng then begin

		
		//if Date > EntryDate and DayTrade then begin
			
			if DailyGain < -( StopDaily * CurrentContracts ) then begin
				DayTrade = False;
				EnableTrade = False;
				if MarketPosition > 0 then Sell("XL.StopDaily.m") next bar at Market
				else if MarketPosition < 0 then BuyToCover("XS.StopDaily.m") next bar at Market;
			end
			else begin
				if MarketPosition > 0 then begin
					StopVal = Close - ( DailyGain / CurrentContracts + StopDaily - ContractCost ) / ( BigPointValue );
					Sell("XL.StopDaily.s") next bar at StopVal Stop;
				end else
				if MarketPosition < 0 then begin
					StopVal = Close + ( DailyGain / CurrentContracts + StopDaily - ContractCost ) / ( BigPointValue );
					BuyToCover("XS.StopDaily.s") next bar at StopVal Stop;
				end;
				
			end;

		//end;
		
		
		if MarketPosition <> 0 then begin	
	
			MaxCP = GT.MaxContractProfit;

			SetStopContract;	
			
			// LONG CONDITIONS
			
			if MarketPosition > 0 then begin
			
			
				// STOPLOSS
				StopVal = EntryPrice - ( StopL - ContractCost ) / BigPointValue;
				if Close <= StopVal then Sell("XL.Stop.m") next bar at Market
				else if Close > StopVal and StopVal > StopMin then SetStopLoss(StopL);
						
				
				// BRAKEVEN	
				StopVal = EntryPrice + ( ContractCost * 1.5 ) / BigPointValue;
				if MaxCP > BrkL and Close <= StopVal then Sell("XL.Brk.m") next bar at Market
				else if MaxCP > BrkL and Close > StopVal and StopVal > StopMin then Sell("XL.Brk.s") next bar at StopVal Stop;
				
						
				// MODAL EXIT 1
				if CurrentContracts = nos then begin
					StopVal = EntryPrice + ( ModL1 + ContractCost ) / BigPointValue;
					if Close >= StopVal then Sell("XL.Mod1.m") NumContracts shares next bar at Market
					else if Close < StopVal and StopVal < StopMax then Sell("XL.Mod1.s") NumContracts shares next bar at StopVal Limit;
				end;
				
								
				{// MODAL EXIT 2
				if CurrentContracts < nos then begin
					StopVal = EntryPrice + ( ModL2 + ContractCost ) / BigPointValue;
					if Close >= StopVal then Sell("XL.Mod2.m") CurrentContracts shares next bar at Market
					else if Close < StopVal and StopVal < StopMax then Sell("XL.Mod2.s") CurrentContracts shares next bar at StopVal Limit;
				end;}
				
					 			
		 		// TRAILING STOP
		 		if CurrentContracts < nos and MaxCP > TRStartL then begin
		  			StopVal = EntryPrice + ( MaxCP - TRLevelL + ContractCost ) / BigPointValue;
		  			if Close <= StopVal then Sell ("XL.Trl.m") CurrentContracts shares next bar at Market
					else if Close > StopVal and StopVal > StopMin then Sell("XL.Trl.s") CurrentContracts shares next bar at StopVal Stop;
		 		end;
		 		
		 		
		 		// PROFIT TARGET
		 		StopVal = EntryPrice + ( PrfTrgtL + ContractCost ) / BigPointValue;
		 		if Close >= StopVal then Sell("XL.Profit.m") next bar at Market
		 		else if Close < StopVal and StopVal < StopMax then SetProfitTarget(PrfTrgtL);
		 		
		 		
		 	end
		 	
		 	// SHORT CONDITIONS
		 	
		 	else if MarketPosition < 0 then begin
		 	
		 		
		 		// STOPLOSS		
				StopVal = EntryPrice + ( StopS - ContractCost ) / BigPointValue;
				if Close >= StopVal then BuyToCover("XS.Stop.m") next bar at Market
				else if Close < StopVal and StopVal < StopMax then SetStopLoss(StopS);
				
				
				// BRAKEVEN
				StopVal = EntryPrice - ( ContractCost * 1.5 ) / BigPointValue;
				if MaxCP > BrkS and Close >= StopVal then BuyToCover("XS.Brk.m") next bar at Market
				else if MaxCP > BrkS and Close < StopVal and StopVal < StopMax then BuyToCover("XS.Brk.s") next bar at StopVal Stop;
				
				
				// MODAL EXIT 1
				if CurrentContracts = nos then begin
					StopVal = EntryPrice - ( ModS1 + ContractCost ) / BigPointValue;
					if Close <= StopVal then BuyToCover("XS.Mod1.m") NumContracts shares next bar at Market
					else if Close > StopVal and StopVal > StopMin then BuyToCover("XS.Mod1.s") NumContracts shares next bar at StopVal Limit;
				end;
				
				
				{// MODAL EXIT 2
				if CurrentContracts < nos then begin
					StopVal = EntryPrice - ( ModS2 + ContractCost ) / BigPointValue;
					if Close <= StopVal then BuyToCover("XS.Mod2.m") CurrentContracts shares next bar at Market
					else if Close > StopVal and StopVal > StopMin then BuyToCover("XS.Mod2.s") CurrentContracts shares next bar at StopVal Limit;
				end;}
				
		 		
		 		{//TRAILING STOP
				if CurrentContracts < nos and MaxCP > TRStartS then begin
		  			StopVal = EntryPrice - ( MaxCP - TRLevelS + ContractCost ) / BigPointValue;
		  			if Close >= StopVal then BuyToCover("XS.Trl.m") CurrentContracts shares next bar at Market
					else if Close < StopVal and StopVal < StopMax then BuyToCover("XS.Trl.s") CurrentContracts shares next bar at StopVal Stop;
		 		end;}
		 		
		 		
		 		// PROFIT TARGET
		 		StopVal = EntryPrice - ( PrfTrgtS + ContractCost ) / BigPointValue;
		 		if Close <= StopVal then BuyToCover("XS.Profit.m") next bar at Market
		 		else if Close > StopVal and StopVal > StopMin then SetProfitTarget(PrfTrgtS);
		 		
		 		
			end;
			
		end;
	
	end;


	if StartTime <= Time and Time < StopTime and DataTrue and EnableTrade and RangeFilter then begin

		if OnlyLong and OnlyShort then begin
			if DayLowest <= SetupL and MarketPosition < 1 then buy("Long") NoS Shares next bar at ( EnterL - ( SetupL - DayLowest ) / Div ) Stop;
			if DayHighest >= SetupS and MarketPosition > -1 then SellShort("Short") NoS Shares next bar at ( EnterS + ( DayHighest - SetupS ) / Div ) Stop;

			if MarketPosition < 1 then buy("Break-Long") NoS Shares next bar at BreakL Stop;
			if MarketPosition > -1 then SellShort("Break-Short") NoS Shares next bar at BreakS Stop;
				
			//if MarketPosition = -1 then Buy("RevS-Long") NoS Shares next bar at ( EntryPrice + ReverseS ) Stop;
			//if MarketPosition = 1 then SellShort("RevL-Short") NoS Shares next bar at ( EntryPrice - ReverseL ) Stop;
		end;	
		if OnlyLong and OnlyShort=false then begin
			if DayLowest <= SetupL and MarketPosition < 1 then buy("Long_") NoS Shares next bar at ( EnterL - ( SetupL - DayLowest ) / Div ) Stop;
			if DayHighest >= SetupS and MarketPosition > -1 then sell("Short_") NoS Shares next bar at ( EnterS + ( DayHighest - SetupS ) / Div ) Stop;

			if MarketPosition < 1 then buy("Break-Long_") NoS Shares next bar at BreakL Stop;
			if MarketPosition > -1 then sell("Break-Short_") NoS Shares next bar at BreakS Stop;
				
			//if MarketPosition = -1 then Buy("RevS-Long") NoS Shares next bar at ( EntryPrice + Reverse ) Stop;
			//if MarketPosition = 1 then SellShort("RevL-Short") NoS Shares next bar at ( EntryPrice - Reverse ) Stop;
		end;	
		if OnlyLong=False and OnlyShort then begin
			if DayLowest <= SetupL and MarketPosition < 1 then buytocover("_Long") NoS Shares next bar at ( EnterL - ( SetupL - DayLowest ) / Div ) Stop;
			if DayHighest >= SetupS and MarketPosition > -1 then SellShort("_Short") NoS Shares next bar at ( EnterS + ( DayHighest - SetupS ) / Div ) Stop;

			if MarketPosition < 1 then buytocover("_Break-Long") NoS Shares next bar at BreakL Stop;
			if MarketPosition > -1 then SellShort("_Break-Short") NoS Shares next bar at BreakS Stop;
				
			//if MarketPosition = -1 then Buy("RevS-Long") NoS Shares next bar at ( EntryPrice + Reverse ) Stop;
			//if MarketPosition = 1 then SellShort("RevL-Short") NoS Shares next bar at ( EntryPrice - Reverse ) Stop;
		end;	
			
	end;

end;
