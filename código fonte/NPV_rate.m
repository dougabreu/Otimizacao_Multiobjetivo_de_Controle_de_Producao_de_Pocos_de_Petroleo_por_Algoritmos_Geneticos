function NPV = NPV_rate(model, outpath, filepath_results, number_of_wells)

EconomicInputs = ReadXMLFileInputs(outpath);

ShutdownTime = 1000000000;

FileToRead = fopen(fullfile(filepath_results, 'Time_template.inc'));
    
j = 1;
fline = fgetl(FileToRead);
while ischar(fline)
    pattern = '(\*DATE)\s*(\d*)\s*(\d*)\s*(\d*)';
    LineMatched = regexp(fline, pattern, 'tokens');
    if isempty(LineMatched) == 0
        DateVect(j,1) = str2double(LineMatched{:}{2}); 
        DateVect(j,2) = str2double(LineMatched{:}{3}); 
        DateVect(j,3) = str2double(LineMatched{:}{4}); 
        j = j + 1;
    end
    fline = fgetl(FileToRead);
end
fclose(FileToRead);
    
[nLines, ~] = size(DateVect);

data = read_text(fullfile(filepath_results, [model, '_data', '.txt']), 6, false, true);

for date = 1:size(DateVect, 1)
    
    for parameter_1 = 1:size(DateVect, 2)
        CompleteMatrixForWells(date, parameter_1, 1) = DateVect(date, parameter_1);
    end
    
    for parameter_2 = 1:length(data)/2
        CompleteMatrixForWells(date, parameter_2 + parameter_1, 1) = data{parameter_2}(date);
    end
    
    CompleteMatrixForWells(date, parameter_2 + 1 + parameter_1, 1) = 0;
    
    for parameter_2 = parameter_2+1:length(data)
        CompleteMatrixForWells(date, parameter_2 + parameter_1 + 1, 1) = data{parameter_2}(date);
    end
    
    CompleteMatrixForWells(date, parameter_2 + parameter_1 + 2, 1) = 0;
    
