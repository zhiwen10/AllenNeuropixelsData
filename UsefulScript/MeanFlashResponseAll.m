cmap1 = cbrewer('qual', 'Set2', 8);
width = 1;
length = 210;

visrl = readtable('export_dataframe_VISrl_2s_odd.csv','ReadVariableNames',true);
visrl1 = readtable('export_dataframe_VISrl_2s_even.csv','ReadVariableNames',true);
visrl_mean = (visrl{:,2:end}+visrl1{:,2:end})/2;
visrl_sum = sum(visrl_mean,2);
visrl_base = mean(visrl_sum(1:10,1));
visrl_sum = visrl_sum-visrl_base;
p1 = plot(visrl{1:length,1},visrl_sum(1:length,1),'color',cmap1(1,:),'LineWidth',width);

hold on

visp_data = readtable('export_dataframe_VISp_2s_odd.csv','ReadVariableNames',true);
visp_data1 = readtable('export_dataframe_VISp_2s_even.csv','ReadVariableNames',true);
visp_mean = (visp_data{:,2:end}+visp_data1{:,2:end})/2;
visp_sum = sum(visp_mean,2);
visp_base = mean(visp_sum(1:10,1));
visp_sum = visp_sum-visp_base;
p2 = plot(visp_data{1:length,1},visp_sum(1:length,1),'color',cmap1(2,:),'LineWidth',width);
hold on

vispm_data = readtable('export_dataframe_VISpm_1s_odd.csv','ReadVariableNames',true);
vispm_data1 = readtable('export_dataframe_VISpm_1s_even.csv','ReadVariableNames',true);
vispm_mean = (vispm_data{:,2:end}+vispm_data1{:,2:end})/2;
vispm_sum = sum(vispm_mean,2);
vispm_base = mean(vispm_sum(1:10,1));
vispm_sum = vispm_sum-vispm_base;
p3 = plot(vispm_data{:,1},vispm_sum,'color',cmap1(3,:),'LineWidth',width);
hold on

% visam_data = readtable('export_dataframe_VISam_1s_odd.csv','ReadVariableNames',true);
% visam_data1 = readtable('export_dataframe_VISam_1s_even.csv','ReadVariableNames',true);
% visam_mean = (visam_data{:,2:end}+visam_data1{:,2:end})/2;
% visam_sum = sum(visam_mean,2);
% visam_base = mean(visam_sum(1:10,1));
% visam_sum = visam_sum-visam_base;
% p4 = plot(visam_data{:,1},visam_sum,'color',cmap1(4,:),'LineWidth',width);
% hold on
% 
% visal_data = readtable('export_dataframe_VISal_2s_odd.csv','ReadVariableNames',true);
% visal_data1 = readtable('export_dataframe_VISal_2s_even.csv','ReadVariableNames',true);
% visal_mean = (visal_data{:,2:end}+visal_data1{:,2:end})/2;
% visal_sum = sum(visal_mean,2);
% visal_base = mean(visal_sum(1:10,1));
% visal_sum = visal_sum-visal_base;
% p5 = plot(visal_data{1:110,1},visal_sum(1:110,1),'color',cmap1(5,:),'LineWidth',width);
% hold on
% 
% visl_data = readtable('export_dataframe_VISl_1s_odd.csv','ReadVariableNames',true);
% visl_data1 = readtable('export_dataframe_VISl_1s_even.csv','ReadVariableNames',true);
% visl_mean = (visl_data{:,2:end}+visl_data1{:,2:end})/2;
% visl_sum = sum(visl_mean,2);
% visl_base = mean(visl_sum(1:10,1));
% visl_sum = visl_sum-visl_base;
% p6 = plot(visl_data{:,1},visl_sum,'color',cmap1(6,:),'LineWidth',width);

% lp_data = readtable('export_dataframe_LP_1s_odd.csv','ReadVariableNames',true);
% lp_data1 = readtable('export_dataframe_LP_1s_even.csv','ReadVariableNames',true);
% lp_mean = (lp_data{:,2:end}+lp_data1{:,2:end})/2;
% lp_sum = sum(lp_mean,2);
% lp_base = mean(lp_sum(1:10,1));
% lp_sum = lp_sum-lp_base;
% p7 = plot(lp_data{:,1},lp_sum,'color',cmap1(7,:),'LineWidth',width);
% hold on
% 
% lgn_data = readtable('export_dataframe_LGd_1s_odd.csv','ReadVariableNames',true);
% lgn_data1 = readtable('export_dataframe_LGd_1s_even.csv','ReadVariableNames',true);
% lgn_mean = (lgn_data{:,2:end}+lgn_data1{:,2:end})/2;
% lgn_sum = sum(lgn_mean,2);
% lgn_base = mean(lgn_sum(1:10,1));
% lgn_sum = lgn_sum-lgn_base;
% p8 = plot(lgn_data{:,1},lgn_sum,'color',cmap1(8,:),'LineWidth',width);
hold on

% p3 = []; 
p4 = []; p5 = []; p6 = []; 
p7 = []; p8 = [];
p0 = {p1 p2 p3 p4 p5 p6 p7 p8};
p1 = [p1 p2 p3 p4 p5 p6 p7 p8];
lgd_name = {'VISrl','VISp','VISpm','VISam','VISal','VISlm','LP','LGd'};
idx = find(~cellfun(@isempty,p0));
lgd_name2 = lgd_name(idx);
xlim([-0.2 1])

legend(p1,lgd_name2);