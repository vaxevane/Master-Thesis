function half_truck_flagged(lane,lane_Car_ID,park_flags)
for index=1:length(lane)
    if(index+1<length(lane))
        cond1 = lane_Car_ID(1,index) == lane_Car_ID(1,index+1) && lane_Car_ID(1,index)~=0;
        if(cond1)
            val_1 = index;
            val_2 = index+1;
            t1 = find(val_1 == park_flags);
            t2 = find(val_2 == park_flags);
        end
    else
        cond1 = 0;
    end
    if(index-1>0)
        cond2 = lane_Car_ID(1,index-1) == lane_Car_ID(1,index) && lane_Car_ID(1,index-1)~=0;
        if(cond2)
            val_1 = index-1;
            val_2 = index;
            t1 = find(val_1 == park_flags);
            t2 = find(val_2 == park_flags);
        end
    else 
        cond2= 0;
    end
    if((cond1 || cond2))
        if(any(t1) && ~any(t2))
            bug = 1;
        elseif(any(t2) && ~any(t1))
            bug = 1;
        end
    end
end