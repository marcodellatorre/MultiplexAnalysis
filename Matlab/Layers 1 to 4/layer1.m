clear all
close all
clc

%% Layer 1
Data = xlsread('NAMA_10_A10.xlsx');
[~,SheetNames] = xlsfinfo('GDP and GVA - annual.xlsx');
nSheets = length(SheetNames);
GDP=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    GDP = [GDP, xlsread('GDP and GVA - annual.xlsx',Name)];
end

%% Fix
DataoverGDP = Data./GDP(:,1);

%% Restrizioni
[~,SheetNames] = xlsfinfo('Restrizioni.xlsx');
nSheets = length(SheetNames);
restr=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    restr = [restr, xlsread('Restrizioni.xlsx',Name)];
end

restr = restr(:,1:8);

%% Corr
corr = xlsread('Sector R-U - NAIDQ_10_A10.xlsx');
corr2 = [-corr(:,11)/100, -corr(:,15)/100];


%% Pesati
datapesati = zeros(4,8);

for i = 1:4
    if (i == 1 || i == 2)
        datapesati(i,:) = DataoverGDP'.*restr(i,:);
    end
    if (i == 3 || i == 4)
        datapesati(i,:) = DataoverGDP'.*restr(i,:)+DataoverGDP'.*(1-restr(i,:)).*corr2(:,i-2)';
    end
end

%% similarities
sim_arts = zeros(size(datapesati,2),size(datapesati,2),4);
for i = 1:4
    for k = 1:(size(datapesati,2))
        for j = 1:size(datapesati,2)
            sim_arts(k,j,i) = 1 - abs(datapesati(i,k)-datapesati(i,j))/(abs(datapesati(i,k))+(datapesati(i,j)));
        end
    end
end
sim_arts(isnan(sim_arts))=1;

%% Fix
for k = 1:4
    for i = 1:8
        sim_arts(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)
%% Latex
matlab2latextot(sim_arts(:,:,4),'sim_imp.txt',true)