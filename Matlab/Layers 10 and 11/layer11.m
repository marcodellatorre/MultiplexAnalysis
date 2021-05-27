clear all
close all
clc

%% Layer bonds
[~,SheetNames] = xlsfinfo('Benchmark Government Bond - TR.xlsx');
nSheets = length(SheetNames);
data =[];
for ii = 1:nSheets
    Name = SheetNames{ii};
    data = [data, xlsread('Benchmark Government Bond - TR.xlsx',Name)];
end

%% Fix
data_medie = zeros(size(data,1),size(data,2)/2);
for i = 1:(size(data,2)/2)
    data_medie(:,i) = (data(:,1+(i-1)*2)+data(:,2+(i-1)*2))./2;
end

%% Years1
for i = 1:(size(data_medie,2)/3)
    data_medie10y(:,i) = data_medie(:,3+(i-1)*3);
end

%% Similarities
correlations = zeros(size(data_medie10y,2),size(data_medie10y,2),4);
for k = 1:(size(data_medie10y,2))
    for j = 1:size(data_medie10y,2)
        R = corrcoef(data_medie10y(1:62,k)',data_medie10y(1:62,j)');
        correlations(k,j,1) = 2 - sqrt(2*(1-R(1,2)));
        R = corrcoef(data_medie10y(63:125,k)',data_medie10y(63:125,j)');
        correlations(k,j,2) = 2 - sqrt(2*(1-R(1,2)));
        R = corrcoef(data_medie10y(126:185,k)',data_medie10y(126:185,j)');
        correlations(k,j,3) = 2 - sqrt(2*(1-R(1,2)));
        R = corrcoef(data_medie10y(186:251,k)',data_medie10y(186:251,j)');
        correlations(k,j,4) = 2 - sqrt(2*(1-R(1,2)));
    end
end
correlations_fixed = correlations./2;

%% Fix
for k = 1:4
    for i = 1:8
        correlations_fixed(i,i,k) = 0;
    end
end
%sim_imp = round(sim_exp,2)

%% Latex
matlab2latextot(correlations_fixed(:,:,4),'sim_imp.txt',true)