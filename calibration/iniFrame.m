function [f0, f01]=iniFrame(frame0, ~) 

kscale = 50; % Kernel scale for the Gaussian filter

% Apply Gaussian filter using built-in function
f0 = imgaussfilt(frame0, kscale);

% Compute the mean difference between the original and filtered image
dI = mean(frame0 - f0, 3);

% Adaptive threshold based on image statistics
threshold = mean(dI(:)) + std(dI(:));

% Blend original and filtered image based on adaptive threshold
blendMask = dI < threshold;
f0(blendMask) = f0(blendMask) * 0.15 + frame0(blendMask) * 0.85;

% Calculate the mean of f0
t = mean(f0(:));

% Create the f01 image by adjusting the contrast
f01 = 1 + ((t ./ f0) - 1) * 2;

end

