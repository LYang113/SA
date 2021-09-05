   function [sol_best] = SA(coordinates,groups,q)

%  load('chushi.mat');
%  coordinates=chushi;
    a = 0.99;	% �¶�˥�������Ĳ���
	t0 = 97; tf = 0.001; t = t0;
	Markov_length = 100;	% Markov������
	amount = 200; 	% �������Ŀ

	coordinates = NEH(coordinates);         % ������ʼ��

    sol_new=1:200;
    amount = 200-q; 	% �������Ŀ
    
   Palmer=1:200;
    for i=1:200
    for k=1:10
    Palmer(i)=Palmer(i)+(k-(5+1)/2)*coordinates(k,i);
    end
    end


    
    for i=1:q
        sol_new(find(sol_new==groups(i,2)))=[];
    end
% sol_new��ÿ�β������½⣻sol_current�ǵ�ǰ�⣻sol_best����ȴ�е���ý⣻
	E_current = inf;E_best = inf; 		% E_current�ǵ�ǰ���Ӧ�Ļ�·���룻
% E_new���½�Ļ�·���룻
% E_best�����Ž��
	sol_current = sol_new; sol_best = sol_new;          
	p = 1;
    
	while t>=tf
		for r=1:Markov_length		% Markov������
			% ��������Ŷ�
			if (rand < 0.5)	% ��������ǽ�������������������
				% ������
				ind1 = 0; ind2 = 0;
				while (ind1 == ind2)
					ind1 = ceil(rand.*amount);
					ind2 = ceil(rand.*amount);
				end
				tmp1 = sol_new(ind1);
				sol_new(ind1) = sol_new(ind2);
				sol_new(ind2) = tmp1;
			else
				% ������
				ind1 = 0; ind2 = 0; ind3 = 0;
				while (ind1 == ind2) || (ind1 == ind3) ...
					|| (ind2 == ind3) || (abs(ind1-ind2) == 1)
					ind1 = ceil(rand.*amount);
					ind2 = ceil(rand.*amount);
					ind3 = ceil(rand.*amount);
				end
				tmp1 = ind1;tmp2 = ind2;tmp3 = ind3;
				% ȷ��ind1 < ind2 < ind3
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

			%����Ƿ�����Լ��
			
			% ����Ŀ�꺯��ֵ�������ܣ�
%             T=zeros(10,10);
% 			E_new = Enery(10,10,coordinates,sol_new);

             E_new=Fun(coordinates,sol_new,q,groups,Palmer);
			if E_new < E_current
				E_current = E_new;
				sol_current = sol_new;
				if E_new < E_best
% ����ȴ��������õĽⱣ������
					E_best = E_new;
					sol_best = sol_new;
				end
			else
				% ���½��Ŀ�꺯��ֵС�ڵ�ǰ��ģ�
				% �����һ�����ʽ����½�
				if rand < exp(-(E_new-E_current)./t)
					E_current = E_new;
					sol_current = sol_new;
				else	
					sol_new = sol_current;
				end
            end
        end
        E(p)=E_best;

		t=t.*a^(r)*(cos(pi/2*(1-r/Markov_length)))+cos(pi/(2*t)*(1-r/Markov_length));		% ���Ʋ���t���¶ȣ�����Ϊԭ����a��
        if (p>500)&&(E(p-500)==E(p))
            break
        end
                p=p+1
    end
     	disp(E_best)
   end

% 	disp('���Ž�Ϊ��')
% 	disp(sol_best)
% 	disp('���ʱ�䣺')
 %	disp(E_best)




