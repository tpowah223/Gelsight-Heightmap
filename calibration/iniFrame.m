function [f0, f01]=iniFrame(frame0, border) 
% 1)filter with a Gaussian filter and cut border to get f1 2) after convolution, if the difference between original image and filtered image is less than 5
% keep 85% of the original image + 15% fitered image, this is f0


% frame0 is the raw data from camera
%kscale=50; %what dis is
%kernnel=fspecial('gaussian',[kscale*2 kscale*2],kscale*1);
% fspecial ( gaussian, hsize, sigma)
% better to use imgaussfilt for 2d or filt3 for 3d
% frame0 is the raw data from the camera

kscale = 50; % Kernel scale for the Gaussian filter
frame0_ = double(frame0);

% Apply Gaussian filter using built-in function
f0 = imgaussfilt(frame0_, kscale);

% Crop the image if border is specified
if border > 0
    f0 = f0(border+1:end-border, border+1:end-border, :);
    frame0_ = frame0_(border+1:end-border, border+1:end-border, :);
end

% Compute the mean difference between the original and filtered image
dI = mean(f0 - frame0_, 3);

% Adaptive threshold based on image statistics
threshold = mean(dI(:)) + std(dI(:));

% Blend original and filtered image based on adaptive threshold
blendMask = dI < threshold;
f0(blendMask) = f0(blendMask) * 0.15 + frame0_(blendMask) * 0.85;

% Calculate the mean of f0
t = mean(f0(:));

% Create the f01 image by adjusting the contrast
f01 = 1 + ((t ./ f0) - 1) * 2;

end

