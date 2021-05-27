clear all
close all
clc

%% Layer economico: Trade
formatData='dd/mm/yyyy';
[~,SheetNames] = xlsfinfo('Imp - exp tra paesi update.xlsx');
nSheets = length(SheetNames);
Data=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    Data = [Data, xlsread('Imp - exp tra paesi update.xlsx',Name)];
end

%% medie
Data_means = zeros(size(Data,1)/3,size(Data,2)/2);

for jj = 1:4
    for kk = 1:size(Data,2)
        Data_means(jj,kk) = mean(Data(1 + (jj-1)*3:jj*3,kk));
    end
end
Data_means_export = Data_means(:,1:56);
Data_means_import = Data_means(:,57:112);

%% similarità export
sim_exp = zeros(8,8,4);
for i = 1:4
    for k = 1:7
        for j = k:7
            sim_exp(k,j+1,i) = 1 - abs(Data_means_export(i,j+(k-1)*7)-Data_means_export(i,k+j*7))/(abs(Data_means_export(i,j+(k-1)*7))+(Data_means_export(i,k+j*7)));
        end
    end
end
for i = 1:4
    sim_exp(:,:,i) = sim_exp(:,:,i) + sim_exp(:,:,i)';
    for k = 1:size(sim_exp,1)
        sim_exp(k,k,i) = 1;
    end
end

%% Test
test = zeros(8,1,4);

for k = 1:4
    for i = 1:8
        test(i,k) = sum(sim_exp(i,:,k))-1;
    end
end
%% similarità import
sim_imp = zeros(8,8,4);
for i = 1:4
    for k = 1:7
        for j = k:7
            sim_imp(k,j+1,i) = 1 - abs(Data_means_import(i,j+(k-1)*7)-Data_means_import(i,k+j*7))/(abs(Data_means_import(i,j+(k-1)*7))+(Data_means_import(i,k+j*7)));
        end
    end
end
for i = 1:4
    sim_imp(:,:,i) = sim_imp(:,:,i) + sim_imp(:,:,i)';
    for k = 1:size(sim_imp,1)
        sim_imp(k,k,i) = 1;
    end
end
%% Fix
for k = 1:4
    for i = 1:8
        sim_exp(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)
%% Latex
matlab2latextot(sim_exp(:,:,4),'sim_imp.txt',true)