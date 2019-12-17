%
% Creates the list of node names in the graph, sorted in the followng
% order:
% Prerequisite KCs -> Developed KCs -> Teaching and Learning
% Activities -> Intended Learning Outcomes -> Merged KCs
% Also assigns types to the nodes.
function SetNodesNames( tGraph, tKCM )
	tGraph.strCourseCode = tKCM.strCourseCode;
	%
	% compute the number of nodes
	tGraph.iNumberOfPrerequisiteNodes	= numel( tKCM.astrPrerequisiteKCs ); 
	tGraph.iNumberOfDevelopedNodes		= numel( tKCM.astrDevelopedKCs ); 
	tGraph.iNumberOfILONodes			= numel( tKCM.astrIntendedLearnOutcomes );
	tGraph.iNumberOfMergedNodes			= numel( tKCM.astrMergedKCs );
	tGraph.iNumberOfNodes				= numel( tKCM.astrPrerequisiteKCs )...
										+ numel( tKCM.astrDevelopedKCs )...
										+ numel( tKCM.astrIntendedLearnOutcomes )...
										+ numel( tKCM.astrMergedKCs ); 
	%
	% allocate the names of the nodes
	tGraph.astrNodesNames = [tKCM.astrPrerequisiteKCs
							tKCM.astrDevelopedKCs
							tKCM.astrIntendedLearnOutcomes
							tKCM.astrMergedKCs];
	%
	% allocate the types of the nodes
	tGraph.aiNodesTypes = zeros( tGraph.iNumberOfNodes, 1 );
	%
	% First prerequisites, then developed, after that ILO and finally merged.
	tGraph.aiNodesTypes(1:tGraph.iNumberOfPrerequisiteNodes)		= KCGraph.TYPE_PREREQUISITE;
	tGraph.aiNodesTypes(tGraph.iNumberOfPrerequisiteNodes...
							+ (1:tGraph.iNumberOfDevelopedNodes))	= KCGraph.TYPE_DEVELOPED;
	tGraph.aiNodesTypes(tGraph.iNumberOfPrerequisiteNodes + tGraph.iNumberOfDevelopedNodes...
							+  (1:tGraph.iNumberOfILONodes))		= KCGraph.TYPE_ILO;
	tGraph.aiNodesTypes((tGraph.iNumberOfPrerequisiteNodes + tGraph.iNumberOfDevelopedNodes...
							+  tGraph.iNumberOfILONodes + 1):end)	= KCGraph.TYPE_MERGED;
	%					
end % function

