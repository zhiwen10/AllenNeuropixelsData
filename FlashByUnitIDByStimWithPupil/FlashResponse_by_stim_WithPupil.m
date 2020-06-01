data_rep = readtable('session_742951821_VISrl_2s_by_presentation.csv','ReadVariableNames',true);
data = readtable('session_742951821_VISrl_2s_by_id.csv','ReadVariableNames',true);
pupil = readtable('session_742951821_pupil_width.csv','ReadVariableNames',true);
flash_time = readtable('session_742951821_flash_time.csv','ReadVariableNames',true);
window = [-0.1,2.0];
binSize = 0.01;
%%
pupil1 = table2array(pupil);
flash_time1 = table2array(flash_time);
response_data_rep = data_rep{:,2:end};
response_data = data{:,2:end};
pupil2 = interp1(pupil1(:,1),pupil1(:,2),flash_time1(:,2));
% plot(pupil1(:,1),pupil1(:,2));
% hold on
% scatter(flash_time1(:,2),pupil2,'r');
pupil2y = 1:length(pupil2);


%% baseline subtraction and normalisation
figure
subplot(4,1,1)
normResponses_rep = baseline_sub(data_rep,binSize,window);
normResponses_rep2 = normResponses_rep;
plot_response(normResponses_rep2)
hold on
plot(210-pupil2,pupil2y','r','LineWidth',2);
ylabel('trial repetition');

subplot(4,1,2)
sum_response_rep = sum(normResponses_rep2,2);
plot(-0.1:0.01:2.0,sum_response_rep,'r')
xlim([-0.1 2.0]);


subplot(4,1,3)
normResponses = baseline_sub(data,binSize,window);
totalwin = window(1,2)-window(1,1);
%get response sequence from window [0s 0.4s]
% response = response_data(:,(abs(window(1,1))/binSize+1):(window(1,2)/(binSize*5)+abs(window(1,1))/binSize+1));
response = response_data(:,(abs(window(1,1))/binSize+1):0.25/(binSize)+abs(window(1,1))/binSize+1);
%find time index for max firing rate for each cluster
[~,maxR] = max(response,[],2);
%order cluster by max firing time index
[sorta,sortb] = sort(maxR);
normResponses2 = normResponses(:,sortb);
plot_response(normResponses2)
ylabel('unit number');

subplot(4,1,4)
sum_response = sum(normResponses2,2);
plot(-0.1:0.01:2.0,sum_response,'r')
xlim([-0.1 2.0]);

savefig('session_742951821_VISrl_pupil');
print('-depsc','-painters','-loose','session_742951821_VISrl_pupil')


function plot_response(normResponses2)
imagesc(normResponses2'); 
xlabel('time from stim on (s)'); 
xticks([0:10:210])
tick_label = -0.1:0.1:2.0;
tick_label1 = string(tick_label');
xticklabels(tick_label1);
% xticklabels({'-0.1','0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})
c = flipud(gray);
colormap(c);
caxis([0 0.1]);
% h = colorbar; set(get(h, 'Label'), 'string', 'Normolized firing rate')


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