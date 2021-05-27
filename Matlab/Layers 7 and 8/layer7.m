clear all
close all
clc

%% Layer economico: Trade
formatData='dd/mm/yyyy';
[~,SheetNames] = xlsfinfo('Import - export dati ASSOLUTI.xlsx');
nSheets = length(SheetNames);
Data=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    Data = [Data, xlsread('Import - export dati ASSOLUTI.xlsx',Name)];
end

%% medie
Data_means = zeros(size(Data,1)/3,size(Data,2)/2);

for jj = 1:4
    for kk = 1:size(Data,2)/2
        Data_means(jj,kk) = mean(Data(1 + (jj-1)*3:jj*3,1 + (kk-1)*2));
    end
end
Data_means_export = Data_means(:,1:8);
Data_means_import = Data_means(:,9:16);

%% similarità export
sim_exp = zeros(size(Data_means_export,2),size(Data_means_export,2),4);
for i = 1:4
    for k = 1:(size(Data_means_export,2))
        for j = 1:size(Data_means_export,2)
            sim_exp(k,j,i) = 1 - abs(Data_means_export(i,k)-Data_means_export(i,j))/(abs(Data_means_export(i,k))+(Data_means_export(i,j)));
        end
    end
end

%% similarità import
sim_imp = zeros(size(Data_means_import,2),size(Data_means_import,2),4);
for i = 1:4
    for k = 1:(size(Data_means_import,2))
        for j = 1:size(Data_means_import,2)
            sim_imp(k,j,i) = 1 - abs(Data_means_import(i,k)-Data_means_import(i,j))/(abs(Data_means_import(i,k))+(Data_means_import(i,j)));
        end
    end
end

%% Fix
for k = 1:4
    for i = 1:8
        sim_exp(i,i,k) = 0;
        sim_imp(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)
%% Latex
matlab2latextot(sim_exp(:,:,1),'sim_imp.txt',true)