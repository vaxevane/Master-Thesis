function draw(focus_point,save,time,cell_size,road,inter_cell,hor,hor2,hor3,hor4,hor5,hor6,vert,vert2,vert3,vert4,vert5,vert6,vert7,tpr,sph,spv,amea_freq,varargin)

inter1 = inter_cell{1};
inter2 = inter_cell{2};
inter3 = inter_cell{3};
inter4 = inter_cell{4};
inter5 = inter_cell{5};
inter6 = inter_cell{6};
inter7 = inter_cell{7};
inter8 = inter_cell{8};
inter9 = inter_cell{9};
inter10 = inter_cell{10};
inter11 = inter_cell{11};
inter12 = inter_cell{12};
inter13 = inter_cell{13};
inter14 = inter_cell{14};
inter15 = inter_cell{15};
inter16 = inter_cell{16};
inter17 = inter_cell{17};
inter18 = inter_cell{18};
inter19 = inter_cell{19};
inter20 = inter_cell{20};
inter21 = inter_cell{21};
inter22 = inter_cell{22};
inter23 = inter_cell{23};
inter24 = inter_cell{24};
inter25 = inter_cell{25};
inter26 = inter_cell{26};
inter27 = inter_cell{27};
inter28 = inter_cell{28};
inter29 = inter_cell{29};
%dummies inter
inter30 = [inter3(1) inter22(2)];
inter31 = [inter6(1) inter22(2)];
inter32 = [inter10(1) inter22(2)];
inter33 = [inter15(1) inter22(2)];

%logical values for inverse movement
inverse(1) = 0; %hor1 inter1
inverse(2) = 1; %hor2 inter4
inverse(3) = 0; %hor3 inter7
inverse(4) = 1; %hor4 inter11
inverse(5) = 0; %hor5 inter16
inverse(6) = 1; %hor6 inter23
inverse(7) = 1; %vert1 inter16
inverse(8) = 0; %vert2 inter11
inverse(9) = 1; %vert3 inter7
inverse(10) = 0; %vert4 inter1
inverse(11) = 1; %vert5 inter2
inverse(12) = 0; %vert6 inter3
inverse(13) = 1; %vert7 inter22


hor_ID = hor{2};
hor_steps = hor{5};
hor2_ID = hor2{2};
hor2_steps = hor2{5};
hor3_ID = hor3{2};
hor3_steps = hor3{5};
hor4_ID = hor4{2};
hor4_steps = hor4{5};
hor5_ID = hor5{2};
hor5_steps = hor5{5};
hor6_ID = hor6{2};
hor6_steps = hor6{5};
vert_ID = vert{2};
vert_steps = vert{5};
vert2_ID = vert2{2};
vert2_steps = vert2{5};
vert3_ID = vert3{2};
vert3_steps = vert3{5};
vert4_ID = vert4{2};
vert4_steps = vert4{5};
vert5_ID = vert5{2};
vert5_steps = vert5{5};
vert6_ID = vert6{2};
vert6_steps = vert6{5};
vert7_ID = vert7{2};
vert7_steps = vert7{5};

[row,col] = size(road);

black_car = imread('images/car/black.bmp');
white_car = imread('images/car/white.bmp');
red_car = imread('images/car/red.bmp');
green_car = imread('images/car/green.bmp');
cyan_car = imread('images/car/cyan.bmp');
blue_car = imread('images/car/blue.bmp');
purple_car = imread('images/car/purple.bmp');
bblack_truck = imread('images/truck/truck back black.bmp');
bwhite_truck = imread('images/truck/truck back white.bmp');
bred_truck = imread('images/truck/truck back red.bmp');
bgreen_truck = imread('images/truck/truck back green.bmp');
bcyan_truck = imread('images/truck/truck back cyan.bmp');
fblack_truck = imread('images/truck/truck front black.bmp');
fwhite_truck = imread('images/truck/truck front white.bmp');
fred_truck = imread('images/truck/truck front red.bmp');
fgreen_truck = imread('images/truck/truck front green.bmp');
fcyan_truck = imread('images/truck/truck front cyan.bmp');
pavement = imread('images/pavement2.bmp');
empty = imread('images/empty.bmp');
flag = imread('images/flag2.bmp');
flag_exp = imread('images/flag_exp.bmp');
down_flash = imread('images/flashingdown2.bmp');
up_flash = imread('images/flashingup2.bmp');
green_light = imread('images/newgreen.bmp');
red_light = imread('images/newred.bmp');
orange_light = imread('images/orange.bmp');
amea_park = imread('images/amea.bmp');
parking = imread('images/parking.bmp');
roa = imread('images/road.bmp');
black_car_amea = imread('images/car/black_amea.bmp');
white_car_amea = imread('images/car/white_amea.bmp');
red_car_amea = imread('images/car/red_amea.bmp');
green_car_amea = imread('images/car/green_amea.bmp');
cyan_car_amea = imread('images/car/cyan_amea.bmp');
blue_car_amea = imread('images/car/blue_amea.bmp');
purple_car_amea = imread('images/car/purple_amea.bmp');
stop = imread('images/stop.bmp');



