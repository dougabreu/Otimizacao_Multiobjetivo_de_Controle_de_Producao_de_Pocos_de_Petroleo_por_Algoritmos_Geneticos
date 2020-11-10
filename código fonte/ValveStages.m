function [LumpStages] = ValveStages( ValveType )

    switch ValveType
        case 'Pre-simulation'
            LumpStages = [0.0001 0.003 0.007 0.01 0.04 0.08 0.1 0.2 0.8 1.0];
        case 'On-Off'
            LumpStages = [0.0001 1.0];
        case 'Multistages'
            LumpStages = [0.0001 0.003 0.007 0.01 0.03 0.006 0.1 0.2 0.8 1.0];
        otherwise
            LumpStages = [0.0001 0.003 0.007 0.01 0.03 0.006 0.1 0.2 0.8 1.0];
    end
end

