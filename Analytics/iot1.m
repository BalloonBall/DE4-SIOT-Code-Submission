clc;clear;
close all;
%% Data import
% import dataset from csv
user_A = readmatrix('user_A.csv');
user_B = readmatrix('user_B.csv');
%%
bathroom_ID_A = user_A(:,1);
date_time_A = unidate(user_A);

bathroom_ID_B = user_B(:,1);
date_time_B = unidate(user_B);

[bathroom_1_A, bathroom_2_A] = room(user_A);
[bathroom_1_B, bathroom_2_B] = room(user_B);

[bathroom_1_A_enter, bathroom_1_A_leave] = state_change(bathroom_1_A);
[bathroom_2_A_enter, bathroom_2_A_leave] = state_change(bathroom_2_A);
[bathroom_1_B_enter, bathroom_1_B_leave] = state_change(bathroom_1_B);
[bathroom_2_B_enter, bathroom_2_B_leave] = state_change(bathroom_2_B);

bathroom_1_A_duration = timediff(bathroom_1_A_enter, bathroom_1_A_leave);
bathroom_2_A_duration = timediff(bathroom_2_A_enter, bathroom_2_A_leave);
bathroom_1_B_duration = timediff(bathroom_1_B_enter, bathroom_1_B_leave);
bathroom_2_B_duration = timediff(bathroom_2_B_enter, bathroom_2_B_leave);
%%
bathroom_1_A_duration_total = sum(bathroom_1_A_duration);
bathroom_2_A_duration_total = sum(bathroom_2_A_duration);
bathroom_1_B_duration_total = sum(bathroom_1_B_duration);
bathroom_2_B_duration_total = sum(bathroom_2_B_duration);

bathroom_1_A_frequency = length(bathroom_1_A_duration);
bathroom_2_A_frequency = length(bathroom_2_A_duration);
bathroom_1_B_frequency = length(bathroom_1_B_duration);
bathroom_2_B_frequency = length(bathroom_2_B_duration);

duration_average_A = (bathroom_1_A_duration_total+bathroom_1_A_duration_total)...
    /(bathroom_1_A_frequency+bathroom_2_A_frequency);
duration_average_B = (bathroom_1_B_duration_total+bathroom_1_B_duration_total)...
    /(bathroom_1_B_frequency+bathroom_2_B_frequency);
%%
figure(1)
plot(date_time_A,bathroom_ID_A,'ro')
ylim([0 3])
yticks([1 2])
hold on
plot(date_time_B,bathroom_ID_B,'bo')
title('Bathroom usage in 7 days')
legend({'Person A','Person B'},'Location','northeast')
%%
figure(2)
bathroom_1_A_enter_time = unidate(bathroom_1_A_enter);
bathroom_2_A_enter_time = unidate(bathroom_2_A_enter);
bar(bathroom_1_A_enter_time,bathroom_1_A_duration,60,'b')
hold on
bar(bathroom_2_A_enter_time,bathroom_2_A_duration,0.15,'r')
title('Person A bathrooms usage durations')
ylabel('Duration(minutes)')
legend({'Bathroom 1','Bathroom 2'},'Location','northeast')
%%
figure(3)
bathroom_1_B_enter_time = unidate(bathroom_1_B_enter);
bathroom_2_B_enter_time = unidate(bathroom_2_B_enter);
bar(bathroom_1_B_enter_time,bathroom_1_B_duration,1,'b')
hold on
bar(bathroom_2_B_enter_time,bathroom_2_B_duration,0.05,'r')
title('Person B bathrooms usage durations')
ylabel('Duration(minutes)')
legend({'Bathroom 1','Bathroom 2'},'Location','northeast')
%%
figure(4)
X_duration = categorical({'A';'B'});
X_duration = reordercats(X_duration,{'A';'B'});
Y_duration = [bathroom_1_A_duration_total bathroom_2_A_duration_total;...
    bathroom_1_B_duration_total bathroom_2_B_duration_total];
bar(X_duration,Y_duration)
title('Total bathrooms usage durations')
ylabel('Total Duration(minutes)')
legend({'Bathroom 1','Bathroom 2'},'Location','northeast')
%%
figure(5)
X_freq = categorical({'A';'B'});
X_freq = reordercats(X_freq,{'A';'B'});
Y_freq = [bathroom_1_A_frequency bathroom_2_A_frequency;...
    bathroom_1_B_frequency bathroom_2_B_frequency];
bar(X_freq,Y_freq)
title('Total bathrooms usage frequency')
ylabel('Number of usage')
legend({'Bathroom 1','Bathroom 2'},'Location','northeast')
%%
figure(6)
X_freq = categorical({'A';'B'});
X_freq = reordercats(X_freq,{'A';'B'});
Y_freq = [duration_average_A;...
    duration_average_B];
bar(X_freq,Y_freq)
title('Average usage duration')
ylabel('Average Duration(minutes)')
%%
function [bathroom_1,bathroom_2] = room(user)
TF1 = user(:,1) == 1;
TF2 = user(:,1) == 2;
bathroom_1= user(TF1,:);
bathroom_2 = user(TF2,:);
end

function duration = timediff(enter,leave)
for i = 1:length(enter)
    duration(i) = (leave(i,3) - enter(i,3))/60;
end
end

function [enter,leave] = state_change(user)
TF1 = user(:,2) == 1;
TF2 = user(:,2) == 0;
enter= user(TF1,:);
leave = user(TF2,:);
end

function date_time = unidate(user)
unix_time = user(:,3);
date_time = datetime(unix_time,'ConvertFrom','epochtime');
end
