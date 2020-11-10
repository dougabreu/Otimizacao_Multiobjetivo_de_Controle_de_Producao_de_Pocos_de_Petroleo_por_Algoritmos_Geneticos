function [ NumberOfTimes ] = GetValvesChangesTime( TemplateDirectory )

    TemplateLocation = regexp(TemplateDirectory, '[^\\]*(.dat)', 'split');
    TemplateLocation = TemplateLocation{1};
    templateName = '\Time_template.inc';
    FileToRead = fileread(strcat(TemplateLocation,templateName));
    
    expr = '*OPEN';
    NumberOfTimes = regexp(FileToRead, expr,'match');
    NumberOfTimes = size(NumberOfTimes,2);

end

