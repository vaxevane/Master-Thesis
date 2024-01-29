function[lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = RTcars(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,epoch,ID_max,amea_freq,new_car,season)

if season == 's'; truck_perc = 0.0249; elseif season == 'w'; truck_perc = 0.0274;  end

% if(rand(1)>1-new_car && ~mod(epoch,2))
if(rand(1)>1-new_car)
	%TRUCK
    if(lane(1,1) == -1 && lane(1,2) == -1 && (rand(1)>1-truck_perc))%put here percentages for cars/trucks etc
		lane(1,1:2) = 1;
		park_signals(1,1:2) = rand-0.4;
		if ~mod(ID_max+1,amea_freq); new_ID = ID_max+2; else, new_ID = ID_max+1; end
		lane_Car_ID(1,1:2) = new_ID;
		ID_max = new_ID;
		delay_parking_ID(1,new_ID) = 0;
		ID_park(1,new_ID) = randi([60*2 60*60*2],1);
	%CAR
	elseif(lane(1,1) == -1)
		%1 AMEA car appears after 20 cars
		lane(1,1) = 1;
		park_signals(1,1) = rand-0.4;
		lane_Car_ID(1,1) = ID_max+1;
		ID_max = ID_max + 1;
		delay_parking_ID(1,ID_max) = 0;
		ID_park(1,ID_max) = randi([60*2 60*60*2],1);
    end
end