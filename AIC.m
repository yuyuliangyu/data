function [outputArg1] = AIC(inputArg1,inputArg2)
%AIC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
family={'Gaussian','Clayton','Frank','Gumbel','t'};
family_aicbic=zeros(2,length(family));
for i=1:length(family)-1
rhohat = copulafit(family{i},inputArg1);
log_L= sum( log( copulapdf(family{i},inputArg1,rhohat(1,end)) ) );
[aic,bic]= aicbic(log_L,1,size(inputArg1,1));%aicbic����ķֱ�����Ȼ�������������������ݹ�ģ
family_aicbic(1,i)=aic;
family_aicbic(2,i)=bic;
end
%%
%t-copula�����г���
[rhohat,nu] = copulafit('t',inputArg1);
log_L= sum( log( copulapdf('t',inputArg1,rhohat(1,end),nu) ) );
[aic,bic]= aicbic(log_L,2,size(inputArg1,1));
family_aicbic(:,end)=[aic,bic]';
min_aicbic=min(family_aicbic');
%%
%�ж���С��aic����bic����һ�����͵�copula
if strcmp(inputArg2,'aic')%�ж��Ƿ����
    [a b]=find(family_aicbic(1,:)==min_aicbic(1))
    min_aicbic=min_aicbic(1);
elseif strcmp(inputArg2,'bic')%�ж��Ƿ����
    [a b]=find(family_aicbic(2,:)==min_aicbic(2))
    min_aicbic=min_aicbic(2);
end
%%
if ~strcmp(family{b}, 't')%�ж��Ƿ����t
    rhohat=copulafit(family{b},inputArg1);
    y = copulacdf(family{b},inputArg1,rhohat(1,end));
    outputArg1 ={family{b},rhohat(1,end),min_aicbic,y};
else
    [rhohat,nu]=copulafit(family{b},inputArg1);
    y = copulacdf('t',inputArg1,rhohat(1,end),nu);
%   y = copulacdf('t',inputArg1,copulafit('t',inputArg1),rhohat(1,end),nu);
    outputArg1 ={family{b},[rhohat(1,end),nu],min_aicbic,y};
end
end

