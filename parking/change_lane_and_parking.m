function [lane,temp,lane_Car_ID,park_signals,steps_parked,change_signals,ID_park,delay_parking_ID] = change_lane_and_parking(d,lane,temp,lane_Car_ID,park_signals,steps_parked,change_signals,ID_park,delay_parking_ID)

%flash switching and lane changing 
for i=1:d+2
    if(i<d+1)
        idx_l = find(change_signals(i+1,:)==1);%spots that cars want to flash left
        vac_sp_l = lane(i,idx_l)==-1;% checking which of these spots are occupied
        temp(i,idx_l(vac_sp_l)) = 8;%number 8 is flashing color for left
        lane(i,idx_l(vac_sp_l)) = lane(i+1,idx_l(vac_sp_l));%car going to the left
        lane(i+1,idx_l(vac_sp_l)) = -1;
        lane_Car_ID(i,idx_l(vac_sp_l)) = lane_Car_ID(i+1,idx_l(vac_sp_l));
        lane_Car_ID(i+1,idx_l(vac_sp_l)) = 0;
        change_signals(i+1,idx_l(vac_sp_l)) = 0;%switching off flash
        if(i<d)
            park_signals(i,idx_l(vac_sp_l)) = park_signals(i+1,idx_l(vac_sp_l));
            park_signals(i+1,idx_l(vac_sp_l)) = 0;
        end
        if(i == d)
            park_signals(i,idx_l(vac_sp_l)) = (rand(1,sum(vac_sp_l))/2)-0.3;%giving new park variables %delay park_signals reappearance
            steps_parked(i,idx_l(vac_sp_l)) = 0;
			%DELAY and ID_PARK
            delay_parking_ID(1,lane_Car_ID(i,idx_l(vac_sp_l))) = randi([60 2*60*60],1,sum(vac_sp_l));
            ID_park(1,lane_Car_ID(i,idx_l(vac_sp_l))) = randi([2*60 2*60*60],1,sum(vac_sp_l));
        end
    %Parking on the top side 
    elseif(i==d+1)
        idx_l = find(change_signals(i-1,:)==1);%spots that cars want to flash left
        vac_sp_l = lane(i+1,idx_l)==-1;% checking which of these spots are occupied
        temp(i+1,idx_l(vac_sp_l)) = 8;%number 8 is flashing color for left
        lane(i+1,idx_l(vac_sp_l)) = 0;%car stops
        lane(i-1,idx_l(vac_sp_l)) = -1;
        change_signals(i-1,idx_l(vac_sp_l)) = 0;%switching off flash
        park_signals(i-1,idx_l(vac_sp_l)) = 0;
        lane_Car_ID(i+1,idx_l(vac_sp_l)) = lane_Car_ID(i-1,idx_l(vac_sp_l));
        lane_Car_ID(i-1,idx_l(vac_sp_l)) = 0;
        steps_parked(i,idx_l(vac_sp_l)) = 0;
    end

    %Unparking from top side
    if(i==d+2)
        idx_r = find(change_signals(i,:)==-1);
        vac_sp_r = lane(i-2,idx_r)==-1;
        temp(i-2,idx_r(vac_sp_r)) = 6;%number 6 is flashing color for right
        lane(i-2,idx_r(vac_sp_r)) = lane(i,idx_r(vac_sp_r));
        lane(i,idx_r(vac_sp_r)) = -1;
        change_signals(i,idx_r(vac_sp_r)) = 0;
        steps_parked(i-1,idx_r(vac_sp_r)) = 0;
        park_signals(i-2,idx_r(vac_sp_r)) = (rand(1,sum(vac_sp_r))/2)-0.3; %delay park_signals reappearance
        lane_Car_ID(i-2,idx_r(vac_sp_r)) = lane_Car_ID(i,idx_r(vac_sp_r));
        lane_Car_ID(i,idx_r(vac_sp_r)) = 0;
		%DELAY and ID_PARK
        delay_parking_ID(1,lane_Car_ID(i-2,idx_r(vac_sp_r))) = randi([60 2*60*60],1,sum(vac_sp_r));
        ID_park(1,lane_Car_ID(i-2,idx_r(vac_sp_r))) = randi([2*60 2*60*60],1,sum(vac_sp_r));
    elseif(i>=2)
        idx_r = find(change_signals(i-1,:)==-1);%spots that cars want to flash right
        vac_sp_r = lane(i,idx_r)==-1;
        temp(i,idx_r(vac_sp_r)) = 6;%number 6 is flashing color for right
        if(i == d+1)
            park_signals(i-1,idx_r(vac_sp_r)) = 0;%make zero the desire to park after parking
            lane(i,idx_r(vac_sp_r)) = 0;%car stoped                
            steps_parked(i-1,idx_r(vac_sp_r)) = 0;
        else
            lane(i,idx_r(vac_sp_r)) = lane(i-1,idx_r(vac_sp_r));
            park_signals(i,idx_r(vac_sp_r)) = park_signals(i-1,idx_r(vac_sp_r));
            park_signals(i-1,idx_r(vac_sp_r)) = 0;
        end
        lane(i-1,idx_r(vac_sp_r)) = -1;
        lane_Car_ID(i,idx_r(vac_sp_r)) = lane_Car_ID(i-1,idx_r(vac_sp_r));
        lane_Car_ID(i-1,idx_r(vac_sp_r)) = 0;
        change_signals(i-1,idx_r(vac_sp_r)) = 0;
    end
end