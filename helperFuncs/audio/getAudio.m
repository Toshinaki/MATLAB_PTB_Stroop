function [ audio, Fs ] = getAudio( id )
%GETAUDIO Get audio files of participant of given id
%   Return concatenated audio and Frequency

audiofolder = ['./data/' num2str(id) '/audio/'];
audionum = length(dir([audiofolder '*.wav']));

audio = [];
for i = 1:audionum
    filename = [audiofolder num2str(i) '.wav'];
    [a, Fs] = psychwavread(filename);
    audio = [audio a'];
end
