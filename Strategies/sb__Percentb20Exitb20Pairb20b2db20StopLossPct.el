{ 
This general purpose exit strategy is also convenient for use with the other single-
position "discretionary" strategies.  It makes available percent-based versions of 
TradeStation's built-in stop loss and profit target in one convenient pairing.  The 
strategy will exit the entire position when either the stop loss or the profit target 
is triggered, whichever comes first, and will apply to both long and short positions.

Because it uses EntryPrice, this strategy will work correctly only in situations with 
no scale-up/scale-down, and the entry bar stop loss and profit target will be 
slightly different from the specified amounts.  For additional details, see ENTRY-BAR 
CALCULATIONS note below.

THIS STRATEGY IS FOR USE WITH STOCKS ONLY.  Percent-based exit are not commonly used 
with futures because of the high leverage, but if required, the code below can be 
modified for use with futures by multiplying all stop loss and profit target amounts 
by BigPointValue.
}

inputs: 
   ProfitTargetPct( 0 ), { pass in 0 if you don't want a profit target }
   StopLossPct( 0.5 ) ; { pass in 0 if you don't want a stop loss }

   { pass in .XX for XX percent }

SetStopShare ;
if MarketPosition <> 0 then { set regular profit-target and stop-loss }
   begin
   if ProfitTargetPct > 0 then
      SetProfitTarget( EntryPrice * ProfitTargetPct ) ;
   if StopLossPct > 0 then
      SetStopLoss( EntryPrice * StopLossPct ) ;
   end
else { set entry-bar profit-target and stop-loss }
   begin
   if ProfitTargetPct > 0 then
      SetProfitTarget( Close * ProfitTargetPct ) ;
   if StopLossPct > 0 then
      SetStopLoss( Close * StopLossPct ) ;
   end ;

{
ENTRY-BAR CALCULATIONS

This strategy's regular profit-target and stop-loss exits do not kick in until after 
the post-entry bar close.  So for a this-bar-on-close entry, the entire next bar is 
ignored.  For a next-bar entry, the remainder of the entry bar is ignored.  To 
compensate for this, this exit strategy includes a supplementary exit pair for the 
"entry-bar".  These exits are a little less precise because they use the previous 
close instead of the entry price to determine the profit-target and stop-loss 
amounts.  They don't use the entry price because this is not available at the time 
the exit amounts need to be calculated.  The exit prices are calculated by adding/
subtracting the previous-close-based exit amounts from the entry price, not from the 
previous close, so the approximation is generally pretty close.
}

{ ** Copyright (c) 2001 - 2010 TradeStation Technologies, Inc. All rights reserved. ** 
  ** TradeStation reserves the right to modify or overwrite this strategy component 
     with each release. ** }
