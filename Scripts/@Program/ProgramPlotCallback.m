%
% Called when we click the program plot.
function ProgramPlotCallback(tProgram, ~, hEvent)
%
% Check for double-clicks. This is taken from the Matlab Answers site.
persistent doubleclick;
if (isempty(doubleclick))
	doubleclick = 1;
	fDelayMillis = 300;
	pause(fDelayMillis/1000);
	if (doubleclick == 1)
		bDidWeCClick = false;
		doubleclick = [];
	else
		return;
	end
else
	bDidWeCClick = true;
	doubleclick = [];
end
if (ParametersManager.PARAMS.bVerbose)
	fprintf('Program Plot callback: ');
end
%
% Handle clicks on the courses: we should plot the clicked scatter marker
if (isa(hEvent.Source, 'matlab.graphics.chart.primitive.Scatter'))
	if (ParametersManager.PARAMS.bVerbose)
		fprintf('course hit, ');
	end
	tChosenKCM = tProgram.atKCMs(hEvent.Source.YData == hEvent.IntersectionPoint(2));
	switch (hEvent.Button)
		case 1
			%
			% Double-left-click: plot the KCs of the course
			if (bDidWeCClick)
				if (ParametersManager.PARAMS.bVerbose)
					fprintf('plotting %s\n', tChosenKCM.strCourseCode);
				end
				plot(tChosenKCM.ToKCGraph(), 0, tProgram);
			else
				%
				% Left-click: toggle focus on a course
				afClicked = hEvent.IntersectionPoint;
				afYData = hEvent.Source.YData;
				iCourseIndex = find(afYData == afClicked(2));
				% Because setxor saves at least four lines of code.
				tProgram.aiCoursesInFocus = setxor(tProgram.aiCoursesInFocus, iCourseIndex);
				if (ParametersManager.PARAMS.bVerbose)
					fprintf('focus toggled\n');
				end
				%
				% Update the plot (can this be done without plotting
				% again?)
				tProgram.Plot();
			end
		case 3
			%
			% Right-click: plot the course's relationship to the KCs
			if (ParametersManager.PARAMS.bVerbose)
				fprintf('showing KC relations\n');
			end
			Program.PlotCourseToKCRelations(tChosenKCM);
		otherwise
			if (ParametersManager.PARAMS.bVerbose)
				disp('No callback for you.');
			end
	end
	
%
% Handle clicks on any edge: we should plot the connections from one course
% to another
elseif (isa(hEvent.Source, 'matlab.graphics.chart.primitive.Line'))
	if (ParametersManager.PARAMS.bVerbose)
		fprintf('connection hit, plotting it\n');
	end
	tSourceKCM = tProgram.GetKCMByCourseCode(hEvent.Source.UserData.strSource);
	tTargetKCM = tProgram.GetKCMByCourseCode(hEvent.Source.UserData.strTarget);
	tSourceKCM.GetLinkedKCs(tTargetKCM, 'plot');
end
end
