clear all
close all
clc

%% Layer 4
[~,SheetNames] = xlsfinfo('GDP and GVA - annual.xlsx');
nSheets = length(SheetNames);
GDP=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    GDP = [GDP, xlsread('GDP and GVA - annual.xlsx',Name)];
end

[~,SheetNames] = xlsfinfo('Sector I by Country - SBS_NA_1A_SE_R2.xlsx');
nSheets = length(SheetNames);
data=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    data = [data, xlsread('Sector I by Country - SBS_NA_1A_SE_R2.xlsx',Name)];
end

%% Fix
dataprod = data(1,:) .* data(2,:);
DataoverGDP = dataprod./GDP(:,1)';

%% Restrizioni
[~,SheetNames] = xlsfinfo('Restrizioni.xlsx');
nSheets = length(SheetNames);
restr=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    restr = [restr, xlsread('Restrizioni.xlsx',Name)];
end

restr = restr(:,25:32);

%% Corr
corr = xlsread('Sector I - STS_SETU_Q.xlsx');
corr = [corr(:,30), corr(:,34)];

%% Pesati
datapesati = zeros(4,8);

for i = 1:4
    if (i == 1 || i == 2)
        datapesati(i,:) = DataoverGDP.*restr(i,:);
    end
    if (i == 3 || i == 4)
        datapesati(i,:) = DataoverGDP.*restr(i,:)+DataoverGDP.*(1-restr(i,:)).*corr(:,i-2)';
    end
end

%% similarities
sim_rest = zeros(size(datapesati,2),size(datapesati,2),4);
for i = 1:4
    for k = 1:(size(datapesati,2))
        for j = 1:size(datapesati,2)
            sim_rest(k,j,i) = 1 - abs(datapesati(i,k)-datapesati(i,j))/(abs(datapesati(i,k))+(datapesati(i,j)));
        end
    end
end
sim_rest(isnan(sim_rest))=1;

%% Fix
for k = 1:4
    for i = 1:8
        sim_rest(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)

%% Latex
matlab2latextot(sim_rest(:,:,4),'sim_imp.txt',true)