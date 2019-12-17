%
% Loads a KCM from the specified path
function Load(tKCM, strPath)
	%
	% Import the data from the spreadsheet 	
	tEverything = importdata( strPath );
	tTextual = tEverything.textdata;
	tNumeric = tEverything.data;
	%
	% Find the starting date: it should be at B23 in the course info sheet
	% End date should be at B24
	iBeginExpectedRow = 23;
	iBeginExpectedColumn = 2;
	%
	% Perhaps this format should be derived from the system instead?
	strFormat = ParametersManager.PARAMS.strDateFormat;
	%
	% Try to enter the date
	try
		tKCM.dtCourseStart = datetime(tTextual.courseSummary(iBeginExpectedRow,...
		iBeginExpectedColumn), 'InputFormat', strFormat);
	catch eNoDate
		%
		% Invalid date found; enter zero as serial date number
		if (strcmp(eNoDate.identifier, 'MATLAB:datetime:ParseErr'))
			tKCM.dtCourseStart = ParametersManager.DT_UNSPECIFIED;
			warning(['Failed to read starting date: ' eNoDate.message]);
		else
			rethrow(eNoDate);
		end
	end
	%
	% Find the course code: it should be at D24 in the course info sheet
	iExpectedRow = 24;
	iExpectedColumn = 4;
	tKCM.strCourseCode = tTextual.courseSummary{iExpectedRow, iExpectedColumn};
	%
	% Repeat for the taxonomies
	iExpectedColumn = 3;
	astrTaxonomies = regexp(tTextual.courseSummary{iExpectedRow, iExpectedColumn},...
		',\s*', 'split');
	astrTaxonomies = reshape(astrTaxonomies, numel(astrTaxonomies), 1);
	%
	% Check the taxonomies
	if (numel(astrTaxonomies) == 1 && isempty(astrTaxonomies{1}))
		tKCM.astrTaxonomies = {ParametersManager.STR_DEFAULT_TAXONOMY_TYPE};
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('No taxonomy type was specified; assuming it was "%s"\n',...
				ParametersManager.STR_DEFAULT_TAXONOMY_TYPE);
		end
	elseif (any(cellfun(@isempty, astrTaxonomies)))
		error('Taxonomy list is incorrectly formatted.');
	else
		tKCM.astrTaxonomies = astrTaxonomies;
	end
	tKCM.iTaxonomyCount = numel(astrTaxonomies);
	%
	% get the lists of courses and KCs
	tKCM.CreateListOfKCs( tTextual );
	%
	% fill the actual fields of the KCM
	if (numel(tKCM.astrTaxonomies) > 1)
		tKCM.FillTheKCM3D(tTextual);
	else
		tKCM.FillTheKCM( tNumeric );
	end
	tKCM.bHasILOs = any(tKCM.aafTaxonomyValuesILO, [1 2]);
	tKCM.bHasTLAs = any(tKCM.aafTaxonomyValuesTLA, [1 2]);
	%
	% in case, truncate the number of courses
	tKCM.TruncateTheKCMIfRequired();
	%
	% generate the tables
	if (numel(astrTaxonomies) > 1)
		tKCM.CreateInformationTables(tNumeric, tTextual);
	else
		tKCM.CreateInformationTables( tNumeric );
	end
	%
	% include the KCM path
	tKCM.strPath = strPath;
	%
	% detect if KCs depend on future teachings
	tKCM.DetectNoncausalEdges();
	%
	% report that the KCM is ready
	if (ParametersManager.PARAMS.bVerbose)
		fprintf('KCM at %s of course %s is now ready\n', tKCM.strPath, tKCM.strCourseCode);
	end
	%
end % function

