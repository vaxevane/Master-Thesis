function [f_rd,hor,hor2,hor3,hor4,hor5,hor6,vert,vert2,vert3,vert4,vert5,vert6,vert7,ID_max,delay_parking_ID,ID_park,tir] = ...
    initialize_road(save,time,cell_size,inv,sph,spv,f_rd,cars1,cars2,cars3,cars4,cars5,cars6,inter_cell,tir,wtl,amea_freq)

inter1 = inter_cell{1}; %hor1 vert4
inter2 = inter_cell{2}; %vert5
inter3 = inter_cell{3}; %vert6
inter4 = inter_cell{4}; %hor2
inter5 = inter_cell{5};
inter6 = inter_cell{6};
inter7 = inter_cell{7}; %hor3 & vert3
inter8 = inter_cell{8};
inter9 = inter_cell{9};
inter10 = inter_cell{10};
inter11 = inter_cell{11}; %vert2 hor4
inter12 = inter_cell{12};
inter13 = inter_cell{13};
inter14 = inter_cell{14};
inter15 = inter_cell{15};
inter16 = inter_cell{16}; %vert1 hor5
inter17 = inter_cell{17};
inter18 = inter_cell{18};
inter19 = inter_cell{19};
inter20 = inter_cell{20};
inter21 = inter_cell{21};
inter22 = inter_cell{22};
inter23 = inter_cell{23}; %hor6
inter24 = inter_cell{24};
inter25 = inter_cell{25};
inter26 = inter_cell{26};
inter27 = inter_cell{27};
inter28 = inter_cell{28};
inter29 = inter_cell{29};

priority = [1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 0 0 1 1 1 0 0 0 0 1 1 1 0]; %if 1 priority on vert if 0 priority on hor
d = 1;


%Starting points for each road: 7.5 meter per  cell
%sph = [47 42 31 22 12 1]; CORRECT
%spv = [41 34 24 9 1 1 46];CORRECT

%Starting points for each road: 5 meter per  cell
%sph = [74 69 58 49 39 1]; CORRECT
%spv = [75 67 57 42 1 1 82];CORRECT

