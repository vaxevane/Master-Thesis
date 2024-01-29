function[lane_cell,delay_parking_ID,ID_park,temp] = parking_old(lane_cell,delay_parking_ID,ID_park,inverse,en_amea,time,amea_sp)
d=1;
park_time = 1;%if 0 same parking time for all if 1 random parking time


if ~inverse; lane = lane_cell{1}; else, lane = flip(lane_cell{1},2); end
if ~inverse; lane_Car_ID = lane_cell{2}; else, lane_Car_ID = flip(lane_cell{2},2); end
if ~inverse; park_signals = lane_cell{3}; else, park_signals = flip(lane_cell{3},2); end
if ~inverse; park_flags = lane_cell{4}; else, park_flags = flip(lane_cell{4},2); end
if ~inverse; steps_parked = lane_cell{5}; else, steps_parked = flip(lane_cell{5},2); end
if ~inverse; change_signals = lane_cell{6}; else, change_signals = flip(lane_cell{6},2); end

last_park = length(lane);

%Signal indication for unparking cars
%CHANGE WITH NEW FOR TEST

%Increase time steps for each parked car
idx_dur = find(lane(d+1,:) == 0);
steps_parked(1,idx_dur) = steps_parked(1,idx_dur)+1;
idx_dur = find(lane(d+2,:) == 0);
steps_parked(2,idx_dur) = steps_parked(2,idx_dur)+1;

for side=d+1:d+2
    j = 1;
    if(park_time == 0)
        %OLD WAY
        idx_unpark = find(steps_parked(side-1,:) >= 60 & lane(side,:) == 0);
    elseif(park_time == 1)
        idx_parked = find(lane(side,:) == 0);
        idx_unpark = idx_parked(find(steps_parked(side-1,idx_parked) > ID_park(lane_Car_ID(side,idx_parked))));
    end
    
    if(side == d+1)
        flash = 1;
    elseif(side == d+2)
        flash = -1;
    end
    while j<=length(idx_unpark)
        cond1 = lane_Car_ID(side,idx_unpark(j)) == lane_Car_ID(side,idx_unpark(j)+1);
        if(cond1)
            cond2 = (lane(1,idx_unpark(j):idx_unpark(j)+1) == -1);
            cond3 = change_signals(d+1,idx_unpark(j):idx_unpark(j)+1) == 0;
        else
            cond2 = (lane(1,idx_unpark(j)) == -1);  
        end
        if(cond1 && all(cond2) && all(cond3))
            change_signals(side,idx_unpark(j):idx_unpark(j)+1) = flash;
        elseif(~cond1)
            change_signals(side,idx_unpark(j)) = flash;
        end
        if(cond1)
            j = j + 2;
        else
            j = j + 1;
        end
        
    end
end


%DEBUGGING
half_truck_flagged(lane,lane_Car_ID,park_flags);
%DEBUGGING
%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%Increment the duration of each flag and disable flag
idx_dur = find(lane(d+1,:) == 7);
steps_parked(d,idx_dur) = steps_parked(d,idx_dur)+1;
idx_dur = find(lane(d+2,:) == 7);
steps_parked(d+1,idx_dur) = steps_parked(d+1,idx_dur)+1;

idx_unflag = steps_parked(d,:) >= 5*60 & lane(d+1,:) == 7;
park_flags(d,idx_unflag) = 0;
lane(d+1,idx_unflag) = -1;
steps_parked(d,idx_unflag) = 0;

idx_unflag = steps_parked(d+1,:) >= 5*60 & lane(d+2,:) == 7;
park_flags(d+1,idx_unflag) = 0;
lane(d+2,idx_unflag) = -1;
steps_parked(d+1,idx_unflag) = 0;

%Decreasing delay for cars that have already parked once
idx_red_delay = find(delay_parking_ID > 0);
if(idx_red_delay)
    if(find(ismember(lane_Car_ID,idx_red_delay)))
        idx_dec = lane_Car_ID(find(ismember(lane_Car_ID,idx_red_delay)));
        delay_parking_ID(idx_dec) = delay_parking_ID(idx_dec) - 1;
    end
end


%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING


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
                        cond_amea = all(se_sp ~= amea_sp(side-1,:)-1) && all(se_sp ~= amea_sp(side-1,:));
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

%if ~inverse; temp = lane; else, temp = flip(lane,2); end
temp = lane;
temp(d+1,find(lane(d+1,:)==0)) = 9;%Parked cars value for draw (lower Side)
temp(d+2,find(lane(d+2,:)==0)) = 9;%Parked cars value for draw (upper Side)
%Parking AMEA
if(en_amea == 1) %Amea on lower Side
    temp_amea = amea_sp(1,:);
    %Find searches for the amea pos that aren't occupied inorder to show
    %them with the amea symbol
    if any(lane(d+1,temp_amea(temp_amea>0))==-1); temp(d+1,temp_amea(find(lane(d+1,temp_amea(temp_amea>0))==-1))) = -4;end
