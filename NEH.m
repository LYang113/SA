function [sequence ] = NEH( S )
%NEH 此处显示有关此函数的摘要
%   此处显示详细说明
S=S';
[jobSize,machineSize,] = size(S);
S_row = sum(S,2);
[~,index] = sort(S_row);
index = fliplr(index')';
newS = S(index,:);
%2.首先比较job1与job2的顺序，然后将job3，job4...不断的插入并判断最小的makespan，插完为止
for i = 1:1:(jobSize-1)
    tempMakespan = 100000;
     if i==1
            tempS = newS(1,1:machineSize);   %截取矩阵
            sequence = tempS;
     end
    for j = 1:1:(i+1) 
       
        if j==1                         %插入到所有job的最前面。
            tempS = cat(1,newS((i+1),:),sequence);
        end
        if j>1 && j<(i+1)
            tempS = cat(1,sequence(1:(j-1),:),newS((i+1),:),sequence(j:i,:));
        end
        if j == (i+1)
            tempS = cat(1,sequence(1:i,:),newS((i+1),:));
        end
        
        TMS= Conbine(tempS);
        
         if TMS < tempMakespan
            tempMakespan = TMS; 
            tempSequence = tempS;
%             tempS1 = tempS;
         end
    end
    sequence = tempSequence;
end

sequence=sequence';
end

