% Do the clear
close all;
clearvars;
commandwindow;

% Seed the random number generator with time
rng('shuffle')


%----------------------------------------------------------------------
%                       Screen setup
%----------------------------------------------------------------------

[ window, windowRect, grey, vbl, ifi ] = GetScreen();

% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Keybpard setup
upkey = KbName('UpArrow');
downkey = KbName('DownArrow');
leftkey = KbName('LeftArrow');
rightkey = KbName('RightArrow');


%----------------------------------------------------------------------
%                       Color information
%----------------------------------------------------------------------

[ colorNames, colorCodes ] = GetColor();
colorNum = length(colorNames);


%----------------------------------------------------------------------
%                       Experimental indexes
%----------------------------------------------------------------------

[ nameIndexes, codeIndexes ] = GetStroop(colorNum);


%----------------------------------------------------------------------
%                        Fixation Cross
%----------------------------------------------------------------------

allCoords = GetFixationCross( windowRect );

% Set the line width for our fixation cross
lineWidthPix = 4;


%----------------------------------------------------------------------
%                      Experimental Loop
%----------------------------------------------------------------------

% Collect the timestamp of stimulusonset and key-press
% The difference will be explained as reaction time
onsets = zeros(1, length(nameIndexes));
reacts = zeros(1, length(nameIndexes));

% Start screen
DrawFormattedText(window, 'Press Space To Begin', 'center', 'center', grey*2);
Screen('Flip', window);
KbWait;

% Run the loop
for i = 1:length(nameIndexes)
    
    % Check if any key pressing
    keyDown = 1;
    while keyDown
        [keyDown, secs, keycode] = KbCheck;
    end
    
    % Draw fixation cross
    Screen('DrawLines', window, allCoords, lineWidthPix, grey*2, [xCenter yCenter], 2);
    vbl = Screen('Flip', window, vbl+0.5*(1-ifi)); 
    % 0.5*(1-ifi) means wait 0.5 second after previous frame
    % 0.5 / ifi -- frames in 0.5 second
    % ifi -- second for one frame
    % waitframes = 0.5 / ifi
    % (waitframes - 0.5) * ifi = waitframes * ifi - 0.5 * ifi
    % = 0.5 - 0.5 * ifi = 0.5 * (1 - ifi)
    
    % Draw color names
    DrawFormattedText(window, char(colorNames(nameIndexes(i))), 'center', 'center', colorCodes(codeIndexes(i), :));
    % Get the StimulusOnsetTime when flip the screen
    % Flip after 0.5 secs from cross shown
    [~, onset] = Screen('Flip', window, vbl+0.5*(1-ifi));
    onsets(i) = onset;
    
    % Within the next 5 seconds after the stimulus shown
    % Check if up, down, left or right key pressed
    while true
        if GetSecs >= onset + 5
            secs = onset + 5;
            break
        end
        [ keyDown, secs, keycode ] = KbCheck;
        if keycode(upkey) || keycode(downkey) || keycode(leftkey) || keycode(rightkey)
            break
        end
    end
    
    reacts(i) = secs;
    vbl = Screen('Flip', window);
end

reacts - onsets

sca;