% road_ID map
road_ID = zeros(row,col);

road_ID = copying(road_ID,hor_ID,sph(1),[inter1(1) 0],hor2_ID,sph(2),[inter4(1) 0],...
    hor3_ID,sph(3),[inter7(1) 0],hor4_ID,sph(4),[inter11(1) 0],hor5_ID,sph(5),[inter16(1) 0],...
    hor6_ID,sph(6),[inter23(1) 0],vert_ID,spv(1),[0 inter16(2)],vert2_ID,spv(2),[0 inter11(2)],...
    vert3_ID,spv(3),[0 inter7(2)],vert4_ID,spv(4),[0 inter1(2)],vert5_ID,spv(5),[0 inter2(2)],...
    vert6_ID,spv(6),[0 inter3(2)],vert7_ID,spv(7),[0 inter22(2)]);
%Replace till here with func copying

road_ID = show_befaft_inter(road_ID,hor_ID,[inter1(1) inter1(2) inter2(2) inter3(2)],sph(1),...
    hor2_ID,[inter4(1) inter4(2) inter5(2) inter6(2)],sph(2),...
    hor3_ID,[inter7(1) inter7(2) inter8(2) inter9(2) inter10(2)],sph(3),...
    hor4_ID,[inter11(1) inter11(2) inter12(2) inter13(2) inter14(2) inter15(2)],sph(4),...
    hor5_ID,[inter16(1) inter16(2) inter17(2) inter18(2) inter19(2) inter20(2) inter21(2) inter22(2)],sph(5),...
    hor6_ID,[inter23(1) inter23(2) inter24(2) inter25(2) inter26(2) inter27(2) inter28(2) inter29(2)],sph(6));
%Replace till here with func show_befaft_inter


