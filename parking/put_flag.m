function [lane,temp,park_flags] = put_flag(d,lane,temp,lane_Car_ID,park_signals,park_flags,last_park,amea_freq,amea_sp,en_amea)

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
        if(park_temp(s)+1<length(lane))
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
            half_truck_flagged(lane,lane_Car_ID,park_flags);
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
            
            if(Acond && mod(lane_Car_ID(1,flag_vector),amea_freq))%flag for regular cars
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