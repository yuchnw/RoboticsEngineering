function [ output_args ] = addImageToAxes( imageFileName, axesHandle, axesWidth )
%HELPER Summary of this function goes here
%   Opens image filename and adds it to axes
%   Return the image object
%   If axesWidth = 0, then use image dafult pixel size


%   Open the file to get image data
imageData = imread(imageFileName);
%   Create image object and make the parent the axes
imageObject = image(imageData,'Parent',axesHandle);
%   Make unit of the axes pixels
%   Visible off
set(axesHandle,'Units','Pixels','Visible','Off');

%   Get the current position of the axes so we can use x and y
currentPosition = get(axesHandle,'Position');

%   Get the number of columns and rows of the image
[rows_height, cols_width, depth] = size(imageData);

%   If axesWidth = 0, axesWidth = num cols, axesHeight = num rows
if axesWidth == 0
    axesWidth = cols_width;
    axesHeight = rows_height;
%   Else, use the axesWidth and aspect ratio to calculate the height
else
    axesHeight = axesWidth * rows_height/cols_width;
end

%   Set the new position on the axes
set(axesHandle,'Position',[currentPosition(1) currentPosition(2) axesWidth axesHeight])


end

