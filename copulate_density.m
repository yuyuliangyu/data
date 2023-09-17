function [outputArg1] = copulate_density(varargin)
%COPULATE_DENSITY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
syms u v a nu;
uu=varargin{1};
vv=varargin{2};
copulafamily=varargin{3};
%%
if isnumeric(varargin{4})
    a=varargin{4};
    if strcmp(copulafamily,'Gumbel')
        outputArg1=(exp(-((-log(uu)).^a + (-log(vv)).^a).^(1./a)).*(-log(uu)).^(a - 1).*(-log(vv)).^(a - 1).*((-log(uu)).^a +......
            (-log(vv)).^a).^(2./a - 2))./(uu.*vv) - (a.*exp(-((-log(uu)).^a + (-log(vv)).^a).^(1./a))......
            .*(-log(uu)).^(a - 1).*(-log(vv)).^(a - 1).*(1/a - 1).*((-log(uu)).^a + (-log(vv)).^a).^(1./a - 2))./(uu.*vv);
    elseif strcmp(copulafamily,'Clayton')
        outputArg1=(a.*(1./a + 1))./(uu.^(a + 1).*vv.^(a + 1).*(1./uu.^a + 1./vv.^a - 1).^(1./a + 2));
    elseif strcmp(copulafamily,'Frank')
        outputArg1=(a.*exp(-a.*uu).*exp(-a.*vv).*(exp(-a.*uu) - 1).*(exp(-a.*vv) - 1))./((exp(-a) - 1).^2......
            .*(((exp(-a.*uu) - 1).*(exp(-a.*vv) - 1))./(exp(-a) - 1) + 1).^2) - (a.*exp(-a.*uu).*exp(-a.*vv))......
            ./((exp(-a) - 1).*(((exp(-a.*uu) - 1).*(exp(-a.*vv) - 1))./(exp(-a) - 1) + 1));
    elseif strcmp(copulafamily,'Gaussian')
        %         uu=icdf('Normal',uu);
        %         vv=icdf('Normal',vv);
        outputArg1=copulapdf('Gaussian',[uu vv],a(1) );
    elseif  strcmp(copulafamily,'t')
        %%
        %�溯���õ�ԭ��������
        %t=( gamma( (nu+1)./(2) ) )./(gamma( nu./(2) ).*sqrt( pi.*nu ) ).*( 1+u.^(2)./(nu) ).^( -(nu+1)./2 );
        %T=int(t,u,inf,u);
        %         uu=icdf('t',uu,parameters(2));
        %         vv=icdf('t',vv,parameters(2));
        outputArg1=copulapdf('t',[uu vv],a(1),a(2));
    end
% else
%     parameters=varargin{4};%ע������Ĳ����ǰ���������Ԫ��
%     if strcmp(copulafamily,'Gumbel')
%         outputArg1=(exp(-((-log(uu)).^a + (-log(vv)).^a).^(1./a)).*(-log(uu)).^(a - 1).*(-log(vv)).^(a - 1).*((-log(uu)).^a +......
%             (-log(vv)).^a).^(2./a - 2))./(uu.*vv) - (a.*exp(-((-log(uu)).^a + (-log(vv)).^a).^(1./a))......
%             .*(-log(uu)).^(a - 1).*(-log(vv)).^(a - 1).*(1/a - 1).*((-log(uu)).^a + (-log(vv)).^a).^(1./a - 2))./(uu.*vv);
%     elseif strcmp(copulafamily,'Clayton')
%         outputArg1=(a.*(1./a + 1))./(uu.^(a + 1).*vv.^(a + 1).*(1./uu.^a + 1./vv.^a - 1).^(1./a + 2));
%     elseif strcmp(copulafamily,'Frank')
%         outputArg1=(a.*exp(-a.*uu).*exp(-a.*vv).*(exp(-a.*uu) - 1).*(exp(-a.*vv) - 1))./((exp(-a) - 1).^2......
%             .*(((exp(-a.*uu) - 1).*(exp(-a.*vv) - 1))./(exp(-a) - 1) + 1).^2) - (a.*exp(-a.*uu).*exp(-a.*vv))......
%             ./((exp(-a) - 1).*(((exp(-a.*uu) - 1).*(exp(-a.*vv) - 1))./(exp(-a) - 1) + 1));
%     elseif strcmp(copulafamily,'Gaussian')
%         uu=icdf('Normal',uu);
%         vv=icdf('Normal',vv);
%         %ע�⣬�����uu.vv�����ۼƷֲ��������ڼ����˹��t�ֲ�ʱ����Ҫ��uu.vv�������ۻ��ֲ��任
%         C_gaussian_pdf=( (1-a.^2).^( -(1./2) ) ).*( exp( -(1./2).*( uu.^2+vv.^2-2.*a.*uu.*vv ).*(1-a.^2) ) ).*( exp( (1./2).*(uu.^2+vv.^2) ) );
%     elseif  strcmp(copulafamily,'t')
%         uu=tinv(uu,parameters(2));
%         vv=tinv(vv,parameters(2));        outputArg1=subs( subs( outputArg1 , {a nu}, {parameters{1} parameters{2} } ) , {u v}, {uu vv} );
%     end
end

