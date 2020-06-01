%% read unit table, and preset parameters

sessionnum = '754312389';
% sessionnum = '742951821';
% sessionnum = '732592105';
filename = ['session_' sessionnum '.nwb'];
binSize = 0.01;
ybound = 800;
presentation_scale = 1000;
yscale = 3;
cmap1 = flipud(cbrewer('qual', 'Set1', 6));
sz = 5;

%% get presenattion table list
presentation = readtable(['session_' sessionnum '_presentation.csv']);
pre_name = presentation.stimulus_name;
pre_x = presentation.start_time;
pre_y = ones(size(pre_x))*presentation_scale;
pre_c = grp2idx(presentation.stimulus_name);
stim_n = size(unique(pre_c),1);
cmap2 = cbrewer('div','Spectral',stim_n);
color1 = zeros(size(pre_x,1),3);
for i = 1:size(pre_x,1)
color1(i,:) = cmap2(pre_c(i),:);
end

%% get spikes and histogram
name_list = {'VISam','VISpm','VISp','VISlm','VISal','VISrl'};

for i = 1:6
    name_select = name_list{i};
    csv_name = [sessionnum,'_' name_select '_porbe.csv'];
    if isfile(csv_name)
        table1 = readtable(csv_name);
        s1{i} = extract_data(table1,filename);
        [n1{i},x1{i}] = spike_histogram(s1{i},binSize);
    else 
        s1{i} = []; x1{i} = []; n1{i} = [];
    end
end

%% order 
% A-AM; B-PM; C-VISp; D-LM; E-AL; F-RL

figure; 
p0 = gscatter(pre_x,pre_y,pre_name,flipud(cmap2),[],20)
lgd1 = legend(p0);
set(lgd1,'Interpreter','none')
lgd1_name1 = lgd1.String;

for i =1:6
    if ~isempty(s1{i}) 
        hold on; t1{i} = scatter(s1{i}.spikes.times,s1{i}.spikes.depths,sz,cmap1(i,:),'filled');
        hold on; p1{i} = plot(x1{i},n1{i}*yscale+ybound,'color',cmap1(i,:));
    else 
        p1{i} = [];
    end
end
p2 = [p1{1},p1{2},p1{3},p1{4},p1{5},p1{6}]';

lgd_name = {'VISam','VISpm','VISp','VISlm','VISal','VISrl'};
idx = find(~cellfun(@isempty,p1));
lgd_name2 = lgd_name(idx);
lgd_name_all = [lgd_name2,lgd1_name1];
lgd = legend([p2; p0],lgd_name_all);
% 
% % lgd.NumColumns = 2;
% ldg.NumColumnsModes = 'auto';
% lgd.FontSize = 10;

%% spike_histogram
function [n,x] = spike_histogram(s1,binSize)
time_max = max(s1.spikes.times);
time_min = min(s1.spikes.times);
[n,x] = hist(s1.spikes.times, time_min:binSize:time_max);
end

%% get spike properties for each probe
function s1 = extract_data(table,filename)
%% import spike_time, id, local_index, peak_channel
spike_time = h5read(filename,'/units/spike_times');
id = h5read(filename,'/units/id');
spike_index = h5read(filename,'/units/spike_times_index');
peak_channel = h5read(filename,'/units/local_index');
spike_amp = h5read(filename,'/units/spike_amplitudes');
spike_cluster = h5read(filename,'/units/cluster_id');

%% get spike IDs
id2 = reformat_array(spike_index,id);
peak_channel2 = reformat_array(spike_index,peak_channel);
spike_cluster2 = reformat_array(spike_index,spike_cluster);

%%filter unit ID based on unit_id in the table
[id3,index3] = ismember(id2,table.unit_id);

%% filter spike id 
id4 = id2(id3);
peak_channel4 = peak_channel2(id3);
spike_time4 = spike_time(id3);
spike_amp4 = spike_amp(id3);
spike_cluster4 = spike_cluster2(id3);

s1.spikes.times = spike_time4;
s1.spikes.depths = double(peak_channel4);
s1.spikes.clusters = double(spike_cluster4);
s1.spikes.amps = spike_amp4;

% clear spike_time spike_amp id spiek_index peak_channel spike_cluster id2 peak_channel2 spike_cluster2 id3...
%     index3 id4 peak_channel4 spike_time4 spike_cluster4
end