for roads=1:13
    if (roads == 1)
        ID_max = 0;
        if(cell_size == 7.5)%size was 26
            [hor_lane,hor_Car_ID,hor_park_signals,hor_park_flags,hor_steps_parked,ID_max] = init_lane7(d,54,sph(1),cars1,ID_max,0,0,0,0,inter1(2),3,12,inter2(2),2,5);
        elseif(cell_size == 5)%size should be 70 
            [hor_lane,hor_Car_ID,hor_park_signals,hor_park_flags,hor_steps_parked,ID_max] = init_lane5(d,74,sph(1),cars1,ID_max,0,0,0,0,0,inter1(2),2,7,26,20,inter2(2),2,4,6,7);
        end
    elseif (roads == 2)
        if(cell_size == 7.5)%size was 37
            [hor2_lane,hor2_Car_ID,hor2_park_signals,hor2_park_flags,hor2_steps_parked,ID_max] = init_lane7(d,59,sph(2),cars2,ID_max,1,2,8,0,inter4(2),2,14,inter5(2),2,5);            
        elseif(cell_size == 5)
            [hor2_lane,hor2_Car_ID,hor2_park_signals,hor2_park_flags,hor2_steps_parked,ID_max] = init_lane5(d,88,sph(2),cars2,ID_max,2,2,8,2,8,inter4(2),2,3,20,17,inter5(2),2,3,8,8);
        end
	elseif (roads == 3)
        if(cell_size == 7.5)%size was 45
            [hor3_lane,hor3_Car_ID,hor3_park_signals,hor3_park_flags,hor3_steps_parked,ID_max] = init_lane7(d,70,sph(3),cars3,ID_max,1,4,5,0,inter7(2),2,9,inter8(2),2,14,inter9(2),2,5);            
        elseif(cell_size == 5)
            [hor3_lane,hor3_Car_ID,hor3_park_signals,hor3_park_flags,hor3_steps_parked,ID_max] = init_lane5(d,99,sph(3),cars3,ID_max,2,2,4,2,2,inter7(2),2,4,17,16,inter8(2),2,3,20,17,inter9(2),2,3,8,6);            
        end
    elseif (roads == 4)
        if(cell_size == 7.5)%size was 66
            [hor4_lane,hor4_Car_ID,hor4_park_signals,hor4_park_flags,hor4_steps_parked,ID_max] = init_lane7(d,79,sph(4),cars3,ID_max,1,2,4,0,inter11(2),2,6,inter12(2),2,9,inter13(2),2,14,inter14(2),2,5,inter15(2),2,18);            
        elseif(cell_size == 5)%size should be 112
            [hor4_lane,hor4_Car_ID,hor4_park_signals,hor4_park_flags,hor4_steps_parked,ID_max] = init_lane5(d,113,sph(4),cars3,ID_max,2,2,4,2,4,inter11(2),2,4,11,7,inter12(2),2,3,14,10,inter13(2),2,3,20,17,inter14(2),2,3,8,8,inter15(2),2,2,27,25);            
        end
	elseif (roads == 5)
        if(cell_size == 7.5)
            [hor5_lane,hor5_Car_ID,hor5_park_signals,hor5_park_flags,hor5_steps_parked,ID_max] = init_lane7(d,89,sph(5),cars3,ID_max,1,2,5,0,inter16(2),2,5,inter17(2),3,6,inter18(2),2,10,inter19(2),3,14,inter20(2),2,5,inter21(2),2,3,inter22(2),3,10);            
        elseif(cell_size == 5)%inter17down instead of 12 10 inter18 and inter19 should be 20 and 30 slots but not enough space we have 17 and 25,inter22 should have 10 no 7 slots down
            [hor5_lane,hor5_Car_ID,hor5_park_signals,hor5_park_flags,hor5_steps_parked,ID_max] = init_lane5(d,131,sph(5),cars3,ID_max,2,1,10,2,5,inter16(2),2,2,11,7,inter17(2),2,2,11,9,inter18(2),2,2,18,7,inter19(2),2,2,26,16,inter20(2),2,3,12,9,inter21(2),2,2,8,8,inter22(2),1,2,15);                        
        end
    elseif (roads == 6)
        if(cell_size == 7.5)
            [hor6_lane,hor6_Car_ID,hor6_park_signals,hor6_park_flags,hor6_steps_parked,ID_max] = init_lane7(d,100,sph(6),cars3,ID_max,1,3,15,0,inter23(2),2,5,inter24(2),3,7,inter25(2),2,10,inter27(2),2,5,inter28(2),2,3,inter29(2),3,11);            
        elseif(cell_size == 5)%inter24up instead of 13 10 inter25up instead of 20 17 inter27up instead of 10 9 inter28up instead of 12 8 inter 29up instead of 22 20
            [hor6_lane,hor6_Car_ID,hor6_park_signals,hor6_park_flags,hor6_steps_parked,ID_max] = init_lane5(d,147,sph(6),cars3,ID_max,2,2,14,2,25,inter23(2),2,2,6,11,inter24(2),2,2,5,11,inter25(2),2,2,9,18,inter26(2),2,20,21,25,inter27(2),2,2,6,10,inter28(2),2,2,7,8,inter29(2),2,2,21,21);                        
        end
    elseif (roads == 7)
        if(cell_size == 7.5)%size was 25 RECHECK PARKS reduced start by 1
            [vert_lane,vert_Car_ID,vert_park_signals,vert_park_flags,vert_steps_parked,ID_max] = init_lane7(d,26,spv(1),cars4,ID_max,1,2,3,0,inter16(1),2,7,inter23(1),3,6);
        elseif(cell_size == 5)
            [vert_lane,vert_Car_ID,vert_park_signals,vert_park_flags,vert_steps_parked,ID_max] = init_lane5(d,38,spv(1),cars4,ID_max,2,2,5,2,6,inter16(1),2,3,10,10,inter23(1),2,3,7,10);            
        end
    elseif (roads == 8)
        if(cell_size == 7.5)%size was 35 RECHECK PARKS reduced start by 1
            [vert2_lane,vert2_Car_ID,vert2_park_signals,vert2_park_flags,vert2_steps_parked,ID_max] = init_lane7(d,33,spv(2),cars5,ID_max,1,1,2,0,inter11(1),2,5,inter17(1),2,7,inter24(1),3,6);   
        elseif(cell_size == 5)
            [vert2_lane,vert2_Car_ID,vert2_park_signals,vert2_park_flags,vert2_steps_parked,ID_max] = init_lane5(d,50,spv(2),cars5,ID_max,2,2,4,2,4,inter11(1),2,3,9,11,inter17(1),2,2,7,11,inter24(1),2,3,9,9);               
        end
    elseif (roads == 9)
        if(cell_size == 7.5)%size was 46 RECHECK PARKS AT inter7,12
            [vert3_lane,vert3_Car_ID,vert3_park_signals,vert3_park_flags,vert3_steps_parked,ID_max] = init_lane7(d,43,spv(3),cars6,ID_max,1,2,3,1,inter7(1),2,5,inter12(1),2,5,inter18(1),2,7,inter25(1),2,4);            
        elseif(cell_size == 5)
            [vert3_lane,vert3_Car_ID,vert3_park_signals,vert3_park_flags,vert3_steps_parked,ID_max] = init_lane5(d,64,spv(3),cars6,ID_max,1,2,4,0,0,inter7(1),1,3,11,inter12(1),1,3,11,inter18(1),1,6,11,inter25(1),1,2,4);                        
        end
    elseif (roads == 10)
        if(cell_size == 7.5)
            [vert4_lane,vert4_Car_ID,vert4_park_signals,vert4_park_flags,vert4_steps_parked,ID_max] = init_lane7(d,58,spv(4),cars6,ID_max,0,0,0,1,inter1(1),4,5,inter4(1),2,6,inter8(1),2,4);            
        elseif(cell_size == 5)
            [vert4_lane,vert4_Car_ID,vert4_park_signals,vert4_park_flags,vert4_steps_parked,ID_max] = init_lane5(d,87,spv(4),cars6,ID_max,0,0,0,0,0,inter1(1),1,5,10,inter4(1),1,5,10,inter8(1),1,3,4);                        
        end
    elseif (roads == 11)
        if(cell_size == 7.5)%RECHECK PARKS AT inter5,9,14 RECHECK PARKS reduced start by 1 
            [vert5_lane,vert5_Car_ID,vert5_park_signals,vert5_park_flags,vert5_steps_parked,ID_max] = init_lane7(d,66,spv(5),cars6,ID_max,1,2,7,0,inter2(1),2,7,inter5(1),2,6,inter9(1),2,5,inter14(1),2,5,inter20(1),2,6,inter27(1),3,6);            
        elseif(cell_size == 5)
            [vert5_lane,vert5_Car_ID,vert5_park_signals,vert5_park_flags,vert5_steps_parked,ID_max] = init_lane5(d,100,spv(5),cars6,ID_max,2,3,8,3,8,inter2(1),2,4,10,8,inter5(1),2,4,11,8,inter9(1),2,3,8,8,inter14(1),2,4,7,9,inter20(1),2,4,9,6,inter27(1),2,5,10,10);                        
        end
    elseif (roads == 12)
        if(cell_size == 7.5)%RECHECK PARKS AT inter10,15
            [vert6_lane,vert6_Car_ID,vert6_park_signals,vert6_park_flags,vert6_steps_parked,ID_max] = init_lane7(d,66,spv(6),cars6,ID_max,0,0,0,1,inter3(1),2,7,inter6(1),2,6,inter10(1),2,5,inter15(1),2,5);            
        elseif(cell_size == 5)
            [vert6_lane,vert6_Car_ID,vert6_park_signals,vert6_park_flags,vert6_steps_parked,ID_max] = init_lane5(d,100,spv(6),cars6,ID_max,0,0,0,0,0,inter3(1),1,3,12,inter6(1),1,4,11,inter10(1),1,4,11,inter15(1),1,4,10);                        
        end
    elseif (roads == 13)
        if(cell_size == 7.5)
            [vert7_lane,vert7_Car_ID,vert7_park_signals,vert7_park_flags,vert7_steps_parked,ID_max] = init_lane7(d,21,spv(7),cars6,ID_max,0,0,0,1,inter22(1),2,6,inter29(1),3,5);           
        elseif(cell_size == 5)
            [vert7_lane,vert7_Car_ID,vert7_park_signals,vert7_park_flags,vert7_steps_parked,ID_max] = init_lane5(d,30,spv(7),cars6,ID_max,0,0,0,0,0,inter22(1),1,3,10,inter29(1),1,3,10);                       
        end
    end
