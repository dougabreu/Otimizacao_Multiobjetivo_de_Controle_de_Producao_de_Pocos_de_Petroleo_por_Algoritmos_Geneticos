function CreateTriggerFileForOptimization(TemplateDirectory, RootDirectory, NumberOfProdLumpsPerWell, NumberOfInjLumpsPerWell, ValveType, PercentValveOpenVector)

    NumberOfTotalLumps = sum(NumberOfProdLumpsPerWell) + sum(NumberOfInjLumpsPerWell);
    
    templateName = '\Time_template.inc';
    FileToRead = fopen(strcat(TemplateDirectory,templateName));
    
    fline = fgetl(FileToRead);
    outputtextfile = '';
    j = 1;
    expr = '*OPEN %$';
    outputpattern = '';
    while ischar(fline)
        if any(strfind(fline,expr))
            outputpattern = strcat('*CLUMPSETTING', {32}, {10});
            for i = 1:NumberOfTotalLumps
                outputpattern = strcat(outputpattern, '''CLUMP_p', num2str(i), '''', {32});
                outputpattern = strcat(outputpattern, num2str(PercentValveOpenVector(j)), {10});
                j = j + 1;
            end
        end
        newlineToWrite = replace(fline, expr, outputpattern);
        outputtextfile = strcat(outputtextfile, {10}, newlineToWrite);
        fline = fgetl(FileToRead);
    end
    fclose(FileToRead);

    file = fopen(strcat(TemplateDirectory,templateName), 'w');
    fprintf(file, '%s', string(outputtextfile));
    fclose(file);
    
end

