function[hor,vert,left_red,top_red,cnt_left,cnt_top] = change_traffic_light(hor,vert,inter,sph,spv,max_red,thr_press,...
    cnt_left,cnt_top,d_signal)

index_h = 1+inter(2)-sph;
index_v = 1+inter(1)-spv;
%pressure of each approach
valh = 8;
valv = 8;
if(index_h < 9)% possible to have smaller number of spots before a inter
    valh = length(1:index_h)-1;
end
if(index_v < 9)
    valv = length(1:index_v)-1;
end
left_press = sum(hor(1,index_h-valh:index_h)>=0 & hor(1,index_h-valh:index_h)<6); 
top_press = sum(vert(1,index_v-valv:index_v)>=0 & vert(1,index_v-valv:index_v)<6);
if hor(1,index_h) == 6, left_red = 1;top_red = 0;else, left_red = 0;top_red = 1; end

if(d_signal~=0 || cnt_top==1 || cnt_left==1)
    %don't change the traffic lights cause a car is on top of the inter
    %the cnt are for min green lights which is 2
%max_red   
elseif(cnt_top>=max_red)
    left_red = 1;
    top_red = 0;
    hor(1,index_h) = 6; %creating obstacle for cars 
    vert(1,index_v) = -1; %free pass for the other lane
    cnt_top = 0;
elseif(cnt_left>=max_red)
    top_red = 1;
    left_red = 0;
    vert(1,index_v) = 6;
    hor(1,index_h) = -1; 
    cnt_left = 0;
else%max_pressure
    if(top_press>=thr_press)
        left_red = 1;
        top_red = 0;
        hor(1,index_h) = 6; %creating obstacle for cars 
        vert(1,index_v) = -1; %free pass for the other lane
        cnt_top = 0;
    elseif(left_press>=thr_press)
        top_red = 1;
        left_red = 0;
        vert(1,index_v) = 6;
        hor(1,index_h) = -1; 
        cnt_left = 0;
    else %biggest pressusre of the 2
%             if(top_press>left_press)
%                 left_red = 1;
%                 top_red = 0;
%                 hor_lane(1,index_h) = 6;  
%                 vert_lane(1,index_v) = -1; 
%                 count_red_top = 0;
%             elseif(left_press>top_press)
%                 top_red = 1;
%                 left_red = 0;
%                 vert_lane(1,index_v) = 6; 
%                 hor_lane(1,index_h) = -1;
%                 count_red_left = 0;
%            end    
    end
end