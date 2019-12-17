%
% Helper function for getting the currently plotted taxonomy.
function strTaxonomy = GetActiveTaxonomy(tGraph)
strTaxonomy = tGraph.astrTaxonomies{tGraph.iTaxonomyToPlot};
end
