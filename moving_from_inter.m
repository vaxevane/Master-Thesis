function [delay_signal] = moving_from_inter(left_is_red,top_is_red,hor_lane,vert_lane,intersection,sph,spv,inv)


index_hor = 1+intersection(2)-sph;
index_vert = 1+intersection(1)-spv;

len_hor = length(hor_lane);
len_vert = length(vert_lane);

if inv(1); index_hor = len_hor - index_hor + 1; hor_lane = flip(hor_lane,2); end
if inv(2); index_vert = len_vert - index_vert + 1; vert_lane = flip(vert_lane,2); end

delay_signal = 0;

if(left_is_red && vert_lane(1,index_vert)~=-1)
	delay_signal = -1;
end
if(top_is_red && hor_lane(1,index_hor)~=-1)
	delay_signal = 1;
end