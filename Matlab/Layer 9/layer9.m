clear all
close all
clc

%% Layer NPL
Data = xlsread('NPL - fonte ECB.xlsx');

%% Similarity
debt_sim = zeros(size(Data,2),size(Data,2),4);
for i = 1:4
    for k = 1:(size(Data,2))
        for j = 1:size(Data,2)
            debt_sim(k,j,i) = 1 - abs(Data(i,k)-Data(i,j))/(abs(Data(i,k))+abs(Data(i,j)));
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
matlab2latextot(debt_sim(:,:,4),'sim_imp.txt',true)