end
    
    Po = EconomicInputs(1)*6.2898;        
    Pg = EconomicInputs(2)/(10^3);         
    ROY = EconomicInputs(3);     
    tauC = EconomicInputs(4);    
    mi = EconomicInputs(5);      
    mi = ((1+mi)^(1/12))-1;
    
    number_of_wells = [0 1 0 1];
    
    nc = number_of_wells(1);                     
    ns = number_of_wells(2);                     
    mc = number_of_wells(3);                     
    ms = number_of_wells(4);                     
    
    QpoPerWell(:,:) = CompleteMatrixForWells(:,4,:);        
    QpaPerWell(:,:) = CompleteMatrixForWells(:,5,:);        
    QpgvPerWell(:,:) = CompleteMatrixForWells(:,6,:);       
    QioPerWell(:,:) = CompleteMatrixForWells(:,8,:);        
    QiaPerWell(:,:) = CompleteMatrixForWells(:,9,:);        
    QigvPerWell(:,:) = CompleteMatrixForWells(:,10,:);       
        
    QpoFieldTotalperPeriod = sum(QpoPerWell,2);
    QpaFieldTotalperPeriod = sum(QpaPerWell,2);
    QpgvFieldTotalperPeriod = sum(QpgvPerWell,2);
    QiaFieldTotalperPeriod = sum(QiaPerWell,2);
    QigvFieldTotalperPeriod = sum(QigvPerWell,2);
    
    QpoFieldAccumulatedinPeriod = sum(QpoPerWell,2);
    QpaFieldAccumulatedinPeriod = sum(QpaPerWell,2);
    QpgvFieldAccumulatedinPeriod = sum(QpgvPerWell,2);
    QiaFieldAccumulatedinPeriod = sum(QiaPerWell,2);
    QigvFieldAccumulatedinPeriod = sum(QigvPerWell,2);
    
    [StartYearProduction,StartProductionIndex] = CheckProductionTime(QpoFieldTotalperPeriod,QpaFieldTotalperPeriod,QpgvFieldTotalperPeriod,DateVect);
    
    for i = 1:nLines
        if i == 1
            TimeElapsed = 1;
            FlagNewYear = 1;
        else
            TimeElapsed = CountDays(DateVect(i,:),DateVect(i-1,:));
            FlagNewYear = CheckIfYearChanged(i,DateVect(i,:),DateVect(i-1,:));
        end
        QpoFieldAccumulatedinPeriod(i) = QpoFieldAccumulatedinPeriod(i).*TimeElapsed;
        QpaFieldAccumulatedinPeriod(i) = QpaFieldAccumulatedinPeriod(i).*TimeElapsed;
        QpgvFieldAccumulatedinPeriod(i) = QpgvFieldAccumulatedinPeriod(i).*TimeElapsed;
        QiaFieldAccumulatedinPeriod(i) = QiaFieldAccumulatedinPeriod(i).*TimeElapsed;
        QigvFieldAccumulatedinPeriod(i) = QigvFieldAccumulatedinPeriod(i).*TimeElapsed;
        FieldCO = CustoOperacional(i,ShutdownTime, QpoFieldAccumulatedinPeriod(i), QpaFieldAccumulatedinPeriod(i), QpgvFieldAccumulatedinPeriod(i), QiaFieldAccumulatedinPeriod(i), QigvFieldAccumulatedinPeriod(i), nc, ns, mc, ms,EconomicInputs);         %CO = funcao(); CUSTO OPERACIONAL
        VfieldAccumulated(i) = ReceitaGerada(QpoFieldAccumulatedinPeriod(i),QpgvFieldAccumulatedinPeriod(i),FieldCO,i,EconomicInputs);
        IfieldAccumulated(i) = CustoInvestimento(i,StartYearProduction,StartProductionIndex,ShutdownTime,nLines,DateVect,nc,ns,mc,ms,EconomicInputs);
        VPLfieldAccumulated(i) = VfieldAccumulated(i)-IfieldAccumulated(i);
        if i == 1
            CumulativeVPL(i) = VPLfieldAccumulated(i);
        else
            CumulativeVPL(i) = CumulativeVPL(i-1) + VPLfieldAccumulated(i);
        end
        for well = 1:1         
            COperWell = CustoOperacional(i,ShutdownTime,(QpoPerWell(i,well)*TimeElapsed), (QpaPerWell(i,well)*TimeElapsed), (QpgvPerWell(i,well)*TimeElapsed), (QiaPerWell(i,well)*TimeElapsed), (QigvPerWell(i,well)*TimeElapsed), nc,ns,mc,ms,EconomicInputs);
            VperWell = ReceitaGerada((QpoPerWell(i,well)*TimeElapsed),(QpgvPerWell(i,well)*TimeElapsed),COperWell,i,EconomicInputs);
            IperWell = CustoInvestimento(i,StartYearProduction,StartProductionIndex,ShutdownTime,nLines,DateVect,nc,ns,mc,ms,EconomicInputs);
            VPLperWell(i,well) = VperWell - IperWell;
        end
    end
    IfieldAccumulated = IfieldAccumulated';
    VPLfieldAccumulated = VPLfieldAccumulated';
    CumulativeVPL = CumulativeVPL';
    
    
    FixedData = [DateVect CumulativeVPL VPLfieldAccumulated IfieldAccumulated QpoFieldTotalperPeriod QpaFieldTotalperPeriod QpgvFieldTotalperPeriod QiaFieldTotalperPeriod];
    NPV = VPLfieldAccumulated;
end

function nDays = CountDays(ActualDate, PastDate)
    ActualT = datetime(ActualDate(1), ActualDate(2), ActualDate(3));
    PastT = datetime(PastDate(1), PastDate(2), PastDate(3));
    DifT = ActualT - PastT;
    DifT.Format = 'd';
    nDays = days(DifT);
end

function Flag = CheckIfYearChanged(TimeStep, ActualDate, PastDate)
    if rem(TimeStep-1,12) == 0 
        Flag = 1;
    else
        Flag = 0;
    end
end

