function [ FixedData ] = OptimizationGA(IMEXexe, DatSimulation,SimulationFolder, RootDirectory, TotalWellsQuantity,ProdLumpsPerWell,InjLumpsPerWell,EconomicInputs,ValveType)

    NumberTimesOfChanges = GetValvesChangesTime(SimulationFolder);
    TotalNumberOfLumps = sum(ProdLumpsPerWell)+sum(InjLumpsPerWell);
    [~,NumberOfLumpPossibilities] = size(ValveStages(ValveType));
    numberOfGenerations = 5;
    sizeOfPopulation = 5;
    
    Iterator = MyTimeStampedValues(linspace(1,((numberOfGenerations+1)*(sizeOfPopulation*2))+2,((numberOfGenerations+1)*(sizeOfPopulation*2)+2)));

    ObjectiveFunction = @(ValvePercentage) AuxiliarObjectiveFunction(IMEXexe,DatSimulation,SimulationFolder,RootDirectory,TotalWellsQuantity,ProdLumpsPerWell,InjLumpsPerWell,EconomicInputs,ValveType, ValvePercentage, Iterator);
      
    FunctionRecoveryFactor = @(ValvePercentage)RecoveryFactor(SimulationFolder,ValvePercentage);
    
    multiObjetivo = @(ValvePercentage) [ObjectiveFunction(ValvePercentage), FunctionRecoveryFactor(ValvePercentage)];
    
    LB = ones(NumberTimesOfChanges*TotalNumberOfLumps,1);
    UB = NumberOfLumpPossibilities*ones(NumberTimesOfChanges*TotalNumberOfLumps,1);
    
    settings = gaoptimset('PlotFcn', @gaplotpareto, 'display', 'iter', 'generations', numberOfGenerations, 'StallGenLimit', 10000, 'PopulationSize', sizeOfPopulation);
    
    n_vars = NumberTimesOfChanges*TotalNumberOfLumps;
    
    [x,fval] = gamultiobj(multiObjetivo,n_vars,[],[],[],[],LB,UB,settings);
    
    AuxiliarObjectiveFunction(IMEXexe,DatSimulation,SimulationFolder,RootDirectory,TotalWellsQuantity,ProdLumpsPerWell,InjLumpsPerWell,EconomicInputs,ValveType, x, Iterator)
            
    disp(x);
    disp(fval);
    FixedData = [x, fval];
end