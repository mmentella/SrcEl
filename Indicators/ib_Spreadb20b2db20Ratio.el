inputs: DataSeries1( Close of data1 ), DataSeries2( Close of data2 ) ;

if DataSeries2 <> 0 then
	Plot1( DataSeries1 / DataSeries2, "SprdRatio" ) ;
