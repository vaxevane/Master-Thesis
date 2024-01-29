function [full_road] = copying_steps(full_road,varargin)%varargin will have all roads and all intersections
i = 1;
while i<=length(varargin)
	road = varargin{i};
	[~,s] = size(road);
    inter = varargin{i+1};
    spoint = varargin{i+2};
    if(inter(1)~= 0)
        full_road(inter(1)-1,spoint:spoint+s-1) = road(2,:);
        full_road(inter(1)+1,spoint:spoint+s-1) = road(1,:);
    else
        full_road(spoint:spoint+s-1,inter(2)+1) = road(2,:)';
        full_road(spoint:spoint+s-1,inter(2)-1) = road(1,:)';
    end
	i = i + 3;
end