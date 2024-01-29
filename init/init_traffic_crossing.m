function [full_road] = init_traffic_crossing(full_road,inter_cell,priority,inv)%varargin contains all the intersections
for i=1:length(inter_cell)
	arr = inter_cell{i};
	for j=1:length(arr)
		%STOP signs
		if(priority(i) == 1)
            if(inv(i,1))
                full_road(arr(1)-2,arr(2)+2) = 13; %horizontal spot (STOP)
            else
                full_road(arr(1)+2,arr(2)-2) = 13; %horizontal spot (STOP)
            end
% 			full_road(arr(1)-2,arr(2)-2) = -10; %vertical spot
		elseif(priority(i) == 0)
% 			full_road(arr(1)+2,arr(2)-2) = -10; %horizontal spot
            if(inv(i,2))
                full_road(arr(1)+2,arr(2)+2) = 13; %vertical spot (STOP)
            else
                full_road(arr(1)-2,arr(2)-2) = 13; %vertical spot (STOP)
            end
		end
	end
end