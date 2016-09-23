% The full course of an experiment

commandwindow;
clearvars;
rng('shuffle');

% Add current folder and all sub-folders
addpath(genpath(pwd));
id = partGen();
%--------------------------------------------------------------------------
%                       Global variables
%--------------------------------------------------------------------------
global window windowRect fontsize xCenter yCenter white grey;


%--------------------------------------------------------------------------
%                       Screen initialization
%--------------------------------------------------------------------------

% First create the screen for stimulation displaying
% Using function prepareScreen.m
% This returned vbl may not be precise; flip again to get a more precise one
% This screen size is for test
[window, windowRect, vbl, ifi] = prepareScreen([0 0 1280 1024]);
HideCursor;


%--------------------------------------------------------------------------
%                       Global settings
%--------------------------------------------------------------------------

% Screen center
[xCenter, yCenter] = RectCenter(windowRect);

% device
% The way participants take the experiment; could be "key", "mouse", "game"
% To use different device for every section;
% comment this and define individually in every section
respdevice = 'mouse';

% Get instructions for each device
%deviceInstruc = getInstruc();

%%
%______________________________________________________________
%=====================================================
%                       Section one -- stroop
%______________________________________________________________

%=====================================================
%                       Preparation of Section one

% Define some DEFAULT values
trialNum = 20; % 100 trial
congRate = 1.0; % 100% of which are incongruent
e_trialNum = 10; % exercise
e_congRate = 0.0;

interval = 1; % time length showing the word


% Get the fixation cross coords and set its line and color
fixCoords = getFixationCross();
linewidth = 4;
color = white;
% Get color names and their codes; use default value which are japanese
[colorNames, colorCodes] = GetColor(true);
colorNum = length(colorNames);
% Get the name indexes and code indexes
[nameIn, codeIn] = stroopGen(colorNum, trialNum, congRate);
[e_nameIn, e_codeIn] = stroopGen(colorNum, e_trialNum, e_congRate);

% Records the results
ontimestamp = zeros(1, trialNum); % the time stamps when stimulus are shown


% Prepare for recording
audiofolder = ['./data/' num2str(id) '/audio/'];
deviceid = 2;
freq = 48000;
channels = [1, 1];
voicetrigger = 0.5;

recordedaudio = []; % This is only for demo; comment it when experiment

% Open the audio device, with mode 2 (== Only audio capture),
% and a required latencyclass of zero 0 == no low-latency mode
% This returns a handle to the audio device:
pahandle = PsychPortAudio('Open', deviceid, 2, 0, freq, channels);
% Preallocate an internal audio recording  buffer with a capacity of 15 seconds:
PsychPortAudio('GetAudioData', pahandle, 15);

%=====================================================
%                       Execution of Section one

fprintf('\n******************************\n[*] Executing SECTION ONE...\n');

% Exercise starts here
% Draw instruction here and above
DrawFormattedText(window, 'Ready?', 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

fprintf('[*] Runing ...\n\n');
fprintf('Trial # | Color name | Real color | Response time\n');
vbl = Screen('Flip', window);

% loop
for i =1:e_trialNum

    ni = e_nameIn(i);
    ci = e_codeIn(i);
    cn = colorNames{ni};
    cc = colorCodes(ci, :);


    % Draw fixation cross
    Screen('DrawLines', window, fixCoords, linewidth, color, [xCenter yCenter], 2);
    [vbl, t1] = Screen('Flip', window, vbl+0.5*(1-ifi));

    % Draw color names
    DrawFormattedText(window, double(cn), 'center', 'center', cc);
    % Get the StimulusOnsetTime when flip the screen
    % Flip after 0.5 secs from cross shown
    [vbl, ~] = Screen('Flip', window, vbl+0.5*(1-ifi));

    % clear the screen to grey
    [vbl, t2] = Screen('Flip', window, vbl+interval*(1-ifi));

    fprintf('%8d|%7s(%2d)|%7s(%2d)|%12.4f\n', i, char(cn), ni, char(colorNames{ci}), ci, 2);
end

Screen('Flip', window);

% Experiment starts here --------------------------------------------------

% Draw instruction here and above
DrawFormattedText(window, 'Ready?', 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% get a timestamp as the start point
% It's not very import if I use t0; the first vbl below works too
t0 = GetSecs; 
    
fprintf('[*] Runing ...\n\n');
fprintf('Trial # | Color name | Real color | Response time\n');

recordStart = PsychPortAudio('Start', pahandle, 0, 0, 1); % timestamp when record started
fprintf('Audio capture started\n');

vbl = Screen('Flip', window);

% loop
for i =1:trialNum

    ni = nameIn(i);
    ci = codeIn(i);
    cn = colorNames{ni};
    cc = colorCodes(ci, :);


    % Draw fixation cross
    Screen('DrawLines', window, fixCoords, linewidth, color, [xCenter yCenter], 2);
    [vbl, t1] = Screen('Flip', window, vbl+0.5*(1-ifi));

    % Draw color names
    DrawFormattedText(window, double(cn), 'center', 'center', cc);
    % Get the StimulusOnsetTime when flip the screen
    % Flip after 0.5 secs from cross shown
    [vbl, onset] = Screen('Flip', window, vbl+0.5*(1-ifi));
    ontimestamp(i) = onset;% record the timestamp when stimulus show up

    % clear the screen to grey
    [vbl, t2] = Screen('Flip', window, vbl+interval*(1-ifi));

    % save the audio file every 5 trial
    % in case the file get too big 
    if mod(i, 5) == 0
        audiodata = PsychPortAudio('GetAudioData', pahandle);
        wavfilename = sprintf('%d.wav', i/5);
        psychwavwrite(transpose(audiodata), freq, 16, [audiofolder wavfilename]);
        recordedaudio = [recordedaudio audiodata]; % This is only for demo; comment it when experiment
    end

    fprintf('%8d|%7s(%2d)|%7s(%2d)|%12.4f\n', i, char(cn), ni, char(colorNames{ci}), ci, 2);
end

Screen('Flip', window);

% Stop capture
PsychPortAudio('Stop', pahandle);
fprintf('Audio capture stopped\n');
% Close the audio device
PsychPortAudio('Close', pahandle);

% Wait key press
KbStrokeWait;
sca;

%=====================================================
%                       Cleanup of Section one
% Show the response time here; just for demo
[audiodata, Fs] = getAudio(id);
resTime = audioTimestamp(t0, recordStart, ontimestamp, audiodata, Fs, 0.2)% Set level as 0.2 here; it may differe depends on the recording device settings
