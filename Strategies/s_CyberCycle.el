Inputs: price(MedianPrice),alpha(.07),lag(9);

vars: smooth(0),cycle(0),alpha2(0),signal(0);

smooth = (price + 2*price[1] + 2*price[2] + price[3])/6;

cycle = (1 - .5*alpha)*(1 - .5*alpha)*(smooth - 2*smooth[1] + smooth[2]) + 2*(1 - alpha)*cycle[1] - (1 - alpha)*(1 - alpha)*cycle[2];

if currentbar < 7 then cycle = (price - 2*price[1] + price[2])/4;

alpha2 = 1/(lag + 1);

signal = alpha2*cycle + (1 - alpha2)*signal[1];

if signal cross under signal[1] then buy next bar on open;
if signal cross over signal[1] then sellshort next bar on open;

if marketposition = 1 and positionprofit < 0 and barssinceentry > 8 then sellshort this bar on close;
if marketposition = -1 and positionprofit < 0 and barssinceentry > 8 then buy this bar on close;
