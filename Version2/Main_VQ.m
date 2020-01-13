close all;
clear all;
clc;
addpath(genpath('bosaris_toolkit'));
Reference = [3 6 9 12 15;2 4 7 9 12;3 6 8 11 15;1 6 10 13 14];
len=size(Reference,1);
clust=128;
r=[5 9 13 18];
for trial=1:len
EER =zeros(75,1);
ref=Reference(trial,:)
temp = 1:15;
test = setxor(temp,ref);
start=5;ending=75;
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
                CB=vqsplit(RefFeat',clust);
                refIdx=(VQIndex(RefFeat',CB))';
                refCount=accumarray(refIdx,1);
                refCount=[refCount;zeros(clust-length(refCount),1)];
                refCount=bsxfun(@rdivide,bsxfun(@minus, refCount ,min(refCount)),max(refCount)-min(refCount));

%                finding cost matrix of genuine and forgery samples
                 G_distmat = zeros(length(test),1);           
                 for p= 1:length(test)
                        Idx=(VQIndex(Genuine_Feature{test(p)}',CB))';
                        TestCount=accumarray(Idx,1);
                        TestCount=[TestCount;zeros(clust-length(TestCount),1)];
                        TestCount=bsxfun(@rdivide,bsxfun(@minus, TestCount ,min(TestCount)),max(TestCount)-min(TestCount));
                        G_distmat(p,1)=Dist(refCount',TestCount');
                 end

                F_distmat=zeros(15,1);
                for p= 1:15
                        Idx=(VQIndex(Forgery_Feature{p}',CB))';
                        TestCount=accumarray(Idx,1);
                        TestCount=[TestCount;zeros(clust-length(TestCount),1)];
                        TestCount=bsxfun(@rdivide,bsxfun(@minus, TestCount ,min(TestCount)),max(TestCount)-min(TestCount));
                        F_distmat(p,1)=Dist(refCount',TestCount');
                end
                    
                G_cost=((G_distmat')) ;           
                F_cost=((F_distmat'));
                [~,~,~,EER(user,1)]=fastEval(-1*G_cost,-1*F_cost,0.1);
                EER(user,1);
                eer=(EER(start:user))';
                Mean_EER =mean(eer)  
        end
eer=(EER(start:ending))' %EER vector of all users founded out
Mean_EER=mean(eer)      % average EER for all users 
display('---------------------Trial Ends--------------------');
end