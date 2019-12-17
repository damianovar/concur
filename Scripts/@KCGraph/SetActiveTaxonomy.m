%
% Sets the taxonomy we should plot.
function SetActiveTaxonomy(tGraph)
if (isscalar(tGraph.astrTaxonomies))
	fprintf('The only taxonomy type that exists is %s.\n', tGraph.astrTaxonomies{1})
	return;
end
fprintf('Which of these taxonomy types would you like to analyze?\n');
disp(tGraph.astrTaxonomies);
%
% Keep asking until we get an existing taxonomy type
bInvalidChoice = true;
while (bInvalidChoice)
	strTaxonomy = input('', 's');
	iChoice = find(strcmp(strTaxonomy, tGraph.astrTaxonomies));
	if (isempty(iChoice))
		fprintf(ParametersManager.STR_WRONG_INPUT);
	else
		tGraph.iTaxonomyToPlot = iChoice;
		bInvalidChoice = false;
	end
end
end
