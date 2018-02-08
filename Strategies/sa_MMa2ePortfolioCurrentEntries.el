vars: filename("C:\MM.portfolioCurrentEntries.txt");

FileAppend(filename,MM.ELDateToString_IT(d) + " " + NumToStr(Portfolio_CurrentEntries,0)+NewLine);
