function [full_road] = init_bound(full_road,len,varargin)%varargin will have all the intersections
%each inter will have a array with a 0 on the dim not used and the value on the other for ex.[0 val] or [val 0]
%if[val 0] then the init is full_road(val,:) if [0 val] then full_road(:,val)

for i=1:length(varargin)
	arr = varargin{i};
	for j=1:length(arr)
		%Boundaries
		if(arr(j) ~= 0 && j == 1)
			full_road(arr(1)-2,1:len(i)) = -2;
			full_road(arr(1)+2,1:len(i)) = -2;
		elseif(arr(j) ~= 0 && j == 2)
			full_road(1:len(i),arr(2)-2) = -2;
			full_road(1:len(i),arr(2)+2) = -2;
		end
	end
end