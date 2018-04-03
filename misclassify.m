% Calculate the misclassification matrix
function mis_mat = misclassify(y,CLASS,test_data)
mis_mat = zeros(CLASS);
temp = 0;
for i = 1:CLASS
index = [];
index = y(1+temp:test_data(i)+temp);
temp = test_data(i)+temp;
for j = 1:length(index)
    mis_mat(i,index(j)) = mis_mat(i,index(j))+1;
end
end
end