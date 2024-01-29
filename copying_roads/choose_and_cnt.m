function [full_road,cnt_rt,cnt_rl] = choose_and_cnt(full_road,topred,cnt_rt,cnt_rl,inters,varargin)%varargin will have all temp lanes and all intersections

for i=1:length(topred)
    val = varargin{i};
    if(topred(i))
        full_road(inters(i,1),inters(i,2)) = val(1);
        cnt_rt(i) = cnt_rt(i) + 1;
    else
        full_road(inters(i,1),inters(i,2)) = val(2);
        cnt_rl(i) = cnt_rl(i) + 1;
    end
end