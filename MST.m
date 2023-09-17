function [outputArg1] = MST(empirical_T)
%MST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
dimension=length(empirical_T);
vine_matrix=zeros(dimension,dimension);
for i=1:dimension-1
    [a b]=find(vine_matrix~=0);
    c=unique([a b]);
    index= ~ismember([1:dimension],c);%�ҵ������
    if ~isempty(c)
        max_tao=max( max(max(empirical_T(c,index))) , max(max(empirical_T(index,c))) );
        %�������������ӵ�ı����ҵ����ֵ��������������Ϊֻ�������Ǿ���洢����Ϣ��
        %������ȫ��Ļ�����©һЩ���ϵ��������c=[2 3],indexΪ=[1 4 5]��
    else
        max_tao=max( empirical_T(:) );
    end
    [a b]=find(empirical_T==max_tao);
    vine_matrix(a,b)=max_tao;
end
outputArg1 = vine_matrix;
end

