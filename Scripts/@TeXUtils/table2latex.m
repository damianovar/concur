% ----------------------------------------------------------------------- %
% Function table2latex(T, filename) converts a given MATLAB(R) table into %
% a plain .tex file with LaTeX formatting.                                %
%                                                                         %
%   Input parameters:                                                     %
%       - T:        MATLAB(R) table. The table should contain only the    %
%                   following data types: numeric, boolean, char or string.
%                   Avoid including structs or cells.                     %
%       - filename: (Optional) Output path, including the name of the file.
%                   If not specified, the table will be stored in a       %
%                   './table.tex' file.                                   %  
% ----------------------------------------------------------------------- %
%   Example of use:                                                       %
%       LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};             %
%       Age = [38;43;38;40;49];                                           %
%       Smoker = logical([1;0;1;0;1]);                                    %
%       Height = [71;69;64;67;64];                                        %
%       Weight = [176;163;131;133;119];                                   %
%       T = table(Age,Smoker,Height,Weight);                              %
%       T.Properties.RowNames = LastName;                                 %
%       table2latex(T);                                                   %                                       
% ----------------------------------------------------------------------- %
%   Version: 1.1                                                          %
%   Author:  Victor Martinez Cagigal                                      %
%   Date:    09/10/2018                                                   %
%   E-mail:  vicmarcag (at) gmail (dot) com                               %
% ----------------------------------------------------------------------- %
%   This function has been modified to allow for the creation of standalone
%   tables.                                                               %
function table2latex(T, filename, standalone)
    
    % Error detection and default parameters
	if nargin < 2
        filename = 'table.tex';
		standalone = false;
        fprintf('Output path is not defined. The table will be written in %s.\n', filename); 
	elseif nargin < 3
		standalone = false;
	end
	
    if ~ischar(filename)
        error('The output file name must be a string.');
    else
        if ~strcmp(filename(end-3:end), '.tex')
            filename = [filename '.tex'];
        end
    end
    if nargin < 1, error('Not enough parameters.'); end
    if ~istable(T), error('Input must be a table.'); end
    
	
    % Parameters
    n_col = size(T,2);
    col_spec = [];
    for c = 1:n_col, col_spec = [col_spec 'l']; end
    col_names = strjoin(T.Properties.VariableNames, ' & ');
    row_names = T.Properties.RowNames;
    if ~isempty(row_names)
        col_spec = ['l' col_spec]; 
        col_names = ['& ' col_names];
    end
    
    % Writing header
    fileID = fopen(filename, 'w+');
	if standalone
		fprintf(fileID, ['\\documentclass{standalone}\n'...
			'\\usepackage{booktabs}\n'...
			'\\begin{document}\n']);
	end
	fprintf(fileID, '\\begin{tabular}{%s}\n', col_spec);
	fprintf(fileID, '\\toprule\n');
    fprintf(fileID, '%s \\\\ \n', col_names);
    fprintf(fileID, '\\midrule \n');
    
    % Writing the data
    try
        for row = 1:size(T,1)
            temp{1,n_col} = [];
            for col = 1:n_col
                value = T{row,col};
                if isstruct(value), error('Table must not contain structs.'); end
				if iscategorical(value), value = char(value); end % Fix for categoricals
                while iscell(value), value = value{1,1}; end
                if isnumeric(value) && isinf(value), value = '$\infty$'; end
                temp{1,col} = num2str(value);
				temp{1, col} = replace(temp{1, col}, '&', '\&');
            end
            if ~isempty(row_names)
                temp = [row_names{row}, temp];
				temp{1, 1} = replace(temp{1, 1}, '&', '\&');
            end
            fprintf(fileID, '%s \\\\ \n', strjoin(temp, ' & '));
            clear temp;
        end
	catch tME
        error('Unknown error. Make sure that table only contains chars, strings or numeric values.');
    end
    
    % Closing the file
    fprintf(fileID, '\\bottomrule \n');
    fprintf(fileID, '\\end{tabular}\n');
	if standalone
		fprintf(fileID, '\\end{document}');
	end
    fclose(fileID);
end