%
% A class that holds constants that are used in the COnCUR.
classdef ParametersManager < handle
	%
	% ---------------------------------------------------------------------
	% These properties are those that are allowed to be modified. Since
	% they are embedded in a static handle, we can read them with
	% convenience. Writing is a bit more involved, but we do not have to
	% pass the parameters manager as a parameter everywhere.
	%
	% Q: But WHY do we do this? 
	%
	% A: It is because we only instantiate the parameters manager once. We
	% find that we might as well have the instance as a static variable in
	% ParametersManager. Sure, it could reset occasionally.
	properties
		%
		% Verbose mode. Debugging should use breakpoints and the built-in
		% debugger!
		bVerbose logical = false;
		bUseApp logical = true;
		%
		% Scaling to use in labels etc.
		fResolutionMult double = 1;
		%
		% paths
		strPathToKCMsDatabase char = '../Databases/KCMs/';
		strPathToProgramsDatabase char = '../Databases/Programs/';
		strPathToReportOutput char = '../Results/GenedReports/';
		strDefaultProgram char = 'LTU-MachineElements-2019.txt';
% 		strDefaultProgram char = 'NTNU-MIIK.txt';
		%
		strDateFormat char = 'yyyy-MM-dd';
		strDefaultKCMFilename char = 'demo.xlsx';
		iMaxNumberOfKCsInTheKCMFile double = 20;
		%
		% Preferred layer assignment method
		strPreferredLayeringMethod char = 'auto';
		%
		% Output format of the report. One of
		strReportFormat char = 'tex';
		%
	end % properties
	%
	% constants. Edit these.
	properties (Constant = true)
		%
		% This is what we should reference from now on!
		PARAMS ParametersManager = ParametersManager();
		%
		% Created specifically for 1920 by 1200. Change width and height to
		% fit your screen.
		AI_FULLSCREEN double = [-7 33 1936 1168];
		% -----------------------------------------------------------------
		% The following parameters should not be changed
		%
		% For use in conjunction with strKCMSource.
		STR_PROGRAM char = 'program';
		STR_LOCAL char = 'local';
		STR_IN_PROGRAM char = 'course-in-program';
		%
		ACAT_REPORT_FORMAT_LIST categorical = categorical("txt", "tex");
		
		I_GOOGLE_SHEETS double = 1;
		I_LOCAL_FILE double = 2;
		I_LOADED_PROGRAM double = 3;
		%
		% The expected number in A1 of the 'developed vs prerequisite KCs'
		% sheet in the KCM.
		I_TEMPLATE_VARIANT double = 1;
		%
		% Figure indices.
		I_FIGURE_INDEX_PROGRAM double = 1337;
		I_FIGURE_INDEX_COURSE2KC double = 42;
		I_FIGURE_INDEX_CROSSCOURSE double = 123;
		I_FIGURE_INDEX_KC2COURSE double = 255;
		%
		% The KCM may not have more than this number of KCs.
		I_KC_CAP uint16 = 400;
		%
		% Largest and smallest scale allowed.
		F_MAX_SCALE double = 2;
		F_MIN_SCALE double = 0.5;
		%
		% Default datetime if the entry is missing
		DT_UNSPECIFIED datetime = datetime('1970-01-01');
		%
		% For telling the user their input doesn't work.
		
		STR_WRONG_INPUT char = ['\nWrong choice! Please check what you actually'...
			' would like to do.\n\n'];
		STR_WARN_DIM_MISMATCH char...
			= ['Either %s or %s is missing at least one dimension of its %s matrix.\n'...
			'The other matrix has the missing dimensions, so this could lead to '...
			'spurious problems in the KC flow graph.'];
		%
		% Is the default name of the temporary KCM.
		STR_DEFAULT_TEMP_KCM_NAME char = 'cache.xlsx';
		STR_DEFAULT_TAXONOMY_TYPE char = 'SOLO';
		%
		% Error identifier for merging duplicate courses.
		STR_MERGE_ERROR_ID char = 'citesuite:KCMDuplicateMerge';
		STR_KC_DUPE_ID char = 'citesuite:KCOfMoreThanOneType';
		STR_NO_PROGRAM_ERROR_ID char = 'citesuite:ProgramNotChosen';
	end % constants
	%
	%
	% ---------------------------------------------------------------------
	methods (Access = private) % non-static
		% Private constructor; this should hold the properties to modify
		function tParametersManager = ParametersManager()
			
		end
		%
	end % non-static methods
	%
	%
	% ---------------------------------------------------------------------
	methods (Static = true)
		%
		%
		Print();
		ChangeParameter();
	end % static methods
	%
	%
end % classdef
 
