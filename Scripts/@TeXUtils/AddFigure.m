function strFigure = AddFigure(strPath, varargin)
%
% Parse inputs; expect char vectors or strings
tInputParser = inputParser;
addRequired(tInputParser, 'path', @(x) ischar(x) || isstring(x));
addOptional(tInputParser, 'caption', 'none', @(x) ischar(x) || isstring(x));
addOptional(tInputParser, 'label', 'none', @(x) ischar(x) || isstring(x));
addParameter(tInputParser, 'FloatSpec', '', @(x) ischar(x) || isstring(x));
% TODO add support for choosing image types
addParameter(tInputParser, 'FileType', 'eps', @(x) ischar(x) || isstring(x));
tInputParser.parse(strPath, varargin{:});
tResults = tInputParser.Results;

%
% Begin figure
if strlength(tResults.FloatSpec)
	strFigure = TeXUtils.BeginEnvironment('figure', tResults.FloatSpec);
else
	strFigure = TeXUtils.BeginEnvironment('figure');
end

%
% Center, include graphics, add caption if provided, add label if provided
strFigure = [strFigure TeXUtils.STR_CENTERING];
strFigure = [strFigure TeXUtils.IncludeGraphics(tResults.path)];
if ~strcmp(tResults.caption, 'none') && ~isempty(tResults.caption)
	strFigure = [strFigure TeXUtils.AddCaption(tResults.caption)];
end
if ~strcmp(tResults.label, 'none') && ~isempty(tResults.label)
	strFigure = [strFigure TeXUtils.AddLabel(tResults.label)];
end

%
% End figure
strFigure = [strFigure TeXUtils.EndEnvironment('figure')];
end