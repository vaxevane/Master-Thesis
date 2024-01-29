 function vargout = main(focus,savefolder,cell_size,prev,max_epoch,per,with_traffic_signals,season,varargin)
mkdir (savefolder);

addpath('./init/');
addpath('./copying_roads/');
addpath('./movement/');
addpath('./parking');
addpath('./debug_func/');


rt_cpdsummer = [11026 8059 5099 4944]; %real time values for one (summer) day 
rt_cpdwinter = [11059 7765 5410 4444]; %real time values for one (winter) day

rt_cpdsummer = [3000 4727 2884 4000 4944 5099 2000 2884 3200 8059 11026 11000 1500]; %real time values for one (summer) day 
rt_cpdwinter = [3000 4229 3042 4000 4444 5410 2000 3042 3200 7765 11059 11000 1500]; %real time values for one (winter) day
if season == 's'; rt_sim = rt_cpdsummer; elseif season == 'w', rt_sim = rt_cpdwinter; end

%rng(1); for debug
%rng(4); resolved many dublicate flags
%rng(7);
rng(574793) %use this again


new_car_prob = 0.1;%new cars old 0.35
new_truck_prob = 0.01;%new truck old 0.5
dec_prob = 0.15;%chance of decreasing speed
park_prob = 0.5;
amea_freq = 20;%frequency of amea cars (with 50 we have 2%)(20 = 5%)
%chance_of_not_having_flag = 0.15;
max_red = 60;%max number of red
max_cross = 100;%max number of epoch before allow a veh from sec lane to cross
thr_press = 8; %pressure threshold

%Inverse Movement
inv = [0 1 0 1 0 1 1 0 1 0 1 0 1];
%inv = [0 0 0 0 0 0 0 0 0 0 0 0 0];

%intersection variables
%new inters inter 1 hor1 vert4
if cell_size == 7.5; intersection1 = [10 53]; elseif cell_size == 5, intersection1 = [15,75]; end
%its inter 4 hor2
if cell_size == 7.5; intersection4 = [21 53]; elseif cell_size == 5, intersection4 = [29,75]; end
%its inter 16 hor5 vert1 was 3
if cell_size == 7.5; intersection16 = [46 20]; elseif cell_size == 5, intersection16 = [71,28]; end
%its inter 11 vert2 hor4 was 4
if cell_size == 7.5; intersection11 = [38 28]; elseif cell_size == 5, intersection11 = [57,42]; end
%its inter 8 hor3
if cell_size == 7.5; intersection8 = [30 53]; elseif cell_size == 5, intersection8 = [43,75]; end
%its inter 7 vert3
if cell_size == 7.5; intersection7 = [30 40]; elseif cell_size == 5, intersection7 = [43,55]; end
%its inter 2 vert5
if cell_size == 7.5; intersection2 = [10 71]; elseif cell_size == 5, intersection2 = [15,103]; end
%its inter 3 vert6
if cell_size == 7.5; intersection3 = [10 79]; elseif cell_size == 5, intersection3 = [15,115]; end
%its inter 4
if cell_size == 7.5; intersection5 = [21 71]; elseif cell_size == 5, intersection5 = [29,103]; end
%its inter 6
if cell_size == 7.5; intersection6 = [21 79]; elseif cell_size == 5, intersection6 = [29,115]; end
%its inter 9
if cell_size == 7.5; intersection9 = [30 71]; elseif cell_size == 5, intersection9 = [43,103]; end
%its inter 11
if cell_size == 7.5; intersection10 = [30 79]; elseif cell_size == 5, intersection10 = [43,115]; end
%its inter 12
if cell_size == 7.5; intersection12 = [38 40]; elseif cell_size == 5, intersection12 = [57,55]; end
%its inter 13
if cell_size == 7.5; intersection13 = [38 53]; elseif cell_size == 5, intersection13 = [57,75]; end
%its inter 14
if cell_size == 7.5; intersection14 = [38 71]; elseif cell_size == 5, intersection14 = [57,103]; end
%its inter 15
if cell_size == 7.5; intersection15 = [38 79]; elseif cell_size == 5, intersection15 = [57,115]; end
%its inter 17
if cell_size == 7.5; intersection17 = [46 28]; elseif cell_size == 5, intersection17 = [71,42]; end
%its inter 18
if cell_size == 7.5; intersection18 = [46 40]; elseif cell_size == 5, intersection18 = [71,55]; end
%its inter 19
if cell_size == 7.5; intersection19 = [46 53]; elseif cell_size == 5, intersection19 = [71,75]; end
%its inter 20
if cell_size == 7.5; intersection20 = [46 71]; elseif cell_size == 5, intersection20 = [71,103]; end
%its inter 21
if cell_size == 7.5; intersection21 = [46 79]; elseif cell_size == 5, intersection21 = [71,115]; end
%its inter 22
if cell_size == 7.5; intersection22 = [46 85]; elseif cell_size == 5, intersection22 = [71,125]; end
%its inter 23 hor6
if cell_size == 7.5; intersection23 = [56 20]; elseif cell_size == 5, intersection23 = [85,28]; end
%its inter 24
if cell_size == 7.5; intersection24 = [56 28]; elseif cell_size == 5, intersection24 = [85,42]; end
%its inter 25
if cell_size == 7.5; intersection25 = [56 40]; elseif cell_size == 5, intersection25 = [85,55]; end
%its inter 26
if cell_size == 7.5; intersection26 = [56 53]; elseif cell_size == 5, intersection26 = [85,75]; end
%its inter 27
if cell_size == 7.5; intersection27 = [56 71]; elseif cell_size == 5, intersection27 = [85,103]; end
%its inter 28
if cell_size == 7.5; intersection28 = [56 79]; elseif cell_size == 5, intersection28 = [85,115]; end
%its inter 29
if cell_size == 7.5; intersection29 = [56 85]; elseif cell_size == 5, intersection29 = [85,125]; end


