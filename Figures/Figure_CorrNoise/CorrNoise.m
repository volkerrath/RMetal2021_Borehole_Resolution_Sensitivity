clear all
close all
clc

%GRAPHICS
plotfmt='png';
% plotfmt='epsc2';
plotfmt='pdf';
fontwg='normal';
fontsz=16;
linewd=2;
%cols={'-b','-r','-g','-m','-k' '--b','--r','--g','--m','--k' ':b',':r',':g',':m',':k'};
zlimits=[0 2500];


load('SYN_DepthGrid.mat');

Err        =   0.03;
L=3;
CovType = 'g';

N = length(z);
ErrNorm =  Err*randn(N,1);
E=[];
Li = [1 3 5 7];
for L = Li
    switch lower(CovType)
        case{'e' 'markov' 'exponential'}
            Cov=CovarExpnl(ones(N,1),L);
        case{'g' 'gauss'}
            Cov=CovarGauss(ones(N,1),L);
            %     case{'m' 'matern'}
            %         Cov=CovarMatern(ones(N,1),L);
        otherwise
            error([lower(CovFun), ' not implemented. STOP']);
    end
    C    = chol(Cov);
    ErrCorr =  ErrNorm'*C;
    E =[E ErrCorr(:)];
    %
end
[~,nL]=size(E);


figure;
for ii=1:nL
    plot(E,z,'LineWidth',linewd);hold on
    legstr{ii}= ...
         strcat(['L \approx ',num2str(20*Li(ii)), ' m']);
end
grid on;
set(gca,'ydir','rev','FontSize',fontsz,'FontWeight',fontwg);
ylabel('depth (m)');xlabel('\Delta T (K)');
ylim(zlimits);
xlim([-0.1 0.2]);
%title(strcat([SITE,': ',run]),'FontSize',fontsz,'FontWeight',fontwg);
legend(legstr,'location','southeast');
filename=strcat(['Figure_NoiseCorr']);
%saveas(gcf,filename,plotfmt)
saveas(gcf,filename,'pdf')
saveas(gcf,filename,'epsc2')
saveas(gcf,filename,'png')