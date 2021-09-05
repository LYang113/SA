function [makespanmax ] = Conbine( coordinates)
coordinates=coordinates';
[~,k]=size(coordinates);
 sol_new=1:k;
for i=1:k
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

