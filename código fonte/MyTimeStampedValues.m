function iterator = MyTimeStampedValues(values)

    index = 1;

    function [value, done] = next()
        if index <= length(values)
            value = values(index);
            done = (index == length(values));
            index = index + 1;
        else
            error('Values exhausted');
        end
    end

    iterator = @next;
end


