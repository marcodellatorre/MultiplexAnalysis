clear all
close all
clc

%% Layer debt
Data = xlsread('DEBT - gross external debt.xlsx');
spotrate = xlsread('FX spot rate EUR-SEK.xlsx');

%% GDP
GDP = xlsread('GDP1920.xlsx');

%% Cambio
trim_spotrate = zeros(4,1);
trim_spotrate(1) = mean(spotrate(1:66,2));
trim_spotrate(2) = mean(spotrate(67:131,2));
trim_spotrate(3) = mean(spotrate(132:196,2));
trim_spotrate(4) = mean(spotrate(197:262,2));
Data(:,8) = Data(:,8)./trim_spotrate;

%% Over GDP
DataoverGDP = zeros(4,8);
for i = 1:4
    if i == 1
        DataoverGDP(i,:)= Data(i,:)./GDP(:,1)';
    else
        DataoverGDP(i,:)= Data(i,:)./GDP(:,2)';
    end
end

%% Similarity
debt_sim = zeros(size(DataoverGDP,2),size(DataoverGDP,2),4);
for i = 1:4
    for k = 1:(size(DataoverGDP,2))
        for j = 1:size(DataoverGDP,2)
            debt_sim(k,j,i) = 1 - abs(DataoverGDP(i,k)-DataoverGDP(i,j))/(abs(DataoverGDP(i,k))+(DataoverGDP(i,j)));
        end
    end
end

%% Fix
for k = 1:4
    for i = 1:8
        debt_sim(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)

%% Latex
matlab2latextot(debt_sim(:,:,4),'sim_imp.txt',false)