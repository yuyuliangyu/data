function [outputArg1] = Empirical(varargin)
%EMPIRICAL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if isnumeric(varargin{1})%�ж��Ƿ�Ϊ��һ�㣬��Ϊ�ڶ��㿪ʼ����Ϣ�Ͳ������б��������б����Ϣ
    inputArg1=varargin{1};
    dimension=size(inputArg1,2);
    empirical_T=zeros(dimension);
    for k=1:(dimension-1)
        for w=(k+1):dimension
            empirical_T(k,w)=corr(inputArg1(:,k),inputArg1(:,w),'Type','Kendall');
        end
    end
    outputArg1= empirical_T;
else
    outputArg1=cell(1,2);
    a=varargin{1,1};
    inputArg1=a(end,:);
    str=a(2,:);
    theta=a(3,:);
    a=a(1,:);
    dimension=size(a,2);
    empirical_T=zeros(dimension);
    %     b=varargin{2};
    for i=1:length(a)-1
        for j=i+1:length(a)
            b=intersect([a{i}],[a{j}]);
            if ~isempty(b)
                %�жϱ���֮���Ƿ��н������н��������п�������~ismember([1:dimension],c);
                u=copula_diff( inputArg1{i}(:, ~ismember(a{i},b)) , inputArg1{i}(:, ismember(a{i},b)), str{i} , theta{i}  );
                v=copula_diff( inputArg1{j}(:, ~ismember(a{j},b)) , inputArg1{j}(:, ismember(a{j},b)), str{j} , theta{j}  );
                outputArg1{2}{i,j}=[u,v];             
                empirical_T(i,j)=corr( u ,......
                v ,'Type','Kendall');
            end
        end
    end
    outputArg1{1}= empirical_T;
end
end

