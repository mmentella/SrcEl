[LegacyColorValue = TRUE];

input: Micronda(3),Onda(7),Mese(30),Tipo("TEST");
var: VolD(0),VM(0),VO(0),VMM(0),maxVO(-999999),minVO(999999),maxVMM(-999999),minVMM(999999),perc1(0),perc2(0);
var: Utile(0),Chiusure(0),UtilePrecedente(0),OpenE(0),NomeFile1(""),NomeFile2(""),Simbolo("");
var: NomeFileVolD(""),VolC(0),MedI(0),MaxVolD(-999999),MinVolD(999999),perc3(0);

{if currentbar=1 then begin
	
Simbolo= LeftStr(GetSymbolName, 5);
NomeFile1= Simbolo;
NomeFile2= "c:\Vol"+Tipo+"\"+NomeFile1+".txt";
NomeFileVolD = "c:\VolD"+Tipo+"\"+NomeFile1+".txt";
FileDelete(NomeFile2);
FileDelete(NomeFileVolD);
end
else
	begin}

VolD=(h-l)*bigpointvalue;
VolC=(Highest(H, Micronda)-Lowest(L,Micronda))*bigpointvalue;
MedI= average(VolC,Micronda);
VM=average(Vold,Micronda);
VO=average(VolD,Onda);
VMM=average(VolD,Mese);

if VO>maxVO then maxVO=VO;
if VO<minVO then minVO=VO;

if Medi>MaxVolD then MaxVolD=Medi;
if Medi<MinVolD then MinVolD=Medi;

if VO>maxVMM then maxVMM=VMM;
if VO<minVMM then minVMM=VMM;


perc1=(100*VO)/maxVO;
perc2=(100*VMM)/maxVMM;
perc3=(100*Medi)/MaxVolD;


{plot1(VM,"Micronda");}

plot2(VO,"Onda");
plot3(VMM,"Mese");
	//FileAppend(NomeFile2,ELDateToString(d)+"|"+numtostr(Vo,0)+"|"+numtostr(maxVO,0)+"|"+numtostr(minVO,0)+"|"+numtostr(perc1,0)+newline);
	//FileAppend(NomeFileVolD,ELDateToString(d)+"|"+numtostr(Medi,0)+"|"+numtostr(MaxVolD,0)+"|"+numtostr(MinVolD,0)+"|"+numtostr(perc3,0)+newline);	
//end;
