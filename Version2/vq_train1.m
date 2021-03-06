function [obj] = vq_train1(tr_cell,clt)
no_tr_sign=size(tr_cell,2);
tr_cell1(1:no_tr_sign,1)=tr_cell(1,1:no_tr_sign);
m=cell2mat(tr_cell1);
% seed=m(1:clt,:);
Op=statset('MaxIter',1000);
l=size(m,1);
q=floor(l./clt);
r=rem(l,clt);
c=1:r;
g=repmat(c,q+1,1);
g=g(:);
c1=r+1:clt;
g1=repmat(c1,q,1);
g1=g1(:);
clt_guess=[g;g1];
% [clt_indx,ctr]=kmeans(m,clt,'MaxIter',150,'emptyaction','singleton');
obj=gmdistribution.fit(m,clt,'Start',clt_guess,'Options',Op,'CovType','diagonal','SharedCov',true);