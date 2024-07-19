function [ContactMask, ValidMap, center, Radius] = FindBallArea_coarse(I, frame, MANUAL)
% find the circle in the pressing sphere sample case.
% The input matrix I is single-channelled, the result of the current image
% subtract the background
% MANUAL: whether to adjust the center and radius manually

if ~exist('MANUAL', 'var')
    MANUAL = false;
end

if ~exist('frame', 'var')
    frame(:,:,1) = (I + 50) * 1.5; % create a dummy frame if none provided
    frame(:,:,2) = (I + 50) * 1.5;
    frame(:,:,3) = (I + 50) * 1.5;
end

% Initial parameters
center = [size(I, 2) / 2, size(I, 1) / 2];  % Center of the image
Radius = min(size(I)) / 16;  % Initial radius
colors = {'r', 'g', 'b', 'y', 'm', 'c', 'w'};  % Color options
colorIndex = 1;
color = colors{colorIndex};
kstep = 10;  % Step size for adjustments

if MANUAL
    % Display the image
    hf = figure;
    himage = imshow(frame); 
    hold on;
    viscircles(center, Radius, 'EdgeColor', color); 
    
    % Interactive menu to calibrate circle
    while ishandle(hf)
        k = waitforbuttonpress;
        if k  % Keyboard
            c = get(hf, 'CurrentCharacter');
            if c == 27  % ESC
                break;
            elseif c == 'w'  % Move up
                center(2) = center(2) - kstep;
            elseif c == 's'  % Move down
                center(2) = center(2) + kstep;
            elseif c == 'a'  % Move left
                center(1) = center(1) - kstep;
            elseif c == 'd'  % Move right
                center(1) = center(1) + kstep;
            elseif c == '+'  % Increase radius
                Radius = Radius + kstep;
            elseif c == '-'  % Decrease radius
                Radius = Radius - kstep;
            elseif c == 'c'  % Change color
                colorIndex = mod(colorIndex, length(colors)) + 1;
                color = colors{colorIndex};
            end
            
            % Redraw the circle
            imshow(frame);  % Refresh the image
            hold on;
            viscircles(center, Radius, 'EdgeColor', color);
        end
    end
    close(hf);
end

% Generate the ContactMask and ValidMap
[xq, yq] = meshgrid(1:size(I, 2), 1:size(I, 1));
xq = xq - center(1);
yq = yq - center(2);
rq = xq.^2 + yq.^2;
ContactMask = (rq < (Radius^2));
ValidMap = true(size(I));  % Assuming the whole image is valid for now

end