if1 = [hor_ID(1,1+inter1(2)-sph(1)) vert4_ID(1,1+inter1(1)-spv(4))]; %must have the vert part on the sec element when add the otherlanes
if2 = [hor_ID(1,1+inter2(2)-sph(1)) vert5_ID(1,1+inter2(1)-spv(5))];
if3 = [hor_ID(1,1+inter3(2)-sph(1)) vert6_ID(1,1+inter3(1)-spv(6))];
if4 = [hor2_ID(1,1+inter4(2)-sph(2)) vert4_ID(1,1+inter4(1)-spv(4))];
if5 = [hor2_ID(1,1+inter5(2)-sph(2)) vert5_ID(1,1+inter5(1)-spv(5))];
if6 = [hor2_ID(1,1+inter6(2)-sph(2)) vert6_ID(1,1+inter6(1)-spv(6))];
if7 = [hor3_ID(1,1+inter7(2)-sph(3)) vert3_ID(1,1+inter7(1)-spv(3))];
if8 = [hor3_ID(1,1+inter8(2)-sph(3)) vert4_ID(1,1+inter8(1)-spv(4))];
if9 = [hor3_ID(1,1+inter9(2)-sph(3)) vert5_ID(1,1+inter9(1)-spv(5))];
if10 = [hor3_ID(1,1+inter10(2)-sph(3)) vert6_ID(1,1+inter10(1)-spv(6))];
if11 = [hor4_ID(1,1+inter11(2)-sph(4)) vert2_ID(1,1+inter11(1)-spv(2))];
if12 = [hor4_ID(1,1+inter12(2)-sph(4)) vert3_ID(1,1+inter12(1)-spv(3))];
if13 = [hor4_ID(1,1+inter13(2)-sph(4)) vert4_ID(1,1+inter13(1)-spv(4))];
if14 = [hor4_ID(1,1+inter14(2)-sph(4)) vert5_ID(1,1+inter14(1)-spv(5))];
if15 = [hor4_ID(1,1+inter15(2)-sph(4)) vert6_ID(1,1+inter15(1)-spv(6))];
if16 = [hor5_ID(1,1+inter16(2)-sph(5)) vert_ID(1,1+inter16(1)-spv(1))];
if17 = [hor5_ID(1,1+inter17(2)-sph(5)) vert2_ID(1,1+inter17(1)-spv(2))];
if18 = [hor5_ID(1,1+inter18(2)-sph(5)) vert3_ID(1,1+inter18(1)-spv(3))];
if19 = [hor5_ID(1,1+inter19(2)-sph(5)) vert4_ID(1,1+inter19(1)-spv(4))];
if20 = [hor5_ID(1,1+inter20(2)-sph(5)) vert5_ID(1,1+inter20(1)-spv(5))];
if21 = [hor5_ID(1,1+inter21(2)-sph(5)) vert6_ID(1,1+inter21(1)-spv(6))];
if22 = [hor5_ID(1,1+inter22(2)-sph(5)) vert7_ID(1,1+inter22(1)-spv(7))];
if23 = [hor6_ID(1,1+inter23(2)-sph(6)) vert_ID(1,1+inter23(1)-spv(1))];
if24 = [hor6_ID(1,1+inter24(2)-sph(6)) vert2_ID(1,1+inter24(1)-spv(2))];
if25 = [hor6_ID(1,1+inter25(2)-sph(6)) vert3_ID(1,1+inter25(1)-spv(3))];
if26 = [hor6_ID(1,1+inter26(2)-sph(6)) vert4_ID(1,1+inter26(1)-spv(4))];
if27 = [hor6_ID(1,1+inter27(2)-sph(6)) vert5_ID(1,1+inter27(1)-spv(5))];
if28 = [hor6_ID(1,1+inter28(2)-sph(6)) vert6_ID(1,1+inter28(1)-spv(6))];
if29 = [hor6_ID(1,1+inter29(2)-sph(6)) vert7_ID(1,1+inter29(1)-spv(7))];
%dummies
if30 = [hor_ID(1,1+inter30(2)-sph(1)) 0];
if31 = [hor2_ID(1,1+inter31(2)-sph(2)) 0];
if32 = [hor3_ID(1,1+inter32(2)-sph(3)) 0];
if33 = [hor4_ID(1,1+inter33(2)-sph(4)) 0];

inters = [inter1(1) inter1(2);inter2(1) inter2(2);inter3(1) inter3(2);inter4(1) inter4(2);inter5(1) inter5(2);...
    inter6(1) inter6(2);inter7(1) inter7(2);inter8(1) inter8(2);inter9(1) inter9(2);inter10(1) inter10(2);...
    inter11(1) inter11(2);inter12(1) inter12(2);inter13(1) inter13(2);inter14(1) inter14(2);inter15(1) inter15(2);...
    inter16(1) inter16(2);inter17(1) inter17(2);inter18(1) inter18(2);inter19(1) inter19(2);inter20(1) inter20(2);...
    inter21(1) inter21(2);inter22(1) inter22(2);inter23(1) inter23(2);inter24(1) inter24(2);inter25(1) inter25(2);...
    inter26(1) inter26(2);inter27(1) inter27(2);inter28(1) inter28(2);inter29(1) inter29(2);inter30(1) inter30(2);...
    inter31(1) inter31(2);inter32(1) inter32(2);inter33(1) inter33(2)];
cntt = zeros(1,length(inters)); %dummy counts
cntl = zeros(1,length(inters)); %dummy counts

[road_ID,~,~] = choose_and_cnt(road_ID,tpr,cntt,cntl,inters,if1,if2,if3,if4,if5,if6,if7,if8,if9,if10,if11,if12,if13,...
    if14,if15,if16,if17,if18,if19,if20,if21,if22,if23,if24,if25,if26,if27,if28,if29,if30,if31,if32,if33);
%Replace till here with func choose_and_cnt

%Parking Steps
steps = zeros(row,col);

steps = copying_steps(steps,hor_steps,[inter1(1) 0],sph(1),hor2_steps,[inter4(1) 0],sph(2),...
    hor3_steps,[inter7(1) 0],sph(3),hor4_steps,[inter11(1) 0],sph(4),hor5_steps,[inter16(1) 0],sph(5),...
    hor6_steps,[inter23(1) 0],sph(6),vert_steps,[0 inter16(2)],spv(1),vert2_steps,[0 inter11(2)],spv(2),...
    vert3_steps,[0 inter7(2)],spv(3),vert4_steps,[0 inter1(2)],spv(4),vert5_steps,[0 inter2(2)],spv(5),...
    vert6_steps,[0 inter3(2)],spv(6),vert7_steps,[0 inter22(2)],spv(7));
