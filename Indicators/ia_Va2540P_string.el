//CrazyNasdaq date 20101012
//Volume@Price string
//version beta 0.1

Inputs: Txt.Color(black),
	 Txt.Size(10),
	 Txt.Bold(false),
	 Txt.Font("arial");
	

Vars: StartPrice(0),
      minD(0),
      MAXD(0),
      iPrice(0),
      MyVolume(0),
      vector(0),
      TickFactor(0),
      TickDistance(0);
      
      
      
Array: Vol.Array[1001](0),
       Vol.Txt[1001](0),
       Vol.Str[1001]("---");
       
If date = lastcalcdate then begin

MyVolume = Volume;

once begin
  for iprice=0 to 1000 begin
    vol.txt[iprice]=text_new(d, getAppInfo(aiRightDispDateTime), iprice ,"text string");
	text_setstyle(vol.txt[iprice],2,2);
	text_setcolor(vol.txt[iprice],getbackgroundcolor);
	END;
END;

	
// Reset Each day at the first TICK
if Date > Date[1] then begin
	iPrice = AvgPrice;
	StartPrice = AvgPrice;
	minD = AvgPrice;
	MaxD = AvgPrice;
	Vol.Array[iPrice] = MyVolume;	
END;
	
// Calculate the value for the rest of the day past the first TICK
If Date = Date[1] and StartPrice > 0 then begin
	vector = AvgPrice - StartPrice;  
	TickFactor = (minmove/PriceScale);
	TickDistance = vector * TickFactor;
	iPrice = StartPrice + TickDistance;   //this identifies each price level, referencing from the first tick which is the start price
	Vol.Array[iPrice] = Vol.Array[iPrice] + MyVolume; //this collects volume at each new tick and summs Volume with previous volume
	
	If iPrice >= MaxD then   {MAX of the day}
	MaxD = iPrice;
	If iPrice <= minD then   {min of the day}
	minD = iPrice;
	
END;	
	


For iPrice = minD to MAXD begin
	Array_Sort(Vol.Array,minD, MAXD,true);   //This sort the Array with Volume in ascending mode by price
	
	Vol.Str[iPrice]= numtostr(Vol.Array[iprice],0); //This transform each volume @ Price of the array in a numerical string
	
	Text_SetString(Vol.Txt[iprice],"   "+Vol.Str[iprice]);
	Text_SetColor(Vol.Txt[iprice],Txt.color);
	Text_SetSize(Vol.Txt[iprice], Txt.Size);
	Text_SetAttribute(Vol.Txt[iprice],1, txt.Bold);
	Text_SetFontName(Vol.Txt[iprice],Txt.Font);
END;
//Print(File("C:/temp/VolumeString.txt"),"  ",numtostr(iPrice,4),"  ",numtostr(Vol.array[iPrice],0));  	
END;
