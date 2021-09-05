clc,clear;
load('TA.mat');
% [~,I]=sort(chushi(1,:));
% for i=1:length(I)
%     A(:,i)=chushi(:,I(i));
% end
Palmer=zeros(1,200);
chushi=chushi';
[ groups,q ]=group(chushi);

sol_best = SA(chushi,groups,q);
