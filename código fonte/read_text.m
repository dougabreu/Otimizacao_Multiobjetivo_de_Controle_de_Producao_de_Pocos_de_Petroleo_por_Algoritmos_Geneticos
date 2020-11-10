function output = read_text(input, number_of_columns, first, float)

columns = '';

for i = 1:number_of_columns 
    
    if float
        columns = [columns, '%f'];
    else
        columns = [columns, '%s'];
    end
    
end

fid = fopen(input, 'r');

if number_of_columns == 1
    output = textscan(fid, columns, 'delimiter', '\n');
else
    output = textscan(fid, columns);
end

fclose(fid);

if first
    output = output{1};
end

end