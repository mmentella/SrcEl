input: 
    Price(AvgPrice),
    LocalHrsOffset(0),                       
    time1(0900),
    time2(0930),
    time3(1129),
    time4(1315),
    time5(1415),
    upColor(Cyan),
    dnColor(Magenta);

var:
    var0(0);
var0 = VWAPResettable(Price,LocalHrsOffset,time1,time2,time3,time4,time5);

if var0 > var0[1] then buy this bar c;
if var0 < var0[1] then sell short this bar c;
