%% Record and Test
clc
clear
Replay = false;
t=audiodevinfo;
num = input('Enter the class number you are humming for:');
t=input('Enter the duration of recording(s):');
if isempty(t)
    t = 10;
end
disp('Start speaking in 3 seconds!')
pause(1);
disp('Start speaking in 2 seconds!')
pause(1);
disp('Start speaking in 1 seconds!')
pause(1);
disp('Start speaking now!')

rec1 = audiorecorder(22050,16,1);
recordblocking(rec1,t);
disp('End of Recording.');
w1 = getaudiodata(rec1);
fs = rec1.SampleRate;
filename = 'test.wav';
audiowrite(filename,w1,fs); %write it into 'test.wav'
if Replay
    play(rec1);
end
%% plot and playback
% filename = '4-12.m4a';
% num = 4;
clc
[w1,fs]=audioread(filename);
plot(w1)
xlabel('Samples') 
ylabel('Frequency')
title('Frequency Plot of Audio Record')

% process the record
load HMM.mat
seq= [];
seq = featureextractor(filename);
tp(:) = logprob(hmms,seq); %test the sequence belongs to which HMM class
fprintf('You are humming for %i',num)
fprintf('\n')
[x y] = max(tp(:));
fprintf('The recognizion result is %i',y)
fprintf('\n')
if y == num
    fprintf('Correct!')
    fprintf('\n')
else
     fprintf('Try Again!')
     fprintf('\n')
end