function [lane,park_flags,steps_parked,change_signals] = flag_steal(d,lane,lane_Car_ID,park_signals,park_flags,steps_parked,change_signals,last_park,time,amea_sp)

%cars that haven't acquired the flag system
for side=d+1:d+2
    if (side == d+1)
        idx_park = find(park_signals(d,1:last_park)<=-1);
        flash = -1;
    else
        idx_park = find(park_signals(d,1:last_park)>=1);
        flash = 1;
    end
    exclude_already_flagged = park_flags(side-1,find(park_flags(side-1,:)~=0));
    park_spot = lane(side,idx_park) == 7;
    park_temp = idx_park(park_spot);
    park_temp = setdiff(park_temp,exclude_already_flagged);
    for s=1:length(park_temp)
    %if it's true the car steals the flagged position
        if(1)
            %conditions in order to let some trucks steal flag pos
            cond1 = (lane_Car_ID(1,park_temp(s)) == lane_Car_ID(1,park_temp(s)+1) && lane(side,park_temp(s)+1)~=0 && lane(side,park_temp(s)+1)~=-2);
            cond2 = (lane_Car_ID(1,park_temp(s)) == lane_Car_ID(1,park_temp(s)-1) && lane(side,park_temp(s)-1)~=0 && lane(side,park_temp(s)-1)~=-2);
            cond3 = (lane_Car_ID(1,park_temp(s)) ~= lane_Car_ID(1,park_temp(s)-1) && lane_Car_ID(1,park_temp(s)) ~= lane_Car_ID(1,park_temp(s)+1));
            if(cond2 && park_flags(side-1,park_temp(s)-1) ~= 0)
                search_val = park_temp(s) - 1;
            else
                search_val = park_temp(s);
            end
            %find the new indexes for the cars who had already flagged
            mask = find(park_flags(side-1,:)~=0);
            mask = mask(find(mask == search_val):end);
            %taking the flags of the car and after
            exclude_already_flagged = park_flags(side-1,find(park_flags(side-1,:)~=0));
            moving_flags = exclude_already_flagged(find(exclude_already_flagged == park_flags(side-1,search_val)):end);
            %find if prev. index is a part of a truck in order to move it along
            if((~isempty(moving_flags)) && moving_flags(1) > 1)
                if(lane_Car_ID(1,moving_flags(1)) == lane_Car_ID(1,moving_flags(1)-1))
                    mask(length(mask)+1) = 0;
                    mask = circshift(mask,1);
                    mask(1) = mask(2)-1;
                    moving_flags(length(moving_flags)+1) = 0;
                    moving_flags = circshift(moving_flags,1);
                    moving_flags(1) = moving_flags(2)-1;
                end
            end
            park_flags(side-1,mask) = 0;
            lane(side,mask) = -1;
            %Showing the spot/s that is taken is unavailable
            if(cond1)                    
                lane(side,park_temp(s):park_temp(s)+1) = 0;
            elseif(cond2)
                lane(side,park_temp(s)-1:park_temp(s)) = 0;
            elseif(cond3)          
                lane(side,park_temp(s)) = 0;
            end
            re = 1;
            %Searching new flags for the cars that had already put flags
            while (re<=length(mask))
                new_flag = [];
                if(lane_Car_ID(1,moving_flags(re)) == lane_Car_ID(1,moving_flags(re)+1))
                    fou = 0;
                    for se_sp = mask(re):length(lane)-1
                        cond_empty = lane(side,se_sp) == -1 && lane(side,se_sp+1) == -1;
                        cond_amea = all(se_sp ~= amea_sp(side-1,:)-1) && all(se_sp ~= amea_sp(side-1,:));%exclude amea spots from re-flagging
                        cond_flash = change_signals(1,se_sp) ~= flash && change_signals(1,se_sp+1) ~= flash;
                        if(~fou && cond_empty && cond_amea && cond_flash)
                            fou = 1;
                            new_flag = se_sp:se_sp+1;
                            moving_flag_vector = moving_flags(re):moving_flags(re)+1;                                         
                        end
                    end
                    if(~isempty(new_flag))
                        if(any(new_flag ~= mask(re):mask(re)+1))
                            steps_parked(side-1,mask(re):mask(re)+1) = 0;
                            steps_parked(side-1,new_flag) = 0;
                        end
                    else
                        steps_parked(side-1,mask(re):mask(re)+1) = 0;
%                         if(cond1 || cond2 || cond3) %FIXED WITHOUT IF
%                             steps_parked(side-1,mask(re):mask(re+1)) = 0;
%                         end
                    end
                    re = re + 1;
                else
                    cond_flash = change_signals(1,:) ~= flash;
                    cond_flash(mask(re)) = 1;%Maybe the car's already parking
                    cond_empty = find(lane(side,mask(re):end)==-1) +mask(re)-1;
                    cond_empty = setdiff(cond_empty,amea_sp(side-1,:));%exclude amea spots from re-flagging
                    spots = cond_flash(cond_empty);
                    new_flag = cond_empty(find(spots == 1,1));
                    moving_flag_vector = moving_flags(re);
                    if(new_flag ~= mask(re))
                        steps_parked(side-1,mask(re)) = 0;
                        steps_parked(side-1,new_flag) = 0;
                    end
                end
                if(new_flag<=last_park)
                    park_flags(side-1,new_flag) = moving_flag_vector;
                    lane(side,new_flag) = 7;
                    if(any(new_flag~=mask(re)))
%                         side
%                         time
%                         fprintf ('Someone took your parking spot move to new spot:%d \n',new_flag);
                    end
                else
%                     fprintf ('Unfortunately someone took your parking spot and we cant find new pos near\n');
                end
                re = re + 1;
            end
            %Returning in it to -1 in order to let the car the car that stole the flag park
            %Showing the spot that is taken is available for the car
            if(cond1)                    
                lane(side,park_temp(s):park_temp(s)+1) = -1;
                change_signals(1,park_temp(s):park_temp(s)+1) =  flash;
            elseif(cond2)  
                lane(side,park_temp(s)-1:park_temp(s)) = -1;
                change_signals(1,park_temp(s)-1:park_temp(s)) =  flash;
            elseif(cond3)                
                lane(side,park_temp(s)) = -1;
                change_signals(1,park_temp(s)) = flash;
            end
        end
    end
end
