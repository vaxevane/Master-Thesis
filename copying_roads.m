function [full_road,count_red_top,count_red_left] = copying_roads(full_road,hor_temp,hor2_temp,hor3_temp,...
    hor4_temp,hor5_temp,hor6_temp,vert_temp,vert2_temp,vert3_temp,vert4_temp,vert5_temp,vert6_temp,vert7_temp,inter_cell,...
    count_red_top,count_red_left,top_is_red,sph,spv)

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

full_road = copying(full_road,hor_temp,sph(1),[inter1(1) 0],hor2_temp,sph(2),[inter4(1) 0],...
    hor3_temp,sph(3),[inter7(1) 0],hor4_temp,sph(4),[inter11(1) 0],hor5_temp,sph(5),[inter16(1) 0],...
    hor6_temp,sph(6),[inter23(1) 0],vert_temp,spv(1),[0 inter16(2)],vert2_temp,spv(2),[0 inter11(2)],...
    vert3_temp,spv(3),[0 inter7(2)],vert4_temp,spv(4),[0 inter1(2)],vert5_temp,spv(5),[0 inter2(2)],...
    vert6_temp,spv(6),[0 inter3(2)],vert7_temp,spv(7),[0 inter22(2)]);

full_road = show_befaft_inter(full_road,hor_temp,[inter1(1) inter1(2) inter2(2) inter3(2)],sph(1),...
    hor2_temp,[inter4(1) inter4(2) inter5(2) inter6(2)],sph(2),...
    hor3_temp,[inter7(1) inter7(2) inter8(2) inter9(2) inter10(2)],sph(3),...
    hor4_temp,[inter11(1) inter11(2) inter12(2) inter13(2) inter14(2) inter15(2)],sph(4),...
    hor5_temp,[inter16(1) inter16(2) inter17(2) inter18(2) inter19(2) inter20(2) inter21(2) inter22(2)],sph(5),...
    hor6_temp,[inter23(1) inter23(2) inter24(2) inter25(2) inter26(2) inter27(2) inter28(2) inter29(2)],sph(6));


