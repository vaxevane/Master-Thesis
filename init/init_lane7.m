function [lane,Car_ID,park_signals,park_flags,steps_parked,ls_car] = init_lane7(d,size,sp,cars,ls_car,en,f_p,f_v,oneside,varargin)
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
i = 1;
while i <= 2
    j = 1;
    if(en)
        par_slots(i,f_p:f_p+f_v-1) = -1;          
    end
    while j<= length(varargin)
        inter = varargin{j};
        start = 1+inter-sp+varargin{j+1};
        fin = 1+inter-sp+varargin{j+2};
        par_slots(i,start:fin) = -1;
        j = j + 3;
    end
    lane(i+1,:) = par_slots(i,:);
    if(oneside)
        lane(i+2,:) = par_slots(i+1,:);
        i = i + 1;
    end
    i = i + 1;
end

park_signals = zeros(d,size);
park_flags = zeros(2,size);

park_signals(1,index_lane) = (rand(1,cars)/2)-0.2;