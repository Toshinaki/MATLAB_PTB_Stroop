function [ nameIndexes, codeIndexes ] = stroopGen( colorNum, trialNum, congRate )
%GETSTROOP Generate random number for color index
%   Generate random numbers with given trial num and congruent rate
%   Return 2 array, one for color name and one for color code


% Check parameter colorNum
try
    narginchk(1, Inf)
catch E
    error('Parameter "colorNum" is needed!!')
end

% Set default number of trial and congruent rate if not inputted
switch nargin
    case 1
        trialNum = 10;
        congRate = 0.9;
    case 2
        congRate = 0.9;
end

% Create zero vectors to save indexes
nameIndexes = zeros(1, trialNum);
codeIndexes = zeros(1, trialNum);


% Generating loop
for i = 1:trialNum
    % Random integer >= 1, and <= colorNum
    n = randi([1 colorNum]);
    if i > 2
        while n == codeIndexes(i-1) || n == codeIndexes(i-2)
            n = randi([1 colorNum]);
        end
    end
    codeIndexes(i) = n;
    
    % Decide if color code is congruent with color name
    if rand() > congRate
        % Congruent condition
        nameIndexes(i) = n;
    else
        % Incongruent condition
        % Generate another integer different with n above
        n2 = randi([1 colorNum]);
        try
            pre  = nameIndexes(i-1);
        catch ME
            pre = 0;
        end
        while n2 == n || n2 == pre
            n2 = randi([1 colorNum]);
        end
        nameIndexes(i) = n2;
    end
end

nicount = zeros(1, colorNum);
cicount = zeros(1, colorNum);

for i=1:colorNum
    nicount(i) = sum(nameIndexes==i);
    cicount(i) = sum(codeIndexes==i);
end

fprintf('[*] Count for color names: 1: %2d; 2: %2d; 3: %2d; 4: %2d\n', nicount);
fprintf('[*] Count for color codes: 1: %2d; 2: %2d; 3: %2d; 4: %2d\n', cicount);

end