inter_cell = {intersection1,intersection2,intersection3,intersection4,intersection5,intersection6,intersection7,...
    intersection8,intersection9,intersection10,intersection11,intersection12,intersection13,intersection14,...
    intersection15,intersection16,intersection17,intersection18,intersection19,intersection20,intersection21,...
    intersection22,intersection23,intersection24,intersection25,intersection26,intersection27,intersection28,intersection29};


if(cell_size == 7.5)
    full_road = zeros(66,100); %Complete Grid
    full_road(:,:) = -10; %initialize road
    %Starting points for each road: 7.5 meter per cell
    sph = [47 42 31 22 12 1];
    spv = [41 34 24 9 1 1 46];
    %AMEA SPOTS for each lane
    amea_spots = {[0 0;11 18] [0;20] [0;0] [0;35] [0 0;37 45] [47 48 76;0 0 0],...%correct it with 57 58 amea pos [47 48 76; 57 58 0]
        [21 22;0 0] [0;0] [0;0] [24;0] [43;14] [42;0] [16;0]};
elseif(cell_size == 5)
    full_road = zeros(100,147); %Complete Grid
    full_road(:,:) = -10; %initialize road
%Starting points for each road: 5 meter per  cell
    sph = [74 60 49 35 17 1];
    spv = [63 51 37 14 1 1 71];
    %AMEA SPOTS for each lane
    amea_spots = {[0 0;12 20] [0;29] [0;0] [0;47] [0 0;45 61] [63 64 109;95 96 0],...
        [29 30;0 0] [0;0] [0;0] [32 33;0 0] [64;21] [64;0] [25;0]};
end
if (prev == 0)
	epoch = 1;
    time = seconds(epoch);
    time.Format = 'hh:mm:ss';
    last_epoch = 0;
	%Cars for each road (currently every road starts with 8)
	cars1 = 8;
	cars2 = 8;
	cars3 = 8;
	cars4 = 8;
	cars5 = 8;
	cars6 = 8;
	top_is_red = ones(1,33); %+4 dummies
	left_is_red = zeros(1,33); %+4 dummies
	count_red_left = zeros(1,33); %+4 dummies
	count_red_top = zeros(1,33); %+4 dummies
	delay_signal = zeros(1,33); %+4 dummies
	[full_road,hor,hor2,hor3,hor4,hor5,hor6,vert,vert2,vert3,vert4,vert5,vert6,vert7,ID_max,delay_parking_ID,ID_park,top_is_red] = ...
		initialize_road(savefolder,time,cell_size,inv,sph,spv,full_road,cars1,cars2,cars3,cars4,cars5,cars6,inter_cell,top_is_red,with_traffic_signals,amea_freq);
