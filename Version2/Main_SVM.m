close all;
clear all;
clc;
addpath(genpath('bosaris_toolkit'));
Reference = [3 6 9 12 15];%;1 3 5 8 10 ;2 4 7 9 12;1 6 10 13 14];
len=size(Reference,1);
wind=5;%Mask window of size 5
r=[7]; 
for trial=1:len
EER =zeros(75,1);        
ref=Reference(trial,:)
temp = 1:15;
test = setxor(temp,ref);
start=1;ending=75;
    Hinge_G_Feature = cell(15,2,75);
    Hinge_F_Feature = cell(15,2,75);
    Lbp_G_Feature=cell(15,2,75);
    Lbp_F_Feature=cell(15,2,75);
    for user=start:ending
                    for q=1:15
                            G=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/v',int2str(q),'.bmp');
                            F=horzcat('2004_MCYTDB_OffLineSignSubCorpus/',int2str(user),'/f',int2str(q),'.bmp');
                            im_G=imread(G);
                            BW_G=imcomplement(im2bw(im_G));
                            b_G = bwboundaries(BW_G);
                            
                            im_F=imread(F);
                            BW_F=imcomplement(im2bw(im_F));
                            b_F = bwboundaries(BW_F);
                            
                            [Hinge_G_Feature{q,1,user},Hinge_G_Feature{q,2,user}]=Hinge(b_G,r);
                            [Hinge_F_Feature{q,1,user},Hinge_F_Feature{q,2,user}]=Hinge(b_F,r);
                            
                            [Lbp_G_Feature{q,1,user},Lbp_G_Feature{q,2,user}]=LBP_(BW_G,b_G,r,wind);
                            [Lbp_F_Feature{q,1,user},Lbp_F_Feature{q,2,user}]=LBP_(BW_F,b_F,r,wind);
                    end
    end
    
    for user=start:ending
        TrainX=zeros(20,2);
        i=1;
        for p=1:5
            for q=1:5
                if p<q
                    TrainX(i,1)=HingeCost(Hinge_G_Feature{ref(p),:,user},Hinge_G_Feature{ref(q),:,user});
                    TrainX(i,2)=LbpCost(Lbp_G_Feature{ref(p),:,user},Lbp_G_Feature{ref(q),:,user});
                    i=i+1;
                end
            end
        end
        a=mod(user+1,75);
        if a==0
            a=75;
        end
        for p=1:5
            for q=1:2
                TrainX(i,1)=HingeCost(Hinge_G_Feature{ref(p),:,user},Hinge_G_Feature{q,:,a});
                TrainX(i,2)=LbpCost(Lbp_G_Feature{ref(p),:,user},Lbp_G_Feature{q,:,a});
                i=i+1;
            end
        end
        TrainY=[ones(10,1);2*ones(10,1)];
		
        %linear 
        c = cvpartition(size(TrainX,1),'KFold',4);
        opts = optimset('TolX',5e-4,'TolFun',5e-4);
        minfn = @(z)kfoldLoss(fitcsvm(TrainX,TrainY,'CVPartition',c,...
            'KernelFunction','linear','BoxConstraint',exp(z(1)),...
            'ClassNames',[1 2]));
        
        m = 1;
        fval = zeros(m,1);
        z = zeros(m,1);
        for j = 1:m;
            [searchmin,fval(j)] = fminsearch(minfn,randn(1,1),opts);
            z(j) = exp(searchmin);
        end
        z = z(fval == min(fval),:);

        SVM_Ln = fitcsvm(TrainX,TrainY,'KernelFunction','linear',...
            'BoxConstraint',z(1));

        %-----------------------------------------------------------------------------
		%RBF
		minfn = @(z)kfoldLoss(fitcsvm(TrainX,TrainY,'CVPartition',c,...
            'KernelFunction','rbf','BoxConstraint',exp(z(1)), 'KernelScale',exp(z(2)),...
            'ClassNames',[1,2]));
        m = 1;
        fval = zeros(m,1);
        z = zeros(m,2);
        for j = 1:m;
            [searchmin,fval(j)] = fminsearch(minfn,randn(2,1),opts);
            z(j,:) = exp(searchmin);
        end
        z = z(fval == min(fval),:);

        SVM_R = fitcsvm(TrainX,TrainY,...
            'KernelFunction','rbf','BoxConstraint',(z(1)), 'KernelScale',(z(2)),...
            'ClassNames',[1,2]);
		%------------------------------------------------------------------------------------
        Test_G=zeros(5,2,10);
        Test_F=zeros(5,2,15);
        for p=1:10
            for q=1:5
                Test_G(q,1,p)=HingeCost(Hinge_G_Feature{ref(q),:,user},Hinge_G_Feature{test(p),:,a});
                Test_G(q,2,p)=LbpCost(Lbp_G_Feature{ref(q),:,user},Lbp_G_Feature{test(p),:,a});
            end
        end
        for p=1:15
            for q=1:5
                Test_F(q,1,p)=HingeCost(Hinge_F_Feature{ref(q),:,user},Hinge_F_Feature{(p),:,a});
                Test_F(q,2,p)=LbpCost(Lbp_F_Feature{ref(q),:,user},Lbp_F_Feature{(p),:,a});
            end
        end
        Test_X=zeros(10,2);
        b=mean(Test_G);
        for p=1:10
            Test_X(p,:)=b(:,:,p);
        end
        Test_Y=zeros(15,2);
        b=mean(Test_F);
        for p=1:15
            Test_Y(p,:)=b(:,:,p);
        end
        
        [~,score1] = predict(SVM_R,Test_X);
        [~,score2] = predict(SVM_R, Test_Y);
        [~,~,~,EER(user,1)]=fastEval(-1*score1(:,2),-1*score2(:,2),0.1);
        user
        EER(user,1)
        eer=(EER(start:user))';
        Mean_EER=mean(eer)   
    end
eer=(EER(start:ending))' %EER vector of all users founded out
Mean_EER=mean(eer)      % average EER for all users 
display('---------------------Trial Ends--------------------');
    
end