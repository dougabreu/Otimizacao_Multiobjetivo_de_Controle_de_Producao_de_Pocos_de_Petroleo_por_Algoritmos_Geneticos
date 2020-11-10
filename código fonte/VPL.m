function currentVPL = VPL(outpath, NumberOfWells, NumberOfProdLumpsPerWell, NumberOfInjLumpsPerWell, ValveType, EconomicInputs)

currentVPL = EvaluateVPL_report(outpath, NumberOfWells, NumberOfProdLumpsPerWell, NumberOfInjLumpsPerWell, EconomicInputs);

inc = read_text(fullfile(outpath, 'Time_template.inc'), 1, true, false);

end