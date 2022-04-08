
%% Comparison between build-in PCA by Matlab and Own PCA

M = 7; % Number of observations
N = 5; % Number of variables observed
X = rand(M,N);

%% Apply PCA by Matlab

[PC1,L1,latent1] = pca(X);

%% Apply own PCA

X = X-mean(X);

% Calculate eigenvalue and eigenvectors of the Covariance matrix of the data
covMatrix = cov(X);
[PC2,L2] = eig(covMatrix);

% Sort matrix of eigenvectors in desc. order in terms of component variance
[~,ind] = sort(diag(L2),'descend');
PC2 = PC2(:,ind);

% Save eigenvalues / principal components variances
latent2 = diag(L2);
latent2 = latent2(ind);

% Save Projection of original data on the princ comp vector space
L2 = X*PC2;

% PC1 == PC2 (aside of sign)
% latent 1 == latent2
% L1 == L2
