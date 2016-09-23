function [ colorNames, colorCodes ] = GetColor( useDefault, isdialog )
%GETCOLOR Return color information for stroop test


%-----------------------------------------------------------------------
%                           Default values
%-----------------------------------------------------------------------

% Default color values
defaultColors = {double('緑'); double('赤'); double('青'); double('黃')};%{double('みどり'); double('あか'); double('あお'); double('きいろ')}; % %'GREEN'; 'RED'; 'BLUE'; 'YELLO';
defaultCodes = [0 1 0; 1 0 0; 0 0 1; 1 1 0];

% Messages
prompt = {sprintf('[*] Input color names; separate with semicolon: \n(Input nothing to use default value; input "q" to quit)'), sprintf('[*] Input color codes; separate with semicolon:\n(Input "q" to quit)')};
quitStr = '[!] Failed to set colors; function quits now!';
noInputStr = '[*] No input; press ENTER to use default, or input "q" to quit';
useDefaultStr = sprintf('[*] Using default color setting\n Colors: %s\t%s\t%s\t%s\n Codes:\t %d%d%d\t%d%d%d\t%d%d%d\t%d%d%d', defaultColors{:}, defaultCodes');

%-----------------------------------------------------------------------
%                           Get inputs
%-----------------------------------------------------------------------

if ~useDefault
if isdialog
    % Show dialog to get input
    dlg_title = 'Input color information';
    num_lines = 2;
    
    while true
        inputs = inputdlg(prompt, dlg_title, num_lines);
        
        % Check which button clicked
        if ~isempty(inputs) % Ok clicked
            [colors, codes] = inputs{:};
        else                   % Cancel clicked
            disp(quitStr); return
        end
        
        % Check if input empty
        if isempty(colors)
            % If empty, use default colors
            useDefault = true;
            break
        else
            % If not empty, parse the values
            colorNames = strtrim(strsplit(char(colors), ';'))';
            colorCodes = str2num(codes);
            
            % Check if the length of colorNames and colorCodes match
            if length(colorNames) ~= length(colorCodes)
                choice = questdlg(sprintf('ERROR: the number of color names (%d) and the number of color codes (%d) does not match!!!\nDo you want to input again?\nClick "Yes" to continue, "No" to use default, or "Cancel" to quit.', [length(colorNames) length(colorCodes)]));
                if strcmp( choice, 'Yes' )    % re-input
                    continue
                elseif strcmp( choice, 'No' ) % use default
                    useDefault = true;
                    break
                else                          % quit
                    disp( quitStr );
                    return
                end
            else
                break
            end
        end
    end
            
else
    % Get input from console
    inputs = repmat({''}, 1, 2);
    
    for i = 1:length(prompt)

        % Get color information
        disp(char(prompt(i)));
        temp = input('', 's');
        
        if isempty(temp) % no input; using default
            useDefault = true;
            break
        elseif lower(temp) == 'q' % "q" inputed, quit
            disp(quitStr);
            return;
        end

        % save input
        inputs(i) = {temp};
    end
    colorNames = strtrim(strsplit(char(inputs(1)), ';'))';
    colorCodes = str2num(char(inputs(2)));
end
end

% Check if use default
if useDefault
    disp(useDefaultStr);
    colorNames = defaultColors;
    colorCodes = defaultCodes;
end
return;
end

