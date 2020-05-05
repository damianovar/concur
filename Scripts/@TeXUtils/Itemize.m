function strBulletList = Itemize(astrList)
if isnumeric(astrList) || islogical(astrList)
	astrList = arrayfun(@num2str, astrList, 'UniformOutput', false);
end
strBulletList = TeXUtils.BeginEnvironment('itemize');
astrBullets = cellfun(@(str) ['\item ' replace(str, '&', '\&') newline],...
	astrList, 'UniformOutput', false);
strBulletList = [strBulletList astrBullets{:}];
strBulletList = [strBulletList TeXUtils.EndEnvironment('itemize')];
end