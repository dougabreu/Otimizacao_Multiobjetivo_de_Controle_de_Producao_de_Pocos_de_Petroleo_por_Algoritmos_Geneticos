function [ SimulationInputs ] = ReadXMLFileInputs( FileDirectory )
    
    try
       
    EconomicScenarioFile = strcat(FileDirectory, '\Input_Variables.xml');        
        
    xmlDoc = xmlread(EconomicScenarioFile);
    findLabels = {'OilPrice','GasPrice',...         
        'Royalties','IReContribuicaoSocial','TaxaDescontoApropriada',...        
        'WorkoverCostForProducerCC','WorkoverFrequencyForProducerCC','WorkoverCostForProducerIC','WorkoverFrequencyForProducerIC','WorkoverCostForInjectorCC','WorkoverFrequencyForInjectorCC','WorkoverCostForInjectorIC','WorkoverFrequencyForInjectorIC',...
        'OtherFixedCosts',...       
        'OilTreatment','OilTransport','GasTreatment','GasTransport','ProductionWaterTreatment','InjectionWaterTreatment',...        
        'OtherInvestmentsCosts',...     
        'AbandonCost','CCProducerCost','CIProducerCost','CCInjectorCost','CIInjectorCost',...       
        'ProducerPerforationCost','InjectorPerforationCost',...     
        'DepreciationTime', 'DepreciationReductionTax',...      
        };
    DataVector = zeros(size(findLabels));
    
    allListitems = xmlDoc.getElementsByTagName('FlexwellEconomicList');
    tam = allListitems.getLength-1;
    for k = 0:tam
        thisListitem = allListitems.item(k);
       
        for i = 1:size(findLabels,2)
            thisList = thisListitem.getElementsByTagName(findLabels{i});
            thisElement = thisList.item(0);
            DataElement = thisElement.getFirstChild.getData;
            DataVector(1,i) = str2double(DataElement);
        end
    end
    catch
        error('Unable to parse XML file %s.',FileDirectory);
    end
    SimulationInputs = DataVector;
end

