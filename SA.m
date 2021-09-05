   function [sol_best] = SA(coordinates,groups,q)

%  load('chushi.mat');
%  coordinates=chushi;
    a = 0.99;	% 温度衰减函数的参数
	t0 = 97; tf = 0.001; t = t0;
	Markov_length = 100;	% Markov链长度
	amount = 200; 	% 工序的数目

	coordinates = NEH(coordinates);         % 产生初始解

    sol_new=1:200;
    amount = 200-q; 	% 工序的数目
    
   Palmer=1:200;
    for i=1:200
    for k=1:10
    Palmer(i)=Palmer(i)+(k-(5+1)/2)*coordinates(k,i);
    end
    end


    
    for i=1:q
        sol_new(find(sol_new==groups(i,2)))=[];
    end
% sol_new是每次产生的新解；sol_current是当前解；sol_best是冷却中的最好解；
	E_current = inf;E_best = inf; 		% E_current是当前解对应的回路距离；
% E_new是新解的回路距离；
% E_best是最优解的
	sol_current = sol_new; sol_best = sol_new;          
	p = 1;
    
	while t>=tf
		for r=1:Markov_length		% Markov链长度
			% 产生随机扰动
			if (rand < 0.5)	% 随机决定是进行两交换还是三交换
				% 两交换
				ind1 = 0; ind2 = 0;
				while (ind1 == ind2)
					ind1 = ceil(rand.*amount);
					ind2 = ceil(rand.*amount);
				end
				tmp1 = sol_new(ind1);
				sol_new(ind1) = sol_new(ind2);
				sol_new(ind2) = tmp1;
			else
				% 三交换
				ind1 = 0; ind2 = 0; ind3 = 0;
				while (ind1 == ind2) || (ind1 == ind3) ...
					|| (ind2 == ind3) || (abs(ind1-ind2) == 1)
					ind1 = ceil(rand.*amount);
					ind2 = ceil(rand.*amount);
					ind3 = ceil(rand.*amount);
				end
				tmp1 = ind1;tmp2 = ind2;tmp3 = ind3;
				% 确保ind1 < ind2 < ind3
				if (ind1 < ind2) && (ind2 < ind3)
				elseif (ind1 < ind3) && (ind3 < ind2)
					ind2 = tmp3;ind3 = tmp2;
				elseif (ind2 < ind1) && (ind1 < ind3)
					ind1 = tmp2;ind2 = tmp1;
				elseif (ind2 < ind3) && (ind3 < ind1) 
					ind1 = tmp2;ind2 = tmp3; ind3 = tmp1;
				elseif (ind3 < ind1) && (ind1 < ind2)
					ind1 = tmp3;ind2 = tmp1; ind3 = tmp2;
				elseif (ind3 < ind2) && (ind2 < ind1)
					ind1 = tmp3;ind2 = tmp2; ind3 = tmp1;
				end
				
				tmplist1 = sol_new((ind1+1):(ind2-1));
				sol_new((ind1+1):(ind1+ind3-ind2+1)) = ...
					sol_new((ind2):(ind3));
				sol_new((ind1+ind3-ind2+2):ind3) = ...
					tmplist1;
			end

			%检查是否满足约束
			
			% 计算目标函数值（即内能）
%             T=zeros(10,10);
% 			E_new = Enery(10,10,coordinates,sol_new);

             E_new=Fun(coordinates,sol_new,q,groups,Palmer);
			if E_new < E_current
				E_current = E_new;
				sol_current = sol_new;
				if E_new < E_best
% 把冷却过程中最好的解保存下来
					E_best = E_new;
					sol_best = sol_new;
				end
			else
				% 若新解的目标函数值小于当前解的，
				% 则仅以一定概率接受新解
				if rand < exp(-(E_new-E_current)./t)
					E_current = E_new;
					sol_current = sol_new;
				else	
					sol_new = sol_current;
				end
            end
        end
        E(p)=E_best;

		t=t.*a^(r)*(cos(pi/2*(1-r/Markov_length)))+cos(pi/(2*t)*(1-r/Markov_length));		% 控制参数t（温度）减少为原来的a倍
        if (p>500)&&(E(p-500)==E(p))
            break
        end
                p=p+1
    end
     	disp(E_best)
   end

% 	disp('最优解为：')
% 	disp(sol_best)
% 	disp('最短时间：')
 %	disp(E_best)