else
	last_epoch = prev + 1; %if wanna cont. previous run change to prev. num_of_ep
	hor = {varargin{1,1}{1,:}};
	hor2 = {varargin{1,1}{2,:}};
	hor3 = {varargin{1,1}{3,:}};
	hor4 = {varargin{1,1}{4,:}};
	hor5 = {varargin{1,1}{5,:}};
	hor6 = {varargin{1,1}{6,:}};
	vert = {varargin{1,1}{7,:}};
	vert2 = {varargin{1,1}{8,:}};
	vert3 = {varargin{1,1}{9,:}};
	vert4 = {varargin{1,1}{10,:}};
	vert5 = {varargin{1,1}{11,:}};
	vert6 = {varargin{1,1}{12,:}};
	vert7 = {varargin{1,1}{13,:}};
	ID_max = {varargin{1,1}{14,1}};
	top_is_red = {varargin{1,1}{14,2}};
	left_is_red = {varargin{1,1}{14,3}};
	count_red_left = {varargin{1,1}{14,4}};
	count_red_top = {varargin{1,1}{14,5}};
	delay_signal = {varargin{1,1}{14,6}};
end

for epoch=2+last_epoch:max_epoch+last_epoch
    time = seconds(epoch);
    time.Format = 'dd:hh:mm:ss';
    rt = 1;
    %Move
    for roads=1:13
        if (roads == 1)
            [hor,delay_parking_ID,ID_park,ID_max] = movement(hor,delay_parking_ID,ID_park,inv(1),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(1),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{1});
        elseif (roads == 2)
            [hor2,delay_parking_ID,ID_park,ID_max] = movement(hor2,delay_parking_ID,ID_park,inv(2),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(2),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{2});
        elseif (roads == 3)
            [hor3,delay_parking_ID,ID_park,ID_max] = movement(hor3,delay_parking_ID,ID_park,inv(3),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(3),season,new_car_prob,new_truck_prob,amea_freq,0,amea_spots{3});
        elseif (roads == 4)
            [hor4,delay_parking_ID,ID_park,ID_max] = movement(hor4,delay_parking_ID,ID_park,inv(4),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(4),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{4});
        elseif (roads == 5)
            [hor5,delay_parking_ID,ID_park,ID_max] = movement(hor5,delay_parking_ID,ID_park,inv(5),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(5),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{5});
        elseif (roads == 6)
            [hor6,delay_parking_ID,ID_park,ID_max] = movement(hor6,delay_parking_ID,ID_park,inv(6),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(6),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{6});
        elseif (roads == 7)
            [vert,delay_parking_ID,ID_park,ID_max] = movement(vert,delay_parking_ID,ID_park,inv(7),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(7),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{7});
        elseif (roads == 8)
            [vert2,delay_parking_ID,ID_park,ID_max] = movement(vert2,delay_parking_ID,ID_park,inv(8),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(8),season,new_car_prob,new_truck_prob,amea_freq,0,amea_spots{8});
        elseif (roads == 9)
            [vert3,delay_parking_ID,ID_park,ID_max] = movement(vert3,delay_parking_ID,ID_park,inv(9),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(9),season,new_car_prob,new_truck_prob,amea_freq,0,amea_spots{9});
        elseif (roads == 10)
            [vert4,delay_parking_ID,ID_park,ID_max] = movement(vert4,delay_parking_ID,ID_park,inv(10),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(10),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{10});
        elseif (roads == 11)
            [vert5,delay_parking_ID,ID_park,ID_max] = movement(vert5,delay_parking_ID,ID_park,inv(11),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(11),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{11});
        elseif (roads == 12)
            [vert6,delay_parking_ID,ID_park,ID_max] = movement(vert6,delay_parking_ID,ID_park,inv(12),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(12),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{12});
        elseif (roads == 13)
            [vert7,delay_parking_ID,ID_park,ID_max] = movement(vert7,delay_parking_ID,ID_park,inv(13),epoch,dec_prob,park_prob,ID_max,rt,rt_sim(13),season,new_car_prob,new_truck_prob,amea_freq,1,amea_spots{13});
        end
    end
        %Moving away from intersection
        for inter=1:29
            if (inter == 1)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor{1},vert4{1},intersection1,sph(1),spv(4),[inv(1) inv(10)]);
            elseif (inter == 2)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor{1},vert5{1},intersection2,sph(1),spv(5),[inv(1) inv(11)]);
            elseif (inter == 3)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor{1},vert6{1},intersection3,sph(1),spv(6),[inv(1) inv(12)]);
            elseif (inter == 4)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor2{1},vert4{1},intersection4,sph(2),spv(4),[inv(2) inv(10)]);
            elseif (inter == 5)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor2{1},vert5{1},intersection5,sph(2),spv(5),[inv(2) inv(11)]);
            elseif (inter == 6)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor2{1},vert6{1},intersection6,sph(2),spv(6),[inv(2) inv(12)]);
            elseif (inter == 7)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor3{1},vert3{1},intersection7,sph(3),spv(3),[inv(3) inv(9)]);
            elseif (inter == 8)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor3{1},vert4{1},intersection8,sph(3),spv(4),[inv(3) inv(10)]);
            elseif (inter == 9)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor3{1},vert5{1},intersection9,sph(3),spv(5),[inv(3) inv(11)]);
            elseif (inter == 10)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor3{1},vert6{1},intersection10,sph(3),spv(6),[inv(3) inv(12)]);
            elseif (inter == 11)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor4{1},vert2{1},intersection11,sph(4),spv(2),[inv(4) inv(8)]);
            elseif (inter == 12)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor4{1},vert3{1},intersection12,sph(4),spv(3),[inv(4) inv(9)]);
            elseif (inter == 13)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor4{1},vert4{1},intersection13,sph(4),spv(4),[inv(4) inv(10)]);
            elseif (inter == 14)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor4{1},vert5{1},intersection14,sph(4),spv(5),[inv(4) inv(11)]);
            elseif (inter == 15)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor4{1},vert6{1},intersection15,sph(4),spv(6),[inv(4) inv(12)]);
            elseif (inter == 16)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert{1},intersection16,sph(5),spv(1),[inv(5) inv(7)]);
            elseif (inter == 17)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert2{1},intersection17,sph(5),spv(2),[inv(5) inv(8)]);
            elseif (inter == 18)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert3{1},intersection18,sph(5),spv(3),[inv(5) inv(9)]);
            elseif (inter == 19)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert4{1},intersection19,sph(5),spv(4),[inv(5) inv(10)]);
            elseif (inter == 20)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert5{1},intersection20,sph(5),spv(5),[inv(5) inv(11)]);
            elseif (inter == 21)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert6{1},intersection21,sph(5),spv(6),[inv(5) inv(12)]);
            elseif (inter == 22)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor5{1},vert7{1},intersection22,sph(5),spv(7),[inv(5) inv(13)]);
            elseif (inter == 23)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert{1},intersection23,sph(6),spv(1),[inv(6) inv(7)]);
            elseif (inter == 24)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert2{1},intersection24,sph(6),spv(2),[inv(6) inv(8)]);
            elseif (inter == 25)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert3{1},intersection25,sph(6),spv(3),[inv(6) inv(9)]);
            elseif (inter == 26)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert4{1},intersection26,sph(6),spv(4),[inv(6) inv(10)]);
            elseif (inter == 27)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert5{1},intersection27,sph(6),spv(5),[inv(6) inv(11)]);
            elseif (inter == 28)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert6{1},intersection28,sph(6),spv(6),[inv(6) inv(12)]);
            elseif (inter == 29)
                [delay_signal(inter)] = moving_from_inter(left_is_red(inter),top_is_red(inter),hor6{1},vert7{1},intersection29,sph(6),spv(7),[inv(6) inv(13)]);
            end
        end    
    %Parking
    for roads=1:13
        if (roads == 1)
            [hor,delay_parking_ID,ID_park,hor_temp] = parking(hor,delay_parking_ID,ID_park,inv(1),amea_freq,2,time,amea_spots{1});
        elseif (roads == 2)
            [hor2,delay_parking_ID,ID_park,hor2_temp] = parking(hor2,delay_parking_ID,ID_park,inv(2),amea_freq,2,time,amea_spots{2});
        elseif (roads == 3)
            [hor3,delay_parking_ID,ID_park,hor3_temp] = parking(hor3,delay_parking_ID,ID_park,inv(3),amea_freq,0,time,amea_spots{3});
        elseif (roads == 4)
            [hor4,delay_parking_ID,ID_park,hor4_temp] = parking(hor4,delay_parking_ID,ID_park,inv(4),amea_freq,2,time,amea_spots{4});
        elseif (roads == 5)
            [hor5,delay_parking_ID,ID_park,hor5_temp] = parking(hor5,delay_parking_ID,ID_park,inv(5),amea_freq,2,time,amea_spots{5});
        elseif (roads == 6)
            [hor6,delay_parking_ID,ID_park,hor6_temp] = parking(hor6,delay_parking_ID,ID_park,inv(6),amea_freq,3,time,amea_spots{6});
        elseif (roads == 7)
            [vert,delay_parking_ID,ID_park,vert_temp] = parking(vert,delay_parking_ID,ID_park,inv(7),amea_freq,1,time,amea_spots{7});
        elseif (roads == 8)
            [vert2,delay_parking_ID,ID_park,vert2_temp] = parking(vert2,delay_parking_ID,ID_park,inv(8),amea_freq,0,time,amea_spots{8});
        elseif (roads == 9)
            [vert3,delay_parking_ID,ID_park,vert3_temp] = parking(vert3,delay_parking_ID,ID_park,inv(9),amea_freq,0,time,amea_spots{9});
        elseif (roads == 10)
            [vert4,delay_parking_ID,ID_park,vert4_temp] = parking(vert4,delay_parking_ID,ID_park,inv(10),amea_freq,1,time,amea_spots{10});
        elseif (roads == 11)
            [vert5,delay_parking_ID,ID_park,vert5_temp] = parking(vert5,delay_parking_ID,ID_park,inv(11),amea_freq,3,time,amea_spots{11});
        elseif (roads == 12)
            [vert6,delay_parking_ID,ID_park,vert6_temp] = parking(vert6,delay_parking_ID,ID_park,inv(12),amea_freq,1,time,amea_spots{12});
        elseif (roads == 13)
            [vert7,delay_parking_ID,ID_park,vert7_temp] = parking(vert7,delay_parking_ID,ID_park,inv(13),amea_freq,1,time,amea_spots{13});
        end
    end
    %Copying
    [full_road,count_red_top,count_red_left] = copying_roads(full_road,hor_temp,hor2_temp,hor3_temp,...
        hor4_temp,hor5_temp,hor6_temp,vert_temp,vert2_temp,vert3_temp,vert4_temp,vert5_temp,vert6_temp,vert7_temp,...
        inter_cell,count_red_top,count_red_left,top_is_red,sph,spv);

    %Visualization
    if(per == 1)%(epoch >= 18000 && epoch <= 18300) || (epoch >= 27000 && epoch <= 27300) || 
        if((epoch >= 54204 && epoch <= 54300) || (epoch >= 57600 && epoch <= 57900) || (epoch >= 75600 && epoch <= 75900))
            draw(focus,savefolder,time,cell_size,full_road,inter_cell,hor,hor2,hor3,hor4,hor5,hor6,vert,vert2,vert3,vert4,vert5,...
                vert6,vert7,top_is_red,sph,spv,amea_freq,amea_spots);
        end
    elseif(per == -1)

    elseif(~mod(epoch,per))
        draw(focus,savefolder,time,cell_size,full_road,inter_cell,hor,hor2,hor3,hor4,hor5,hor6,vert,vert2,vert3,vert4,vert5,...
            vert6,vert7,top_is_red,sph,spv,amea_freq,amea_spots);
    end

    %Traffic control
    for inter=1:29
        if (inter == 1)
			if(with_traffic_signals == 1)
				[hor{1},vert4{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor{1},vert4{1},intersection1,sph(1),spv(4),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));	
			elseif(with_traffic_signals == 0)
				[vert4{1},hor{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor{1},vert4{1},intersection1,sph(1),spv(4),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(1) inv(10)]);
			end		
        elseif (inter == 2)
			if(with_traffic_signals == 1)
				[hor{1},vert5{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor{1},vert5{1},intersection2,sph(1),spv(5),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert5{1},hor{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor{1},vert5{1},intersection2,sph(1),spv(5),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(1) inv(11)]);
			end			
        elseif (inter == 3)
			if(with_traffic_signals == 1)
				[hor{1},vert6{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor{1},vert6{1},intersection3,sph(1),spv(6),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert6{1},hor{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor{1},vert6{1},intersection3,sph(1),spv(6),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(1) inv(12)]);
			end
        elseif (inter == 4)
			if(with_traffic_signals == 1)
				[hor2{1},vert4{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor2{1},vert4{1},intersection4,sph(2),spv(4),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert4{1},hor2{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor2{1},vert4{1},intersection4,sph(2),spv(4),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(2) inv(10)]);
			end
        elseif (inter == 5)
			if(with_traffic_signals == 1)
				[hor2{1},vert5{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor2{1},vert5{1},intersection5,sph(2),spv(5),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert5{1},hor2{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor2{1},vert5{1},intersection5,sph(2),spv(5),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(2) inv(11)]);
			end
        elseif (inter == 6)
			if(with_traffic_signals == 1)
				[hor2{1},vert6{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor2{1},vert6{1},intersection6,sph(2),spv(6),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert6{1},hor2{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor2{1},vert6{1},intersection6,sph(2),spv(6),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(2) inv(12)]);
			end
        elseif (inter == 7)
			if(with_traffic_signals == 1)
				[hor3{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor3{1},vert3{1},intersection7,sph(3),spv(3),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert3{1},hor3{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor3{1},vert3{1},intersection7,sph(3),spv(3),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(3) inv(9)]);
			end
        elseif (inter == 8)
			if(with_traffic_signals == 1)
				[hor3{1},vert4{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor3{1},vert4{1},intersection8,sph(3),spv(4),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert4{1},hor3{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor3{1},vert4{1},intersection8,sph(3),spv(4),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(3) inv(10)]);
			end
        elseif (inter == 9)
			if(with_traffic_signals == 1)
				[hor3{1},vert5{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor3{1},vert5{1},intersection9,sph(3),spv(5),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert5{1},hor3{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor3{1},vert5{1},intersection9,sph(3),spv(5),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(3) inv(11)]);
			end
        elseif (inter == 10)
			if(with_traffic_signals == 1)
				[hor3{1},vert6{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor3{1},vert6{1},intersection10,sph(3),spv(6),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert6{1},hor3{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor3{1},vert6{1},intersection10,sph(3),spv(6),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(3) inv(12)]);
			end
        elseif (inter == 11)
			if(with_traffic_signals == 1)
				[hor4{1},vert2{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor4{1},vert2{1},intersection11,sph(4),spv(2),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert2{1},hor4{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor4{1},vert2{1},intersection11,sph(4),spv(2),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(4) inv(8)]);
			end
        elseif (inter == 12)
			if(with_traffic_signals == 1)
				[hor4{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor4{1},vert3{1},intersection12,sph(4),spv(3),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor4{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor4{1},vert3{1},intersection12,sph(4),spv(3),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(4) inv(9)]);
			end
        elseif (inter == 13)
            if(with_traffic_signals == 1)
				[hor4{1},vert4{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor4{1},vert4{1},intersection13,sph(4),spv(4),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert4{1},hor4{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor4{1},vert4{1},intersection13,sph(4),spv(4),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(4) inv(10)]);
            end			
        elseif (inter == 14)
			if(with_traffic_signals == 1)
				[hor4{1},vert5{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor4{1},vert5{1},intersection14,sph(4),spv(5),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert5{1},hor4{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor4{1},vert5{1},intersection14,sph(4),spv(5),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(4) inv(11)]);
			end
        elseif (inter == 15)
			if(with_traffic_signals == 1)
				[hor4{1},vert6{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor4{1},vert6{1},intersection15,sph(4),spv(6),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert6{1},hor4{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor4{1},vert6{1},intersection15,sph(4),spv(6),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(4) inv(12)]);
			end	
        elseif (inter == 16)
			if(with_traffic_signals == 1)
				[hor5{1},vert{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert{1},intersection16,sph(5),spv(1),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor5{1},vert{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor5{1},vert{1},intersection16,sph(5),spv(1),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(7)]);
			end
        elseif (inter == 17)
			if(with_traffic_signals == 1)
				[hor5{1},vert2{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert2{1},intersection17,sph(5),spv(2),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor5{1},vert2{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor5{1},vert2{1},intersection17,sph(5),spv(2),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(8)]);
			end
        elseif (inter == 18)
			if(with_traffic_signals == 1)
				[hor5{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert3{1},intersection18,sph(5),spv(3),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor5{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor5{1},vert3{1},intersection18,sph(5),spv(3),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(9)]);
			end
        elseif (inter == 19)
			if(with_traffic_signals == 1)
				[hor5{1},vert4{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert4{1},intersection19,sph(5),spv(4),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert4{1},hor5{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor5{1},vert4{1},intersection19,sph(5),spv(4),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(10)]);
			end
        elseif (inter == 20)
			if(with_traffic_signals == 1)
				[hor5{1},vert5{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert5{1},intersection20,sph(5),spv(5),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert5{1},hor5{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor5{1},vert5{1},intersection20,sph(5),spv(5),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(11)]);
			end
        elseif (inter == 21)
			if(with_traffic_signals == 1)
				[hor5{1},vert6{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert6{1},intersection21,sph(5),spv(6),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert6{1},hor5{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor5{1},vert6{1},intersection21,sph(5),spv(6),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(12)]);
			end
        elseif (inter == 22)
			if(with_traffic_signals == 1)
				[hor5{1},vert7{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor5{1},vert7{1},intersection22,sph(5),spv(7),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor5{1},vert7{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor5{1},vert7{1},intersection22,sph(5),spv(7),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(5) inv(13)]);
			end
        elseif (inter == 23)
			if(with_traffic_signals == 1)
				[hor6{1},vert{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert{1},intersection23,sph(6),spv(1),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor6{1},vert{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor6{1},vert{1},intersection23,sph(6),spv(1),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(7)]);
			end
        elseif (inter == 24)
			if(with_traffic_signals == 1)
				[hor6{1},vert2{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert2{1},intersection24,sph(6),spv(2),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor6{1},vert2{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor6{1},vert2{1},intersection24,sph(6),spv(2),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(8)]);
			end	
        elseif (inter == 25)
			if(with_traffic_signals == 1)
				[hor6{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert3{1},intersection25,sph(6),spv(3),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor6{1},vert3{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor6{1},vert3{1},intersection25,sph(6),spv(3),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(9)]);
			end
        elseif (inter == 26)
			if(with_traffic_signals == 1)
				[hor6{1},vert4{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert4{1},intersection26,sph(6),spv(4),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert4{1},hor6{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor6{1},vert4{1},intersection26,sph(6),spv(4),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(10)]);
			end
        elseif (inter == 27)
            if(with_traffic_signals == 1)
				[hor6{1},vert5{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert5{1},intersection27,sph(6),spv(5),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert5{1},hor6{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor6{1},vert5{1},intersection27,sph(6),spv(5),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(11)]);
            end	
        elseif (inter == 28)
            if(with_traffic_signals == 1)
				[hor6{1},vert6{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert6{1},intersection28,sph(6),spv(6),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[vert6{1},hor6{1},top_is_red(inter),left_is_red(inter),count_red_top(inter),count_red_left(inter)] = change_crossing_lane(2,hor6{1},vert6{1},intersection28,sph(6),spv(6),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(12)]);
            end
        elseif (inter == 29)
			if(with_traffic_signals == 1)
				[hor6{1},vert7{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_traffic_light(hor6{1},vert7{1},intersection29,sph(6),spv(7),max_red,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter));
			elseif(with_traffic_signals == 0)
				[hor6{1},vert7{1},left_is_red(inter),top_is_red(inter),count_red_left(inter),count_red_top(inter)] = change_crossing_lane(1,hor6{1},vert7{1},intersection29,sph(6),spv(7),max_cross,thr_press,count_red_left(inter),count_red_top(inter),delay_signal(inter),[inv(6) inv(13)]);
			end	
        end
    end
	%Switching isnt needed for regular street, cause we have Stops on one of the two directions!!
    if(with_traffic_signals == 1)
		%switching traffic lights
		full_road = switch_traffic_lights(full_road,top_is_red,left_is_red,count_red_top,count_red_left,max_red,inter_cell);
    end

time
end

%Return cell
etc = {ID_max,top_is_red,left_is_red,count_red_left,count_red_top,delay_signal};
current_values = [hor; hor2; hor3; hor4; hor5; hor6; vert; vert2; vert3; vert4; vert5; vert6; vert7; etc];
vargout {1} = current_values;