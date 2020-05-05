function strSection = CreateSection(strSectionName, iLevel)
if nargin < 1
	fprintf('No section name was provided.');
	strSectionName = 'Lorem Ipsum';
	iLevel = 0;
elseif nargin < 2
	iLevel = 0;
elseif ~ismember(iLevel, 0:2)
	error('Unexpected section level %d.', iLevel);
end
strSection = ['\' repmat('sub', 1, iLevel) 'section{' strSectionName '}'...
	newline];
end