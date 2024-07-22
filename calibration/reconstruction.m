clear LookupTable;




%% Check the folder and the calibration file name
Inputfolder='../testpics/7.16.2/';
lookupfile=[Inputfolder 'testpics.mat'];

[framename,location] = uigetfile('Im*.jpg', 'select images', '../testpics/');

border=0;
load(lookupfile);

frame0=imread([Inputfolder 'frame0.jpg']); % ref image
f0 = iniFrame(frame0, border);
frame=imread([location framename] );

frame_=frame(border+1:end-border,border+1:end-border,:);
I=frame- f0;

[ImGradX, ImGradY, ImGradMag, ImGradDir]=matchGrad_Bnz(LookupTable, dI, f0,f01, validMask);
hm=fast_poisson2(ImGradX, ImGradY);



figure;
tiledlayout(1,2);

nexttile;
imshow(frame_);
title("Captured 2D image");

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
