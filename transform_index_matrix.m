function [matrix,origin_index] = transform_index_matrix(varargin)
%TRANSFORM_MATRIX �˴���ʾ�йش˺�����ժҪ
%��ʼ������
% varargin{1}=[7,8,3,6,2,5,4,1];
matrix=varargin{1};
varargin{1}=diag(matrix)';
%�����Dvine��Ҫ���ɾ����ٴ�����rvine����ֱ�Ӵ���
if size(matrix,1)==1
    if size(varargin{1},1)==1
        for i=1:size(varargin{1},2)
            for j=i:size(varargin{1},2)
                if j==i
                    matrix(j,i)=varargin{1}(j);
                else
                    matrix(j,i)=varargin{1}(end-j+i+1);
                end
            end
        end
    end
end
%%
%�Ծ����������
for i=1:size(varargin{1},2)
    matrix(matrix==varargin{1}(i))=100-i;
end
matrix(matrix~=0)=matrix(matrix~=0)-(100-size(varargin{1},2)-1);
origin_index=varargin{1};
end