end
%Replace till here with new func init_lane

%len_matrix = [length(hor_lane),length(vert_lane),length(vert2_lane),length(hor2_lane)];%every lane might have diff size
%full_road = init_bound(full_road,len_matrix,[intersection(1) 0],[0 intersection2(2)],[0 intersection3(2)],[intersection4(1) 0]);
%Replace till here with func init_bound

[delay_parking_ID,ID_park] = init_park_variables(ID_max);

if(wtl == 1)
	f_rd = init_traffic_light(f_rd,inter_cell);
elseif(wtl == 0)
	f_rd = init_traffic_crossing(f_rd,inter_cell,priority,[inv(1) inv(10);inv(1) inv(11);inv(1) inv(12);inv(2) inv(10);inv(2) inv(11);...
        inv(2) inv(12);inv(3) inv(9);inv(3) inv(10);inv(3) inv(11);inv(3) inv(12);inv(4) inv(8);inv(4) inv(9);inv(4) inv(10);...
        inv(4) inv(11);inv(4) inv(12);inv(5) inv(7);inv(5) inv(8);inv(5) inv(9);inv(5) inv(10);inv(5) inv(11);inv(5) inv(12);...
        inv(5) inv(13);inv(6) inv(7);inv(6) inv(8);inv(6) inv(9);inv(6) inv(10);inv(6) inv(11);inv(6) inv(12);inv(6) inv(13)]);
