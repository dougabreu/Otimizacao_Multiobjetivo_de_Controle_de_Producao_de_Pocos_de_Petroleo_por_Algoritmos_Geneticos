function [ TimeStamp ] = GetTimeStamp( TemplateDirectory )

    TemplateLocation = regexp(TemplateDirectory, '[^\\]*(.dat)', 'split');
    TemplateLocation = TemplateLocation{1};
    templateName = '\Time_template.inc';
    FileToRead = fileread(strcat(TemplateLocation,templateName));
    
    expr = '*DATE';
    TimeStamp = regexp(FileToRead, expr,'match');
    TimeStamp = size(TimeStamp,2);
end

