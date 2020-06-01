data = readtable('export_dataframe_VISrl_2s_odd.csv','ReadVariableNames',true);
data1 = readtable('export_dataframe_VISrl_2s_even.csv','ReadVariableNames',true);
data_mean = (data{:,2:end}+data1{:,2:end})/2;

%data = readtable('export_dataframe.csv','ReadVariableNames',true);
window = [-0.1,1.0];
binSize = 0.01;
filename = 'VISrl_flash_raster2_1s_xvalid';

%% baseline subtraction and normalisation
response_data = table2array(data)';
normResponses = baseline_sub(data,binSize,window);

totalwin = window(1,2)-window(1,1);
%get response sequence from window [0s 0.4s]
response = response_data(:,(abs(window(1,1))/binSize+1):(window(1,2)/(binSize*5)+abs(window(1,1))/binSize+1));
%find time index for max firing rate for each cluster
[~,maxR] = max(response,[],2);
%order cluster by max firing time index
[sorta,sortb] = sort(maxR);
normResponses2 = normResponses(sortb,:);

%% cross validate sorting??

normResponses_even = baseline_sub(data1,binSize,window);
normResponses2_even = normResponses_even(sortb,:);

%% don't sort by peak response time, but by onset time instead?? How??
%% sort cluster by brain area??
%% plot sorted cluster response

% plot_response(normResponses2)
plot_response(normResponses2_even,filename)

function plot_response(normResponses2,filename)
figure
imagesc(normResponses2); 
xlabel('time from stim on (s)'); ylabel('neuron number');
xticks([0 10 20 30 40 50 60 70 80 90 100 110])
xticklabels({'-0.1','0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})
c = flipud(gray);
colormap(c);
caxis([0 1]);
h = colorbar; set(get(h, 'Label'), 'string', 'Normolized firing rate')
savefig(filename);
print('-depsc','-painters','-loose',filename)
end
%% baseline subtraction function

function normResponses = baseline_sub(data,binSize,window)
response_data = table2array(data)';
%mean subtraction 
%baseline window set as [0.2s 0s], get mean firing rate at baseline for all
%clusters
baseline = response_data(:,1:abs(window(1,1))/binSize);
meanBaseline = mean(baseline,2);
meanBaseline1 = repmat(meanBaseline,1,size(response_data,2));
% subtract baseline, and divided by baseline.
% cluster with baseline firing rate <1, should not be divided by baseline (result in FR amplification)
% just leave them as they are, but setting it to 1.
meanBaselineNorm = meanBaseline1;
% meanBaselineNorm(meanBaselineNorm<1) = 1;
% subtract baseline, and divided by baseline.
normResponses = (response_data-meanBaseline1)./(meanBaselineNorm+0.5);
end