
%% Stock Market Analysis with PCA (^GDAXI)

%% Get Data

% ^GDAXI

gdaxi = getMarketDataViaYahoo('^GDAXI','1-Jan-2022','31-Mar-2022','1d');

% Components of ^GDAXI

data = zeros(63,30);
components_dax = {'SHL.DE','MRK.DE','SY1.DE','FME.DE','LIN.DE', ...
    'VOW3.DE','FRE.DE','1COV.DE','BMW.DE','DTG.DE','AIR.DE', ...
    'ALV.DE','PUM.DE','BAS.DE','RWE.DE','SIE.DE','ADS.DE', ...
    'HEI.DE','IFX.DE','CON.DE','DB1.DE','MTX.DE','HNR1.DE', ...
    'BAYN.DE','DTE.DE', 'DPW.DE','DBK.DE','ZAL.DE','HFG.DE','DHER.DE'};

cnt = 1;
for comp = components_dax
    
    data_comp = getMarketDataViaYahoo(char(comp), ...
        '1-Jan-2022','31-Mar-2022','1d');
    data(:,cnt) = (data_comp.Close-data_comp.Open)./(data_comp.Open);
    cnt = cnt+1;
    
end

% De-mean the data
data = data - mean(data);

%% Visualize Data

figure();
plot(gdaxi.Date,data(:,1));
hold on
for c = 2:30
    plot(gdaxi.Date,data(:,c));
end
hold off
xlim([datetime("2022-01-03") datetime("2022-03-30")])
title('Daily Returns of the Stocks in the DAX30');

%% Apply PCA by Matlab

[PC1,L1,latent1] = pca(data);

pcc11 = PC1(:,1);
weights1 = abs(pcc11)/sum(abs(pcc11));
myrs1 = (weights1.')*(data.');

% Visualize first principal component
figure()
plot(pcc11)
title('First principal component of DAX30');

%% Apply own PCA

% Calculate eigenvalue and eigenvectors of the Covariance matrix of the data
covMatrix = cov(data);
[PC2,L2] = eig(covMatrix);

% Sort matrix of eigenvectors in desc. order in terms of component variance
[~,ind] = sort(diag(L2),'descend');
PC2 = PC2(:,ind);

% Save eigenvalues / principal components variances
latent2 = diag(L2);
latent2 = latent2(ind);

% Save Projection of original data on the princ comp vector space
L2 = data*PC2;

pcc12 = PC2(:,1);

weights2 = abs(pcc12)/sum(abs(pcc12));
myrs2 = (weights2.')*(data.');

%% Visualize ^GDAXI and Replication based on PCA

% PCA by Matlab
figure()
plot(gdaxi.Date,(gdaxi.Close-gdaxi.Open)./(gdaxi.Open))
hold on
plot(gdaxi.Date,myrs1);
hold off
xlim([datetime("2022-01-03") datetime("2022-03-30")])
legend('GDAXI','myrs','myrs2');
title('Replicating GDAXI with PCA Based Portfolio');

% PCA by Me
figure()
plot(gdaxi.Date,(gdaxi.Close-gdaxi.Open)./(gdaxi.Open))
hold on
plot(gdaxi.Date,myrs2);
hold off
xlim([datetime("2022-01-03") datetime("2022-03-30")])
legend('GDAXI','myrss');
title('Replicating GDAXI with PCA Based Portfolio');


