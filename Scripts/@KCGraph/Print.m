%
% Prints information about the graph.
function Print( tGraph )
	%
	% summary
	fprintf('number of nodes:     %d \n', tGraph.iNumberOfNodes);
	fprintf('number of edges:     %d \n', tGraph.iNumberOfEdges);
	fprintf('is weakly connected: %d \n', tGraph.IsConnected('weak'));
	%
	% names
	for iNode = 1:numel( tGraph.astrNodesNames )
		%
		fprintf('\tnode %2d : %s\n', iNode, tGraph.astrNodesNames{iNode});
		%
	end %
	%
	% links
	for iSource = 1:tGraph.iNumberOfNodes
	for iSink	= 1:tGraph.iNumberOfNodes
		%
		if( tGraph.aafAdjacencyMatrix(iSource, iSink) ~= 0 )
			%
			fprintf('\tlink from "%s" to "%s" with weight %d\n',...
				tGraph.astrNodesNames{iSource}, tGraph.astrNodesNames{iSink},...
				tGraph.aafAdjacencyMatrix(iSource, iSink));
			%
			
		end %
		%
	end %
	end %
	disp(tGraph.tabIllegalEdges);
	%
% 	fprintf('adjacency matrix: \n');
% 	disp( tGraph.aafAdjacencyMatrix );
% 	%
% 	fprintf('edge-node incidence matrix: \n');
% 	disp( tGraph.aaiEdgeNodeIncidenceMatrix );
	%
end % function

