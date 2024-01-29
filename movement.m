function[lane_cell,delay_parking_ID,ID_park,ID_max] = movement(lane_cell,delay_parking_ID,ID_park,inverse,epoch,dec_prob,park_prob,ID_max,rt,vehicle_load,season,new_car_prob,new_truck_prob,amea_freq,en_amea,amea_sp)


if ~inverse; lane = lane_cell{1}; else, lane = flip(lane_cell{1},2); end
if ~inverse; lane_Car_ID = lane_cell{2}; else, lane_Car_ID = flip(lane_cell{2},2); end
if ~inverse; park_signals = lane_cell{3}; else, park_signals = flip(lane_cell{3},2); end
if ~inverse; park_flags = lane_cell{4}; else, park_flags = flip(lane_cell{4},2); end
if ~inverse; steps_parked = lane_cell{5}; else, steps_parked = flip(lane_cell{5},2); end

len = length(lane);

if (inverse)
    amea_sp = len - amea_sp + 1;
    amea_sp(amea_sp == len+1) = 0;
    amea_sp = sort(amea_sp,2);
end

%INITIALIZATION
[d,c,lane,park_signals,lane_Car_ID,change_signals] = init_movement(lane,park_signals,lane_Car_ID);

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%INSERT CARS/TRUCKS
if(rt == 1)
	%RT new cars (replaces old way of inserting incoming cars)
	%new_car = vehicle_load/(24*60*60);%creating probability for a vehicle to appear per sec. const. value
    new_car = vehicle_distribution(vehicle_load,season,mod(epoch,24*60*60));
    [lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = RTcars(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,epoch,ID_max,amea_freq,new_car,season);
% 	Optional if the new_car value is lower than expected
%     if(new_car<0.1)
% 		new_car = 2*new_car;
% 		[lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = RTcars(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,epoch,ID_max,amea_freq,new_car,season);
% 	else
% 		[lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = RTcars(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,2,ID_max,amea_freq,new_car,season);
% 	end
elseif(rt == 0)
    %Random way of inserting incoming cars (based on a single possibility variable)
    [lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = insert_rand(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max,amea_freq,new_car_prob,new_truck_prob);
end

%MOVEMENT
[lane,lane_Car_ID,park_signals,park_flags,steps_parked] = move(d,c,lane,lane_Car_ID,park_signals,park_flags,steps_parked,park_prob,amea_freq,amea_sp,en_amea);

%REDUCE SPEED & PARK,CHANGE SIGNALS
[lane,park_signals,change_signals] = reduce_speed_signaling(d,c,lane,lane_Car_ID,park_signals,park_flags,change_signals,delay_parking_ID,dec_prob,amea_freq,amea_sp,en_amea);


%DEBUGGING
half_truck_flagged(lane,lane_Car_ID,park_flags);
%DEBUGGING
%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%Updating cell
if ~inverse; lane_cell = {lane(:,1:c-10),lane_Car_ID(:,1:c-10),park_signals(:,1:c-10),park_flags(:,1:c-10),...
        steps_parked(:,1:c-10),change_signals(:,1:c-10)}; else, lane_cell = {flip(lane(:,1:c-10),2),flip(lane_Car_ID(:,1:c-10),2),...
        flip(park_signals(:,1:c-10),2),flip(park_flags,2),flip(steps_parked,2),flip(change_signals(:,1:c-10),2)};
end