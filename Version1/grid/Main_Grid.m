close all;
clear all;
clc;
%diary('Grid_testing.txt');
addpath(genpath('bosaris_toolkit'));
Reference = [11 12 13 14 15;1 2 3 7 9;2 4 7 9 12;3 6 8 11 15;1 6 10 13 14];
len=length(Reference);
for trial=1:len
EER =zeros(75,1);
Grid_size=3;        
r=[4 6 8 10];
ref=Reference(trial,:)
temp = 1:15;
test = setxor(temp,ref);
start=1;ending=5;
        for user=start:ending
                Genuine_Feature = cell(15,1);
                Forgery_Feature = cell(15,1);
                for q=1:15                                 
                        G=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/v',int2str(q),'.bmp');
                        Genuine_Feature{q}=Image_Feature(G,r,Grid_size);
                        F=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/f',int2str(q),'.bmp');
                        Forgery_Feature{q}=Image_Feature(F,r,Grid_size);
                end

                 %finding cost matrix of genuine and forgery samples
                 G_distmat = zeros(length(test),length(ref));           
                 for p= 1:length(test)                       
                     for t=1:length(ref)
                        R = Genuine_Feature{ref(t)}; 
                        T = Genuine_Feature{test(p)};
                       [G_distmat(p,t),~]= dtw(R,T); 
                     end
                 end

                F_distmat=zeros(15,length(ref));
                for p= 1:15
                    for t=1:length(ref)
                        R = Genuine_Feature{ref(t)};
                        T = Forgery_Feature{p};
                       [F_distmat(p,t),~]= dtw(R,T); 
                    end
                end

                G_cost=min(G_distmat(1:length(test),:)');            
                F_cost=min(F_distmat(1:15,:)');
                [~,~,~,EER(user,1)]=fastEval(-1*G_cost,-1*F_cost,0.1);
                EER(user,1)
        end
eer=(EER(start:ending))' %EER vector of all users founded out
Mean_EER=mean(eer)      % average EER for all users 
display('---------------------Trial Ends--------------------');
end