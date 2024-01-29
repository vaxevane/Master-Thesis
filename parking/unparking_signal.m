function [steps,signals] = unparking_signal(d,lane,Car_ID,steps,signals,ID_park)

park_time = 1;%if 0 same parking time for all if 1 random parking time


%Increase time steps for each parked car
idx_dur = find(lane(d+1,:) == 0);
steps(1,idx_dur) = steps(1,idx_dur)+1;
idx_dur = find(lane(d+2,:) == 0);
steps(2,idx_dur) = steps(2,idx_dur)+1;

for side=d+1:d+2
    j = 1;
    if(park_time == 0)
        %OLD WAY
        idx_unpark = find(steps(side-1,:) >= 60 & lane(side,:) == 0);
    elseif(park_time == 1)
        idx_parked = find(lane(side,:) == 0);
        idx_unpark = idx_parked(find(steps(side-1,idx_parked) > ID_park(Car_ID(side,idx_parked))));
    end
    
    if(side == d+1)
        flash = 1;
    elseif(side == d+2)
        flash = -1;
    end
    while j<=length(idx_unpark)
        cond1 = Car_ID(side,idx_unpark(j)) == Car_ID(side,idx_unpark(j)+1);
        if(cond1)
            cond2 = (lane(1,idx_unpark(j):idx_unpark(j)+1) == -1);
            cond3 = signals(d+1,idx_unpark(j):idx_unpark(j)+1) == 0;
        else
            cond2 = (lane(1,idx_unpark(j)) == -1);  
        end
        if(cond1 && all(cond2) && all(cond3))
            signals(side,idx_unpark(j):idx_unpark(j)+1) = flash;
        elseif(~cond1)
            signals(side,idx_unpark(j)) = flash;
        end
        if(cond1)
            j = j + 2;
        else
            j = j + 1;
        end
        
    end
end