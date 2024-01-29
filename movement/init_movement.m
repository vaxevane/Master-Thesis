function [d,c,lane,park,Car_ID,change] = init_movement(lane,park,Car_ID)

lane(:,length(lane)+1:length(lane)+10) = -1;
[d,c] = size(lane);
d=1;
park(park>1) = 1;%if desire bigger that 1
park(park<-1) = -1;%if desire bigger that 1
park(:,c-9:c) = 0;
Car_ID(1,c-9:c) = 0;
change = zeros(d+2,c);%signals for changing lanes