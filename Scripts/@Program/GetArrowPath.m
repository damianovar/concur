%
% Computes a path between two nodes.
function [afXSteps, afYSteps] = GetArrowPath(tSourceNode, tTargetNode)
% Design parameters
fFirstXStep = 0.1;
fYClearanceBelow = 0.2;
fArrowheadOffset = 0.05;
%
% Check if the source is to the right of the target
if (tSourceNode.fX > tTargetNode.fX)
	% 
	% Create the backwards path
	afXStep23 = tSourceNode.fX + (tSourceNode.fX - tTargetNode.fX)*fFirstXStep;
	afXStep45 = tTargetNode.fX - (tSourceNode.fX - tTargetNode.fX)*fFirstXStep;
	afXSteps = [tSourceNode.fX + fArrowheadOffset
				repmat(afXStep23, 2, 1)
				repmat(afXStep45, 2, 1)
				tTargetNode.fX - fArrowheadOffset];
	afYStep34 = tTargetNode.fY - fYClearanceBelow;
	afYSteps = [repmat(tSourceNode.fY, 2, 1)
				repmat(afYStep34, 2, 1)
				repmat(tTargetNode.fY, 2, 1)];
elseif (tSourceNode.fX < tTargetNode.fX)
	%
	% Create the forwards path
	afXStep23 = tSourceNode.fX + 1/(1 + tTargetNode.fY - tSourceNode.fY);
	afXSteps = [tSourceNode.fX + fArrowheadOffset
				repmat(afXStep23, 2, 1)
				tTargetNode.fX - fArrowheadOffset];
	afYSteps = [repmat(tSourceNode.fY, 2, 1)
				repmat(tTargetNode.fY, 2, 1)];
else
	%
	% Create a self-link (should not happen too often)
	afXStep23 = tSourceNode.fX + 0.75*fFirstXStep;
	afXStep45 = tTargetNode.fX - 0.75*fFirstXStep;
	afXSteps = [tSourceNode.fX + fArrowheadOffset
				repmat(afXStep23, 2, 1)
				repmat(afXStep45, 2, 1)
				tTargetNode.fX - fArrowheadOffset];
	afYStep34 = tTargetNode.fY - fYClearanceBelow;
	afYSteps = [repmat(tSourceNode.fY, 2, 1)
				repmat(afYStep34, 2, 1)
				repmat(tTargetNode.fY, 2, 1)];
end
end