end
tir(1:29) = double(~priority);
%Replace till here with func init_traffic_light

f_rd = copying(f_rd,hor_lane,sph(1),[inter1(1) 0],hor2_lane,sph(2),[inter4(1) 0],...
    hor3_lane,sph(3),[inter7(1) 0],hor4_lane,sph(4),[inter11(1) 0],hor5_lane,sph(5),[inter16(1) 0],...
    hor6_lane,sph(6),[inter23(1) 0],vert_lane,spv(1),[0 inter16(2)],vert2_lane,spv(2),[0 inter11(2)],...
    vert3_lane,spv(3),[0 inter7(2)],vert4_lane,spv(4),[0 inter1(2)],vert5_lane,spv(5),[0 inter2(2)],...
    vert6_lane,spv(6),[0 inter3(2)],vert7_lane,spv(7),[0 inter22(2)]);
%Replace till here with func copying

f_rd = show_befaft_inter(f_rd,hor_lane,[inter1(1) inter1(2) inter2(2) inter3(2)],sph(1),...
    hor2_lane,[inter4(1) inter4(2) inter5(2) inter6(2)],sph(2),...
    hor3_lane,[inter7(1) inter7(2) inter8(2) inter9(2) inter10(2)],sph(3),...
    hor4_lane,[inter11(1) inter11(2) inter12(2) inter13(2) inter14(2) inter15(2)],sph(4),...
    hor5_lane,[inter16(1) inter16(2) inter17(2) inter18(2) inter19(2) inter20(2) inter21(2) inter22(2)],sph(5),...
    hor6_lane,[inter23(1) inter23(2) inter24(2) inter25(2) inter26(2) inter27(2) inter28(2) inter29(2)],sph(6));
%Replace till here with func show_befaft_inter 


