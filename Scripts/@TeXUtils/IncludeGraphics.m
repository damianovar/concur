function strGraphics = IncludeGraphics(strPath, varargin)
tParamParser = inputParser;
addRequired(tParamParser, 'strPath', @(x) isstring(x) || ischar(x));
addParameter(tParamParser, 'width', '', @(x) isstring(x) || ischar(x)...
	|| isnumeric(x));
addParameter(tParamParser, 'trim', '{0cm 0cm 0cm 0cm}', @(x) (isnumeric(x)...
	&& numel(x) == 4) || isstring(x) || ischar(x));
addParameter(tParamParser, 'clip', false, @(x) isscalar(x) && (islogical(x)...
	|| isnumeric(x)));
parse(tParamParser, strPath, varargin{:});
% TODO figure out how to include options here
strGraphics = ['\includegraphics' '{' strPath '}' newline];
end