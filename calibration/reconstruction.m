clear LookupTable;




%% Check the folder and the calibration file name
Inputfolder='../testpics/7.22.1/';
lookupfile=[Inputfolder 'testpics.mat'];

[framename,location] = uigetfile('Im*.jpg', 'select images', '../testpics/');

border=0;
load(lookupfile);

frame0=imread([Inputfolder 'frame0.jpg']); % ref image
f0 = iniFrame(frame0, border);
frame=imread([location framename] );

frame_=frame(border+1:end-border,border+1:end-border,:);
I=im2double(frame)- f0;

[ContactMask, validMask, touchCenter, Radius] = FindBallArea_coarse(I, frame, BALL_MANUAL);
validMask = ContactMask; %added so that the valid mask for the picture reconstructed actually matches the picture being reconstructed

[ImGradX, ImGradY, ImGradMag, ImGradDir]=matchGrad_Bnz(LookupTable, I, f0);
hm=fast_poisson2(ImGradX, ImGradY);



figure;
tiledlayout(1,2);

A1 = framename;
formatSpec = 'Captured 2D image of %s';
str = sprintf(formatSpec, A1);
nexttile;
imshow(frame_);
title(str);

nexttile;
tt=mesh(hm);  %axis equal;
title("Reconstructured 3D");

%set(tt, 'XData', -1*get(tt,'XData'))
set(tt, 'YData', -1*get(tt,'YData'))
view(2);

%exportgraphics(figure, 'rst'+framename);

% reduce the reconstructed 3D surface size.
hmm = shortArray(hm, 15); 

% conver to STL file
%surf2stl('0507_2_Im06.stl', 1, 1, hmm);
