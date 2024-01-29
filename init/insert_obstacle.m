function varargout = insert_obstacle(varargin)%varargin will have all vert lanes and all intersections that cross them
i = 1;
val = 1;
while i<=length(varargin)
	road = varargin{i};%pick the road
    road_park_signals = varargin{i+1};
    road_ID = varargin{i+2};
	inter_arr = varargin{i+3};%put all the spots that vert has intersections
    spoint = varargin{i+4};
    j = 1;
    while j <= length(inter_arr)
        if(inter_arr(j+1) == 0)
            ind = inter_arr(j)-spoint+1;
            if(road(1,ind) ~= -1)
                road_park_signals(ind) = 0;
                road_ID(1,ind) = 0;
            end
            road(1,ind) = 6;
        end
        j = j + 2;
    end
    varargout{val} = road;
    varargout{val+1} = road_park_signals;
    varargout{val+2} = road_ID;
    val = val + 3;
	i = i + 5;
end