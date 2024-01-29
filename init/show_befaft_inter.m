function [full_road] = show_befaft_inter(full_road,varargin)%varargin will have all hor lanes and all intersections that cross them
i = 1;
while i<=length(varargin)
	road = varargin{i};%pick the road
	inter_arr = varargin{i+1};%put all the spots that hor has intersections
    spoint = varargin{i+2};
    j = 1;
    while j <= length(inter_arr)-1
        ind = inter_arr(j+1)-spoint+1;
        full_road(inter_arr(1),inter_arr(j+1)-1) = road(1,ind-1);
        full_road(inter_arr(1),inter_arr(j+1)+1) = road(1,ind+1);
        j = j + 1;
    end
	i = i + 3;
end