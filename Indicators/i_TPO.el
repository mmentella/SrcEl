[RecoverDrawings=False]

Inputs: ResNum(2),
        Precision(0),
        ModeView(1),
        SpcWidth(3),  //Space width for mode 2
        FactorShift(20),
        CorrectShiftTime(0),
        PriceRange(1000),
        ColorTPOFirst("Coral"),
        Color_IBR("Aquamarine"),
        ColorSymbol("DeepSkyBlue"),
        ColorTPOMax("Maroon"),
        Font("Lucida Console"),
        Space(" ");


Variables: 
	    intrabarpersist prev_day(IntPortion(datetime data(ResNum))),
	    intrabarpersist cur_day(IntPortion(datetime data(ResNum))),
	    intrabarpersist SessionN(0),           
           intrabarpersist UHigh(0),
           intrabarpersist ULow(0),
           intrabarpersist _Precision(0),
           intrabarpersist DShift(0),
           intrabarpersist TShift(0),
           intrabarpersist StartTime(0),
           intrabarpersist OneStDay(true), 
           intrabarpersist CalcShiftTime(0),
           intrabarpersist Midl_ID(0), 
           intrabarpersist EndPrice(0),
           intrabarpersist EndTime(0),
           intrabarpersist End_ID(0),
           intrabarpersist CorrectDay(0), 
           intrabarpersist TPOStep(0),
           intrabarpersist MidlMaxPrc(0),
           intrabarpersist MidlMinPrc(99999),
           intrabarpersist IdxMidlPrc(0), 
           intrabarpersist StartSession(0),
           intrabarpersist ColorIBR(0), 
           intrabarpersist SetNewStep(false),
           intrabarpersist MidlPrice(0),
           intrabarpersist OldPrice(0),
           intrabarpersist ColorMaxTPO(0),
           intrabarpersist TPO70(0), 
           intrabarpersist RangeWidth(0),
           intrabarpersist CurStepPrc(0),
           intrabarpersist MaxStepPrc(0),
           intrabarpersist MinStepPrc(99999),
           intrabarpersist RangePrc(0), 
           intrabarpersist IBR_ID(0),
           intrabarpersist CorrectTime(2400),
           intrabarpersist SymTPO(""),
           intrabarpersist TextSym(""), 
           intrabarpersist MaxTPOID(0),
           intrabarpersist SaveNum(0),
           intrabarpersist TextID(0),
           
           //Lucida Console, Courier Regular,Bitstream Vera Sans Mono Bold,Bitstream Vera Sans Mono Roman
           intrabarpersist SetRange(500),
           intrabarpersist SNStep(0),
           intrabarpersist FontSize(10),
           intrabarpersist BGColor(0),
           intrabarpersist center(0),
           intrabarpersist SBGColor(0),
           intrabarpersist TextColor(0),
           intrabarpersist Border(false),
           intrabarpersist MaxTPO(0),
           intrabarpersist PRCMaxTPO(0),
           intrabarpersist SaveIPMaxTPO(0),
           intrabarpersist BGBlue(0),
           intrabarpersist BGGreen(0), 
           intrabarpersist BGMagenta(0),
           intrabarpersist BGGray(0),
           intrabarpersist MaxTpoUpdate(false),
           intrabarpersist MaxTpoTlIDXH(0),
           intrabarpersist MaxTpoTlIDXL(0),
           intrabarpersist MaxTpoTlIDXLeft(0),
           intrabarpersist MaxTpoTlIDXRight(0),
           intrabarpersist BarPrcCount(0),
           intrabarpersist WidthMaxTPO(1),
           intrabarpersist NumTL(0),
           intrabarpersist TEST(""),
           intrabarpersist SPC(""),
           //----------------------
           _Font(""),
           intrabarpersist BarCount(0), 
           intrabarpersist MaxPnt(0),
           intrabarpersist MinPnt(0),
           intrabarpersist MaxStep(0),
           intrabarpersist RznTime(0),
           intrabarpersist VP(0),
           intrabarpersist NewStep(false),
           intrabarpersist TextShift(0), 
           intrabarpersist DateMin(0),
           intrabarpersist TimeMin(0),
           intrabarpersist DateTimeMin(0),
           intrabarpersist OpenMin(0),
           intrabarpersist HighMin(0),
           intrabarpersist LowMin(0), 
           intrabarpersist CloseMin(0),
           intrabarpersist SaveCloseMin(0),
           intrabarpersist MinDayPrc(0), 
           intrabarpersist MaxDayPrc(0), 
           intrabarpersist StartMinDayPrc(0),
           intrabarpersist DayRzn(0),
           intrabarpersist CorrDay(0),
           intrabarpersist TotalTPO(0),
           intrabarpersist SavPMaxTPO(0),
           intrabarpersist TDate(0),
           intrabarpersist TTime(0),
           intrabarpersist TTimeMax(0), 
           intrabarpersist TDateMax(0), 
           intrabarpersist AppSize(0), 
           intrabarpersist Online(false), 
           intrabarpersist DrawTPO(false),
                           SetColorText(0), 
                           ColorFirstTPO(0),
           intrabarpersist IdxDayRange(0),
           intrabarpersist CurPrice(0),
           intrabarpersist DDate(0),
           intrabarpersist DTime(0),
           intrabarpersist DOpen(0),
           intrabarpersist DHigh(0),
           intrabarpersist DLow(99999),
           intrabarpersist DClose(0),
           intrabarpersist MinIBR(0),
           intrabarpersist MaxIBR(0),
           intrabarpersist Modif(false),
           intrabarpersist OLDID_MAXTPO(0),
           intrabarpersist ShiftCountTPO(0),
           intrabarpersist ShiftIBR(0),
           intrabarpersist ShiftFTPO(0);
 
    Arrays: intrabarpersist ID_CountTPO[](0),
            intrabarpersist Table[5000,48](0),
            intrabarpersist ArStepTPO[](""),
            intrabarpersist ID_TPO[](0),
            intrabarpersist StringTPO[](""),
            intrabarpersist R_ID[](0);

  once begin
  
       array_setmaxindex(ID_CountTPO,PriceRange);
       array_setmaxindex(ArStepTPO,PriceRange);
       array_setmaxindex(ID_TPO,PriceRange);
       array_setmaxindex(StringTPO,PriceRange);
       array_setmaxindex(R_ID,PriceRange);
       
       ColorMaxTPO = WEBColor(ColorTPOMax);
       SetColorText = WEBColor(ColorSymbol);
       ColorFirstTPO = WEBColor(ColorTPOFirst);
       ColorIBR = WEBColor(Color_IBR);
       _Font = Font;
       SPC = Space;
       if Precision = 0 then begin 
           _Precision = Digits;
       end else begin
           _Precision = Precision;
       end;
       
       TextShift = FactorShift;   
  end;
  
  cur_day = IntPortion(datetime);
  
  if SessionN = 0 then SessionN = CurrSessionNum(ResNum);
  if SessionN = 0 then #return;
  
    DateMin = Date Data(ResNum);
    TimeMin = Time Data(ResNum);
    DateTimeMin = DateTime Data(ResNum);
    OpenMin = Round(Open data(ResNum) ,_Precision);
    HighMin = Round(High data(ResNum) ,_Precision);
    LowMin  = Round(Low data(ResNum) ,_Precision);
    CloseMin= Round(Close data(ResNum) ,_Precision);
 


    if NRTime(TimeMin) then begin

       if BarPeriodN(ResNum, SessionN,DDate,DTime,DOpen,DHigh,DLow,DClose) then begin
 
           OneStDay = true;
           TPOStep = 0;
           StartMinDayPrc = CloseMin - PriceRange/2*SetPoint(Precision);
           for value1=0 to PriceRange begin
               for value2=0 to 48 begin
                   Table[value1,value2] = 0;
               end;
               R_ID[value1]=0;
               ArStepTPO[value1] = "";
               StringTPO[value1] = "";
               ID_TPO[value1] = 0;
               ID_CountTPO[value1]=0;
               
           end;
          
           IdxDayRange =0;
           
           MaxTPO  = 0;
           PRCMaxTPO = 0;
           MaxTPOID = 0;
           MaxTpoTlIDXH = 0;  
           MaxTpoTlIDXL = 0; 
           MaxTpoTlIDXLeft = 0;
           MaxTpoTlIDXright = 0;
           Midl_ID = 0;
           IBR_ID =0;
           End_ID =0;
           OLDID_MAXTPO=0;
           MidlMaxPrc =0;
           MidlMinPrc = 99999;
           TotalTPO=0;
           MaxDayPrc = 0;
           MinDayPrc = 99999;
           EndPrice =0;
           EndTime =0;
           UHigh = 0;
           ULow = 0;
           MinIBR = 99999;
           MaxIBR = 0;
        end;
        
        TDate = DDate+DShift;
       
        MinDayPrc = DLow;   //Day
        MaxDayPrc = DHigh;  //Day

        Online = false;

        NewStep = false;
        if StepTPO_N(ResNum, SessionN, DateMin, TimeMin,30,0,TPOStep) then begin 
            SymTPO = TPOSym(TPOStep);
            NewStep = true;
            MaxStepPrc = 0;
            MinStepPrc = 99999;
            if ModeView = 1 then begin  
                 TextSym = SymTPO;
                 TextColor = SetColorText;
                 BGColor = black;
            end else if ModeView = 2 then begin   
                 switch(SpcWidth ) begin
                     case 1 : TextSym = " ";
                     case 2 : TextSym = "  ";
                     case 3 : TextSym = "   ";
                     case 4 : TextSym = "    ";
                     case 5 : TextSym = "     ";
                 end;
                 TextColor = SetColorText;
                 BGColor = SetColorText; 
                 _Font = "Bitstream Vera Sans Mono Roman";       
            end;
        end; //StepTPO

        MaxStepPrc = maxlist(MaxStepPrc,HighMin); //Step
        MinStepPrc = minlist(MinStepPrc,LowMin);  //Step

            CurPrice = StartMinDayPrc;
      
            DShift=cur_day - prev_day; 
            //if DayOfWeek(DDate) = 5 or DayOfWeek(DDate) = 4 then begin
            //     DShift=3; 
            //end;

            for value1=0 to PriceRange begin
                if CurPrice >= MinStepPrc and CurPrice <= MaxStepPrc then begin    
                    
                    //========== Initial Balance Range ===============
                    if TPOStep = 1 then begin
                       ShiftIBR = TextShift/5;
                       if IBR_ID = 0 then begin
                           IBR_ID = DrawDTLine(DDate+DShift,CorrectShiftTime+DTime+ShiftIBR ,DDate+DShift,CorrectShiftTime+DTime+ShiftIBR ,MinStepPrc,MaxStepPrc,0,ColorIBR,2); //range one step 
                       end else begin
                           TL_Correct(IBR_ID,DDate+DShift,CorrectShiftTime+DTime+ShiftIBR,MinStepPrc-SetPoint(Precision)/2,DDate+DShift,CorrectShiftTime+DTime+ShiftIBR ,MaxStepPrc+SetPoint(Precision)/2);                 
                       end; 
                    end;    
                    
                    //================== Midl Price =========================
                    if MidlMaxPrc < value1 then begin   
                        MidlMaxPrc = value1;
                    end;
                    if MidlMinPrc > value1 then begin   
                        MidlMinPrc = value1;
                    end;

                    if ArStepTPO[value1] <> SymTPO then begin
                        Modif = false;
                        for value2=0 to TPOStep -1 begin
                            
                            //====== First TPO ===========
                            SBGColor = BGColor;
                            if OneStDay then begin
                               ShiftFTPO = TextShift/3;
                               DrawDTText(" ",DDate+DShift,CorrectShiftTime+DTime+ShiftFTPO,CurPrice,TextColor,ColorFirstTPO,FontSize,"Bitstream Vera Sans Mono Roman",0,2,Border); 
                               OneStDay = false;
                            end;

                            if Table[value1,value2] = 0 then begin
                            
                                //=== MAX TPO ===
                                if MaxTPO < (value2+1) then begin
                                    MaxTPO = (value2+1); 
                                    PRCMaxTPO = CurPrice;
                                end;

                                //====== VA ======
                                TPO70 = TotalTPO*70/100; 
                                 
                                //========= Count TPO ==============
                                ShiftCountTPO = TextShift/5;
                                if ID_CountTPO[value1] = 0 then begin
                                    ID_CountTPO[value1] = DrawDTText( NumToStr(value2+1,0),DDate+DShift,CorrectShiftTime+DTime-ShiftCountTPO ,CurPrice ,White,0,FontSize,_Font,1,2,false); //step count  
                                end else begin
                                    text_setstring(ID_CountTPO[value1],NumToStr(value2+1,0));
                                end;

                                StringTPO[value1] = StringTPO[value1] + TextSym+SPC; 
                                Table[value1,value2] = TPOStep;
                                EndPrice = CurPrice;
                                EndTime = TTime+TShift;
                                Modif = true;
                                TotalTPO = TotalTPO +1; 
                                break;
                            end;
                        end; //end tpo cicle
                        ArStepTPO[value1] = SymTPO;
                    end;
                    
                   
                    if Modif then begin
                        if ID_TPO[value1] = 0 then begin
                            ID_TPO[value1] = DrawDTText(StringTPO[value1] ,DDate+DShift,CorrectShiftTime+DTime+TextShift,CurPrice,TextColor,SBGColor,FontSize,_Font,0,2,Border); //Draw Text
                        end else begin
                            text_setstring(ID_TPO[value1],StringTPO[value1]);
                        end;
                            
                        //MAX TPO
                        if PRCMaxTPO = CurPrice then begin   
                            text_setbgcolor(OLDID_MAXTPO,SBGColor);
                            text_setbgcolor(ID_TPO[value1],ColorMaxTPO);
                            OLDID_MAXTPO = ID_TPO[value1];
                        end;
                    end;  
                 end;

               //--------------------------------------------------------
                OldPrice = CurPrice;
                CurPrice = CurPrice + SetPoint(Precision); 
                 
            end; //end price cicle    
    end;//end NRTime 

if cur_day <> prev_day then	prev_day  = cur_day;
