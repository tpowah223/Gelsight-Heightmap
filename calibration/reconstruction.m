clear LookupTable;




%% Check the folder and the calibration file name
folder=input('what folder will be used to reconstruct: ');
path2folder='../testpics/';
Inputfolder = strcat(path2folder,folder,'/');
fname=strcat(folder,'.mat');
lookupfile=[Inputfolder fname];

[framename,location] = uigetfile('*.jpg', 'select images', Inputfolder);

load(lookupfile);
frame=imread([location framename] );

frame0=imread([Inputfolder 'frame0.jpg']); % ref image
[f0,f01] = iniFrame(frame0);

% Display the image
figure;
imshow(frame);
title('Draw ROI to create mask');

% Draw a polygonal ROI
h = drawpolygon('FaceAlpha',0, 'EdgeColor', 'b');

% Wait for the user to finish drawing
wait(h);

% Create a binary mask from the ROI
mask = createMask(h);

% Convert the mask to a logical array
mask = logical(mask);

% Display the mask
figure;
imshow(mask);
title('Generated Mask');

% Apply the mask to the image
% Ensure the mask is the same size as the image
frameMasked = double(frame);
frameMasked(repmat(~mask, [1, 1, 3])) = 0;  % Set areas outside mask to zero
I=frameMasked-f0;
%Generating Gradients
%RGB style
[ImGradX, ImGradY, ImGradMag, ImGradDir]=matchGrad_Bnz(LookupTable, I, f0);


%solving for height map
hm=fast_poisson2(ImGradX, ImGradY);

%graphing

figure;
tiledlayout(1,2);

A1 = framename;
A2= Inputfolder;
formatSpec = 'Captured 2D image of %s from %s';
str = sprintf(formatSpec, A1, A2);

nexttile;
imshow(frame);
title(str);

nexttile;
tt=mesh(hm);  %axis equal;
title("Reconstructured 3D");

%set(tt, 'XData', -1*get(tt,'XData'))
set(tt, 'YData', -1*get(tt,'YData'))
view(2);

A3='rst';
A4 = framename(1:end-4);
prompt="What did you change?: ";
changed = input(prompt,'s');
f='%s_%s_%s';
g=sprintf(f, A3,changed,A4);

folderPath='../comparisons/';
fullFilePath = fullfile(folderPath, g);
savefig(figure,fullFilePath);
% reduce the reconstructed 3D surface size.
hmm = shortArray(hm, 15); 

% conver to STL file
%surf2stl('0507_2_Im06.stl', 1, 1, hmm);
