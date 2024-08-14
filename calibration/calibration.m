
% Generate lookup table from images in a single folder
% To make the calibration video: press a sphere onto the GelSight sensor
% surface, roll it on different positions. Make sure the 1st frame (or at
% least one frame) is blank with nothing contacting the Gel
% Pick up one or more frames in the videos to calibrate the sensor
% Modify the Ball's radius and the sensor's display ratio for each test
%
% Mod by Wenzhen Yuan (yuanwenzhen@gmail.com), Jan 2018

clear; %close all;
BallRad=12.414; %25.4/2; % Ball's radius, in mm
border= 0; % i dont think we need a border
BALL_MANUAL=1;      % whether to find the ball manually
%I dont have a separate functions folder, i run everything under 'Gelsight'

%% Check the folder and the calibration file name

folder=input('what folder will be used to calibrate: ');
path2folder='../testpics/';
Inputfolder = strcat(path2folder,folder,'/');
savename = [folder '.mat'];

%% Generate lookup table
bins = 80;%how would changing bin size affect lookuptable and recon, try 40-120
gradmag = [];
gradir = [];
countmap = [];

% Initialize zeropoint and lookscale with default values
zeropoint = -90; % slight improvement in eliminating noise when raised, but beyond 120 it does not make significant changes
lookscale = 180; % Default lookscale

Pixmm = input("what is the pixmm for this set: ");

BallRad_pix = BallRad / Pixmm;

% Read Initial Image
frame0 = imread([Inputfolder 'frame0.jpg']);
[f0,f01]=iniFrame(frame0);


% List of calibration images
ImList = dir([Inputfolder 'Im*.jpg']); %Im or cal for cal images

% Process each calibration image
for Frn = 1:length(ImList)

    frame = imread([Inputfolder ImList(Frn).name]);
    disp(['Calibration on Frame ' num2str(Frn)]);
    dI = (double(frame)-f0); %try double and im2double

    [ContactMask, ValidMap, touchCenter, Radius] = FindBallArea_coarse(dI,frame, BALL_MANUAL);
    ValidMap = ContactMask;%validMask & ContactMask;
    
    %nomarkermask = min(-I, [], 3) < 30; also appear non-critical, but will
    %test with and without again

    %nomarkermask = imerode(nomarkermask, strel('disk', 3));
    %validMask = validMask & nomarkermask;
    
    [gradmag, gradir, countmap] = LookuptableFromBall_Bnz(dI, f0, bins, touchCenter, Radius, BallRad, Pixmm, ValidMap, gradmag, gradir, countmap, zeropoint, lookscale);
end

disp('Internal calibration process starts');

[GradMag, GradDir] = LookuptableSmooth(bins, gradmag, gradir, countmap);
LookupTable.bins = bins;
LookupTable.GradMag = GradMag;
LookupTable.GradDir = GradDir;
LookupTable.GradX = -cos(GradDir) .* GradMag;
LookupTable.GradY = sin(GradDir) .* GradMag;
LookupTable.Zeropoint = zeropoint;
LookupTable.Scale = lookscale;
LookupTable.Pixmm = Pixmm;
LookupTable.FrameSize = size(frame);
save([Inputfolder savename], 'LookupTable');
disp('Calibration Done');
