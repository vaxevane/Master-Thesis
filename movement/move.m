function [lane,Car_ID,signals,flags,steps] = move(d,c,lane,Car_ID,signals,flags,steps,park_prob,amea_freq,amea,en_amea)


temp_lane = lane;
temp_ID = Car_ID;

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
        if(ID~=0 && ID == Car_ID(i,next_spot)) %check if the newest correction works!!!!!!!
            lane(i,j) = -1;
            if (lane(i,next_spot)>3)
                lane(i,next_spot) = 3;
            end
            lane(i,next_spot-1) = lane(i,next_spot);
            Car_ID(i,j) = 0;
            Car_ID(i,next_spot-1) = ID;
            signals(i,next_spot-1) = signals(i,next_spot);
            if(next_spot-1 ~= j)
                signals(i,j) = 0;
            end
            next_spot = next_spot-1;
            if(flag_spot ~= 0)
                flags(sd,flag_spot-1) = next_spot;
                if(flags(sd,flag_spot) == 0)
                    lane(sd+1,flag_spot-1) = -1;
                    flags(sd,flag_spot-1) = 0;
                end
            end
            %DEBUGGING
            half_truck_flagged(lane,Car_ID,flags)
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
              Car_ID(i,j) = 0;
            end
            Car_ID(i,next_spot) = ID;

            %Keeping track of the car that flagged the parking pos
            flag_spot = 0;
            for side=1:2
                spot = find(flags(side,:) == j);
                if(i==d & spot)
                    flags(side,spot) = next_spot;
                    if(j>1)
                        if(ID == Car_ID(i,j-1))
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
                            flags(side,spot) = 0;
                            Aspots = amea(side,:);
                            if(~mod(Car_ID(1,j),amea_freq) && any(Aspots-next_spot<10 & Aspots-next_spot>0) && en_amea)
                                steps(side,spot) = 0;
                            end
                        else
                            flags(side,spot) = spot; 
                        end
                        if(spot ~= next_spot)
                            lane(i,next_spot) = -1;
                            Car_ID(i,spot) = Car_ID(i,next_spot);
                            Car_ID(i,next_spot) = 0;
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
            signals(i,next_spot) = signals(i,j);
            if(next_spot ~= j)
                signals(i,j) = 0;
            end
        end
    end
    j = j - 1;
end