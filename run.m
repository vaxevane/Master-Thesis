focus_lane = 0;
filename = 'Simulation per Scale Video';
prev_epoches = 0;
duration = 24*60*60;%on seconds
snaps = 1;%seconds for each snapshot
traf_l_or_stops = 0;%1 for traffic lights 0 for stops (on all intersections)
season = 'w'; %'w' for winter 's' for summer
cell_size = 5;
values = main(focus_lane,filename,cell_size,prev_epoches,duration,snaps,traf_l_or_stops,season);



%values = main('test',20,25,1,1,'w',values);


%Potentially saving the results and cont. with future epoches
% if(value_cont_true)
%     max_epoch = 1;
%     [test] =$ main('SIM9999',max_epoch);
%     full_road = test{1};
%     fileID = fopen(['full_road till Epoch = ', num2str(max_epoch),'.txt'],'w+');
%     for i=1:50
%         for j=1:50
%             fprintf(fileID,'%d ',arr(i,j));
%         end
%         fprintf(fileID,'\n');
%     end
%     fclose(fileID);
% end