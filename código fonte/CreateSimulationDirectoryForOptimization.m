function [outDir, DatSimulation] = CreateSimulationDirectoryForOptimization(directory, datfile, foldername)
    [allFilesLocal,~,~] = fileparts(datfile);
    EconomicScenarioFile = strcat(allFilesLocal, '\Input_Variables.xml');
    TimeTemplateFile = strcat(allFilesLocal,'\Time_template.inc');
    LastFolder = foldername;
    outDir = strcat(directory, LastFolder);
    mkdir(outDir);
    copyfile(datfile, outDir, 'f');
    copyfile(EconomicScenarioFile,outDir,'f');
    copyfile(TimeTemplateFile, outDir, 'f');
    datname = char(regexp(datfile, '[^\\]*(.dat)', 'match'));
    DatSimulation = strcat(outDir, '\', datname);
end

