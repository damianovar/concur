classdef TeXUtils
	properties (Constant)
		STR_CENTERING char = ['\centering' newline]
		
	end
	methods (Static)
		%% Preliminaries
		function strPreamble = AddPreamble()
			strPreamble = ['\documentclass[a4paper]{article}' newline...
							'\usepackage{geometry}' newline...
							'\usepackage[utf8]{inputenc}' newline...
							'\usepackage[T1]{fontenc}' newline...
							'\usepackage{booktabs}' newline...
							'\usepackage{graphicx}' newline...
							'\usepackage{acronym}' newline...
							'\usepackage{attachfile}' newline];
		end
		function strStripped = EscapeMathChars(strUnsafe)
			strStripped = regexprep(strUnsafe, '_|\^|\$', '\\$&');
		end
		
		%% External files
		function strInput = AddExternal(strPath)
			strInput = ['\input{' strPath '}' newline];
		end
		
		%% Layout commands
		strSection = CreateSection(strSectionName, iLevel);
		
		%% Environment-related commands
		% It was so simple, so it is allowed to be here.
		function strBegin = BeginEnvironment(strEnv, strFloatSpec)
			strBegin = ['\begin{' strEnv '}'];
			if nargin > 1
				strBegin = [strBegin '[' strFloatSpec ']'];
			end
			strBegin = [strBegin newline];
		end
		
		% It was so simple, so it is allowed to be here.
		function strEnd = EndEnvironment(strEnv)
			strEnd = ['\end{' strEnv '}' newline];
		end
		
		%% Floats: tables, figures etc.
		strFigure = AddFigure(strPath, varargin);
		
		%% Attaching files
		function strAttachFile = AttachFile(strPath)
			strAttachFile = ['\attachfile{' strPath '}' newline];
		end
		
		%% Cross-referencing
		% It was so simple, so it is allowed to be here.
		function strCaption = AddCaption(strCaptionText)
			strCaption = ['\caption{' strCaptionText '}' newline];
		end
		
		% It was so simple, so it is allowed to be here.
		function strLabel = AddLabel(strLabelText)
			strLabel = ['\label{' strLabelText '}' newline];
		end
		
		%% Font styles
		function strBf = Bold(strStrong)
			strBf = ['\textbf{' strStrong '}'];
		end
		
		function strIt = Italics(strEmph)
			strIt = ['\textit{' strEmph '}'];
		end
		
		%% Graphics commands
		strGraphics = IncludeGraphics(strPath, varargin);
		
		% Might produce too tall tables, so putting all things tables in
		% separate standalone documents is recommended.
		table2latex(T, filename, standalone);
		strUnorderedList = Itemize(astrList);
	end
end