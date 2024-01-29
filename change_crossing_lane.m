function[prim_lane,sec_lane,prim_red,sec_red,cnt_prim,cnt_sec] = change_crossing_lane(prim,hor,vert,inter,sph,spv,max_cross,...
    thr_press,cnt_left,cnt_top,d_signal,inv)

if inv(1), hor = flip(hor,2); end
if inv(2), vert = flip(vert,2); end

len_hor = length(hor);
len_vert = length(vert);

%THIS PART WENT INSIDE IF PRIM
% if inv(1), inter(2) = len_hor - inter(2) + 1; end
% if inv(2), inter(1) = len_vert - inter(1) + 1; end

if(prim == 1)
	index_prim = 1+inter(2)-sph; %hor lane is primary
	index_sec = 1+inter(1)-spv; %vert lane is secondary
    if inv(1), index_prim = len_hor - index_prim + 1; end
    if inv(2), index_sec = len_vert - index_sec + 1; end
	prim_lane = hor;
	sec_lane = vert;
	cnt_prim = cnt_left;
	cnt_sec = cnt_top;
elseif(prim == 2)
	index_prim = 1+inter(1)-spv; %vert lane is primary
	index_sec = 1+inter(2)-sph; %hor lane is secondary
    if inv(2), index_prim = len_vert - index_prim + 1; end
    if inv(1), index_sec = len_hor - index_sec + 1; end
	prim_lane = vert;
	sec_lane = hor;
	cnt_prim = cnt_top;
	cnt_sec = cnt_left;
end
%pressure of secondary lane
valsec = 8;
if(index_sec < 9)
   valsec = length(1:index_sec)-1;
end
check_index_prim = index_prim-5:index_prim-1;
check_index_sec = index_sec-2:index_sec-1;%In order to always give priority to the primary lane
if(index_sec < 3)
    check_index_sec = 1:index_sec-1;
end
if(index_prim < 6)
    check_index_prim = 1:index_prim-1;
end

sec_press = sum(sec_lane(1,index_sec-valsec:index_sec)>=0 & sec_lane(1,index_sec-valsec:index_sec)<6);
if prim_lane(1,index_prim) == 6, prim_red = 1;sec_red = 0;else, prim_red = 0;sec_red = 1; end

if(d_signal ~= 0 || cnt_prim == 1 || cnt_sec == 1)
    %don't change the traffic lights cause a car is on top of the inter
    %the cnt are for min green lights which is 2
elseif(all(prim_lane(1,check_index_prim) < 0 & ~all(sec_lane(1,check_index_sec) < 0)) || (cnt_sec >= max_cross) || (sec_press >= thr_press))
	prim_red = 1;
	sec_red = 0;
	prim_lane(1,index_prim) = 6; %creating obstacle for cars 
    sec_lane(1,index_sec) = -1; %free pass for the other lane
    cnt_sec = 0;
else
	sec_red = 1;
	prim_red = 0;	 
    sec_lane(1,index_sec) = 6; %free pass for the other lane
	prim_lane(1,index_prim) = -1; %creating obstacle for cars
    cnt_prim = 0;
end

% if(inv(1))
%     if(prim == 1)
%         prim_lane = flip(prim_lane,2);
%     elseif(prim == 2)
%         sec_lane = flip(sec_lane,2);
%     end
% end
% if(inv(2))
%     if(prim == 2)
%         prim_lane = flip(prim_lane,2);
%     elseif(prim == 1)
%         sec_lane = flip(sec_lane,2);
%     end
% end
cond_prim = [1 2];
for i=1:2
    if(inv(i))
        if(prim == cond_prim(1))
            prim_lane = flip(prim_lane,2);
        elseif(prim == cond_prim(2))
            sec_lane = flip(sec_lane,2);
        end
    end
    cond_prim = circshift(cond_prim,1);
end