%Replace till here with func copying_steps

vert_int = [inter1(2) inter2(2) inter3(2) inter7(2) inter11(2) inter16(2) inter22(2)]; %all vertical lanes intersection spots
hor_vert1 = [inter1(1) inter4(1) inter8(1) inter13(1) inter19(1) inter26(1)]; %which hor lanes intersect with each vert lane vert 53
hor_vert2 = [inter2(1) inter5(1) inter9(1) inter14(1) inter20(1) inter27(1)]; %vert 71
hor_vert3 = [inter3(1) inter6(1) inter10(1) inter15(1) inter21(1) inter28(1)]; %vert 79
hor_vert4 = [inter7(1) inter12(1) inter18(1) inter25(1)]; %vert 40
hor_vert5 = [inter11(1) inter17(1) inter24(1)]; %vert 28
hor_vert6 = [inter16(1) inter23(1)]; %vert 20
hor_vert7 = [inter3(1) inter6(1) inter10(1) inter15(1) inter22(1) inter29(1)]; %vert 85
%vert7 inter3 till inter15 dummies for draw


%AMEA spots
if(~isempty(varargin))
    amea_spots_array = varargin{1};
    amea_spots_overall = [];
    for am=1:length(amea_spots_array)
        amea_spots_lane = amea_spots_array{1,am};
        if(am == 1)
            inter = inter1(1);
        elseif(am == 2)
            inter = inter4(1);
        elseif(am == 3)
            inter = inter7(1);
        elseif(am == 4)
            inter = inter11(1);
        elseif(am == 5)
            inter = inter16(1);
        elseif(am == 6)
            inter = inter23(1);
        elseif(am == 7)
            inter = inter16(2);
        elseif(am == 8)
            inter = inter11(2);
        elseif(am == 9)
            inter = inter7(2);
        elseif(am == 10)
            inter = inter1(2);
        elseif(am == 11)
            inter = inter2(2);
        elseif(am == 12)
            inter = inter3(2);
        elseif(am == 13)
            inter = inter22(2);
        end
        for i=1:2
            if(am <= 6)
                jj = (amea_spots_lane(i,(find(amea_spots_lane(i,:) ~= 0)))+sph(am)-1)';
                if(i == 1)
                    direction = 1;%amea spot down
                elseif(i == 2)
                    direction = -1;%amea spot up
                end
                ii = ones(length(jj),1)*inter + direction;
            elseif(am >= 7)
                ii = (amea_spots_lane(i,(find(amea_spots_lane(i,:) ~= 0)))+spv(am-6)-1)';
                if(i == 1)
                    direction = -1;%amea spot down
                elseif(i == 2)
                    direction = 1;%amea spot up
                end
                jj = ones(length(ii),1)*inter + direction;
            end
            amea_spots_overall = [amea_spots_overall ; ii jj];
        end
    end
end

