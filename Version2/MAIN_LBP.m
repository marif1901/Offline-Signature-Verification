close all;
clear all;
clc;
addpath(genpath('bosaris_toolkit'));
Reference = [3 6 9 12 15];% ;2 4 7 9 12;3 6 8 11 15;1 6 10 13 14];
len=size(Reference,1);
wind=5;
r=[7];
for trial=1:len
EER =zeros(75,1);
ref=Reference(trial,:)
temp = 1:15;
test = setxor(temp,ref);
start=1;ending=75;
        for user=start:ending
                Genuine_Feature = cell(15,2);
                Forgery_Feature = cell(15,2);
                for q=1:15                                 
                        G=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/v',int2str(q),'.bmp');
                        [Genuine_Feature{q,1}]=window_lbp(G,wind);
                        Genuine_Feature{q,2}=Feature(G,r,wind);
                        F=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/f',int2str(q),'.bmp');
                        [Forgery_Feature{q,1}]=window_lbp(F,wind);
                        Forgery_Feature{q,2}=Feature(F,r,wind);
                end
                
                RefHist1=[];
                RefHist2=[];
                for k=1:length(ref)
                    RefHist1=[RefHist1;Genuine_Feature{ref(k),1}];
                    RefHist2=[RefHist2;Genuine_Feature{ref(k),2}];
                end
                [Nref1, X] = hist(RefHist1);
                Nref1=Nref1./sum(Nref1);
                
                [Nref2, X] = hist(RefHist2);
                Nref2=Nref2./sum(Nref2);
                

%                finding cost matrix of genuine and forgery samples
                 G_distmat = zeros(length(test),2);           
                 for p= 1:length(test)                       
                        G_distmat(p,1)=Hist_Dist(Nref1,Genuine_Feature{test(p),1});
                        G_distmat(p,2)=Hist_Dist(Nref2,Genuine_Feature{test(p),2});
                 end

                F_distmat=zeros(15,2);
                for p= 1:15
                       F_distmat(p,1)= Hist_Dist(Nref1,Forgery_Feature{p,1});
                       F_distmat(p,2)= Hist_Dist(Nref2,Forgery_Feature{p,2});
                end
                    
                G_cost=mean((G_distmat')) ;           
                F_cost=mean((F_distmat'));
                [~,~,~,EER(user,1)]=fastEval(-1*G_cost,-1*F_cost,0.1);
                EER(user,1);
                eer=(EER(start:user))';
                Mean_EER =mean(eer)  
        end
eer=(EER(start:ending))' %EER vector of all users founded out
Mean_EER=mean(eer)      % average EER for all users 
display('---------------------Trial Ends--------------------');
end