function CO = CustoOperacional(index,ShutdownTime, Qpo, Qpa, Qpg, Qia, Qig, nc, ns, mc, ms, EconomicInputs)
    CWPc = EconomicInputs(6)*10^6;           
    Nc = nc;             
    fpc = EconomicInputs(7);            
    CWPs = EconomicInputs(8)*10^6;           
    Ns = ns;             
    fps = EconomicInputs(9);                
    CWIc = EconomicInputs(10)*10^6;           
    Mc = mc;             
    fic = EconomicInputs(11);            
    CWIs = EconomicInputs(12)*10^6;           
    Ms = ms;             
    fis = EconomicInputs(13);            
    OCOF = EconomicInputs(14)*10^6;           
 

    if (index > 12) && (index < ShutdownTime)        
        COF = (CWPc*ceil(Nc*fpc)) + (CWPs*ceil(Ns*fps)) + (CWIc*ceil(Mc*fic)) + (CWIs*ceil(Ms*fis)) + OCOF;
        COF = COF/12;       
    else
        COF = 0;
    end
    
    Qgv = Qpg - Qig;
    Co = EconomicInputs(15)*6.2898;             
    Cg = EconomicInputs(17)/(10^3);             
    Ca = EconomicInputs(19);            
    Cia = EconomicInputs(20);            
    Cto = EconomicInputs(16)*6.2898;            
    Ctg = EconomicInputs(18)/(10^3);            
    COV = (Qpo*Co) + (Qpg*Cg) + (Qpa*Ca) + (Qia*Cia) + (Qpo*Cto) + (Qgv*Ctg);
    
    CO = COF + COV;
end

function Receita = ReceitaGerada(Qpo,Qpgv,FieldCO,index,EconomicInputs)
    Po = EconomicInputs(1)*6.2898;        
    Pg = EconomicInputs(2)/(10^3);         
    ROY = EconomicInputs(3);    
    tauC = EconomicInputs(4);    
    mi = EconomicInputs(5);      
    mi = ((1+mi)^(1/12))-1;
    Receita = ( ((Qpo.*Po*(1-ROY)) + (Qpgv.*Pg*(1-ROY)-FieldCO)) .* (1-tauC) )  ./  ((1 + mi)^index);
end

function Investimento = CustoInvestimento(index, StartYearProduction,StartProductionIndex, ShutdownTime,DateTLimit,DateVect, nc, ns, mc, ms, EconomicInputs)
    tauC = EconomicInputs(4);    
    mi = EconomicInputs(5);      
    mi = ((1+mi)^(1/12))-1;
    T = DateTLimit;
    if index == 1
        IW = CustoPerfCompl(nc, ns, mc, ms,EconomicInputs);           
        OI = EconomicInputs(21)*10^6;     
    else 
        IW = 0;
        OI = 0;     
    end
    if index > ShutdownTime*12 || DateVect(index,1) < StartYearProduction       
        DEP = 0;
    else
        timeDif = DateVect(index,1) - StartYearProduction;
        DEP = (((EconomicInputs(21)*10^6))/(EconomicInputs(29)*((1+EconomicInputs(30))^(timeDif))))/12; 
    end
    if (index == ShutdownTime && index == DateTLimit) || (index == ShutdownTime && ShutdownTime < DateTLimit)
        ABD = (nc+ns+mc+ms)*EconomicInputs(22)*10^6;             
        if ShutdownTime < DateTLimit
            T = ShutdownTime;
        end
    else
        ABD = 0;
    end
    Investimento = ( ((IW * (1-tauC)) + OI - (DEP*tauC)) ./ ((1+mi)^index) ) + ( (ABD * (1-tauC)) ./ ((1+mi)^T) );
end

function Custo = CustoPerfCompl(nc, ns, mc, ms,EconomicInputs)
    n =(nc+ns);
    m = (mc+ms);
    Ipc = EconomicInputs(23)*10^6;        
    Ips = EconomicInputs(24)*10^6;        
    Iic = EconomicInputs(25)*10^6;        
    Iis = EconomicInputs(26)*10^6;        
    Dp = EconomicInputs(27)*10^6;         
    Di = EconomicInputs(28)*10^6;         
    Custo = (Ipc*nc) + (Ips*ns) + (Iic*mc) + (Iis*ms) + (Dp*n) + (Di*m);
end

function [StartYearProduction,StartProductionIndex] = CheckProductionTime(Qpo,Qpa,Qpg,DateVect)
    StartYearProduction = 0;
    for i = 1:size(Qpo,1)
        if Qpo(i) > 0 || Qpa(i) > 0 || Qpg(i) > 0
            StartProductionIndex = i;
            StartYearProduction = DateVect(i,1);
            break;
        end
    end
end