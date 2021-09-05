function [ makespanmax ] = Fun(coordinates,sol_new,q,groups,Palmer)
%FUN 此处显示有关此函数的摘要
%   此处显示详细说明
%     for i=1:q
%         x=find(sol_new==groups(i,1));
%         sol=zeros(1,length(sol_new)+1);
%         sol(1:x)=sol_new(1:x);
%         sol(x+1)=groups(i,2);
%         sol(x+2:end)=sol_new(x+1:end);
%         sol_new=sol;
%     end
    for i=1:q
        x=find(sol_new==groups(i,1));
%         sol=zeros(1,length(sol_new)+1);
        if x<length(sol_new)
        if Palmer(sol_new(x+1))<Palmer(groups(i,2))
            sol=[sol_new(1:x),groups(i,2),sol_new(x+1:end)];
        else
            %x=round(rand(1)*length(sol_new));
            sol=[sol_new(1:x+1),groups(i,2),sol_new(x+2:end)];
        end
        else
            sol=[sol_new(1:x),groups(i,2),sol_new(x+1:end)];
%         sol(x+1)=groups(i,2);
        end
%         sol(x+2:end)=sol_new(x+1:end);
        sol_new=sol;
    end
    
    
  for i=1:200
      processingtime(:,i)=coordinates(:,sol_new(i));
  end
[row,column]=size(processingtime);
makespan=zeros(row,column);
makespan(1,:)=cumsum(processingtime(1,:));
makespan(:,1)=cumsum(processingtime(:,1));
for i=2:row
    for j=2:column
        makespan(i,j)=max(makespan(i-1,j),makespan(i,j-1))+processingtime(i,j);
    end
end
makespanmax=makespan(end,end);


end

