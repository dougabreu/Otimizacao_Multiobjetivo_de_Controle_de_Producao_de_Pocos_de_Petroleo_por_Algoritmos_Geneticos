clear all
close all
clc

fig = figure();
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);

graficWindow = uipanel('Parent', fig, 'Title', 'Comportamento típico de válvulas', 'FontSize', 10, 'Position', [.01 .01 .45 .45]);

GrafPlot = subplot(1,1,1,'Parent', graficWindow, 'Units', 'pixels', 'Position', [250 50 550 350]);
ValveGrafBehavior = Model_Equations();
set(ValveGrafBehavior, 'LineWidth', 2.5);

ValveBehaveChoosen = uibuttongroup('Parent',graficWindow, 'Units', 'pixels', 'Position', [10 180 100 220]);    
uicontrol('Style', 'Radio', 'Parent', ValveBehaveChoosen, 'String','On-Off','Position',[10 185 100 30], 'Tag', 'On-Off');

Simulador = uipanel('Parent', fig, 'Title', 'Localização de arquivos de entradas', 'FontSize', 10, 'Units', 'normalized', 'Position', [.001 .47 .75 .532]);

uicontrol('Parent', Simulador, 'Style', 'text', 'String', 'Caminho do simulador IMEX', 'FontSize', 8, 'Units', 'normalized', 'Position', [-.095 .965 .35 .03]);
IMEXLocal = uicontrol('Parent', Simulador, 'Style', 'text', 'Units', 'normalized', 'FontSize', 10, 'BackgroundColor', [1 1 1], 'Position', [.035 .9 .35 .06]);
uicontrol('Parent', Simulador, 'Style', 'pushbutton','Units', 'normalized', 'Position', [.003 .895 .03 .07], 'Callback', {@IMEXexecutable, IMEXLocal});

uicontrol('Parent', Simulador, 'Style', 'text', 'String', 'Caminho do arquivo de simulação', 'FontSize', 8, 'Units', 'normalized', 'Position', [-.082 .865 .35 .03]);
datLocal = uicontrol('Parent', Simulador, 'Style', 'text', 'FontSize', 10, 'BackgroundColor', [1 1 1], 'Units', 'normalized', 'Position', [.035 .8 .35 .06]);
uicontrol('Parent', Simulador, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [.003 .795 .03 .07], 'Callback', {@DATLocation, datLocal});

uicontrol('Parent', Simulador, 'Style', 'text', 'String', 'Diretório de saída', 'FontSize', 8, 'Units', 'normalized', 'Position', [-.108 .765 .35 .03]);
outDirectory = uicontrol('Parent', Simulador, 'Style', 'text', 'FontSize', 10, 'BackgroundColor', [1 1 1], 'Units', 'normalized', 'Position', [.035 .7 .35 .06]);
uicontrol('Parent', Simulador, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [.003 .695 .03 .07], 'Callback', {@OUTLocation, outDirectory});

uicontrol('Parent', Simulador, 'Style', 'text', 'String', 'Inserir o numero de lumps para cada poço', 'FontSize', 8, 'Units', 'normalized', 'Position', [-.035 .175 .25 .06]);
ProdLumpsPerWell = uitable('Parent', Simulador, 'RowName', {'Number of Lumps'}, 'ColumnName', {'Smart|Producer'}, 'Data', (3), 'ColumnEditable', logical([1]), ...
    'Units', 'normalized', 'Position', [.01 .02 .19 .18]);
InjLumpsPerWell = uitable('Parent', Simulador, 'RowName', {'Number of Lumps'}, 'ColumnName', {'Smart|Injector'}, 'Data', (3), 'ColumnEditable', logical([1]), ...
    'Units', 'normalized', 'Position', [.2 .02 .19 .18]);

uicontrol('Parent', Simulador, 'Style', 'text', 'String', 'Inserir o numero total de poços para cada tipo referente', 'FontSize', 8, 'Units', 'normalized', 'Position', [-.01 .35 .25 .1]);
WellsQuantityValue = uitable('Parent', Simulador, 'RowName', {'Number of Wells'}, 'ColumnName', {'Conventional|Producer', 'Smart|Producer', 'Conventional|Injector', 'Smart|Injector'}, ...
    'ColumnWidth', {'auto','auto','auto','auto'}, 'Data', [0 1 0 1], 'ColumnEditable', logical([1 1 1 1]), 'Units', 'normalized', 'Position', [.01 .25 .36 .17], 'CellEditCallback', {@UpdateLumpsTable,ProdLumpsPerWell,InjLumpsPerWell});

simbox3 = uicontrol('Parent', Simulador, 'Style', 'checkbox', 'String', 'Executar Otimização', 'Units', 'normalized', 'Position', [.16 .5 .1 .07], 'Callback', {@ExecuteOptimization, IMEXLocal, outDirectory, datLocal, WellsQuantityValue, ProdLumpsPerWell, InjLumpsPerWell, ValveBehaveChoosen});

function IMEXexecutable(Object, ~, txt)
    [fileName, IMEXPath, FilterIndex]  = uigetfile('*.exe', 'Selecione o executável do software IMEX');
     set(txt, 'String', strcat(IMEXPath, fileName));
end

function DATLocation(Object, ~, txt)
    [fileName, IMEXPath, FilterIndex]  = uigetfile('*.dat', 'Selecione o arquivo de simulação');
     set(txt, 'String', strcat(IMEXPath, fileName));
end

function OUTLocation(Object, ~, txt)
    foldername  = uigetdir('','Selecione a pasta para os arquivos de saída da simulação');
     set(txt, 'String', strcat(foldername, '\'));
end

function ExecuteOptimization(Object, ~, IMEXexe, outDirectory, DATfile, TotalWellsQuantity, ProdLumpsPerWell, InjLumpsPerWell, ValveBehaveChoosen)
    if Object.Value == 1
        foldername = 'OAGMultiObjetivo';
        ValveType = get(get(ValveBehaveChoosen, 'SelectedObject'),'Tag');
        try
            [SimulationFolder, DatSimulation] = CreateSimulationDirectoryForOptimization(outDirectory.String, DATfile.String, foldername);
            EconomicInputs = ReadXMLFileInputs(SimulationFolder);
            FixedData = OptimizationGA(IMEXexe.String, DatSimulation,SimulationFolder,outDirectory.String,TotalWellsQuantity.Data,ProdLumpsPerWell.Data,InjLumpsPerWell.Data,EconomicInputs,ValveType);
            
            [~, colunas] = size(FixedData);
            funcao1 = FixedData(:,colunas-1);
            funcao2 = FixedData(:,colunas);
            scatter(funcao1, funcao2, 'filled');
             
        catch ME
            disp(getReport(ME,'extended', 'hyperlinks', 'on'))
            rethrow(MException('Problema na etapa de otimizacao!'));
        end       
    end
end
