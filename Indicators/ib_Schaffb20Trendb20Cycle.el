{*******************************************************************
Description : This Indicator plots the Schaff Trend Cycle
Provided By : FX-Strategy, Inc. (c) Copyright 1999
********************************************************************}
Inputs: TCLen(10), MA1(23), MA2(50);
plot1(_SchaffTC(TCLen,MA1,MA2),"Schaff_TLC");
plot2(25);
plot3(75);
