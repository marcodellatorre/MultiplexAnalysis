clear all
close all
clc

%% Layer finanziario: DTW
formatData='dd/mm/yyyy';
[~,SheetNames] = xlsfinfo('Layer finanziario - dati.xlsx');
nSheets = length(SheetNames);
Data=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    Data = [Data, xlsread('Layer finanziario - dati.xlsx',Name)];
end
spotrate = xlsread('FX spot rate EUR-SEK.xlsx');

%% Cambio
Data(:,8) = Data(:,8)./spotrate(:,2);

%% Correlation
correlations = zeros(size(Data,2),size(Data,2),4);
for k = 1:(size(Data,2))
    for j = 1:size(Data,2)
        R = corrcoef(Data(1:66,k)',Data(1:66,j)');
        correlations(k,j,1) = 2 - sqrt(2*(1-R(1,2)));
        R = corrcoef(Data(67:131,k)',Data(67:131,j)');
        correlations(k,j,2) = 2 - sqrt(2*(1-R(1,2)));
        R = corrcoef(Data(132:196,k)',Data(132:196,j)');
        correlations(k,j,3) = 2 - sqrt(2*(1-R(1,2)));
        R = corrcoef(Data(197:262,k)',Data(197:262,j)');
        correlations(k,j,4) = 2 - sqrt(2*(1-R(1,2)));
    end
end

%% Rescaling
correlations_fixed = correlations./2

%% Test
test = zeros(8,1,4);

for k = 1:4
    for i = 1:8
        test(i,k) = sum(correlations_fixed(i,:,k))-1;
    end
end

%% Fix
for k = 1:4
    for i = 1:8
        correlations_fixed(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)

%% Latex
matlab2latextot(correlations_fixed(:,:,1),'sim_imp.txt',true)