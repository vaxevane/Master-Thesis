function [lane,Car_ID,park_signals,park_flags,steps_parked,ls_car] = init_lane5(d,size,sp,cars,ls_car,en,f_p_down,f_v_down,f_p_up,f_v_up,varargin)
lane = -ones(d,size);

index_lane = randsample(size-10,cars)';%random car positions
lane(1,index_lane) = randi([0 5],1,cars);

%Unique car ID
Car_ID = zeros(d+2,size);
Car_ID(1,sort(index_lane,'descend')) = 1+ls_car:ls_car+cars;
%ID_park probably should be put here
%delay_Id park here. It start with all zeros then after parking and unparking gets random value
ls_car = ls_car + cars;%Update last car ID for the next lane init


%Parking Init for lane
par_slots = zeros(2,size);
steps_parked = zeros(2,size);%how many time steps each car has stayed parked
par_slots(1:2,:) = -2;

if(en == 2)
    par_slots(1,f_p_down:f_p_down+f_v_down-1) = -1;
    par_slots(2,f_p_up:f_p_up+f_v_up-1) = -1;
elseif(en == 1)
    par_slots(1,f_p_down:f_p_down+f_v_down-1) = -1;
end
j = 1;
while j<= length(varargin)
    inter = varargin{j};
    side = varargin{j+1};
    start = 1+inter-sp+varargin{j+2};
    fin = 1+inter-sp+varargin{j+3};
    %parking slots
    par_slots(1,start:fin) = -1;
    if(side == 2)
        fin_up = 1+inter-sp+varargin{j+4};
        par_slots(2,start:fin_up) = -1;
        j = j + 5;
    elseif(side == 1)%only one side(down)
        j = j + 4;
    end
end
lane(2:3,:) = par_slots;


park_signals = zeros(d,size);
park_flags = zeros(2,size);

park_signals(1,index_lane) = (rand(1,cars)/2)-0.2;