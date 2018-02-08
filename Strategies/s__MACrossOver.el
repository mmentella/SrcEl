{
Strategy:       _MACrossOver

Description:    Simple moving average crossover strategy




}

inputs:
    Price(close),
    Length1(5),
    Length2(27),
    PriceOffset(1),             { Price offset. Typically 1 used since strategy orders usually
                                  of type Buy/Sell NEXT bar at .... }
    PlotOffset(1),              { distance from rightmost bar on chart that plotting stops }
    PlotLength(2000),
    TLStyle(Tool_Solid),
    TLColor1(cyan),
    TLColor2(yellow),
    TLSize(0);


vars:
    MA1(0),
    MA2(0),
    NotOptimizing(GetAppInfo(aiOptimizing) = 0);


    MA1 = Average(Price, Length1);
    MA2 = Average(Price, Length2);

    if MA1 crosses above MA2 then Buy Next Bar at Market;
    if MA1 crosses below MA2 then SellShort Next Bar at Market;

    if NotOptimizing then begin
        value1 = _TLPlot(1, MA1, PlotLength, PriceOffset, PlotOffset, TLStyle, TLColor1, TLSize);
        value1 = _TLPlot(2, MA2, PlotLength, PriceOffset, PlotOffset, TLStyle, TLColor2, TLSize);
    end;
