function [lane,park,change] = reduce_speed_signaling(d,cond_amea_flag,lane,Car_ID,park,flags,change,delay,dec_prob,amea_freq,amea,en_amea)


%Rule3#random speed decrease
j = cond_amea_flag-10;
while (j>=1)          
    for i=1:d      
        same_car = 0;
        decreased = 0;
        rand_dec = lane(i,j);
        ID = Car_ID(i,j);
        %give same values to trucks (random dec,park and flash)
        if(ID ~=0 && ID == Car_ID(i,j+1))
            same_car = 1;
            lane(i,j) = lane(i,j+1);
            park(i,j) = park(i,j+1);
            %cond1 = (lane(i+1,j) == -1 && (lane(i+1,j+1) == 0 || lane(i+1,j+1) == -2));
            %cond2 = (lane(i+2,j) == -1 && (lane(i+2,j+1) == 0 || lane(i+2,j+1) == -2));
            change(i,j) = change(i,j+1);
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
            if(rand_dec>=0 && rand_dec<6 && (park(i,j)<1 && park(i,j)>-1))%<1 bec if he already want to park he should stay commited in order to park
			%PUT HERE DELAYING PARKING AFTER THE CAR HAS ALREADY PARKED ONCE
                if(delay(1,Car_ID(i,j)) == 0)
                    if(park(i,j)<0)
                        park(i,j) = park(i,j)-0.15;%was 0.2
                    else
                        park(i,j) = park(i,j)+0.15;%was 0.2
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
            if(park(i,j) >= 1)
                flag = find(flags(2,:) == j);
                Aspots = amea(2,:);
                if(rand_dec<=2)
                    if(j>=2)
                        if(ID == Car_ID(i,j-1))
                            %For Truck's flashing
                            if(lane(i+2,j-1:j) == -1)
                                if(flag)%If already have flag dont flash
                                    if(flag == j)
                                        change(i,j) = 1;
                                    end
                                else%if not flag and have space flash
                                    %to park
                                    change(i,j) = 1;
                                end
                            end
                        else
                            if(any(Aspots == j) && en_amea) %CHECK IF NEEDS EN_AMEA
                                if(~mod(Car_ID(1,j),amea_freq))
                                    if(flag)
                                    %do nothing cause you have already flagged
                                    else
                                        change(i,j) = 1;
                                    end
                                elseif(rand(1)>0.5 & ~flag)%MUST CHANGE IF TO IF NOT FLAG cause if has flag still will park on AMEA spot
                                    change(i,j) = 1;
                                end
                            else
                                withinrange = Aspots-j<10 & Aspots-j>0;
                                cond_amea_flag = lane(i+2,Aspots(find(withinrange,1))) ~= 0;
                                if(flag)
                                    if(flag == j)
                                        change(i,j) = 1;
                                    end
                                elseif(~mod(Car_ID(1,j),amea_freq) && any(cond_amea_flag) && en_amea)
                                %Amea car is within range of an Amea spot
                                %so do nothing
                                else %all other cars
                                    change(i,j) = 1;
%                                 OLD ONE
%                                 elseif~(~mod(lane_Car_ID(1,j),amea_freq) && Aspot-j <5 && Aspot-j > 0)
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
            elseif(park(i,j) <= -1)
                flag = find(flags(1,:) == j);
                Aspots = amea(1,:);
                if(rand_dec<=2)
                    if(j>=2)
                        %For Truck's flashing
                        if(ID == Car_ID(i,j-1))
                            if(lane(i+1,j-1:j) == -1)
                                if(flag)%If already have flag dont flash
                                    if(flag == j)
                                        change(i,j) = -1;
                                    end
                                else%if not flag and have space flash
                                    %to park
                                    change(i,j) = -1;
                                end
                            end
                        else
                            if(any(Aspots == j) && en_amea)
                                if(~mod(Car_ID(1,j),amea_freq))
                                    if(flag)
                                    %do nothing cause you have already flagged
                                    else
                                        change(i,j) = -1;
                                    end
                                elseif(rand(1)>0.5 & ~flag)
                                    change(i,j) = -1;
                                end
                            else
                                withinrange = Aspots-j<10 & Aspots-j>0;
                                cond_amea_flag = lane(i+1,Aspots(find(withinrange,1))) ~= 0;
                                if(flag)
                                    if(flag == j)
                                        change(i,j) = -1;
                                    end
                                elseif(~mod(Car_ID(1,j),amea_freq) && any(cond_amea_flag) && en_amea)
                                %Amea car is within range of an Amea spot
                                %so do nothing
                                else %all other cars
                                    change(i,j) = -1;
%                                 OLD ONE
%                                 elseif~(~mod(lane_Car_ID(1,j),amea_freq) && Aspot-j <5 && Aspot-j > 0)
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