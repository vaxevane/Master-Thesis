function[lane_cell,delay_parking_ID,ID_park,temp] = parking(lane_cell,delay_parking_ID,ID_park,inverse,amea_freq,en_amea,time,amea_sp)
d=1;


if ~inverse; lane = lane_cell{1}; else, lane = flip(lane_cell{1},2); end
if ~inverse; lane_Car_ID = lane_cell{2}; else, lane_Car_ID = flip(lane_cell{2},2); end
if ~inverse; park_signals = lane_cell{3}; else, park_signals = flip(lane_cell{3},2); end
if ~inverse; park_flags = lane_cell{4}; else, park_flags = flip(lane_cell{4},2); end
if ~inverse; steps_parked = lane_cell{5}; else, steps_parked = flip(lane_cell{5},2); end
if ~inverse; change_signals = lane_cell{6}; else, change_signals = flip(lane_cell{6},2); end

last_park = length(lane);

if (inverse)
    amea_sp = last_park - amea_sp+1;
    amea_sp(amea_sp == last_park+1) = 0;
    amea_sp = sort(amea_sp,2);
    if(amea_sp(1,1) == 0 && any(amea_sp(1,:) ~= 0))
        amea_sp(1,:) = circshift(amea_sp(1,:),(find(amea_sp(1,:)~=0,1)-1)*(-1));
    end
    if(amea_sp(2,1) == 0 && any(amea_sp(2,:) ~= 0))
        amea_sp(2,:) = circshift(amea_sp(2,:),(find(amea_sp(2,:)~=0,1)-1)*(-1));
    end
end

%UNPARKING SIGNAL AND PARK DUR. INCR.
[steps_parked,change_signals] = unparking_signal(d,lane,lane_Car_ID,steps_parked,change_signals,ID_park);

%DEBUGGING
half_truck_flagged(lane,lane_Car_ID,park_flags);
%DEBUGGING
%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%Increment the duration of each flag and disable flag
[lane,park_flags,steps_parked] = flag_incr_and_dis(d,lane,park_flags,steps_parked,5*60);

%DELAY DECR.
[delay_parking_ID] = delay_decrease(lane_Car_ID,delay_parking_ID);

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%Stealing parking spots from already flagged ones
[lane,park_flags,steps_parked,change_signals] = flag_steal(d,lane,lane_Car_ID,park_signals,park_flags,steps_parked,change_signals,last_park,time,amea_sp);

%INIT temp
[temp] = init_temp(d,lane,amea_sp,en_amea);

%PARKING AND CHANGING LANE
[lane,temp,lane_Car_ID,park_signals,steps_parked,change_signals,ID_park,delay_parking_ID] = change_lane_and_parking(d,lane,temp,lane_Car_ID,park_signals,steps_parked,change_signals,ID_park,delay_parking_ID);

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%FLAGGING SYSTEM
[lane,temp,park_flags] = put_flag(d,lane,temp,lane_Car_ID,park_signals,park_flags,last_park,amea_freq,amea_sp,en_amea);

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING


%Updating cell
if inverse; temp = flip(temp,2); end
if ~inverse; lane_cell = {lane,lane_Car_ID,park_signals,park_flags,steps_parked,...
        change_signals}; else, lane_cell = {flip(lane,2),flip(lane_Car_ID,2),...
        flip(park_signals,2),flip(park_flags,2),flip(steps_parked,2),flip(change_signals,2)}; 
end