function launch_report(model, filepath_results, IMEXpath)

version_dot = regexp(IMEXpath, 'IMEX\\(?<Version>.......)\\', 'names');
version = erase(version_dot.Version, '.');

drive = regexp(IMEXpath, '(?<Name>.:)\\.+', 'names');

if isempty(regexp(IMEXpath, version)) == 0
    IMEXpath = erase(IMEXpath, ['\mx', version, '.exe']);
end

REPORTpath = fullfile(IMEXpath, '..', '..', '..', '..', 'BR', version_dot.Version, 'Win_x64', 'EXE');

write_rwd(model, filepath_results);

[~, ~] = system([drive.Name, ' & cd ', REPORTpath, '& report.exe /f "', fullfile(filepath_results, [model, '.rwd"']), ' /o "', fullfile(filepath_results, [model, '.txt"'])]);

end