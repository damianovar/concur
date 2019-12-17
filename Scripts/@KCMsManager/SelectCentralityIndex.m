function SelectCentralityIndex(tKCMsManager)
	%
	% Keep asking until we get a valid choice
	bIsChoiceValid = false;
	%
	while( ~bIsChoiceValid )
		%
		strChoice = input('Which centrality index would you like to change to?', 's');
		%
		if (ismember(strChoice, tKCMsManager.tGraph.astrCentralityIndexesTypes))
			%
			bIsChoiceValid = true;
			%
		elseif (isempty(strChoice))
			% 
			% No choice or zero counts as reconsidering; go back
			return;
		else%
			%
			fprintf(ParametersManager.STR_WRONG_INPUT);
			fprintf('Leave the input blank to go back without changing index.\n');
			%
		end;%
		%
	end;% while
	%
	[~, tKCMsManager.tGraph.iCentralityIndexUserChoice] = ismember(strChoice,...
		tKCMsManager.tGraph.astrCentralityIndexesTypes);
	%
end % function

