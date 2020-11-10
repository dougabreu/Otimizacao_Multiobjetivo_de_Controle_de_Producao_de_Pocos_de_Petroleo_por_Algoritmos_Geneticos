function index = return_index(array, only_first)

j = 1;
index = [];

for i = 1:length(array)

    if ~isempty(array{i})
        index{j} = i;
        j = j + 1;
    end
    
end

if only_first
    index = index{1};
end

end