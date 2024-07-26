function [f0, f01]=iniFrame(frame0, ~) 
% 1)filter with a Gaussian filter and cut border to get f0
% 2) after convolution, if the difference between original image and
% filtered image is less than threshold
% keep 85% of the original image + 15% fitered image, this is f0
%f01 is some contrast image for better results?

kscale = 50; % Kernel scale for the Gaussian filter
frame0_ = double(frame0);

% Apply Gaussian filter using built-in function
f0 = imgaussfilt(frame0_, kscale);

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
