function new_car =  vehicle_distribution(load,season,time)

%Vehicle load percentages per hour
if season == 's'; very_low = 0.95; elseif season == 'w'; very_low = 0.558;  end
if season == 's'; low = 3.36; elseif season == 'w'; low = 3.04;  end 
if season == 's'; medium = 4.13; elseif season == 'w'; medium =  4.4; end
if season == 's'; high = 5.9; elseif season == 'w'; high = 5.7;  end
if season == 's'; very_high = 7.05; elseif season == 'w'; very_high =  6.69; end

%Range of hours for each percentage
if(season == 's')
	if(time >= 0 && time < 6*60*60)
		new_car = (load*very_low)/(100*60*60);
	elseif((time >= 6*60*60 && time <= 9*60*60) || (time >= 22*60*60 && time < 24*60*60))
		new_car = (load*low)/(100*60*60);
	elseif(time >= 9*60*60 && time < 15*60*60)
		new_car = (load*very_high)/(100*60*60);
	elseif(time >= 15*60*60 && time < 18*60*60)
		new_car = (load*medium)/(100*60*60);
	elseif(time >= 18*60*60 && time < 22*60*60)
		new_car = (load*high)/(100*60*60);
	end
elseif(season == 'w')
    if(time >= 0 && time < 6*60*60)
		new_car = (load*very_low)/(100*60*60);
	elseif((time >= 6*60*60 && time <= 8*60*60) || (time >= 21*60*60 && time < 24*60*60))
		new_car = (load*low)/(100*60*60);
	elseif(time >= 8*60*60 && time < 16*60*60)
		new_car = (load*very_high)/(100*60*60);
	elseif(time >= 16*60*60 && time < 17*60*60)
		new_car = (load*medium)/(100*60*60);
	elseif(time >= 17*60*60 && time < 21*60*60)
		new_car = (load*high)/(100*60*60);
    end
end