elseif(en_amea == 2) %Amea on upper Side
    temp_amea = amea_sp(2,:);
    if any(lane(d+2,temp_amea(temp_amea>0))==-1); temp(d+2,temp_amea(find(lane(d+2,temp_amea(temp_amea>0))==-1))) = -4;end
elseif(en_amea == 3) %Amea on both Sides
    temp_amea1 = amea_sp(1,:);
    temp_amea2 = amea_sp(2,:);
    if any(lane(d+1,temp_amea1(temp_amea1>0))==-1); temp(d+1,temp_amea1(find(lane(d+1,temp_amea1(temp_amea1>0))==-1))) = -4;end
    if any(lane(d+2,temp_amea2(temp_amea2>0))==-1); temp(d+2,temp_amea2(find(lane(d+2,temp_amea2(temp_amea2>0))==-1))) = -4;end
end


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

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%Putting flag
for side=d+1:d+2
    if (side == d+1)
        idx_park = find(park_signals(d,1:last_park)<=-1);
    else
        idx_park = find(park_signals(d,1:last_park)>=1);
    end        
    exclude_already_flagged = park_flags(side-1,find(park_flags(side-1,:)~=0));
    park_spot = lane(side,idx_park) == -1; %empty parking spots
    park_temp = idx_park(~park_spot); %TEST
    park_temp = setdiff(idx_park,exclude_already_flagged);
    
    %Put flag for cars that didnt find parking right next to them
    s = 1;
    while (s<=length(park_temp))
        %conditions for giving trucks park_flags
        if(park_temp(s)+1<length(lane))%ENABLE AGAIN FOR TRUCK FLAGS (STILL HAVENT RESOLVED BUG)
            cond1 = lane_Car_ID(1,park_temp(s)) == lane_Car_ID(1,park_temp(s)+1);
        else
            cond1 = 0;
        end
        if(park_temp(s)-1>0)
            cond2 = lane_Car_ID(1,park_temp(s)-1) == lane_Car_ID(1,park_temp(s));
        else 
            cond2= 0;
        end
        temp_idx = [];
        %Park_flags for trucks
        if(cond1 || cond2)
            if cond1, value = park_temp(s);else, value = park_temp(s)-1;end
            flag_vector = value:value+1;
            fou = 0;
            for se_sp = park_temp(s)+1:length(lane)
                if(~fou && lane(side,se_sp) == -1 && lane(side,se_sp+1) == -1 && all(se_sp ~= amea_sp(side-1,:)-1) && all(se_sp ~= amea_sp(side-1,:)))
                    fou=1;
                    temp_idx=se_sp:se_sp+1;
                end
            end
            %DEBUGGING
            %half_truck_flagged(lane,lane_Car_ID,park_flags);
            %DEBUGGING
            if(cond1 & find(park_temp == park_temp(s)+1,1))
                s = s + 1;
            end
        %Park_flags for cars    
        else
            search_space = 1;
            search_area = lane(side,park_temp(s)+1:end) == -1;
            flag_vector = park_temp(s);
            %AMEA Spot
            Aspot = 0;
            Acond = Aspot > flag_vector;
            fou = 0;
            k = 0;
            l = sum(amea_sp(side-1,:)~= 0);
            %finding the nearest AMEA spot (if it exists)
            while(~fou && k<l && en_amea ~= 0)
                if (en_amea == 1 && side == d+1)
                    Aspot = amea_sp(1,k+1);
                elseif(en_amea == 2 && side == d+2)
                    Aspot = amea_sp(2,k+1);
                elseif(en_amea == 3)
                    Aspot = amea_sp(side-1,k+1);
                end
                Acond = Aspot > flag_vector;
                if(Acond)
                    fou = 1;
                    dir = side-1;
                end
                k = k + 1;
            end
            
            if(Acond && mod(lane_Car_ID(1,flag_vector),20))%flag for regular cars
                temp_a = amea_sp(dir,:);
                temp_a = temp_a(temp_a>0);     
                search_area(temp_a(k:end)-flag_vector) = 0;%excluding flag posibility for amea spot
                temp_idx = find(search_area,search_space)+park_temp(s);
            elseif(Acond && ~mod(lane_Car_ID(1,flag_vector),20) && Aspot-flag_vector < 10 && lane(side,Aspot) ~= 0)
                temp_idx = Aspot;%flag for amea
            else
                temp_idx = find(search_area,search_space)+park_temp(s);
            end
        end
        [~,g]=size(temp_idx);
        if(g ~= 0)
            park_flags(side-1,temp_idx) =  flag_vector;%Reserving spot for the particular car
        end
        temp(side,temp_idx) = 7;
        lane(side,temp_idx) = 7;
        s = s + 1;
        %DEBUGGING
        dublicate_flags(park_flags);
        %DEBUGGING
    end
end

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING


%Updating cell
if inverse; temp = flip(temp,2); end
if ~inverse; lane_cell = {lane,lane_Car_ID,park_signals,park_flags,steps_parked,...
        change_signals}; else, lane_cell = {flip(lane,2),flip(lane_Car_ID,2),...
        flip(park_signals,2),flip(park_flags,2),flip(steps_parked,2),flip(change_signals,2)}; 
end