[LegacyColorValue = true]; 
//[IntrabarOrderGeneration = true];


Inputs:Nos(2), apertura(1600),chiusura(2000),Price(C),Length(5),BFL(0.997),BFS(0.973),ADXlun(17),BandaADX(20);
Inputs: profitt(5500),stopp(1500),barra(3),basebrkl(1700),BRKLl(500),basebrks(3000),BRKSs(450),lungh(50),PEOD(500);

Vars: _$MA(0),_$MB(0),_$RA(0),_$Rng(0),_$UB(0),_$LB(0),contaop(0),contabarre(0);

//Trailing stop
Inputs: TRL(5000),TL(500),TRS(4500),TS(1000);
Vars: hh(0),ll(0);
//BreakEven

vars: LvlTrl(0),LvlTrS(0), BRKL(false),BRKS(false);
vars: LvlBRL(0),LvlBRS(0);
vars: TrlA(false),Trsa(false);


{Congestion Channel}
if barstatus(1)=2 then
begin
_$MA=AMA_Pino(Price,Length);
_$MB=(_$MA*(Length-1)+Price)/Length; 
_$RA=AMA_Pino(TrueRange,Length);
_$Rng=(_$RA*(Length-1)+TrueRange)/Length;
_$UB=_$MB+(_$Rng*BFL);
_$LB=_$MB-(_$Rng*BFS);
end;
condition1= (t>=apertura and t<chiusura);


if d[1]<>d and barstatus(1)=2 then
begin
	contabarre=0;
	end;

if barstatus(1)=2 then
begin
	contabarre=contabarre+1;
end;

if condition1 and contabarre>= barra then
	begin
	//messagelog(NumToStr(t,0));
		setstoploss(stopp*Nos);
		
		if openpositionprofit>= ((profitt*nos)/100)*95 then
		begin
		      setprofittarget(profitt*Nos);
		end;

	if marketposition>0 and positionprofit(0)>=basebrkl*nos then
		begin
			Sell("Brkl") Next Bar  Nos shares at entryprice+((BRKLl*Nos)/bigpointvalue) stop;
			end;


    	if marketposition<0 and positionprofit(0)>=basebrks*nos then
		begin
			Buy to Cover("BrkS") Next Bar  Nos shares at entryprice-((BRKSs*Nos)/bigpointvalue) stop;
		end;

	//Trailing Stop
	if marketposition=1 and openpositionprofit>=TRL then
	begin
		TrlA=true;
		Trsa=false;
	end;
	
	if marketposition=-1 and openpositionprofit>=TRS then
	begin
		Trsa=true;
		TrlA=false;
	end;
	
	if marketposition=0 then 
	begin
		TrlA=false;
		Trsa=false;
	end;
	
	if High>=hh then hh=High;
	if Low<=ll then ll=Low;
	
	
	LvlTrl = hh-((TL*nos)/bigpointvalue);
	LvlTrS = ll+((TS*nos)/bigpointvalue);
	
	
	if TrlA and l cross under LvlTrl then
	begin
		sell("TRL") (currentcontracts/2) shares next bar at market;
	end;
	
	if Trsa and h cross over LvlTrS then
	begin
		buytocover("TR") (currentcontracts/2) shares next bar at market;
	end;
	//

	if (t>=1900) and positionprofit>=PEOD*nos then
	begin
		if marketposition>0 then
			begin
				Sell("EODL") (currentcontracts)/2 shares this bar on close;
			end;

		if marketposition<0 then
		begin
			Buy to Cover("EODS") (currentcontracts)/2 shares this bar on close;
			end;
		end;


	if ADXR(ADXLun)<BandaADX then
	begin
			
				//Buy("long") Nos shares next bar at _$UB stop;
			
					Buy("long") Nos shares next bar at _$UB stop;
				
			
				//Sell Short("short") Nos shares next bar at _$LB stop;
				
					Sell Short("short") Nos shares next bar at _$LB stop;
				
					
	end;

	end;

