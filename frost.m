clc, clear all, close all

mkdir('index')

header = ufmf_read_header('fast8.ufmf');


[Ibg,Shist] = bg_simple_ufmf(header, 'fast8.ufmf',1:1000,1,'fast8.bg.bmp', 10, []);


obj_info = ufmf_main(header,'.','fast8.ufmf',1:(header.nframes),'fast8.bg.bmp',1,uint8(ones(size(Ibg))),1,48,[]);

[analysis_info_1] = analysis_olympiad(obj_info, 1, 7.5, 1, [0 size(Ibg,2) 0 200]);
% [analysis_info_2] = analysis_olympiad(obj_info, 1, 7.5, 1, [0 size(Ibg,2) 200 400]);
% [analysis_info_3] = analysis_olympiad(obj_info, 1, 7.5, 1, [0 size(Ibg,2) 400 600]);
% [analysis_info_4] = analysis_olympiad(obj_info, 1, 7.5, 1, [0 size(Ibg,2) 600 800]);
% [analysis_info_5] = analysis_olympiad(obj_info, 1, 7.5, 1, [0 size(Ibg,2) 800 1000]);
% 
num_left_1 = sum(analysis_info_1.pos_hist(1:50,:),1);
% num_left_2 = sum(analysis_info_2.pos_hist(1:50,:),1);
% num_left_3 = sum(analysis_info_3.pos_hist(1:50,:),1);
% num_left_4 = sum(analysis_info_4.pos_hist(1:50,:),1);
% num_left_5 = sum(analysis_info_5.pos_hist(1:50,:),1);
% 
num_right_1 = sum(analysis_info_1.pos_hist(51:101,:),1);
% num_right_2 = sum(analysis_info_2.pos_hist(51:101,:),1);
% num_right_3 = sum(analysis_info_3.pos_hist(51:101,:),1);
% num_right_4 = sum(analysis_info_4.pos_hist(51:101,:),1);
% num_right_5 = sum(analysis_info_5.pos_hist(51:101,:),1);
% 
% num_left=zeros(5,length(num_left_1));
% num_right=zeros(5,length(num_left_1));
% 
% num_left(1,:)=num_left_1;
% num_left(2,:)=num_left_2;
% num_left(3,:)=num_left_3;
% num_left(4,:)=num_left_4;
% num_left(5,:)=num_left_5;
% 
% num_right(1,:)=num_right_1;
% num_right(2,:)=num_right_2;
% num_right(3,:)=num_right_3;
% num_right(4,:)=num_right_4;
% num_right(5,:)=num_right_5;
% 
magicindex_lefton=zeros(5,length(num_left_1));
magicindex_righton=zeros(5,length(num_left_1));


for i=1:length(num_left_1)
    
    magicindex_righton(1,i)=(num_right_1(i) - num_left_1(i))/(num_right_1(i) + num_left_1(i));
    magicindex_lefton(1,i)=(num_left_1(i) - num_right_1(i))/(num_right_1(i) + num_left_1(i));
%     
%     magicindex_righton(2,i)=(num_right_2(i) - num_left_2(i))/(num_right_2(i) + num_left_2(i));
%     magicindex_lefton(2,i)=(num_left_2(i) - num_right_2(i))/(num_right_2(i) + num_left_2(i));
%     
%     magicindex_righton(3,i)=(num_right_3(i) - num_left_3(i))/(num_right_3(i) + num_left_3(i));
%     magicindex_lefton(3,i)=(num_left_3(i) - num_right_3(i))/(num_right_3(i) + num_left_3(i));
%     
%     magicindex_righton(4,i)=(num_right_4(i) - num_left_4(i))/(num_right_4(i) + num_left_4(i));
%     magicindex_lefton(4,i)=(num_left_4(i) - num_right_4(i))/(num_right_4(i) + num_left_4(i));
%     
%     magicindex_righton(5,i)=(num_right_5(i) - num_left_5(i))/(num_right_5(i) + num_left_5(i));
%     magicindex_lefton(5,i)=(num_left_5(i) - num_right_5(i))/(num_right_5(i) + num_left_5(i));
%     
end

% 
% S=struct('magicindex_lefton', magicindex_lefton,'magicindex_righton', magicindex_righton,'num_left', num_left, 'num_right', num_right);
% save('./index/Q.mat', 'S')
