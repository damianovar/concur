classdef KCMsManager < handle
	%
	% ---------------------------------------------------------------------
	properties
		%
		strPathOfCurrentKCM char;
		%
		% container for the KCM object
		tKCM KCM;
		%
		% this is the graph corresponding to the KCM
		tGraph KCGraph;
	end % properties
	%
	%
	% ---------------------------------------------------------------------
	methods % non-static
		%
		% standard constructor
		function tKCMsManager = KCMsManager()
			%
			% load the default parameters
			tKCMsManager.strPathOfCurrentKCM	...
				= strcat(	ParametersManager.PARAMS.strPathToKCMsDatabase,	...
							ParametersManager.PARAMS.strDefaultKCMFilename	);
			%
			% load the default KCM
			tKCMsManager.LoadKCM(tKCMsManager.strPathOfCurrentKCM);
			tKCMsManager.GenerateKCGraph();
			%
		end % standard constructor
		%
	end % non-static methods
	%
	%
	% ---------------------------------------------------------------------
	methods (Static = true)
		%
		%
		DownloadExam();
	end % static methods
	%
	%
end % classdef
 
