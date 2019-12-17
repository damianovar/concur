%
% This function is a joke.
% Does *not* download the solutions to the upcoming exam. Rickrolls the
% foolish instead.
function DownloadExam()
	input('Please enter the password.', 's');
	fprintf(['Wrong password! The password was ' ...
		char(randi(26, 1, 16) + 64) '\n']);
	pause(3);
	fprintf(['Just kidding! We would never upload the solutions to the exam'...
		' you were about to take.\nThis was a setup. You got rickrolled!\n']);
	web('https://youtu.be/dQw4w9WgXcQ', '-browser');
end