if1 = [hor_temp(1,1+inter1(2)-sph(1)) vert4_temp(1,1+inter1(1)-spv(4))];
if2 = [hor_temp(1,1+inter2(2)-sph(1)) vert5_temp(1,1+inter2(1)-spv(5))];
if3 = [hor_temp(1,1+inter3(2)-sph(1)) vert6_temp(1,1+inter3(1)-spv(6))];
if4 = [hor2_temp(1,1+inter4(2)-sph(2)) vert4_temp(1,1+inter4(1)-spv(4))];
if5 = [hor2_temp(1,1+inter5(2)-sph(2)) vert5_temp(1,1+inter5(1)-spv(5))];
if6 = [hor2_temp(1,1+inter6(2)-sph(2)) vert6_temp(1,1+inter6(1)-spv(6))];
if7 = [hor3_temp(1,1+inter7(2)-sph(3)) vert3_temp(1,1+inter7(1)-spv(3))];
if8 = [hor3_temp(1,1+inter8(2)-sph(3)) vert4_temp(1,1+inter8(1)-spv(4))];
if9 = [hor3_temp(1,1+inter9(2)-sph(3)) vert5_temp(1,1+inter9(1)-spv(5))];
if10 = [hor3_temp(1,1+inter10(2)-sph(3)) vert6_temp(1,1+inter10(1)-spv(6))];
if11 = [hor4_temp(1,1+inter11(2)-sph(4)) vert2_temp(1,1+inter11(1)-spv(2))];
if12 = [hor4_temp(1,1+inter12(2)-sph(4)) vert3_temp(1,1+inter12(1)-spv(3))];
if13 = [hor4_temp(1,1+inter13(2)-sph(4)) vert4_temp(1,1+inter13(1)-spv(4))];
if14 = [hor4_temp(1,1+inter14(2)-sph(4)) vert5_temp(1,1+inter14(1)-spv(5))];
if15 = [hor4_temp(1,1+inter15(2)-sph(4)) vert6_temp(1,1+inter15(1)-spv(6))];
if16 = [hor5_temp(1,1+inter16(2)-sph(5)) vert_temp(1,1+inter16(1)-spv(1))];
if17 = [hor5_temp(1,1+inter17(2)-sph(5)) vert2_temp(1,1+inter17(1)-spv(2))];
if18 = [hor5_temp(1,1+inter18(2)-sph(5)) vert3_temp(1,1+inter18(1)-spv(3))];
if19 = [hor5_temp(1,1+inter19(2)-sph(5)) vert4_temp(1,1+inter19(1)-spv(4))];
if20 = [hor5_temp(1,1+inter20(2)-sph(5)) vert5_temp(1,1+inter20(1)-spv(5))];
if21 = [hor5_temp(1,1+inter21(2)-sph(5)) vert6_temp(1,1+inter21(1)-spv(6))];
if22 = [hor5_temp(1,1+inter22(2)-sph(5)) vert7_temp(1,1+inter22(1)-spv(7))];
if23 = [hor6_temp(1,1+inter23(2)-sph(6)) vert_temp(1,1+inter23(1)-spv(1))];
if24 = [hor6_temp(1,1+inter24(2)-sph(6)) vert2_temp(1,1+inter24(1)-spv(2))];
if25 = [hor6_temp(1,1+inter25(2)-sph(6)) vert3_temp(1,1+inter25(1)-spv(3))];
if26 = [hor6_temp(1,1+inter26(2)-sph(6)) vert4_temp(1,1+inter26(1)-spv(4))];
if27 = [hor6_temp(1,1+inter27(2)-sph(6)) vert5_temp(1,1+inter27(1)-spv(5))];
if28 = [hor6_temp(1,1+inter28(2)-sph(6)) vert6_temp(1,1+inter28(1)-spv(6))];
if29 = [hor6_temp(1,1+inter29(2)-sph(6)) vert7_temp(1,1+inter29(1)-spv(7))];
%dummies
if30 = [hor_temp(1,1+inter30(2)-sph(1)) -3];
if31 = [hor2_temp(1,1+inter31(2)-sph(2)) -3];
if32 = [hor3_temp(1,1+inter32(2)-sph(3)) -3];
if33 = [hor4_temp(1,1+inter33(2)-sph(4)) -3];

inters = [inter1(1) inter1(2);inter2(1) inter2(2);inter3(1) inter3(2);inter4(1) inter4(2);inter5(1) inter5(2);...
    inter6(1) inter6(2);inter7(1) inter7(2);inter8(1) inter8(2);inter9(1) inter9(2);inter10(1) inter10(2);...
    inter11(1) inter11(2);inter12(1) inter12(2);inter13(1) inter13(2);inter14(1) inter14(2);inter15(1) inter15(2);...
    inter16(1) inter16(2);inter17(1) inter17(2);inter18(1) inter18(2);inter19(1) inter19(2);inter20(1) inter20(2);...
    inter21(1) inter21(2);inter22(1) inter22(2);inter23(1) inter23(2);inter24(1) inter24(2);inter25(1) inter25(2);...
    inter26(1) inter26(2);inter27(1) inter27(2);inter28(1) inter28(2);inter29(1) inter29(2);inter30(1) inter30(2);...
    inter31(1) inter31(2);inter32(1) inter32(2);inter33(1) inter33(2)];

[full_road,count_red_top,count_red_left] = choose_and_cnt(full_road,top_is_red,count_red_top,count_red_left,inters,...
    if1,if2,if3,if4,if5,if6,if7,if8,if9,if10,if11,if12,if13,if14,if15,if16,if17,if18,if19,if20,if21,if22,if23,if24,...
    if25,if26,if27,if28,if29,if30,if31,if32,if33);
