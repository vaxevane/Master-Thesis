function [delay_parking_ID,ID_park] = init_park_variables(ID_max)

%ID_park
ID_park = randi([2*60 2*60*60],1,ID_max);
%delay_parking_ID
delay_parking_ID = zeros(1,ID_max);