[vert_lane,vert_park_signals,vert_Car_ID,vert2_lane,vert2_park_signals,vert2_Car_ID,...
    vert3_lane,vert3_park_signals,vert3_Car_ID,vert4_lane,vert4_park_signals,vert4_Car_ID,vert5_lane,vert5_park_signals,...
    vert5_Car_ID,vert6_lane,vert6_park_signals,vert6_Car_ID,vert7_lane,vert7_park_signals,vert7_Car_ID,...
    hor_lane,hor_park_signals,hor_Car_ID,hor2_lane,hor2_park_signals,hor2_Car_ID,hor3_lane,hor3_park_signals,hor3_Car_ID,...
    hor4_lane,hor4_park_signals,hor4_Car_ID,hor5_lane,hor5_park_signals,hor5_Car_ID,hor6_lane,hor6_park_signals,hor6_Car_ID]...
    = insert_obstacle(vert_lane,vert_park_signals,vert_Car_ID,[inter16(1) priority(16) inter23(1) priority(23)],spv(1),...
    vert2_lane,vert2_park_signals,vert2_Car_ID,[inter11(1) priority(11) inter17(1) priority(17) inter24(1) priority(24)],spv(2),...
    vert3_lane,vert3_park_signals,vert3_Car_ID,[inter7(1) priority(7) inter12(1) priority(12) inter18(1) priority(18) inter25(1) priority(25)],spv(3),...
    vert4_lane,vert4_park_signals,vert4_Car_ID,[inter1(1) priority(1) inter4(1) priority(4) inter8(1) priority(8) inter13(1) priority(13) inter19(1) priority(19) inter26(1) priority(26)],spv(4),...
    vert5_lane,vert5_park_signals,vert5_Car_ID,[inter2(1) priority(2) inter5(1) priority(5) inter9(1) priority(9) inter14(1) priority(14) inter20(1) priority(20) inter27(1) priority(27)],spv(5),...
    vert6_lane,vert6_park_signals,vert6_Car_ID,[inter3(1) priority(3) inter6(1) priority(6) inter10(1) priority(10) inter15(1) priority(15) inter21(1) priority(21) inter28(1) priority(28)],spv(6),...
    vert7_lane,vert7_park_signals,vert7_Car_ID,[inter22(1) priority(22) inter29(1) priority(29)],spv(7),...
    hor_lane,hor_park_signals,hor_Car_ID,[inter1(2) ~priority(1) inter2(2) ~priority(2) inter3(2) ~priority(3)],sph(1),...
    hor2_lane,hor2_park_signals,hor2_Car_ID,[inter4(2) ~priority(4) inter5(2) ~priority(5) inter6(2) ~priority(6)],sph(2),...
    hor3_lane,hor3_park_signals,hor3_Car_ID,[inter7(2) ~priority(7) inter8(2) ~priority(8) inter9(2) ~priority(9) inter10(2) ~priority(10)],sph(3),...
    hor4_lane,hor4_park_signals,hor4_Car_ID,[inter11(2) ~priority(11) inter12(2) ~priority(12) inter13(2) ~priority(13) inter14(2) ~priority(14) inter15(2) ~priority(15)],sph(4),...
    hor5_lane,hor5_park_signals,hor5_Car_ID,[inter16(2) ~priority(16) inter17(2) ~priority(17) inter18(2) ~priority(18) inter19(2) ~priority(19) inter20(2) ~priority(20) inter21(2) ~priority(21) inter22(2) ~priority(22)],sph(5),...
    hor6_lane,hor6_park_signals,hor6_Car_ID,[inter23(2) ~priority(23) inter24(2) ~priority(24) inter25(2) ~priority(25) inter26(2) ~priority(26) inter27(2) ~priority(27) inter28(2) ~priority(28) inter29(2) ~priority(29)],sph(6));
%Replace till here with func insert_obstacle


hor = {hor_lane,hor_Car_ID,hor_park_signals,hor_park_flags,hor_steps_parked};
hor2 = {hor2_lane,hor2_Car_ID,hor2_park_signals,hor2_park_flags,hor2_steps_parked};
hor3 = {hor3_lane,hor3_Car_ID,hor3_park_signals,hor3_park_flags,hor3_steps_parked};
hor4 = {hor4_lane,hor4_Car_ID,hor4_park_signals,hor4_park_flags,hor4_steps_parked};
hor5 = {hor5_lane,hor5_Car_ID,hor5_park_signals,hor5_park_flags,hor5_steps_parked};
hor6 = {hor6_lane,hor6_Car_ID,hor6_park_signals,hor6_park_flags,hor6_steps_parked};
vert = {vert_lane,vert_Car_ID,vert_park_signals,vert_park_flags,vert_steps_parked};
vert2 = {vert2_lane,vert2_Car_ID,vert2_park_signals,vert2_park_flags,vert2_steps_parked};
vert3 = {vert3_lane,vert3_Car_ID,vert3_park_signals,vert3_park_flags,vert3_steps_parked};
vert4 = {vert4_lane,vert4_Car_ID,vert4_park_signals,vert4_park_flags,vert4_steps_parked};
vert5 = {vert5_lane,vert5_Car_ID,vert5_park_signals,vert5_park_flags,vert5_steps_parked};
vert6 = {vert6_lane,vert6_Car_ID,vert6_park_signals,vert6_park_flags,vert6_steps_parked};
vert7 = {vert7_lane,vert7_Car_ID,vert7_park_signals,vert7_park_flags,vert7_steps_parked};

draw(0,save,time,cell_size,f_rd,inter_cell,hor,hor2,hor3,hor4,hor5,hor6,vert,vert2,vert3,vert4,vert5,vert6,vert7,tir,sph,spv,amea_freq);