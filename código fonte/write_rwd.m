function write_rwd(model, filepath_results)

text = strings(6, 1);

text{1} = ['*FILES ''', fullfile(filepath_results, [model, '.irf']), ''''];
text{2} = '*SPREADSHEET';
text{3} = '*DATE ON';
text{4} = '*TABLE-FOR *GROUPS ''FIELD-PRO''';
text{5} = sprintf(['\t', '*COLUMN-FOR *PARAMETERS ''Oil Rate SC - Monthly'' ''Water Rate SC - Monthly'' ''Gas Rate SC - Monthly''']);
text{6} = '*TABLE-END';
text{7} = '*TABLE-FOR *GROUPS ''FIELD-INJ''';
text{8} = sprintf(['\t', '*COLUMN-FOR *PARAMETERS ''Oil Rate SC - Monthly'' ''Water Rate SC - Monthly'' ''Gas Rate SC - Monthly''']);
text{9} = '*TABLE-END';
text{10} = '*TABLE-FOR *SECTORS ''teste''';
text{11} = sprintf(['\t', '*COLUMN-FOR *PARAMETERS ''Oil Recovery Factor SCTR''']);
text{12} = '*TABLE-END';

write_text(text, fullfile(filepath_results, [model, '.rwd']));