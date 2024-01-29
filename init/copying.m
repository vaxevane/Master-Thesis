function [full_road] = copying(full_road,varargin)%varargin will have all roads and all intersections
i = 1;
while i<=length(varargin)
	road = varargin{i};
	[~,s] = size(road);
    start_point = varargin{i+1};
    inter = varargin{i+2};
    if(inter(1)~= 0)
        full_road(inter(1)-1,start_point:start_point+s-1) = road(3,:);
        full_road(inter(1),start_point:start_point+s-1) = road(1,:);
        full_road(inter(1)+1,start_point:start_point+s-1) = road(2,:);
    else
        full_road(start_point:start_point+s-1,inter(2)+1) = road(3,:)';
        full_road(start_point:start_point+s-1,inter(2)) = road(1,:)';
        full_road(start_point:start_point+s-1,inter(2)-1) = road(2,:)';
    end
	i = i + 3;
end