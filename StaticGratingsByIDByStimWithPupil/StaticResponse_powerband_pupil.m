%% running band power 
clear trace1 smoothtrace1 pupil3 static_time1
epochs = readtable(['session_' sessionnum '_epochs.csv']);
% epoch_name = 'static_gratings';
% epoch_name = 'natural_scenes';
% epoch_name = 'natural_movie_three';
% epoch_name = 'flashes';
epoch_name = 'drifting_gratings';
% epoch_name = 'spontaneous';
session = 3;
temp_epochs = epochs(ismember(epochs.stimulus_name,epoch_name),:);
startt = temp_epochs.start_time(session,1);
stopt = temp_epochs.stop_time(session,1);

%% find stim onset times
indx = find(pre_x>=startt & pre_x<stopt);
pre_x1 = pre_x(indx);
pre_y1 = pre_y(indx);
pre_name1 = pre_name(indx);
%% 
binSize = 0.01;
static_time1 = startt:binSize:stopt;
static_time1 = static_time1';
trace = [x1{3};n1{3}];
trace = trace';
trace1(:,1) = static_time1;
trace1(:,2) = interp1(trace(:,1),trace(:,2),static_time1);

smoothtrace1(:,1) = static_time1;
smoothtrace1(:,2) = movmean(trace1(:,2),1/binSize);


pupil3(:,1) = static_time1;
pupil3(:,2) = interp1(pupil1(:,1),pupil1(:,2),static_time1);
% running window, 1s, 100samples
win1 = 200;
% sampling rate, here 100Hz, 0.01s
fs = 100;
% frequency range, here 3-6 Hz
prange = [3 6];
% for first and last 200 samples, bandpower is 0, not enough samples for power
% spectrum
pband_n = size(trace1,1);
pband  = zeros(pband_n,1);
for i = 201: pband_n-201   
    rtrace = trace1(i-200:i+win1,2)';
    pband(i,1) = bandpower(rtrace,fs,prange);
end
%% plot
figure; plot(trace1(:,1),trace1(:,2),'r');
hold on; plot(trace1(:,1),pband,'b','LineWidth',2);
hold on; plot(smoothtrace1(:,1),smoothtrace1(:,2),'c','LineWidth',2);
hold on; plot(pupil3(:,1),pupil3(:,2),'k','LineWidth',2);
hold on; gscatter(pre_x1,pre_y1,pre_name1,'m',[],10)
xlim([startt,stopt]);
legend({'VISp MUA','VISp MUA Power 3-6Hz','VISp MUA running average 1s','Pupil size','stim'});
title1 = [epoch_name '-session' num2str(session)];
title(title1,'Interpreter', 'none');
savefig(title1); 