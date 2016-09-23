commandwindow;

deviceid = 0;
freq = 44100;
channels = [2, 2];
maxlen = 5;

pahandle = PsychPortAudio('Open', deviceid, 2, 0, freq);
PsychPortAudio('GetAudioData', pahandle, maxlen+1);

fprintf('Press any key to start ...\n');
KbStrokeWait;

PsychPortAudio('Start', pahandle, 0, 0, 1);
fprintf('Audio capture started\n');

recordedaudio = [];
s = PsychPortAudio('GetStatus', pahandle);

WaitSecs(5);

% Stop capture:
PsychPortAudio('Stop', pahandle);

% Get data
audiodata = PsychPortAudio('GetAudioData', pahandle);

% show data
max(abs(audiodata(1, :)))

nrsamples = size(audiodata, 2);

plot(1:nrsamples, audiodata(1, :), 'b', 1:nrsamples, ones(1, nrsamples)*0.5, 'r');
drawnow;

% Close the audio device:
PsychPortAudio('Close', pahandle);
