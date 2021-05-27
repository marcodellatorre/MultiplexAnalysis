clear all
close all
clc

%% Layer 3
[~,SheetNames] = xlsfinfo('Sector H by Country  - SBS_NA_1A_SE_R2.xlsx');
nSheets = length(SheetNames);
data=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    data = [data, xlsread('Sector H by Country  - SBS_NA_1A_SE_R2.xlsx',Name)];
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

DataoverGDP = datafixed./GDP(:,1)';

%% Restrizioni
[~,SheetNames] = xlsfinfo('Restrizioni.xlsx');
nSheets = length(SheetNames);
restr=[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    restr = [restr, xlsread('Restrizioni.xlsx',Name)];
end

restr = restr(:,17:24);

%% Restrizioni nel dettaglio
% Riga 1: Settembre - Dicembre 2019 -> no restrizioni

%% Riga 2: Gennaio - Marzo
% Aggiorno OLANDA: % restr(2,5) = 23/03 inizio "soft-lockdown" (data in Excel)
                   % 19/03: entry-ban extra UE
restr(2,5) = 0.75*restr(2,5) + 0.25*(4/91); % secondo peso sostituibile con 0.5
% restr(2,5) = 0.75*restr(2,5);
 
% Aggiorno SVEZIA: restr(2,8) = 19/03
restr(2,8) = 0.25*restr(2,8); % oppure 0.5

% Aggiorno GERMANIA: lockdown da 22/03; dal 17/03 peso 0.75
restr(2,3) = 0.75*5/91 + 1* 10/91;
%% Riga 3: Aprile - Giugno
% Lockdown: peso 1
lock = [47/91, 40/91, 14/91, 40/91, 0, 40/91, 13/91, 0]; % giorni di lockdown Aprile-Giugno

% Fine lockdown - restrizioni mobilità interna + confini: peso 0.75
% entry_ban = [16, 35, 62, 41, 75, 35, 63, 0]/91; 
% entry_ban = [16, 35, 62, 41, 0, 35, 63, 0]/91; % change_date
entry_ban = [16, 35, 62, 41, 40, 35, 63, 0]/91; % change NL: soft-lockdown fino al 11/05

% Peso 0.5
% border_restr = [0, 0, 0, 0, 0, 0, 0, 73/91];
% border_restr = [0, 0, 0, 0, 75/91, 0, 0, 73/91]; % change_date
% border_restr = [0, 0, 0, 0, 35, 0, 0, 73]/91; % change NL
border_restr = [0, 0, 0, 0, 35, 0, 0, 0]/91; % per pesare tutta la Svezia con correzione

% Entry-ban Extra-UE: peso 0.25
extraUE = 1 - (lock + entry_ban + border_restr);

% Alternativa 1:
% restr(3,:) = 1*lock + 0.75*entry_ban + 0.5*border_restr + 0.25*extraUE;

%% Riga 4: Luglio - Settembre

%% Corr
corr = xlsread('H rev.xlsx');
corr2 = [corr(:,1), corr(:,2)];

% Alternativa 2:
restr(3,:) = 1*lock + 0.75*entry_ban + 0.5*border_restr + corr2(:,1)'.*extraUE;

% Alternativa 3:
% restr(3,:) = 1*lock + corr2(:,1)'.*(1-lock);

%% Pesati VERSIONE TRADIZIONALE
% datapesati = zeros(4,8);
% 
% for i = 1:4
%     if (i == 1 || i == 2)
%         datapesati(i,:) = DataoverGDP.*restr(i,:);
%     end
%     if (i == 3 || i == 4)
%         datapesati(i,:) = DataoverGDP.*restr(i,:)+DataoverGDP.*(1-restr(i,:)).*corr2(:,i-2)';
%     end
% end

%% Pesati VERSIONE NUOVA
datapesati = zeros(4,8);

for i = 1:4
    if (i == 1 || i == 2 || i == 3)
        datapesati(i,:) = DataoverGDP.*restr(i,:);
    end
    if (i == 4)
        datapesati(i,:) = DataoverGDP.*restr(i,:)+DataoverGDP.*(1-restr(i,:)).*corr2(:,i-2)';
    end
end


%% similarities
sim_trasp = zeros(size(datapesati,2),size(datapesati,2),4);
for i = 1:4
    for k = 1:(size(datapesati,2))
        for j = 1:size(datapesati,2)
            sim_trasp(k,j,i) = 1 - abs(datapesati(i,k)-datapesati(i,j))/(abs(datapesati(i,k))+abs(datapesati(i,j)));
        end
    end
end
sim_trasp(isnan(sim_trasp))=1;

%% Fix
for k = 1:4
    for i = 1:8
        sim_trasp(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)
%% Latex
matlab2latextot(sim_trasp(:,:,4),'sim_imp.txt',true)