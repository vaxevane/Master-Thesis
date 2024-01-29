function road = switch_traffic_lights(road,top_red,left_red,cnt_top,cnt_left,max_red,intersections)

for i=1:length(intersections)
	inter = intersections{i};
    
    if(cnt_top(i)>=max_red-1)
%         road(inter(1)-2,inter(2)+2) = 12; %ORANGE 
        road(inter(1)+2,inter(2)-2) = 12; %ORANGE
    elseif (left_red(i)==1)
        road(inter(1)+2,inter(2)-2) = 10;%RED
    else
        road(inter(1)+2,inter(2)-2) = 11; %GREEN
    end    

      

    if(cnt_left(i)>=max_red-1)
        road(inter(1)-2,inter(2)+2) = 12; %ORANGE 
%        road(inter(1)+2,inter(2)-2) = 12; %ORANGE
    elseif (top_red(i)==1)
    road(inter(1)-2,inter(2)+2) = 10;%RED
    else
        road(inter(1)-2,inter(2)+2) = 11; %GREEN
    end  
%     if (left_red(i)==1)
%         if(cnt_left(i)>=max_red-1)
%             road(inter(1)+2,inter(2)-2) = 12; %ORANGE 
%         else
%             road(inter(1)+2,inter(2)-2) = 10; %RED
%         end
%     else
%         road(inter(1)+2,inter(2)-2) = 11; %GREEN
%     end 
end