for i=1:row
    j = 1;
    while (j<=col)   
        %logical conditions
        ID = road_ID(i,j);
        if (j<col)
            front = (ID ~= 0 && ID == road_ID(i,j+1));
        end
        if (i<row)
            bellow = (ID ~= 0 && ID == road_ID(i+1,j));
        end
        amea = ~mod(ID,amea_freq) && ID~= 0;
        for k=1:length(inters)
            tp(k) = ~(tpr(k) && i == inters(k,1) && j == inters(k,2));
        end
		
        sw = 1;
        
        %For roteting the vert lanes
        for k=1:length(vert_int)
            if(k == 1)
                hor_vert = hor_vert1;
            elseif(k == 2)
                hor_vert = hor_vert2;
            elseif(k == 3)
                hor_vert = hor_vert3;
            elseif(k == 4)
                hor_vert = hor_vert4;
            elseif(k == 5)
                hor_vert = hor_vert5;
            elseif(k == 6)
                hor_vert = hor_vert6;
            elseif(k == 7)
                hor_vert = hor_vert7;
                if(i == inter3(1) || i == inter6(1) || i == inter10(1) || i == inter15(1) || i-1 == inter3(1) || i-1 == inter6(1) || i-1 == inter10(1) || i-1 == inter15(1) || i+1 == inter3(1) || i+1 == inter6(1) || i+1 == inter10(1) || i+1 == inter15(1))
                    sw = 0;
                end
            end
            crossed = hor_vert;
            for cl=1:length(crossed)
                in(cl) = i~=crossed(cl);
            end
            vertboole(k) = (j == vert_int(k) || (j == vert_int(k)-1 && all(in)) || (j == vert_int(k)+1 && all(in))) && sw;
            in = [];
            crossed = [];
        end
        
        cond_vert_inv = any(vertboole) && all(tp);
        %INVERSE MOVEMENT
        
        if(inverse(1) && (inter1(1) == i-1 || inter1(1) == i || inter1(1) == i+1) && ~cond_vert_inv)
            inv_move = 1;
        elseif(inverse(2) && (inter4(1) == i-1 || inter4(1) == i || inter4(1) == i+1) && ~cond_vert_inv)
            inv_move = 1;
        elseif(inverse(3) && (inter7(1) == i-1 || inter7(1) == i || inter7(1) == i+1) && ~cond_vert_inv)
            inv_move = 1;
        elseif(inverse(4) && (inter11(1) == i-1 || inter11(1) == i || inter11(1) == i+1) && ~cond_vert_inv)
            inv_move = 1;
        elseif(inverse(5) && (inter16(1) == i-1 || inter16(1) == i || inter16(1) == i+1) && ~cond_vert_inv)
            inv_move = 1;
        elseif(inverse(6) && (inter23(1) == i-1 || inter23(1) == i || inter23(1) == i+1) && ~cond_vert_inv)
            inv_move = 1;
        elseif(inverse(7) && (inter16(2) == j-1 || inter16(2) == j || inter16(2) == j+1))
            inv_move = 1;
        elseif(inverse(8) && (inter11(2) == j-1 || inter11(2) == j || inter11(2) == j+1))
            inv_move = 1;
        elseif(inverse(9) && (inter7(2) == j-1 || inter7(2) == j || inter7(2) == j+1))
            inv_move = 1;
        elseif(inverse(10) && (inter1(2) == j-1 || inter1(2) == j || inter1(2) == j+1))
            inv_move = 1;
        elseif(inverse(11) && (inter2(2) == j-1 || inter2(2) == j || inter2(2) == j+1))
            inv_move = 1;
        elseif(inverse(12) && (inter3(2) == j-1 || inter3(2) == j || inter3(2) == j+1))
            inv_move = 1;
        elseif(inverse(13) && (inter22(2) == j-1 || inter22(2) == j || inter22(2) == j+1))
            inv_move = 1;
        else
            inv_move = 0;
        end
		%inv_move = 0;
        
		%Flashing for trucks
        if(i>1 && i<row && j>1 && j<col)
            flashfront = (road(i+1,j) == 6 && road(i+1,j+1) == 6 && road_ID(i+1,j) == road_ID(i+1,j+1)) || (road(i-1,j) == 8 && road(i-1,j+1) == 8 && road_ID(i-1,j) == road_ID(i-1,j+1));
            flashbellow = (road(i,j-1) == 6 && road(i+1,j-1) == 6 && road_ID(i,j-1) == road_ID(i+1,j-1)) || (road(i,j+1) == 8 && road(i+1,j+1) == 8 && road_ID(i,j+1) == road_ID(i+1,j+1));
        else
            flashfront = 0;
            flashbellow = 0;
        end
        
        %Visualazation of each road variable
        if(road(i,j)==-10)
            out(28*i-27:28*i,28*j-27:28*j,:) = empty;
        elseif(road(i,j)==-4)
            if(any(vertboole))
                out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(amea_park,-90,'bilinear','crop');
            else
                out(28*i-27:28*i,28*j-27:28*j,:) = amea_park;
            end
        elseif(road(i,j)==-3)%RECHECK AGAIN WITH INIT
            if(any(vertboole))
                out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(roa,-90,'bilinear','crop');
            else
                out(28*i-27:28*i,28*j-27:28*j,:) = parking;
            end
            
        elseif(road(i,j)==-2)
            out(28*i-27:28*i,28*j-27:28*j,:) = pavement;
        elseif(road(i,j)==-1)
            if(any(vertboole))
                out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(roa,-90,'bilinear','crop');
            else
                out(28*i-27:28*i,28*j-27:28*j,:) = roa; 
            end
                      
        elseif(road(i,j)==0)
            if(any(vertboole) && all(tp))
                if(amea)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car_amea,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car_amea,-90,'bilinear','crop');
                else
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car,-90,'bilinear','crop');
                end
                if(bellow || flashbellow)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fblack_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bblack_truck,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bblack_truck,-90,'bilinear','crop');
					if inv_move == 1; out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(bblack_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fblack_truck,-90,'bilinear','crop'); end
                    %out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fblack_truck,-90,'bilinear','crop');
                    road(i+1,j) = 100;
                end
            else
                if(front || flashfront)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fblack_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = bblack_truck; end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = bblack_truck;
                    j = j + 1;
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bblack_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = fblack_truck; end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = fblack_truck;
                else
                    if(amea)
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = black_car_amea; end
                        %out(28*i-27:28*i,28*j-27:28*j,:) = black_car_amea;
                    else
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(black_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = black_car; end
                        %out(28*i-27:28*i,28*j-27:28*j,:) = black_car;
                    end   
                end
            end          
        elseif(road(i,j)==1)
            if(any(vertboole) && all(tp))
                if(amea)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car_amea,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car_amea,-90,'bilinear','crop');
                else
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-90,'bilinear','crop');
                end
                if(bellow || flashbellow)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fred_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bred_truck,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bred_truck,-90,'bilinear','crop');
					if inv_move == 1; out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(bred_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fred_truck,-90,'bilinear','crop'); end
                    %out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fred_truck,-90,'bilinear','crop');
                    road(i+1,j) = 100;
                end
            else
                if(front || flashfront)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fred_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = bred_truck; end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = bred_truck;
                    j = j + 1;
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bred_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = fred_truck; end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = fred_truck;
                else
                    if(amea)
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = red_car_amea; end
                        %out(28*i-27:28*i,28*j-27:28*j,:) = red_car_amea;
                    else
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = red_car; end
                        %out(28*i-27:28*i,28*j-27:28*j,:) = red_car;
                    end   
                end
            end
        elseif(road(i,j)==2)
            if(any(vertboole) && all(tp))
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car_amea,-90,'bilinear','crop'); end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car_amea,-90,'bilinear','crop');
                else
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car,-90,'bilinear','crop'); end                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car,-90,'bilinear','crop');
                end
                if(bellow || flashbellow)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fgreen_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bgreen_truck,-90,'bilinear','crop'); end                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bgreen_truck,-90,'bilinear','crop');
					if inv_move == 1; out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(bgreen_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fgreen_truck,-90,'bilinear','crop'); end                    
                    %out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fgreen_truck,-90,'bilinear','crop');
                    road(i+1,j) = 100;
                end
            else
                if(front || flashfront)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fgreen_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = bgreen_truck; end                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = bgreen_truck;
                    j = j + 1;
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bgreen_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = fgreen_truck; end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = fgreen_truck;
                else
                    if(amea)
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = green_car_amea; end                        
                        %out(28*i-27:28*i,28*j-27:28*j,:) = green_car_amea;
                    else
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(green_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = green_car; end                        
                        %out(28*i-27:28*i,28*j-27:28*j,:) = green_car;
                    end
                end
            end 
        elseif(road(i,j)==3)
            if(any(vertboole) && all(tp))
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car_amea,-90,'bilinear','crop'); end                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car_amea,-90,'bilinear','crop');
                else
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car,-90,'bilinear','crop'); end                                        
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car,-90,'bilinear','crop');
                end
                if(bellow || flashbellow)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fcyan_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bcyan_truck,-90,'bilinear','crop'); end                                        
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bcyan_truck,-90,'bilinear','crop');
                    if inv_move == 1; out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(bcyan_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fcyan_truck,-90,'bilinear','crop'); end                    
                    %out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fcyan_truck,-90,'bilinear','crop');
                    road(i+1,j) = 100;
                end
            else
                if(front || flashfront)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fcyan_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = bcyan_truck; end                                        
                    %out(28*i-27:28*i,28*j-27:28*j,:) = bcyan_truck;
                    j = j + 1;
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bcyan_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = fcyan_truck; end
                    %out(28*i-27:28*i,28*j-27:28*j,:) = fcyan_truck;
                else
                    if(amea)
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = cyan_car_amea; end                                                
                        %out(28*i-27:28*i,28*j-27:28*j,:) = cyan_car_amea;
                    else
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(cyan_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = cyan_car; end                                                
                        %out(28*i-27:28*i,28*j-27:28*j,:) = cyan_car;
                    end
                end
            end 
        elseif(road(i,j)==4)
            if(any(vertboole) && all(tp))
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car_amea,-90,'bilinear','crop'); end                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car_amea,-90,'bilinear','crop');
                else
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car,-90,'bilinear','crop'); end                                        
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car,-90,'bilinear','crop');
                end
            else
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = blue_car_amea; end                                                
                    %out(28*i-27:28*i,28*j-27:28*j,:) = blue_car_amea;
                else
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(blue_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = blue_car; end                                                                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = blue_car;
                end
            end 
        elseif(road(i,j)==5)
            if(any(vertboole) && all(tp))
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car_amea,-90,'bilinear','crop'); end                                        
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car_amea,-90,'bilinear','crop');
                else
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car,-90,'bilinear','crop'); end                                                            
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car,-90,'bilinear','crop');
                end
            else
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = purple_car_amea; end                                                
                    %out(28*i-27:28*i,28*j-27:28*j,:) = purple_car_amea;
                else
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(purple_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = purple_car; end                                                                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = purple_car;
                end
            end 
        elseif(road(i,j)==6)
            if(any(vertboole)) 
                out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(down_flash,-90,'bilinear','crop');
            else
                out(28*i-27:28*i,28*j-27:28*j,:) = down_flash;
            end    
        elseif(road(i,j)==7)
            if(any(vertboole))
                if(steps(i,j) > 4*60)
                    out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(flag_exp,-90,'bilinear','crop');
                else
                    out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(flag,-90,'bilinear','crop');
                end
            else
                if(steps(i,j) > 4*60)
                    out(28*i-27:28*i,28*j-27:28*j,:) = flag_exp;
                else
                    out(28*i-27:28*i,28*j-27:28*j,:) = flag;
                end
            end    
        elseif(road(i,j)==8)
            if(any(vertboole))
                out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(up_flash,-90,'bilinear','crop');
            else
                out(28*i-27:28*i,28*j-27:28*j,:) = up_flash;
            end 
        elseif(road(i,j)==9)
            if(any(vertboole))
                if(amea)
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car_amea,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car_amea,-90,'bilinear','crop'); end                                        
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car_amea,-90,'bilinear','crop');
                elseif(~amea && any(all(amea_spots_overall == [i j],2)))
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-90,'bilinear','crop'); end                                                            
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-90,'bilinear','crop');
                else
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car,-90,'bilinear','crop'); end                                                                                
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car,-90,'bilinear','crop');
                end
                if(bellow || flashbellow)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fwhite_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bwhite_truck,-90,'bilinear','crop'); end                                                            
                    %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bwhite_truck,-90,'bilinear','crop');
                    if inv_move == 1; out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(bwhite_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fwhite_truck,-90,'bilinear','crop'); end                                        
                    %out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fwhite_truck,-90,'bilinear','crop');
                    %TURN RED the part of the truck that parked on amea spot
                    if(any(all(amea_spots_overall == [i j],2)) || any(all(amea_spots_overall == [i+1 j],2)))
    					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fred_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bred_truck,-90,'bilinear','crop'); end                                                            
                        %out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bred_truck,-90,'bilinear','crop');
                        if inv_move == 1; out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(bred_truck,-270,'bilinear','crop'); elseif inv_move == 0, out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fred_truck,-90,'bilinear','crop'); end                                                                
                        %out(28*(i+1)-27:28*(i+1),28*j-27:28*j,:) = imrotate(fred_truck,-90,'bilinear','crop');
                    end
                    road(i+1,j) = 100;
                end
            else
                if(front || flashfront)
					if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(fwhite_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = bwhite_truck; end                                                            
                    %out(28*i-27:28*i,28*j-27:28*j,:) = bwhite_truck;
                    j = j + 1;
                    if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bwhite_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = fwhite_truck; end                    
                    %out(28*i-27:28*i,28*j-27:28*j,:) = fwhite_truck;
                    %TURN RED the part of the truck that parked on amea spot
                    if(any(all(amea_spots_overall == [i j-1],2)) || any(all(amea_spots_overall == [i j],2)))
                        if inv_move == 1; out(28*i-27:28*i,28*(j-1)-27:28*(j-1),:) = imrotate(fred_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*(j-1)-27:28*(j-1),:) = bred_truck; end                                                                                    
                        %out(28*i-27:28*i,28*(j-1)-27:28*(j-1),:) = bred_truck;
                        if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(bred_truck,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = fred_truck; end                                            
                        %out(28*i-27:28*i,28*j-27:28*j,:) = fred_truck;
                    end
                else
                    if(amea)
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car_amea,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = white_car_amea; end                                                
                        %out(28*i-27:28*i,28*j-27:28*j,:) = white_car_amea;
                    elseif(~amea && any(all(amea_spots_overall == [i j],2))) %make car red cause it parked on an amea spot
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(red_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = red_car; end                                                                        
                        %out(28*i-27:28*i,28*j-27:28*j,:) = red_car;
                    else
						if inv_move == 1; out(28*i-27:28*i,28*j-27:28*j,:) = imrotate(white_car,-180,'bilinear','crop'); elseif inv_move == 0, out(28*i-27:28*i,28*j-27:28*j,:) = white_car; end                                                                                                
                        %out(28*i-27:28*i,28*j-27:28*j,:) = white_car;
                    end
                end
            end 
        elseif(road(i,j)==10)
            out(28*i-27:28*i,28*j-27:28*j,:) = red_light;
        elseif(road(i,j)==11)
            out(28*i-27:28*i,28*j-27:28*j,:) = green_light;
        elseif(road(i,j)==12)
            out(28*i-27:28*i,28*j-27:28*j,:) = orange_light;
		elseif(road(i,j)==13)
            out(28*i-27:28*i,28*j-27:28*j,:) = stop;
        end
        j = j + 1;
    end
end
f = figure('visible','off');

filename = [save,'/Time = ', datestr(time,'DD-HH-MM-SS')];

%Road MAPPING

if(cell_size == 7.5)
    position =  [1600 140;1600 450;1600 700;1600 930;1600 1160;1600 1440;350 1750;650 1750;1000 1750;1350 1750;1800 1750 ...,
    ;2050 1750;2300 1750];
elseif(cell_size == 5)
    position =  [2500 290;2500 685;2500 1080;2500 1470;2500 1850;2500 2250;620 2700;1050 2700;1400 2700;2000 2700;2750 2700 ...,
    ;3100 2700;3350 2700];
end
values = {'Φυλής';'Αν.Θράκης';'Βιζβύζη';'Αίνου';'Παλαιολόγου';'Ελ.Βενιζέλου';'Μοσχονησίων';'Κομνηνών';'Ι.Δραγούμη'...,
    ;'Ι.Καβύρη';'14ης Μαΐου';'Μαζαράκη';'Πατρ. Ιωακείμ'};
Iout = insertText(uint8(out),position,values,'FontSize',40,'BoxColor','w','BoxOpacity',0.1);
if(focus_point == 0)
	imshow(Iout);
elseif(focus_point == 1)
    imshow(Iout((inter1(1)-4)*28:(inter1(1)+3)*28,(sph(1)-1)*28:end,:));
elseif(focus_point == 2)
    imshow(Iout((inter4(1)-4)*28:(inter4(1)+3)*28,(sph(2)-1)*28:end,:));
elseif(focus_point == 3)
	imshow(Iout((inter7(1)-4)*28:(inter7(1)+3)*28,(sph(3)-1)*28:end,:));
elseif(focus_point == 4)
	imshow(Iout((inter11(1)-4)*28:(inter11(1)+3)*28,(sph(4)-1)*28:end,:));
elseif(focus_point == 5)
	imshow(Iout((inter16(1)-4)*28:(inter16(1)+3)*28,(sph(5)-1)*28:end,:));
elseif(focus_point == 6)
	imshow(Iout((inter23(1)-4)*28:(inter23(1)+3)*28,sph(6):end,:));
elseif(focus_point == 7)
	imshow(Iout((spv(1)-1)*28:end,(inter16(2)-4)*28:(inter16(2)+3)*28,:));
elseif(focus_point == 8)
	imshow(Iout((spv(2)-1)*28:end,(inter11(2)-4)*28:(inter11(2)+3)*28,:));
elseif(focus_point == 9)
	imshow(Iout((spv(3)-1)*28:end,(inter7(2)-4)*28:(inter7(2)+3)*28,:));
elseif(focus_point == 10)
	imshow(Iout((spv(4)-1)*28:end,(inter1(2)-4)*28:(inter1(2)+3)*28,:));
elseif(focus_point == 11)
	imshow(Iout(spv(5):end,(inter2(2)-4)*28:(inter2(2)+3)*28,:));
elseif(focus_point == 12)
	imshow(Iout(spv(6):end,(inter3(2)-4)*28:(inter3(2)+3)*28,:));
elseif(focus_point == 13)
    imshow(Iout((spv(7)-1)*28:end,(inter22(2)-4)*28:(inter22(2)+3)*28,:));
end

title('Κέντρο Αλεξανδρούπολης')
saveas(f,filename,'png');
close;

end