Inputs: Cartella("C:\Portafoglio\Equity"), NomeFile("Strategy"),Capitale(100000);

vars: FileName(Cartella + "\" + NomeFile + ".txt"),dt(""),tm("");


dt = MM.ELDateToString_IT(d);
tm = MM.TimeToStr_IT(t);

FileAppend(FileName, dt + "," + tm + ","
	                   + NumToStr(Capitale + i_OpenEquity, 0) + ","
	                   + NumToStr(Capitale + i_OpenEquity, 0) + ","
	                   + NumToStr(Capitale + i_OpenEquity, 0) + ","
	                   + NumToStr(Capitale + i_OpenEquity, 0) + NewLine);
