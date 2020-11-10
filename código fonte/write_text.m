function write_text(data, write_path)

fid = fopen(write_path, 'wt');

for i = 1:length(data)
    if i ~= 1
        fwrite(fid, newline);
    end
    fwrite(fid, string(data{i}));
end    

fclose(fid);

end