clear all
close all
clc

%% Layer GDP
data = xlsread('GDP and GVA - quarterly.xlsx');

%% Swappo
data = data';

%% Similarities
GDP_sim = zeros(size(data,2),size(data,2),4);

for i = 1:4
    for k = 1:(size(data,2))
        for j = 1:size(data,2)
            GDP_sim(k,j,i) = 1 - abs(data(i,k)-data(i,j))/(abs(data(i,k))+(data(i,j)));
        end
    end
end


%% Fix
for k = 1:4
    for i = 1:8
        GDP_sim(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)

%% Latex
matlab2latextot(GDP_sim(:,:,4),'sim_imp.txt',true)