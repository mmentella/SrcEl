{Goal of this indicator is to measure the aggressiveness AI of the executed transactions (close) relative to the bid / ask prices.

The following measure is calculated:
- AI = 1 - 1 / (1+ cumWghtPlus / cumWghtNeg)
- raAI = cumWghtPlus / cumWghtNeg

where:
- cumWghtPlus: Linearly and volume weighted cumulative count in case close > mid price
- cumWghtNeg: Linearly and volume weighted cumulative count in case close < mid price

AI takes values between 0 (oversold) and 1 (overbought). raAI is the ratio.

If the bid / ask spread is negative then no calculation is done.
}

Input:
	AIUpBoundary(0.8), // user can Set the upper boundary for the AI, The Lower is implicitely set.
	periodLength(10); // number of lookback periods	

Vars:	
	x(0), // control variable
	Intrabarpersist lastBarNumber(0),
	intrabarpersist double bidPrice(0),
	intrabarpersist double askPrice(0),
	Intrabarpersist double bidAsk(0),
	intrabarpersist double midPrice(0),
	intrabarpersist double cumPlus(0),
	intrabarpersist double cumNeg(0),
	intrabarpersist double cumWghtPlus(0),
	intrabarpersist double cumWghtNeg(0),
	Intrabarpersist double AI(0),	
	Intrabarpersist double raAI(0)
	;
{
// Access to market depth provider
var: tsdata.marketdata.MarketDepthProvider depth( NULL );
method override void InitializeComponent()
begin
	depth = new tsdata.marketdata.MarketDepthProvider;
	depth.Symbol = symbol;
	depth.IncludeECNBooks = true;
	depth.AggregateQuotes = true;
	depth.IncludeMarketDepth = true;
	depth.MaximumLevelCount = 1; 
	depth.Load = true;
	depth.Realtime = true;
	depth.Name = "depth";
	depth.updated += depth_Updated;
end;

// Get bid, ask, spread and mid price
method void depth_Updated( elsystem.Object sender, tsdata.marketdata.MarketDepthUpdatedEventArgs args ) 
begin
	bidPrice=depth.bidLevels[0].price;
	askPrice=depth.askLevels[0].price;
	bidAsk=askPrice-bidPrice;
	midPrice=bidPrice + (askPrice - bidPrice) / 2;
end; 

// plot method
Method void plotOutput()
begin
	plot1(AI,"AI",green);
	plot2(AIUpBoundary,"UpBound",yellow);
	plot3(1-AIUpBoundary,"DownBound",yellow);
	plot4(1,"1",white);
	plot5(0,"0",white);
end; 

// Calculation of the cumulative plus / negative counts taken volume into account
If bidAsk>0 then begin
	if close > midPrice then cumPlus = cumPlus + (close - midPrice) * volume;
	if close < midPrice then cumNeg = cumNeg + (midPrice - close) * volume;
end;

// Calculation of indicator AI
If barNumber>lastBarNumber then begin
	cumWghtPlus=0; // resetting variables to 0
	cumWghtNeg=0;
	For x=1 to periodLength begin // calculation of linearly weighted cumulutive plus / negative counts
		cumWghtPlus = cumWghtPlus + cumPlus[x] * (periodLength - x + 1);
		cumWghtNeg = cumWghtNeg + cumNeg[x] * (periodLength - x + 1);
	end;
	cumWghtPlus = cumWghtPlus / (periodLength * (periodLength + 1) / 2);
	cumWghtNeg = cumWghtNeg / (periodLength * (periodLength + 1) / 2);
	
	// calculation of the AI
	AI = iff( cumWghtNeg>0, 1 - 1 / (1 + cumWghtPlus / cumWghtNeg), iff( cumWghtPlus>0 , 1 , 0.5 )); //
	raAI = iff(cumWghtNeg>0, cumWghtPlus / cumWghtNeg,1); // ratio
	
	// resetting variables
	lastBarNumber=barNumber; 
	cumPlus=0;
	cumNeg=0;
end;
	
plotOutput();

// either of the following should cause the indicator to update in RadarScreen
value99=barnumber;
value99=ticks;
value99=time;
}
