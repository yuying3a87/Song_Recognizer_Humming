function tone = featureextractor(recordname)
[S1, fs1] = audioread(recordname,'double');
if length(S1) ~= 0;
S = resample(S1,1,2);
fs1 = fs1/2;
winlen = 0.02 ; %default value 
frIsequence1 = GetMusicFeatures(S, fs1, winlen) ;
pitch = 1.5*frIsequence1(1,:) ;
intensity = log(frIsequence1(3,:)) ;
corr = frIsequence1(2,:) ;
abs = (1:length(frIsequence1)) ;
 % Search the mean of intensity 
meanI = mean(intensity);
final_note = intensity < meanI == 0 ;
final_note = intensity >= meanI == 1 ;
% get rid of the high pitch rendered by the silences
% pitch_note = pitch .* final_note ;
pitch_tone = Get_tone(frIsequence1);
pitch_tone = pitch_tone.*final_note;
tone = pitch_tone;
pitch_tone(:,find(tone==0))=[];
tone = (tone(:,:)-min(pitch_tone))./(max(pitch_tone)-min(pitch_tone));
tone(:,find(tone<0))=0;
tone = tone*100+randn(1,length(tone));
else
    tone = [];
    final_note = [];
end
end
