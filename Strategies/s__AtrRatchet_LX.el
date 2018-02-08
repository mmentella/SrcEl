[LegacyColorValue = true]; 

input: atrMultiplier			(0.05);
input: shortAtrLength		(4);
input: longAtrLength			(20);
input: numLowsBack			(5);
input: numAtrsToStartRatchet	(4);	
input: ______________________	(0);
input: www.linetrol.com		(0);


vars:
	stopPrice(0), atrValue(0), ratchetingBarCnt(0),
	hasStarted(false);


if marketPosition = 1 then begin
	atrValue = _highestAtr(shortAtrLength, longAtrLength);
	
	if C > (entryPrice(0) + (atrValue * numAtrsToStartRatchet)) and hasStarted = false then begin
		hasStarted = true;
		stopPrice  = entryPrice(0);
	end;

	if hasStarted then begin
		if ratchetingBarCnt > 0 then begin
			if stopPrice < Lowest(L, numLowsBack) then stopPrice = Lowest(L, numLowsBack);
			stopPrice = stopPrice + (atrValue * (atrMultiplier * ratchetingBarCnt));
		end;

		sell("Ratchet_LX") next bar at stopPrice stop;
	end;

	ratchetingBarCnt = ratchetingBarCnt + 1;
end;


if marketPosition <> 1 then begin
	hasStarted = false;
	ratchetingBarCnt = 0;
end;

