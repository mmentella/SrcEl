[LegacyColorValue = TRUE];

((Open + Close)/2 + (Volatility(8)/2) < Close) and ((Open + Close)/2 - (Volatility(8)/2) > Open)(PBHigh,"PBHigh");
Open(PBLow,"PBLow");

IF Close Then
    Alert( "" );
