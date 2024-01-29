function [lane,park_flags,steps_parked] = flag_incr_and_dis(d,lane,park_flags,steps_parked,dur)

for side=d+1:d+2
    %Increment the duration of each flag
    idx_dur = find(lane(side,:) == 7);
    steps_parked(side-1,idx_dur) = steps_parked(side-1,idx_dur)+1;

    %disable flag
    idx_unflag = steps_parked(side-1,:) >= dur & lane(side,:) == 7;
    lane(side,idx_unflag) = -1;
    park_flags(side-1,idx_unflag) = 0;
    steps_parked(side-1,idx_unflag) = 0;
end