function [ features ] = Get_tone( frIsequence )
A=frIsequence(1,:);
L=length(A);
% ratio = A(2:end)./A(1:end-1);
edges3 = 0:0.05:1;
rD= discretize(frIsequence(2,:),edges3);% discretizing r_t
pitch(1)=0;% the value of first semitone ratio indicate if benchmark already obtained
j=1;
for i=1:L  % search for first semitone's frequency as benchmark for noise
 
    if rD(i)==20
         pitch(1)=A(i);
    
        break
    end
end
for i=1:L   % get all the ratio between semitones
    if rD(i)==20&&j>1
             frD(i)=A(i)/pitch(j-1);
    else 
            frD(i)=A(i)/pitch(1);     
        end
             
     if i~=L&&rD(i)~=20&&rD(i+1)==20
           j=j+1;
           pitch(j)=A(i+1);
     end
end
             
       
logratio=log(frD);
edges1 = -3:log(2)/12:3;
 
frD=discretize(logratio,edges1);

features=frD;
end
