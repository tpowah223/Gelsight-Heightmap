function [ValidMap, diff] = ReconMask(frame, frame0)


diff = rgb2gray(abs((im2double(frame)-im2double(frame0))));
thresh=mean(diff(:))+ std(diff(:));
BallMask=diff<thresh;

ValidMap = repmat(BallMask, [1, 1, size(diff, 3)]);
diff(~BallMask) = 0;