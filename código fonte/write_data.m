function write_data(number_of_lumps, model, filepath_results, outpath, number_of_wells)

text = read_text(fullfile(filepath_results, [model, '.txt']), 5, false, false);

flexwell_controls = read_text(fullfile(filepath_results, 'Time_template.inc'), 1, true, false);

flexwell_controls_start = flexwell_controls{9};
flexwell_controls_end = flexwell_controls{end};

date_start = regexp(flexwell_controls_start, '(*|)DATE\s+(?<Year>\d+)\s+(?<Month>\d+)\s+(?<Day>\d+)', 'names');
date_end = regexp(flexwell_controls_end, '(*|)DATE\s+(?<Year>\d+)\s+(?<Month>\d+)\s+(?<Day>\d+)', 'names');

index_start = regexp(text{2}, [date_start.Year, '/', sprintf('%02s',date_start.Month), '/01']);
index_end = regexp(text{2}, [date_end.Year, '/', sprintf('%02s',date_end.Month), '/01']);

index_start = return_index(index_start, false);

index_end = return_index(index_end, false);

fid = fopen(fullfile(filepath_results, [model, '_data', '.txt']), 'wt');

for i = index_start{1}:index_end{1}
    results{i-index_start{1}+1, 1} = text{3}{i};
    results{i-index_start{1}+1, 2} = text{4}{i};
    results{i-index_start{1}+1, 3} = text{5}{i};
end

j = index_start{1};

for i = index_start{2}:index_end{2}
    results{j-index_start{1}+1, 4} = text{3}{i};
    results{j-index_start{1}+1, 5} = text{4}{i};
    results{j-index_start{1}+1, 6} = text{5}{i};
    j = j + 1;
end

for i = 1:length(results)
    if i ~= 1
        fwrite(fid, newline);
    end
    c = [];
    for j = 1:size(results, 2)
       c = [c, results{i, j}, '\t'];
    end
    c = sprintf(c);
    fwrite(fid, c);
end

fclose(fid);

NPV = NPV_rate(model, outpath, filepath_results, number_of_wells);

data = read_text(fullfile(filepath_results, [model, '_data', '.txt']), 6, false, true);

for i = 1:length(NPV)
    data{7}(i) = NPV(i);
end

data{7} = data{7}';

fid = fopen(fullfile(filepath_results, [model, '_data', '.txt']), 'wt');

for i = 1:length(data{1})
    if i ~= 1
        fwrite(fid, newline);
    end
    c = [];
    for j = 1:length(data)
       c = [c, num2str(data{j}(i)), '\t'];
    end
    c = sprintf(c);
    fwrite(fid, c);
end

fclose(fid);

end