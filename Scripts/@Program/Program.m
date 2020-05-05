%
% Defines a university program.
classdef Program < handle
	%
	% ---------------------------------------------------------------------
	properties
		% Holds all loaded KCM:s
		atKCMs KCM;
		% A KCM that represents the entire program
		tProgramKCM KCM;
		% For use in plotting
		aiCoursesInFocus uint32;
		% The path to the program text file
		strPath char;
		% A table that holds the data contained in the program text file
		tabAllVersions table;
		% WHY CAN'T YOU BE EMPTY!? $%@& THIS RESTRICTION!
		% Sorry about that, I just had to vent my frustration over the fact
		% that there is no such thing as an array of digraphs. Not even an
		% empty array of them is allowed!
		tAsAGraph digraph = digraph;
	end % properties
	%
	% ---------------------------------------------------------------------
	% non-static methods
	methods
		%
		% Constructor.
		function tProgram = Program(~)
			tProgram.strPath = '';
			tProgram.atKCMs = KCM();
		end
		%
		%
		hPlot = Plot(tProgram, varargin);
		tabFutureDependencies = DetectFutureDependencies(tProgram);
		[tPreKCM, tDevKCM] = CreateFakeKCMs(tProgram);
	end
	%
	% ---------------------------------------------------------------------
	% static methods
	methods (Static = true)
		[strFilename, strPath] = DownloadKCMWithWget(strSheetID);
		[afXSteps, afYSteps] = GetArrowPath(tSourceNode, tTargetNode);
		hPlot = PlotCourseToKCRelations(atKCMs);
	end
end
