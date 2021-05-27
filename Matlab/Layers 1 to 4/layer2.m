clear all
close all
clc

%% Layer 2
[~,SheetNames] = xlsfinfo('Sector G, employees - SBS_NA_DT_R2.xlsx');
nSheets = length(SheetNames);
data=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    data = [data, xlsread('Sector G, employees - SBS_NA_DT_R2.xlsx',Name)];
end
[~,SheetNames] = xlsfinfo('GDP and GVA - annual.xlsx');
nSheets = length(SheetNames);
GDP=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    GDP = [GDP, xlsread('GDP and GVA - annual.xlsx',Name)];
end
%% Fix
dataprod = data(1:2:size(data,1)-1,:).*data(2:2:size(data,1),:);
datafixed = dataprod(1,:)-sum(dataprod(2:size(dataprod,1),:),1);
datafixed = datafixed./100;
DataoverGDP = datafixed./GDP(:,1)';

%% Restrizioni
[~,SheetNames] = xlsfinfo('Restrizioni.xlsx');
nSheets = length(SheetNames);
restr=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    restr = [restr, xlsread('Restrizioni.xlsx',Name)];
end

restr = restr(:,9:16);

%% Corr
corr = xlsread('G rev.xlsx');
corr2 = [corr(:,7), corr(:,8)];


%% Pesati
datapesati = zeros(4,8);

for i = 1:4
    if (i == 1 || i == 2)
        datapesati(i,:) = DataoverGDP.*restr(i,:);
    end
    if (i == 3 || i == 4)
        datapesati(i,:) = DataoverGDP.*restr(i,:)+DataoverGDP.*(1-restr(i,:)).*corr2(:,i-2)';
    end
end

%% similarities
sim_comm = zeros(size(datapesati,2),size(datapesati,2),4);
for i = 1:4
    for k = 1:(size(datapesati,2))
        for j = 1:size(datapesati,2)
            sim_comm(k,j,i) = 1 - abs(datapesati(i,k)-datapesati(i,j))/(abs(datapesati(i,k))+abs(datapesati(i,j)));
        end
    end
end
sim_comm(isnan(sim_comm))=1;

%% Fix
for k = 1:4
    for i = 1:8
        sim_comm(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)
%% Latex
matlab2latextot(sim_comm(:,:,4),'sim_imp.txt',true)