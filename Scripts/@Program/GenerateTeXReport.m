function GenerateTeXReport(tProgram, strTargetDir)
	try
		%% Setup
		% TEMPORARY! Change when the implementation is trustworthy!
		% Also, this code should be restructured, because I repeat the same
		% lines of code and GO ROUND AND ROUND IN CIRCLES!!1one
		if ~exist(strTargetDir, 'dir')
			mkdir(strTargetDir);
		end
		strTargetDir = [strTargetDir '/' tProgram.GetName()];
		iFileID = fopen([strTargetDir '.tex'], 'w+');
		strDevedKCTable = 'developedinfo.tex';
		strKCTable = 'ccm.tex';
		strTLATable = 'tlainfo.tex';
		strCFMLinks = 'cfmlinks.tex';
		strTLALinks = 'tlalinks.tex';
		strILOLinks = 'ilolinks.tex';
		strProblems = 'problemlist.tex';
		% TODO add simple function to TeXUtils that does the same thing as
		% lines that do not ref TeXUtils
		
		%% Preamble
		fwrite(iFileID, TeXUtils.AddPreamble());
		fwrite(iFileID, ['\title{Report of KC Flow In HE Program ' TeXUtils...
			.EscapeMathChars(tProgram.GetName()) '}' newline]);
		fwrite(iFileID, ['\acrodef{KC}{Knowledge Component}' newline]); 
		%
		% First lines in the document
		fwrite(iFileID, TeXUtils.BeginEnvironment('document'));
		fwrite(iFileID, ['\maketitle' newline]);
		fwrite(iFileID, ['\tableofcontents' newline]);
		%
		%% Program summary
		fwrite(iFileID, TeXUtils.CreateSection('Program Summary'));
		
		% Courses
		fwrite(iFileID, TeXUtils.CreateSection('List of Courses', 1));
		fwrite(iFileID, TeXUtils.Itemize({tProgram.atKCMs(1:end-2).strCourseCode}));
		
		% Prerequisites
		fwrite(iFileID, TeXUtils.CreateSection('Prerequisite KCs', 1));
		fwrite(iFileID, TeXUtils.Itemize(tProgram.tProgramKCM.astrPrerequisiteKCs));
		
		% Developed
		fwrite(iFileID, TeXUtils.CreateSection('Developed KCs', 1));
		fwrite(iFileID, TeXUtils.Itemize(tProgram.tProgramKCM.astrDevelopedKCs));
		
		% Matrix with details on which KC is what in the program
		fwrite(iFileID, TeXUtils.CreateSection('KC Dependencies', 1));
		fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
			strKCTable) ' or click the push-pin.' newline]);
		fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strKCTable,...
			'.tex', '.pdf')]));
		TeXUtils.table2latex(tProgram.GetKCRelations(), [strTargetDir...
			strKCTable], true);
		
		% TLA:s (if any)
		if ~isempty(tProgram.tProgramKCM.astrTeachLearnActivities)
			fwrite(iFileID, TeXUtils.CreateSection('Teaching and Learning Activities', 1));
			fwrite(iFileID, TeXUtils.Itemize(tProgram.tProgramKCM.astrTeachLearnActivities));
		end
		
		% ILO:s (if any)
		if ~isempty(tProgram.tProgramKCM.astrIntendedLearnOutcomes)
			fwrite(iFileID, TeXUtils.CreateSection('Intended Learning Outcomes', 1));
			fwrite(iFileID, TeXUtils.Itemize(tProgram.tProgramKCM.astrIntendedLearnOutcomes));
		end
		
		%% More info on deved KCs and TLAs
		fwrite(iFileID, TeXUtils.CreateSection('Details on Certain Items'));
		
		% Developed KCs
		fwrite(iFileID, TeXUtils.CreateSection('On the Developed KCs', 1));
		fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
			strDevedKCTable) newline]);
		TeXUtils.table2latex(tProgram.tProgramKCM.tabDevelopedKCs, [strTargetDir...
			strDevedKCTable], true);
		fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strDevedKCTable,...
			'.tex', '.pdf')]));
		
		% TLAs (if any)
		if ~isempty(tProgram.tProgramKCM.astrTeachLearnActivities)
			fwrite(iFileID, TeXUtils.CreateSection('On the TLAs', 1));
			fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
				strTLATable) newline]);
			TeXUtils.table2latex(tProgram.tProgramKCM.tabTLAs, [strTargetDir...
				strTLATable], true);
			fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strTLATable,...
				'.tex', '.pdf')]));
		end
		
		%% List of links
		fwrite(iFileID, TeXUtils.CreateSection('Links Between KCs and Others'));
		fwrite(iFileID, ['Since the tables could be very tall, they have '...
			'been put in separate documents. They can be opened by '...
			'double-clicking the push-pins.' newline]);
		
		% KCs
		fwrite(iFileID, TeXUtils.CreateSection('Knowledge Flow Across KCs', 1));
		fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
			strCFMLinks) newline]);
		TeXUtils.table2latex(tProgram.tProgramKCM.ToTable(KCM.PMD), [strTargetDir...
			strCFMLinks], true);
		fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strCFMLinks,...
			'.tex', '.pdf')]));
		
		% TLAs
		if ~isempty(tProgram.tProgramKCM.astrTeachLearnActivities)
			fwrite(iFileID, TeXUtils.CreateSection('Knowledge Flow From TLAs', 1));
			fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
				strTLALinks) newline]);
			TeXUtils.table2latex(tProgram.tProgramKCM.ToTable(KCM.TLA), [strTargetDir...
				strTLALinks], true);
			fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strTLALinks,...
				'.tex', '.pdf')]));
		end
		
		% ILOs
		if ~isempty(tProgram.tProgramKCM.astrIntendedLearnOutcomes)
			fwrite(iFileID, TeXUtils.CreateSection('Knowledge Flow To ILOs', 1));
			fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
				strILOLinks) newline]);
			TeXUtils.table2latex(tProgram.tProgramKCM.ToTable(KCM.ILO), [strTargetDir...
				strILOLinks], true);
			fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strILOLinks,...
				'.tex', '.pdf')]));
		end
		
		%% List of problems
		if ~isempty(tProgram.tProgramKCM.tabIllegalEdges)
			fwrite(iFileID, TeXUtils.CreateSection('Structural Problems'));
			fwrite(iFileID, ['Please refer to the table in ' TeXUtils.Italics(...
				strProblems) newline]);
			TeXUtils.table2latex(tProgram.tProgramKCM.tabIllegalEdges, [strTargetDir...
				strProblems], true);
			fwrite(iFileID, TeXUtils.AttachFile([tProgram.GetName() replace(strProblems,...
			'.tex', '.pdf')]));
		end
		
		%% Centrality Indexes
		tGraph = tProgram.tProgramKCM.ToKCGraph();
		tGraph.PlotCentralityIndexes();
		print(tGraph.iDefaultFigureIndexWhenPlotting, [strTargetDir ...
			'_centrality'], '-depsc');
		print(tGraph.iDefaultFigureIndexWhenPlotting, [strTargetDir ...
			'_centrality'], '-dpng');
		close(tGraph.iDefaultFigureIndexWhenPlotting);
		
		
		% Figure
		fwrite(iFileID, TeXUtils.AddFigure([tProgram.GetName() '_centrality.eps'],...
			'Bar diagram of the centrality indexes.', 'fig:centrality', 'FloatSpec',...
			'htbp')); % TODO add name-value pair 'Standalone'
		
		%% Program Plot
		Plot(tProgram);
		print(ParametersManager.I_FIGURE_INDEX_PROGRAM, [strTargetDir...
			'_program'], '-depsc');
		print(ParametersManager.I_FIGURE_INDEX_PROGRAM, [strTargetDir...
			'_program'], '-dpng');
		close(ParametersManager.I_FIGURE_INDEX_PROGRAM);
		
		fwrite(iFileID, TeXUtils.AddFigure([tProgram.GetName() '_program.eps'],...
			'Overview of the KC flow across courses in the program.',...
			'fig:programview', 'FloatSpec', 'htbp'));
		
		%% KC Flow Plot
		tParams = ParametersManager.PARAMS;
		bUseApp = tParams.bUseApp;
		tParams.bUseApp = false;
		plot(tGraph, 0);
		print(tGraph.iDefaultFigureIndexWhenPlotting - 1, [strTargetDir ...
			'_kcflow'], '-depsc');
		print(tGraph.iDefaultFigureIndexWhenPlotting - 1, [strTargetDir ...
			'_kcflow'], '-dpng');
		close(tGraph.iDefaultFigureIndexWhenPlotting - 1);
		tParams.bUseApp = bUseApp;
		
		fwrite(iFileID, TeXUtils.AddFigure([tProgram.GetName() '_kcflow.eps'],...
			'The KC flow in more detail.', 'fig:kcflowview', 'FloatSpec', 'htbp'));
		
		clear('tGraph');
		
		fwrite(iFileID, TeXUtils.AddExternal('../../Manuals/Sources/interpretation.tex'));
		%% Interpretations: take these from the manual
		% TODO learn more about inputParser
		
		fwrite(iFileID, TeXUtils.EndEnvironment('document'));
		fclose(iFileID);
	catch tME
		fclose(iFileID);
		rethrow(tME);
	end
end