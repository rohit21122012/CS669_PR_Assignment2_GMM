[train, test] = datasets('image_scene_datasets/Features/forest/','image_scene_datasets/Features/mountain/','image_scene_datasets/Features/opencountry/');
train = train';
test = test';
num_cluster_per_class = 32

num_classes = size(train,1);

%classes{i} contains parameters of dist of ith class
%classes{i}{1} is the cell of means of clusters,
%classes{i}{2} is the cell containing covs of clusters,
%classes{i}{3} is the cell containing the mixture coefficients

classes = cell(num_classes,1);  
                               
%%%%%%%%%%%%%%TRAINING%%%%%%%%%%%%%%%%%%%

for i = 1:num_classes %for each class 
  classes{i} = cell(num_classes,1);  
  flattenedFeatureSets = vertcat(train{i}{1:end});
  [init_means, init_covs, init_coeffs] = pr_kmeans(flattenedFeatureSets, num_cluster_per_class);
  %init_covs{1};
  [classes{i}{1}, classes{i}{2}, classes{i}{3}] = pr_gmm(flattenedFeatureSets, init_means, init_covs, init_coeffs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


confusionMatrix = zeros(num_classes, num_classes);

%%%%%%%%%%%%%%%TESTING%%%%%%%%%%%%%%%%%%%
num_test_samples = 0;
for i = 1:num_classes %for each class 
    for j=1:length(test{i}) %for each classes's test data 
        predicted_label = getClassLabel(test{i}{j}, classes, num_classes);   %test{i}{j} is one (36*23) sample
        confusionMatrix(i,predicted_label) = confusionMatrix(i,predicted_label) + 1;
        num_test_samples = num_test_samples + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%STATS%%%%%%%%%%%%%%%%
    confusionMatrix
    correct = sum(diag(confusionMatrix));
    accuracy = correct/num_test_samples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%