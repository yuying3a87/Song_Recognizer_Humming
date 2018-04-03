clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory
FEATURE = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat',...
    '7.mat','8.mat'};
CLASS_NUMBER = 8;
%% Get all training data for each class
cd 'D:\KTH\presentation\training'
for j = 1:CLASS_NUMBER
D = dir(num2str(j));
index = find([D.isdir] == true);
D(index)=[];
%Feature sequence extraction
q_1 = [];
q_len = 0;
for i=1:numel(D)
tone = featureextractor(D(i).name);
if length(tone)~=0;
q_1(1+q_len:length(tone)+q_len) = tone; %q_1: combined feature sequence(tone values)
q_len = length(q_1);
lData(i) = length(tone); %lData: the index of subsequences
else
end
end
save(FEATURE{j},'q_1','lData'); 
end
%% HMM model training
% Training with Left-Right HMM model, default training iteration is 5.
hmms = HMM;
for i = 1:numel(FEATURE)
load (FEATURE{i});
index = find(lData == 0);
lData(index)=[];
nStates= 35;
obsData= q_1;
for o = 1:nStates
pD(o)=GaussD('Mean',0,'StDev',1);
end
h = MakeLeftRightHMM(nStates,pD,obsData,lData);
hmms(i) = h;
q_1 = [];
lData = [];
end
save HMM.mat hmms
%% Test records
clc
load HMM.mat
cd 'D:\KTH\presentation\test'
result = [];
lp_total = [];
test_data = zeros(1,8);
for j = 1:CLASS_NUMBER
lp = [];
testfile = dir(num2str(j));
index = find([testfile.isdir] == true);
testfile(index)=[];
lp = zeros(numel(testfile),8);
for k =1:numel(testfile)
xtest = featureextractor(testfile(k).name);
lp(k,:) = logprob(hmms,xtest); %Test the sequence belongs to which HMM class
xtest = [];
fprintf(testfile(k).name)
fprintf('\n')
[x y] = max(lp(k,:));
result = [result y];
disp(y)
end
lp_total = [lp_total; lp];
test_data(j) = numel(testfile);
end
save logprob.mat lp_total
%test_data shows how many examples from each class are being tested
mis_mat = misclassify(result,CLASS_NUMBER,test_data);
save misclassified.mat mis_mat


