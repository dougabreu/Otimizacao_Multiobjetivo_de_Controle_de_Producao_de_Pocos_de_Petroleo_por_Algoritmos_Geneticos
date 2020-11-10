function RunSystemCommand(GEMpath, DATpath, outDir)
    commandLine = strcat(InsertQuotes(GEMpath), 32, '-log', 32, '-f', 32, InsertQuotes(DATpath), 32, '-wd', 32, InsertQuotes(outDir));
    system(commandLine);
end

function quotedText = InsertQuotes(text)
    quotedText = strcat('"', text, '"');
end
