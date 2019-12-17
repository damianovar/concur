classdef KCM < handle
	%
	% ---------------------------------------------------------------------
	properties
		%
		% Lists of KCs and activities
		astrPrerequisiteKCs cell;
		astrDevelopedKCs cell; % May also hold merged KCs.
		astrMergedKCs cell; % Only used for merged KCM:s. Could be removed.
		astrTeachLearnActivities cell;
		astrIntendedLearnOutcomes cell;
		astrTaxonomies cell;
		iTaxonomyCount double;
		%
		% Matrices of taxonomy values
		aafTaxonomyValues double; % TODO Refactor: rename to a3fTaxonomyValuesP2D
		aafTaxonomyValuesTLA double; % How TLA:s relate to KCs and procedures
		aafTaxonomyValuesILO double; % How ILO:s relate to developed KCs
		%
		% Flags to see if matrices are filled
		bHasTLAs logical;
		bHasILOs logical;
		%
		% Tables of information
		tabDevelopedKCs table;
		tabTLAs table;
		tabIllegalEdges table;
		%
		% The date and time when the course begins
		dtCourseStart datetime;
		%
		strPath char;
		% 
		strCourseCode;
		catMode; % Either 'Steffi' or 'Damiano'.
		%
		%
	end % properties
	%
	%
	% ---------------------------------------------------------------------
	properties (Constant = true)
		ASTR_HEADERS_DEV cell = {'targetTaxonomy', 'timeSpent', 'firstLesson'};
		ASTR_HEADERS_TLA cell = {'timeSpent', 'firstLesson', 'lastLesson'};
		ASTR_HEADERS_ILLEGAL cell = {'source', 'target', 'type', 'weight', 'reason'};
		% Illegal characters? Either get r2017a+ or change to cellstr.
		CAT_REASON_NONCAUSAL categorical = categorical("depends on future");
		CAT_REASON_LOW_TAXONOMY categorical = categorical("inadequate taxonomy level");
		CAT_REASON_TLA_TOO_LOW categorical = categorical("insufficient teaching");
		CAT_REASON_CYCLIC categorical = categorical("circular dependence");
		%
		% Used for merging KCM:s.
		PMD double = 1;
		TLA double = 2;
		ILO double = 3;
	end
	methods % non-static
		%
		% standard constructor
		function tKCM = KCM(strPath)
			% Check for missing parameters
			if nargin == 0
				tKCM.strPath = 'fake-path';
			else
				tKCM.strPath				= strPath;
			end
			%
			% load the default parameters
			tKCM.strCourseCode				= '';
			tKCM.aafTaxonomyValues			= [];
			tKCM.astrDevelopedKCs		= [];
			tKCM.astrPrerequisiteKCs	= [];
			%
			if( ParametersManager.PARAMS.bVerbose )
				%
				fprintf('KCM succesfully constructed\n');
				%
			end %
			%
		end % standard constructor
		tMergedKCM = Merge(tKCM, tMergingKCM);
		tGraph = ToKCGraph(tKCM);
	end % non-static methods
	%
	%
	% ---------------------------------------------------------------------
	methods (Static = true)
		%
		%
		aafTaxonomies = FillSubKCM(tNumeric, iDeveloped, iDependencies);
		a3fTaxonomies = FillSubKCM3D(tTextual, iDeveloped, iDependencies, iDims);
		tMergedData = MergeTaxonomies(tThisData, tOtherData);
		acatReasons = GetProblemTypes();
	end % static methods
	%
	%
end % classdef

