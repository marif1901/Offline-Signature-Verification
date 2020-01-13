close all;
clear all;
clc;
addpath(genpath('bosaris_toolkit'));
Reference = [3 6 9 12 15;2 4 7 9 12;3 6 8 11 15;1 6 10 13 14];
len=size(Reference,1);
clust=256;
r=[7];
alpha=1.9;
for trial=1:len
EER =zeros(75,1);
ref=Reference(trial,:)
temp = 1:15;
test = setxor(temp,ref);
start=1;ending=75;
		%GMM
        for user=start:ending
                Genuine_Feature = cell(15,1);
                Forgery_Feature = cell(15,1);
                for q=1:15
                    G=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/v',int2str(q),'.bmp');
                    F=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/f',int2str(q),'.bmp');
                    Genuine_Feature{q}=feat(G,r);
                    Forgery_Feature{q}=feat(F,r);
                end
                
                RefFeat=[];
                for k=1:length(ref)
                    RefFeat=[RefFeat;Genuine_Feature{ref(k)}];
                end
                Op=statset('MaxIter',1000);
                l=size( RefFeat,1);
                q=floor(l./clust);
                r=rem(l,clust);
                c=1:r;
                g=repmat(c,q+1,1);
                g=g(:);
                c1=r+1:clust;
                g1=repmat(c1,q,1);
                g1=g1(:);
                clt_guess=[g;g1];
                GMFIT =gmdistribution.fit(RefFeat,clust,'Start',clt_guess,'Options',Op,'CovType','diagonal','SharedCov',true);
                refIdx=cluster(GMFIT,RefFeat);
%                 refCount=accumarray(refIdx,1);
%                 refCount=[refCount;zeros(clust-length(refCount),1)];
%                 refCount=bsxfun(@rdivide,bsxfun(@minus, refCount ,min(refCount)),max(refCount)-min(refCount));
                [refCount, X] = hist(refIdx,clust);
                refCount=refCount./sum(refCount);

%                finding cost matrix of genuine and forgery samples
                 G_distmat1 = zeros(length(test),1);           
                 for p= 1:length(test)
                        Idx=cluster(GMFIT,Genuine_Feature{test(p)});
%                         TestCount=accumarray(Idx,1);
%                         TestCount=[TestCount;zeros(clust-length(TestCount),1)];
%                         TestCount=bsxfun(@rdivide,bsxfun(@minus, TestCount ,min(TestCount)),max(TestCount)-min(TestCount));
                        [TestCount, X] = hist(Idx,clust);
                        TestCount=TestCount./sum(TestCount);
                        G_distmat1(p,1)=Dist(refCount,TestCount);
                 end

                F_distmat1=zeros(15,1);
                for p= 1:15
                        Idx=cluster(GMFIT,Forgery_Feature{p});
%                         TestCount=accumarray(Idx,1);
%                         TestCount=[TestCount;zeros(clust-length(TestCount),1)];
%                         TestCount=bsxfun(@rdivide,bsxfun(@minus, TestCount ,min(TestCount)),max(TestCount)-min(TestCount));
                        [TestCount, X] = hist(Idx,clust);
                        TestCount=TestCount./sum(TestCount);
                        F_distmat1(p,1)=Dist(refCount,TestCount);
                end
                
                cost=[G_distmat1' F_distmat1'];
                Norm1=bsxfun(@rdivide,bsxfun(@minus, cost ,min(cost)),max(cost)-min(cost));
                G_cost1=Norm1(1:length(test));
                F_cost1=Norm1(length(test)+1:length(Norm1));
      %------------------------------------------------------------------------------------------------------------------------------          
			%F1&F2
                Genuine_Feature = cell(15,2);
                Forgery_Feature = cell(15,2);
                for q=1:15                                 
                        G=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/v',int2str(q),'.bmp');
                        [Genuine_Feature{q,1},Genuine_Feature{q,2}]=Im_Feature(G,r);
                        F=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/f',int2str(q),'.bmp');
                        [Forgery_Feature{q,1},Forgery_Feature{q,2}]=Im_Feature(F,r);
                end
                
                RefHist1=[];
                RefHist2=[];
                for k=1:length(ref)
                    RefHist1=[RefHist1;Genuine_Feature{ref(k),1}];
                    RefHist2=[RefHist2;Genuine_Feature{ref(k),2}];
                end
                [Nref1, X] = hist(RefHist1,12);
                Nref1=Nref1./sum(Nref1);
%                 subplot(2, 1, 1);
%                 bar(X,Nref1, 1);
                
                [Nref2,C]=hist3(RefHist2,[24 24]);
                Nref2 = Nref2 / sum(Nref2(:));
%                 bar3(Nref2);
                
%                finding cost matrix of genuine and forgery samples
                 G_distmat2 = zeros(length(test),2);           
                 for p= 1:length(test)                       
                        G_distmat2(p,1)=Hist_Dist1(Nref1,Genuine_Feature{test(p),1});
                        G_distmat2(p,2)=Hist_Dist2(Nref2,Genuine_Feature{test(p),2});
                 end

                F_distmat2=zeros(15,2);
                for p= 1:15
                       F_distmat2(p,1)= Hist_Dist1(Nref1,Forgery_Feature{p,1});
                       F_distmat2(p,2)= Hist_Dist2(Nref2,Forgery_Feature{p,2});
                end
                    
                G_cost2=mean(G_distmat2') ;
                F_cost2=mean(F_distmat2');
                cost=[G_cost2 F_cost2];
                Norm2=bsxfun(@rdivide,bsxfun(@minus, cost ,min(cost)),max(cost)-min(cost));
                G_cost2=Norm2(1:length(test));
                F_cost2=Norm2(length(test)+1:length(Norm2));
                
                G_cost=min(G_cost1,alpha*G_cost2);
                F_cost=min(F_cost1,alpha*F_cost2);
                [~,~,~,EER(user,1)]=fastEval(-1*G_cost,-1*F_cost,0.1);
                user
                EER(user,1)
                eer=(EER(start:user))';
                Mean_EER=mean(eer)  
                
        end
eer=(EER(start:ending))' %EER vector of all users founded out
Mean_EER=mean(eer)      % average EER for all users 
display('---------------------Trial Ends--------------------');
end