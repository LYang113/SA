function [sequence ] = NEH( S )
%NEH �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
S=S';
[jobSize,machineSize,] = size(S);
S_row = sum(S,2);
[~,index] = sort(S_row);
index = fliplr(index')';
newS = S(index,:);
%2.���ȱȽ�job1��job2��˳��Ȼ��job3��job4...���ϵĲ��벢�ж���С��makespan������Ϊֹ
for i = 1:1:(jobSize-1)
    tempMakespan = 100000;
     if i==1
            tempS = newS(1,1:machineSize);   %��ȡ����
            sequence = tempS;
     end
    for j = 1:1:(i+1) 
       
        if j==1                         %���뵽����job����ǰ�档
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

