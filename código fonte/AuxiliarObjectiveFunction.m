function [ currentVPL ] = AuxiliarObjectiveFunction(IMEXexe,DatSimulation, SimulationFolder, RootDirectory, TotalWellsQuantity, ProdLumpsPerWell, InjLumpsPerWell, EconomicInputs, ValveType, PercentValveOpenVector, Iterator)
    
    [simulationNumber,~] = Iterator();
    [SimulationFolder,DatSimulation] = CreateSimulationDirectoryForOptimization(SimulationFolder, DatSimulation, strcat('\Simulacao',num2str(simulationNumber)));
    LumpSetting = ValveStages(ValveType);
    for i = 1:size(PercentValveOpenVector,2)
        PercentValveOpenVector(1,i) = LumpSetting(round(PercentValveOpenVector(1,i)));
    end
    
    CreateTriggerFileForOptimization(SimulationFolder, RootDirectory, ProdLumpsPerWell, InjLumpsPerWell, ValveType, PercentValveOpenVector)
    RunSystemCommand(IMEXexe, DatSimulation, SimulationFolder);
            
    currentVPL = fuzzy_VPL(SimulationFolder, TotalWellsQuantity, ProdLumpsPerWell, InjLumpsPerWell, ValveType, EconomicInputs);
    
    currentVPL = -currentVPL(end,2);
end

