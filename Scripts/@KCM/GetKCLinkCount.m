%
% Gets the number of KCs that are linked from this KCM to the provided
% KCM. Used to determine the width of the arrows in the graph plot.
function iKCLinks = GetKCLinkCount(tKCM, tNextKCM)
iKCLinks = numel(tKCM.GetLinkedKCs(tNextKCM));
end
