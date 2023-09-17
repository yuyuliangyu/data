clc,clear;
load data.mat;
%%
%����Ԥ��������ͬʱ�����кϲ�����֤ÿ��ʱ�����ÿ���������з���
vine_data=cell(1,5);
vine_data{1}=vine_sse;
vine_data{2}=vine_hsi;
vine_data{3}=vine_twii;
vine_data{4}=vine_n225;
vine_data{5}=vine_ks11;
dimension=length(vine_data);
for i=1:length(vine_data)
    data=vine_data{i};
    time=table2array(data(:,1));
    time=datenum(time);
    time=time(~any(isnan(time),2),:);%any(,2)ָ�������Ƿ�����Ԫ�ء�
    data=table2array(data(:,2));
    data=data(~any(isnan(data),2),:);
    vine_data{i}=fints(time,data, sprintf('vine%d', i));
end
combine_data =vine_data{1};
for i=1:length(vine_data)-1
    combine_data =merge(combine_data,vine_data{i+1},'DateSetMethod','Intersection');
end
%%
%�ҳ��ϲ������������뺫�����ڣ���̣�֮��Ĳ
different_dates = setxor(combine_data.dates, vine_data{5}.dates);
date=datestr(different_dates);
%%
vine_returns=diff(log(combine_data));
vine_returns=fts2mat(vine_returns);

%%
%����garch��ȡ�в�
dimension=size(vine_returns,2);
aicbic_matrix=[];
for i=1:dimension
    [estParams, ~, logL, info] = estimate(garch_model(vine_returns(:,i)), vine_returns(:,i));
    [aic,bic]= aicbic(logL,4,size(vine_returns(:,i),1));%aicbic����ķֱ�����Ȼ�������������������ݹ�ģ
    aicbic_matrix = [aicbic_matrix;aic bic];
    vine_returns(:,i)=infer(garch_model(vine_returns(:,i)),vine_returns(:,i));
end
%%
%���о���ֲ����۴λ��ֱ任��ע�⣺��������۴λ�������Ӱ��ϵ¶�taoֵ���Ѿ�ʵ֤֤����
dimension=size(vine_returns,2);
vine_return_union=[];
vine_return_index=[];
for i=1:dimension %����ÿ�������ʵľ���ֲ�
    [a b]=ecdf(vine_returns(:,i));
    vine_return_union=[vine_return_union a];
    vine_return_index=[vine_return_index b];
end
for i=1:length(vine_returns) %��ÿ�������ʴ��뾭��ֲ������۴λ��ֱ任���ֵ
    for j=1:dimension
        a=max( find( vine_return_index(:,j)<=vine_returns(i,j)) );
        vine_returns(i,j)=vine_return_union(a,j);
    end
end
[a b]=find(vine_returns==1);
vine_returns(a,b)=0.99;%�۴λ��ֱ任��ֵ�������0С��1������Ĵ��벻����ȡ��0��1.
[a b]=find(vine_returns==0);
vine_returns(a,b)=0.0000001;
% t = trnd(5, 1000, 5);
%%
%��ת��������н��о��ȷֲ�����
unionTest_matrix=[];
for i=1:size(vine_returns,2)
[h,p,s] = chi2gof(vine_returns(:,i), 'cdf', {@unifcdf,min(vine_returns(:,i)),max(vine_returns(:,i))});
unionTest_matrix=[unionTest_matrix;h,p,s.chi2stat]
end
%%
[index_matrix,copulafamily_matrix,parameters_matrix,vine_returns] = vine_construction(vine_returns);
[lik]=lik_vine(index_matrix,copulafamily_matrix,parameters_matrix,vine_returns);
% [lik]=lik_vine(index_matrix,copulafamily_matrix,[-0.676181327155250,0.519937870224427,0.280588434296862,11.5635041812958,1.03855149967934,7.81116046027813,-0.387275442720832,0.543849080217753,12.7596036451366,0.140092015817294],vine_returns);
%%
[parameter_max1,ln_lik_max]=optimal_parameters_vine(index_matrix,copulafamily_matrix,parameters_matrix,vine_returns);
% [parameter_max2,ln_lik_max]=optimal_parameters_vine(index_matrix,copulafamily_matrix,parameter_max1,vine_returns);