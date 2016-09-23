function [ resTime ] = audioTimestamp( start, recordstart, onsets, audio, Fs, level )
% AUDIOTIMESTAMP Return response times for every stimulus onset times

% the time lapse of stimulus showing up from "start"
stimulusStamp = onsets - start;

% find indexes of audio data that has higher value than "level"
valids = find(abs(audio) > level);
% split it to audio blocks
intervalmax = 50000;

% find first indexes of sound parts
sStarts = [valids(1)];
for i = 2:length(valids)
    if valids(i) - valids(i-1) > intervalmax
        sStarts = [sStarts valids(i)];
    else
        continue
    end
end

tStarts = (sStarts - 1) / Fs + recordstart-start;

resTime = tStarts - stimulusStamp;