function [temp] = init_temp(d,lane,amea_sp,en_amea)

%if ~inverse; temp = lane; else, temp = flip(lane,2); end %don't know if
%its useful
temp = lane;
temp(d+1,find(lane(d+1,:)==0)) = 9;%Parked cars value for draw (lower Side)
temp(d+2,find(lane(d+2,:)==0)) = 9;%Parked cars value for draw (upper Side)
%Parking AMEA
if(en_amea == 1) %Amea on lower Side
    temp_amea = amea_sp(1,:);
    %Find searches for the amea pos that aren't occupied inorder to show
    %them with the amea symbol
    if any(lane(d+1,temp_amea(temp_amea>0))==-1); temp(d+1,temp_amea(find(lane(d+1,temp_amea(temp_amea>0))==-1))) = -4;end
elseif(en_amea == 2) %Amea on upper Side
    temp_amea = amea_sp(2,:);
    if any(lane(d+2,temp_amea(temp_amea>0))==-1); temp(d+2,temp_amea(find(lane(d+2,temp_amea(temp_amea>0))==-1))) = -4;end
elseif(en_amea == 3) %Amea on both Sides
    temp_amea1 = amea_sp(1,:);
    temp_amea2 = amea_sp(2,:);
    if any(lane(d+1,temp_amea1(temp_amea1>0))==-1); temp(d+1,temp_amea1(find(lane(d+1,temp_amea1(temp_amea1>0))==-1))) = -4;end
    if any(lane(d+2,temp_amea2(temp_amea2>0))==-1); temp(d+2,temp_amea2(find(lane(d+2,temp_amea2(temp_amea2>0))==-1))) = -4;end
end