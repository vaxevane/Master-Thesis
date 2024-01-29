function [full_road] = init_traffic_light(full_road,inter_cell)%varargin contains the intersections
for i=1:length(inter_cell)
	arr = inter_cell{i};
	for j=1:length(arr)
		%Traffic Lights
		full_road(arr(1)+2,arr(2)-2) = 11;
		full_road(arr(1)-2,arr(2)+2) = 10;
	end
end