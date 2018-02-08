inputs:
UpColor(darkgreen),
DownColor(red),
MaxBlock(9999),
MinBlock(0),
ResetDeltaEachBar(0);

variables:
MyVol(0),
Block(0),
color(yellow),
firstrunthrough(true),
intrabarpersist MyCurrentBar(0),
intrabarpersist VolTmp(0),
intrabarpersist Deltac(0),
intrabarpersist DeltaH(0),
intrabarpersist DeltaL(0),
intrabarpersist DeltaO(0);

if firstrunthrough then begin// We need to do this in case indicator starts mid bar
Voltmp=Iff(BarType<2,Ticks,Volume);
firstrunthrough=False;
end;

if LastBarOnChart then begin
 
 if CurrentBar>MyCurrentBar then begin
  VolTmp=0;
  MyCurrentBar=CurrentBar;
  if ResetDeltaEachbar=1 then Deltac=0;
  DeltaO=Deltac;
  DeltaH=Deltac;
  DeltaL=Deltac;
 end;
 
 MyVol=Iff(BarType<2,Ticks,Volume);
 Block=Myvol-VolTmp;
 
 if (Block >= MinBlock ) and ( Block <= MaxBlock) then
  if Close <= InsideBid then
   Deltac = Deltac - MyVol + VolTmp
  else if Close >= InsideAsk then
   Deltac = Deltac + MyVol - VolTmp;
 
 VolTmp = MyVol;
  
 DeltaH = maxlist(DeltaH,Deltac);
 DeltaL = minlist(DeltaL,Deltac);
 

 if Deltac<=Deltal[1]then
 color=DownColor
 else
 if Deltac>=Deltah[1]then
 color=UpColor
 else
 color=color[1];
 
 plot1(DeltaO,"DO",color);
 Plot2(DeltaH,"DH",color);
 Plot3(DeltaL,"DL",color);
 plot4(Deltac,"DC",color);
end; 
