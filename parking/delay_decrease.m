function [delay_parking_ID] = delay_decrease(lane_Car_ID,delay_parking_ID)

%Decreasing delay for cars that have already parked once
idx_red_delay = find(delay_parking_ID > 0);
if(idx_red_delay)
    if(find(ismember(lane_Car_ID,idx_red_delay)))
        idx_dec = lane_Car_ID(find(ismember(lane_Car_ID,idx_red_delay)));
        delay_parking_ID(idx_dec) = delay_parking_ID(idx_dec) - 1;
    end
end