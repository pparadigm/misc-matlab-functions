function [image] = Whitescreen(foreground, background, threshold)
%Whitescreen Use white pixels as a greenscreen.
%   Whitescreen(foreground, background, threshold) takes two RGB images of 
%   the same size (foreground and background) and a threshold value
%   that must be equal to or between 0 and 255. It then searches for pixels
%   in the foreground that have an R, G, and B value greater than the
%   threshold, and replaces those pixels with the R, G, and B values of the
%   background image.
    fg = imread(foreground);
    bg = imread(background);
    assert(and(threshold >= 0, threshold <= 255),...
        'Threshold entered was not equal to nor between 0 and 255.');
    
    % separating RGB data
    % red part:
    red = fg(:, :, 1);
    % assuming that red, green, and blue have the same x and y dimensions
    [x, y] = size(red);
    red(:, :, 2) = zeros(x, y);
    red(:, :, 3) = zeros(x, y);
    % MATLAB doesn't seem to like redefining values that have already been set.
    % Therefore, I let MATLAB fill the previous values on its own, and
    % explicitly set anything extra.
    % green part:
    green(:, :, 2) = fg(:, :, 2);
    green(:, :, 3) = zeros(x, y);
    % blue part:
    blue(:, :, 3) = fg(:, :, 3);

    % create mask based on user input
    redmask = red(:, :, 1) > threshold;
    greenmask = green(:, :, 2) > threshold;
    bluemask = blue(:, :, 3) > threshold;
    whitemask = and(redmask, and(greenmask, bluemask));
    whitemask3D = cat(3, whitemask, whitemask, whitemask);

    % put foreground in a pure white plane
    image = fg;

    % superimpose foreground on background
    image(whitemask3D) = bg(whitemask3D);
end