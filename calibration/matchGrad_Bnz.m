function [ImGradX, ImGradY, ImGradMag, ImGradDir]=matchGrad_Bnz(LookupTable, dI, f0,f01, BallMask)
% LookupTable is the look up table structure; dI is the difference; 
% f01 and validmask are not necessary
% f0 is the initializaion image. In current
% sketch, it's the sum of three channels. 
% validmask is the mask for contact area, optional
% Work for the GelSight-Bnz
%
% Wenzhen Yuan (yuanwenzhen@gmail.com), Feb 2017

if ~exist('f01')
   f0=double(f0);
   t=mean(f0(:));
   f01=1+((t./f0)-1)*2;
end

size1=size(dI,1);size2=size(dI,2); %dI rows (1) , columns (2)
ImGradMag=zeros(size1,size2);
ImGradDir=zeros(size1,size2);
DI=dI.*f01;

binm=LookupTable.bins-1;
if exist('BallMask')    
    sizet=size1*size2;%size of the channels, helps access G
    sizet2=2*sizet;%offset to get B channel
    validid=find(BallMask); %gets positions of true/white values in the mask

    r1=DI(validid);g1=DI(validid+sizet);b1=DI(validid+sizet2); %accessing values of rgb

    r2=(r1-LookupTable.Zeropoint)/LookupTable.Scale; %scaling and normalizing factors
    g2=(g1-LookupTable.Zeropoint)/LookupTable.Scale;
    b2=(b1-LookupTable.Zeropoint)/LookupTable.Scale;
    r2=fix1(r2);g2=fix1(g2);b2=fix1(b2); 

    r3=floor(r2*binm)+1;b3=floor(b2*binm)+1;g3=1+floor(g2*binm);
    ind=sub2ind([LookupTable.bins LookupTable.bins LookupTable.bins], r3,g3,b3);

    ImGradMag(validid)=LookupTable.GradMag(ind);
    ImGradDir(validid)=LookupTable.GradDir(ind);
    
else    % when there is no mask and all are calculated
    r1=DI(:,:,1);g1=DI(:,:,2);b1=DI(:,:,3);
    r2=(r1-LookupTable.Zeropoint)/LookupTable.Scale;r2=fix1(r2);
    g2=(g1-LookupTable.Zeropoint)/LookupTable.Scale;g2=fix1(g2);
    b2=(b1-LookupTable.Zeropoint)/LookupTable.Scale;b2=fix1(b2);
    r3=floor(r2*binm)+1;b3=floor(b2*binm)+1;g3=1+floor(g2*binm);
    ind=sub2ind([LookupTable.bins LookupTable.bins LookupTable.bins], r3,g3,b3);
    ImGradMag=LookupTable.GradMag(ind);
    ImGradDir=LookupTable.GradDir(ind);
end
ImGradX=ImGradMag.*cos(ImGradDir);
ImGradY=ImGradMag.*sin(ImGradDir);
    

function num=fix1(num)
% fix between 0 to 1
num(num>1)=1;num(num<0)=0;