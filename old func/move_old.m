function[lane_cell,delay_parking_ID,ID_park,ID_max] = move_old(lane_cell,delay_parking_ID,ID_park,inverse,epoch,dec_prob,park_prob,ID_max,rt,vehicle_load,new_car_prob,new_truck_prob,en_amea,amea_sp)


if ~inverse; lane = lane_cell{1}; else, lane = flip(lane_cell{1},2); end
if ~inverse; lane_Car_ID = lane_cell{2}; else, lane_Car_ID = flip(lane_cell{2},2); end
if ~inverse; park_signals = lane_cell{3}; else, park_signals = flip(lane_cell{3},2); end
if ~inverse; park_flags = lane_cell{4}; else, park_flags = flip(lane_cell{4},2); end
if ~inverse; steps_parked = lane_cell{5}; else, steps_parked = flip(lane_cell{5},2); end

lane(:,length(lane)+1:length(lane)+10) = -1;
[d,c] = size(lane);
d=1;
park_signals(park_signals>1) = 1;%if desire bigger that 1
park_signals(park_signals<-1) = -1;%if desire bigger that 1
park_signals(:,c-9:c) = 0;
lane_Car_ID(1,c-9:c) = 0;
change_signals = zeros(d+2,c);%signals for changing laneszz

%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%INSERT CARS/TRUCKS
if(rt == 1)
	%RT new cars (replaces old way of inserting incoming cars)
	new_car = vehicle_load/(24*60*60);%creating probability for a car to appear per sec.
	if(new_car<0.1)
		new_car = 2*new_car;
		[lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = RTcars(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,epoch,ID_max,new_car);
	else
		[lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = RTcars(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,2,ID_max,new_car);
	end
elseif(rt == 0)
    %Random way of inserting incoming cars (based on a single possibility variable)
    [lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max] = insert_rand(lane,lane_Car_ID,park_signals,delay_parking_ID,ID_park,ID_max,new_car_prob,new_truck_prob);
end


temp_lane = lane;
temp_ID = lane_Car_ID;

j = c-10;
next_spot = j+1;
flag_spot = 0;
sd = 1;
while(j>=1)   
    for i=1:d
        moved = 0;
        found = 0;
        speed = temp_lane(i,j); %current speed of the car
        ID = temp_ID(i,j);%ID of each car
        %If "truck" then don't apply rules just give values 
        if(ID~=0 && ID == lane_Car_ID(i,next_spot)) %check if the newest correction works!!!!!!!
            lane(i,j) = -1;
            if (lane(i,next_spot)>3)
                lane(i,next_spot) = 3;
            end
            lane(i,next_spot-1) = lane(i,next_spot);
            lane_Car_ID(i,j) = 0;
            lane_Car_ID(i,next_spot-1) = ID;
            park_signals(i,next_spot-1) = park_signals(i,next_spot);
            if(next_spot-1 ~= j)
                park_signals(i,j) = 0;
            end
            next_spot = next_spot-1;
            if(flag_spot ~= 0)
                park_flags(sd,flag_spot-1) = next_spot;
                if(park_flags(sd,flag_spot) == 0)
                    lane(sd+1,flag_spot-1) = -1;
                    park_flags(sd,flag_spot-1) = 0;
                end
            end
            %DEBUGGING
            half_truck_flagged(lane,lane_Car_ID,park_flags)
            %DEBUGGING    
        elseif(speed>=0 && speed<6)
            if(speed<5)
                next_spot = j;
                next_speed = speed;

                %Rule 1#acceleration
                if(temp_lane(i,j+1:j+speed+1)==-1)
                    lane(i,j) = -1;
                    lane(i,j+speed) = speed + 1;
                    next_speed = lane(i,j+speed);
                    next_spot = j+speed;
                    moved = 1;
                end  
            end
          
            %Movement without acc
            if(temp_lane(i,j+1:j+speed)==-1 & (~moved))
              lane(i,j) = -1;
              lane(i,j+speed) = speed;
              next_speed = lane(i,j+speed);
              next_spot = j+speed;
              moved = 1;
            end

            %Rule 2#breaking 
            if(moved)
                if(max(temp_lane(i,j+speed+1:j+speed+next_speed))~=-1)
                    found = 0;
                    count = 0;
                    for k=j+1+speed:j+speed+next_speed
                        count = count+1;
                        if((~found)&&(temp_lane(i,k)>=0))
                            found = 1;
                            lane(i,j+speed) = count-1;
                            next_speed = count-1;
                            next_spot = j+speed;
                        end
                    end
                end
            else
                if(max(temp_lane(i,j+1:j+speed))~=-1)
                    found = 0;
                    count = 0;
                    for k=j+1:j+speed
                        count = count+1;
                        if((~found)&&(temp_lane(i,k)>=0))
                            found = 1;
                            lane(i,j) = -1;
                            lane(i,j+count-1) = 0;
                            next_speed = 0;
                            next_spot = j+count-1;
                        end
                    end
                end
            end
            if(moved || found)
              lane_Car_ID(i,j) = 0;
            end
            lane_Car_ID(i,next_spot) = ID;

            %Keeping track of the car that flagged the parking pos
            flag_spot = 0;
            for side=1:2
                spot = find(park_flags(side,:) == j);
                if(i==d & spot)
                    park_flags(side,spot) = next_spot;
                    if(j>1)
                        if(ID == lane_Car_ID(i,j-1))
                            flag_spot = spot;
                        else
                            flag_spot = 0;
                        end
                    end
                    sd = side;
                    %Stopping next to his flagged park spot
                    if(next_spot>=spot)                      
                        lane(i,spot) = 1;
                        if(rand(1)>1-park_prob)
                            lane(side+1,spot) = -1;
                            park_flags(side,spot) = 0;
                            Aspots = amea_sp(side,:);
                            if(~mod(lane_Car_ID(1,j),20) && any(Aspots-next_spot<10 & Aspots-next_spot>0) && en_amea)
                                steps_parked(side,spot) = 0;
                            end
                        else
                            park_flags(side,spot) = spot; 
                        end
                        if(spot ~= next_spot)
                            lane(i,next_spot) = -1;
                            lane_Car_ID(i,spot) = lane_Car_ID(i,next_spot);
                            lane_Car_ID(i,next_spot) = 0;
                        end
                        next_spot = spot;
                    elseif(next_spot<spot)
                        par_dis = spot-next_spot;
                        if(next_speed>2 & par_dis<=next_speed) %CHECK if needs && or & 
                            lane(i,next_spot) = next_speed-2;
                        end
                    end
                end
            end
            park_signals(i,next_spot) = park_signals(i,j);
            if(next_spot ~= j)
                park_signals(i,j) = 0;
            end
        end
    end
    j = j - 1;
end

%Rule3#random speed decrease
j = c-10;
while (j>=1)          
    for i=1:d      
        same_car = 0;
        decreased = 0;
        rand_dec = lane(i,j);
        ID = lane_Car_ID(i,j);
        %give same values to trucks (random dec,park and flash)
        if(ID ~=0 && ID == lane_Car_ID(i,j+1))
            same_car = 1;
            lane(i,j) = lane(i,j+1);
            park_signals(i,j) = park_signals(i,j+1);
            %cond1 = (lane(i+1,j) == -1 && (lane(i+1,j+1) == 0 || lane(i+1,j+1) == -2));
            %cond2 = (lane(i+2,j) == -1 && (lane(i+2,j+1) == 0 || lane(i+2,j+1) == -2));
            change_signals(i,j) = change_signals(i,j+1);
        end

        if(~same_car)
            if(rand_dec>0 && rand_dec<=5)
                if ((lane(i,j) ~= -1) && (rand(1)>1-dec_prob))
                    lane(i,j) = rand_dec-1;
                    decreased = 1;
                end
            end
            if (decreased)
                rand_dec = rand_dec-1;
            end

            %Change desire to park for all cars
            if(rand_dec>=0 && rand_dec<6 && (park_signals(i,j)<1 && park_signals(i,j)>-1))%<1 bec if he already want to park he should stay commited in order to park
			%PUT HERE DELAYING PARKING AFTER THE CAR HAS ALREADY PARKED ONCE
                if(delay_parking_ID(1,lane_Car_ID(i,j)) == 0)
                    if(park_signals(i,j)<0)
                        park_signals(i,j) = park_signals(i,j)-0.15;%was 0.2
                    else
                        park_signals(i,j) = park_signals(i,j)+0.15;%was 0.2
                    end
                end
            end
%Not needed in this simulation cause we only have a single lane            
            %Signal indication for lane change
%             if((i>1) && (rand_dec>0) && ((rand(1)*(rand_dec/5))>1-max_prob_ch_hispe))
%                 change_signals(i,j) = 1;%flashing to the left
%              elseif((i<d) && (rand_dec>0) && (rand(1)*((6-rand_dec)/5)>1-ch_slower_lane))
%                 change_signals(i,j) = -1;%flashing to the right
%             end       

            %Signal indication for cars that want to park
            if(park_signals(i,j) >= 1)
                flag = find(park_flags(2,:) == j);
                Aspots = amea_sp(2,:);
                if(rand_dec<=2)
                    if(~mod(lane_Car_ID(1,j),20))
                        
                    end
                    if(j>=2)
                        if(ID == lane_Car_ID(i,j-1))
                            %For Truck's flashing
                            if(lane(i+2,j-1:j) == -1)
                                if(flag)%If already have flag dont flash
                                    if(flag == j)
                                        change_signals(i,j) = 1;
                                    end
                                else%if not flag and have space flash
                                    %to park
                                    change_signals(i,j) = 1;
                                end
                            end
                        else
                            if(any(Aspots == j) && en_amea) %CHECK IF NEEDS EN_AMEA
                                if(~mod(lane_Car_ID(1,j),20))
                                    if(flag)
                                    %do nothing cause you have already flagged
                                    else
                                        change_signals(i,j) = 1;
                                    end
                                elseif(rand(1)>0.5 & ~flag)%MUST CHANGE IF TO IF NOT FLAG cause if has flag still will park on AMEA spot
                                    change_signals(i,j) = 1;
                                end
                            else
                                if(flag)
                                    if(flag == j)
                                        change_signals(i,j) = 1;
                                    end
                                elseif(~mod(lane_Car_ID(1,j),20) && any(Aspots-j<10 & Aspots-j>0) && en_amea)
                                %Amea car is within range of an Amea spot
                                %so do nothing
                                else %all other cars
                                    change_signals(i,j) = 1;
%                                 OLD ONE
%                                 elseif~(~mod(lane_Car_ID(1,j),20) && Aspot-j <5 && Aspot-j > 0)
%                                     %for car's flashing without flags
%                                     change_signals(i,j) = 1;     
                                end 
                            end
%                                 %for car's flashing OLD ONE
%                                 change_signals(i,j) = 1;                     
                        end
                    end
                else
                    lane(i,j) =  rand_dec - 2 ;
                end
            elseif(park_signals(i,j) <= -1)
                flag = find(park_flags(1,:) == j);
                Aspots = amea_sp(1,:);
                if(rand_dec<=2)
                    %Discard after debugging
                    if(~mod(lane_Car_ID(1,j),20))
                        
                    end
                    if(j>=2)
                        %For Truck's flashing
                        if(ID == lane_Car_ID(i,j-1))
                            if(lane(i+1,j-1:j) == -1)
                                if(flag)%If already have flag dont flash
                                    if(flag == j)
                                        change_signals(i,j) = -1;
                                    end
                                else%if not flag and have space flash
                                    %to park
                                    change_signals(i,j) = -1;
                                end
                            end
                        else
                            if(any(Aspots == j) && en_amea)
                                if(~mod(lane_Car_ID(1,j),20))
                                    if(flag)
                                    %do nothing cause you have already flagged
                                    else
                                        change_signals(i,j) = -1;
                                    end
                                elseif(rand(1)>0.5 & ~flag)
                                    change_signals(i,j) = -1;
                                end
                            else
                                if(flag)
                                    if(flag == j)
                                        change_signals(i,j) = -1;
                                    end
                                elseif(~mod(lane_Car_ID(1,j),20) && any(Aspots-j<10 & Aspots-j>0) && en_amea)
                                %Amea car is within range of an Amea spot
                                %so do nothing
                                else %all other cars
                                    change_signals(i,j) = -1;
%                                 OLD ONE
%                                 elseif~(~mod(lane_Car_ID(1,j),20) && Aspot-j <5 && Aspot-j > 0)
%                                     %for car's flashing without flags
%                                     change_signals(i,j) = -1;     
                                end    
                            end
%                                 %for car's flashing OLD ONE
%                                 change_signals(i,j) = -1;
                        end
                    end
                else
                    lane(i,j) =  rand_dec - 2 ;
                end
            end
        end
    end  
    j = j - 1;
end

%DEBUGGING
half_truck_flagged(lane,lane_Car_ID,park_flags);
%DEBUGGING
%DEBUGGING
dublicate_flags(park_flags);
%DEBUGGING

%Updating cell
if ~inverse; lane_cell = {lane(:,1:c-10),lane_Car_ID(:,1:c-10),park_signals(:,1:c-10),park_flags(:,1:c-10),...
        steps_parked(:,1:c-10),change_signals(:,1:c-10)}; else, lane_cell = {flip(lane(:,1:c-10),2),flip(lane_Car_ID(:,1:c-10),2),...
        flip(park_signals(:,1:c-10),2),flip(park_flags(:,1:c-10),2),flip(steps_parked(:,1:c-10)),flip(change_signals(:,1:c-10),2)};
end