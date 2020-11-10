function recovery_factor = RecoveryFactor(SimulationFolder, ValvePercentage)

    folders = dir(SimulationFolder);
    names = strings(length(folders), 1);
    for i=1:length(folders)
        names(i) = folders(i).name;
    end
    
    simulations = names(contains(names, 'Simulacao'));
        
    simulation_folder = fullfile(SimulationFolder, strcat('Simulacao', num2str(length(simulations))));
    
    recovery_file = read_text(fullfile(simulation_folder, 'ANEPI.txt'), 3, false, false);
    recovery = recovery_file{1,3};
    recovery_factor = str2double(recovery(end));