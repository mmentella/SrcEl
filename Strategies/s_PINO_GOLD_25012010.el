[LegacyColorValue = true]; 
//[IntrabarOrderGeneration = true];

{******************************************************************************************************************
*  Sistema su COMEX GOLD                        Pino_Con_GOLD V6
*
*  Time Frames: 60min e Daily
*
*  Overnight
*******************************************************************************************************************}



Inputs:Nos(2), Length(3),apertura(1100),chiusura(1800),BFL(0.4),BFS(1.2),profitt(1000),stopp(2000),ABKLong(1000),BreaKL(600),ABShort(2000),BreakS(1000);
Variables: FiltroNoiseAmerica(1400),ADXlun(14),BandaADX(20),barra(4);
Variables: _$MA(0),_$MB(0),_$RA(0),_$Rng(0),_$UB(0),_$LB(0),contaop(0),contabarre(0),Price(C);
Variables: ROC(0),barrep(0),chiusuraV(0),BFLV(0),BFSV(0),profittV(0),stoppV(0),ATRLV(0),ATRSV(0),barraV(0);
Variables: PosHighl(0), ATRVall(0);
Variables: PosLows(0), ATRVals(0);
Vars: CH(0),CL(0);
Input: TRLA(3000),TRL(80),TRSA(3500),TRS(60);

if d[1]<>d and barstatus(1)=2 then
begin
	barrep=contabarre;
	contabarre=0;
end;

if barstatus(1)=2 then
	begin
		contabarre=contabarre+1;
	end;

if barrep<=7 then
begin
	{No Overnight}
		chiusurav=chiusura+100;
		BFLV=BFL*2.25;
		BFSV=BFS*0.375;
		profittV=2400;
		stoppV=1100;
		ATRLV=12;
		ATRSV=15;
		barraV=3;

end
else
	{Overnight}
	begin
		chiusurav=chiusura;
		BFLV=BFL;
		BFSV=BFS;
		profittV=profitt;
		stoppV=stopp;
		ATRLV=14;
		ATRSV=2;
		barraV=4;
		end;


if barstatus(1)=2 then
begin
_$MA=AMA_Pino(close,Length);
_$MB=(_$MA*(Length-1)+close)/Length; 
_$RA=AMA_Pino(TrueRange,Length);
_$Rng=(_$RA*(Length-1)+TrueRange)/Length;
_$UB=_$MB+(_$Rng*BFLV);
_$LB=_$MB-(_$Rng*BFSV);
end;
condition1= (t>=apertura and t<chiusuraV);




if condition1 and contabarre>= barraV then
	begin
			if barssinceentry>1 then
			begin
				//setstoploss(stoppV*Nos);
				//Determino lo stop los
				if openpositionprofit<= -(stoppV*nos) then
				begin
					if marketposition>0 then sell("StolL") this bar on close;
					if marketposition<0 then buytocover("StopS") this bar on close;
				end;
				
				
				if openpositionprofit>= ((profitt*nos)/100)*99 then
				begin
				//determino il profit target
					//setprofittarget(profittV*Nos);
					if marketposition>0 then sell("TragetL") nos shares this bar on close;
					if marketposition<0 then buytocover("TargetS") nos shares this bar on close;
				end;
			end;
			
			{BreakEven}
			if marketposition>0 and positionprofit(0)>=ABKLong*nos then
				begin
				if barssinceentry>1 then
				begin
					Sell("BreaKLong") Next Bar  Nos shares at entryprice+((BreaKL)/bigpointvalue) stop;
				end;
				end;


    			if marketposition<0 and positionprofit(0)>=ABShort*nos then
				begin
				if barssinceentry>1 then
				begin
					Buy to Cover("BreakShort") Next Bar  Nos shares at entryprice-((BreakS)/bigpointvalue) stop;
				end;	
				end;

			{Segnali ingresso}
			if (ADXR(ADXLun)<BandaADX) and (t<>FiltroNoiseAmerica)  then
				begin
					if (marketposition[1]=0 or marketposition[1]=-1)   then
					begin
						Buy("long") Nos shares next bar at _$UB stop;
					end;
					if (marketposition[1]=0 or marketposition[1]=1)  then
					begin

						Sell Short("short") Nos shares next bar at _$LB stop;
					end;	
				end;

				if barstatus(1)=2 then
					begin
						CH=H;
						CL=L;
					end;
		//Trailing Stop
            	if marketposition=1 and barssinceentry>1 then
            		begin
            			setdollartrailing(TRLA*nos);
            			
            		end;
			
		if marketposition=-1 and barssinceentry>1 then
			begin
				setdollartrailing(TRSA*nos);
			end;

	end;

