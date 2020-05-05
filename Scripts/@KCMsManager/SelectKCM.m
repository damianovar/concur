function SelectKCM(tKCMsManager, tProgram)
	%
	% Ask the user for the KCM source
	fprintf( ['How do you want to get the KCM? Choose %d to retrieve a KCM '...
		'from Google Sheets, %d to open an existing KCM or\n'...
		'%d to get it from the currently loaded program.'], ParametersManager.I_GOOGLE_SHEETS,...
		ParametersManager.I_LOCAL_FILE, ParametersManager.I_LOADED_PROGRAM);
	strKCMSource = '';
	bInvalidChoice = true;
	while ( bInvalidChoice )
		%
		% Keep asking until we get a valid option
		iSource = input('');
		if (~IsNatural(iSource))
			fprintf(ParametersManager.STR_WRONG_INPUT);
			continue;
		end
		switch ( iSource )
			case ParametersManager.I_GOOGLE_SHEETS
				strKCMSource = ParametersManager.STR_PROGRAM;
				bInvalidChoice = false;
			case ParametersManager.I_LOCAL_FILE
				strKCMSource = ParametersManager.STR_LOCAL;
				bInvalidChoice = false;
			case ParametersManager.I_LOADED_PROGRAM
				strKCMSource = ParametersManager.STR_IN_PROGRAM;
				bInvalidChoice = false;
			otherwise
				fprintf(ParametersManager.STR_WRONG_INPUT);
		end
	end
	%
	% Check the source of the KCM
	if ( strcmp(strKCMSource, ParametersManager.STR_PROGRAM) )
		fprintf('This option is being repurposed and does nothing.\n');
		strFilename = '';
		strPath = '';
	elseif ( strcmp(strKCMSource, ParametersManager.STR_LOCAL) )
		% Perhaps everything related to Excel should be moved to this
		% block?
		%
		% get the desired path
		[strFilename, strPath] = uigetfile('*.xlsx', 'KCM Select',...
			ParametersManager.PARAMS.strPathToKCMsDatabase);
	elseif ( strcmp(strKCMSource, ParametersManager.STR_IN_PROGRAM) )
		%
		% This procedure is significantly different to the others
		bKeepLoading = true;
		try
			tKCM = tProgram.GetKCMByCourseCode();
		catch tME
			if (strcmp(tME.identifier, ParametersManager.STR_NO_PROGRAM_ERROR_ID))
				disp(tME.message);
				bKeepLoading = false;
				tKCM = [];
			else
				rethrow(tME);
			end
		end
		%
		% Everything inside this while loop could be moved to a module.
		while (bKeepLoading)
			%
			% Ask the user if they want to load more courses
			strResponse = input('Keep loading courses? ', 's');
			astrAffirmatives = {'yes' 'aye' 'yea' 'yeah' 'ye' 'ofc' 'y'};
			astrNegatories = {'no' 'nope' 'nay' 'nah' 'n'};
			%
			% Yes, load another course. Merge their KCM:s only if both
			% exist.
			if (any(strcmpi(strResponse, astrAffirmatives))) 
				tMergingKCM = tProgram.GetKCMByCourseCode();
				if (isempty(tMergingKCM))
					continue;
				elseif (isempty(tKCM))
					tKCM = tMergingKCM;
				else
					%
					% Attempt to merge the matrices; it fails if they share
					% at least one course
					try 
						tKCM = tKCM.Merge(tMergingKCM);
					catch tMergeError
						if (strcmp(tMergeError.identifier, ParametersManager.STR_MERGE_ERROR_ID))
							fprintf([ParametersManager.STR_WRONG_INPUT tMergeError.message '\n']);
						else
							rethrow(tMergeError);
						end
					end
				end
			% No, stop loading courses
			elseif (any(strcmpi(strResponse, astrNegatories)))
				bKeepLoading = false;
			% Easter egg: yes or no or other?
			elseif (strcmpi(strResponse, 'other'))
				fprintf(['This was a yes or no question, but you literally '...
					'gave the answer "other". Are you a politician?\n']);
			else
				fprintf(ParametersManager.STR_WRONG_INPUT);
			end
		end
		%
		% The program loaded the KCM for us, so we can get it from there
		% If it is empty, do nothing
		if (isempty(tKCM))
			if (ParametersManager.PARAMS.bVerbose)
				fprintf('KCM not updated. No KCM was chosen.\n');
			end
		else
			tKCMsManager.tKCM = tKCM;
			tKCMsManager.tGraph = KCGraph();
			if (ParametersManager.PARAMS.bVerbose)
				fprintf('KCM updated.\n');
			end
		end
		return;
	else
		error('Unrecognized KCM source %s', strKCMSource);
	end
	%
	% if the user actually selected something then save it and re-initialize the KCM
	if( strPath ~= 0 )
		%
		% save the path
		tKCMsManager.strPathOfCurrentKCM = strcat(strPath, strFilename);
		%
		% load the new KCM
		tKCMsManager.LoadKCM(tKCMsManager.strPathOfCurrentKCM);
		%
		% convert the information into a graph
		tKCMsManager.GenerateKCGraph();
		%
		% in case, print some verbose information
		if (ParametersManager.PARAMS.bVerbose)
			fprintf('KCM updated.\n');
		end
		%
		% if we cached the KCM, remove it
		if (strcmp(strFilename, ParametersManager.STR_DEFAULT_TEMP_KCM_NAME))
			ClearCachedSheet();
		end
		%
	elseif (ParametersManager.PARAMS.bVerbose)
		%
		% The user did not select any file
		fprintf('No file selected. The currently selected KCM did not change.\n');
	end%
	%
end % function

