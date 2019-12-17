function LoadKCM(tKCMsManager, strPath)
	tKCMsManager.tKCM = KCM();
	%
	tKCMsManager.tKCM.Load(strPath);
	%
end % function

