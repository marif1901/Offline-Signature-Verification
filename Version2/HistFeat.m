close all;
clear all;
clc;
diary('DiwaliUpgrade.txt');
addpath(genpath('bosaris_toolkit'));
Reference = [1 3 5 8 10 ;2 4 7 9 12;3 6 8 11 15;1 6 10 13 14];
len=size(Reference,1);
for trial=1:len
EER =zeros(75,1);        
r=[5];
ref=Reference(trial,:)
temp = 1:15;
test = setxor(temp,ref);
start=1;ending=75;
        for user=start:ending
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
                 G_distmat = zeros(length(test),2);           
                 for p= 1:length(test)                       
                        G_distmat(p,1)=Hist_Dist1(Nref1,Genuine_Feature{test(p),1});
                        G_distmat(p,2)=Hist_Dist2(Nref2,Genuine_Feature{test(p),2});
                 end

                F_distmat=zeros(15,2);
                for p= 1:15
                       F_distmat(p,1)= Hist_Dist1(Nref1,Forgery_Feature{p,1});
                       F_distmat(p,2)= Hist_Dist2(Nref2,Forgery_Feature{p,2});
                end
                    
                G_cost=mean(G_distmat') ;           
                F_cost=mean(F_distmat');
                [~,~,~,EER(user,1)]=fastEval(-1*G_cost,-1*F_cost,0.1);
                EER(user,1)
        end
eer=(EER(start:ending))' %EER vector of all users founded out
Mean_EER=mean(eer)      % average EER for all users 
display('---------------------Trial Ends--------------------');
end