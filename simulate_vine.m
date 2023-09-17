function [outputArg1,outputArg2] = simulate_vine(varargin)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
index_matrix=varargin{1};
copulafamily_matrix=varargin{2};
parameters_matrix=varargin{3};
n=varargin{4};
%%
dimension=size(index_matrix,2);
%%
%�Բ���������е���
if isnumeric( parameters_matrix )
    count=0;
    parameters=parameters_matrix;
    parameters_matrix=cell(dimension);
    for j = 1:dimension
        for i = j+1:dimension
            count=count+1;
            parameters_matrix{i,j}=parameters(count);
            if strcmp(copulafamily_matrix{i,j},'t')
                parameters_matrix{i,j}=[ parameters_matrix{i,j} parameters(count+1) ];
                count=count+1;
            end
        end
    end
end
%%
V_direct=cell( dimension );%��ʼ��V����
V_indirect=cell( dimension );
max_index_matrix=zeros(dimension);%��ʼ��������
Z_1_matrix=cell(dimension);%��ʼ��Z����ƫ������
Z_2_matrix=cell(dimension);
%%
%����01���ȷֲ�
U = unifrnd(0,1,n,5);
%����ģ���������Ŀվ���
variance=zeros(n,dimension);
%%
%V��������ʼ����
% for i=1:dimension
%     eval(['V_direct{',num2str(dimension),',',num2str(i), '}= ','x', num2str(dimension-i+1)]);
% end
for i=1:dimension
    V_direct{dimension,i}=U(:,i);
end
%%
%����Max��������
for j=1:dimension
    for i=j:dimension
        max_index_matrix(i,j)=max(index_matrix(i:end,j));
    end
end
%%
variance(:,1)=V_direct(dimension,dimension);
%%
if ~isempty(parameters_matrix)
    for k=(dimension-1):-1:1
        for i=k+1:1:dimension
            if max_index_matrix(i,k)==index_matrix(i,k)
                Z_2_matrix{i,k}=V_direct{i,dimension-max_index_matrix(i,k)+1};
            else
                Z_2_matrix{i,k}=V_indirect{i,dimension-max_index_matrix(i,k)+1};
            end
            V_direct{dimension,k}=;
            lik=lik+sum( log(copulate_density( Z_1_matrix{i,k} , Z_2_matrix{i,k} ,......
                copulafamily_matrix{i,k} , parameters_matrix{i,k} )) );
            %�������ܶ�ֻ������Ȼ��������Ϊ����֮���ܶ�̫С��������0��
            V_direct{i-1,k}=copula_diff( Z_1_matrix{i,k},Z_2_matrix{i,k},copulafamily_matrix{i,k},parameters_matrix{i,k} );
            V_indirect{i-1,k}=copula_diff( Z_2_matrix{i,k},Z_1_matrix{i,k},copulafamily_matrix{i,k},parameters_matrix{i,k} );
        end
    end
    outputArg1 = lik;
    % else
    %     %���ɲ�������,��ֵ������������
    %     for j = 1:dimension
    %         for i = j+1:dimension
    %             eval( ['syms p',num2str(i),num2str(j)] );
    %             parameters_matrix{i,j}={ eval( [ 'p',num2str(i),num2str(j) ] ) };
    %             if strcmp(copulafamily_matrix,'t')
    %                 eval( ['syms nu',num2str(i),num2str(j)] )
    %                 parameters_matrix{i,j}={ eval( [ 'p',num2str(i),num2str(j) ] )......
    %                 ,eval( ['nu',num2str(i),num2str(j)] ) };
    %             end
    %         end
    %     end
    %%
    %     for k=(dimension-1):-1:1
    %         for i=dimension:-1:(k+1)
    %             lik=lik+1;
    %             Z_1_matrix{i,k}=V_direct{i,k};
    %             if max_index_matrix(i,k)==index_matrix(i,k)
    %                 Z_2_matrix{i,k}=V_direct{i,dimension-max_index_matrix(i,k)+1};
    %             else
    %                 Z_2_matrix{i,k}=V_indirect{i,dimension-max_index_matrix(i,k)+1};
    %             end
    %             lik=lik+sum( log(copulate_density( Z_1_matrix{i,k} , Z_2_matrix{i,k} ,......
    %                 copulafamily_matrix{i,k} , parameters_matrix{i,k} ) ) );
    %             %�������ܶ�ֻ������Ȼ��������Ϊ����֮���ܶ�̫С��������0��
    %             V_direct{i-1,k}=copula_diff( Z_1_matrix{i,k},Z_2_matrix{i,k},copulafamily_matrix{i,k} , parameters_matrix{i,k} );
    %             V_indirect{i-1,k}=copula_diff( Z_2_matrix{i,k},Z_1_matrix{i,k},copulafamily_matrix{i,k} , parameters_matrix{i,k} );
    %         end
    %     end
    %     outputArg1 = lik;
end
end


