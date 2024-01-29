function [lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = insert_rand(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max,amea_freq,new_car_prob,new_truck_prob)

if(lane(1,1) == -1 && lane(1,2)== -1 && (rand(1)>1-new_truck_prob))
    lane(1,1:2) = 1;
    park_signals(1,1:2) = rand-0.4;
    if ~mod(ID_max+1,amea_freq); new_ID = ID_max+2; else, new_ID = ID_max+1; end
    lane_Car_ID(1,1:2) = new_ID;
    ID_max = new_ID;
    delay_parking_ID(1,new_ID) = 0;
    ID_park(1,new_ID) = randi([60*2 60*60*2],1);
end
if ((lane(1,1) == -1) && (rand(1)>1-new_car_prob))%new cars
    lane(1,1) = 1;
    %1 AMEA car appears after 20 cars
    park_signals(1,1) = rand-0.4;
    lane_Car_ID(1,1) = ID_max+1;
    ID_max = ID_max + 1;
    delay_parking_ID(1,ID_max) = 0;
    ID_park(1,ID_max) = randi([60*2 60*60*2],1);
end