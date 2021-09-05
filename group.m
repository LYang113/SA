function [ output,q ] = group( A )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n]=size(A);
E_new=zeros(n,n);
 output=[0,0];
q=1;
for i=1:n
    for j=1:n
        if j~=i
            for k=1:(m-1)
                if A(k+1,i)<A(k,j)
                   E_new(i,j)=E_new(i,j)+A(k,j)-A(k+1,i);%计算延迟度
                end
            end
        else
            E_new(i,j)=10000;
        end
    end
end

B=1:n;


E_n=zeros(n+1,n+1);
E_n(1,2:end)=B;
E_n(2:end,1)=B';
E_n(2:end,2:end)=E_new;

E_new=E_n;


while min(min(E_new(2:end,2:end)))<(sum(sum(A)*0.5)/(m*n))
    [x,y]=find(E_new(2:end,2:end)==min(min(E_new(2:end,2:end))));  
    output(q,:)=[E_new(x(1)+1,1),E_new(1,y(1)+1)];
    E_new(:,[x(1)+1,y(1)+1])=[]; 
    E_new([x(1)+1,y(1)+1],:)=[]; 
    q=q+1;

end

q=q-1;
            
  
end

