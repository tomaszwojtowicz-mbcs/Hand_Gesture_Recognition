function [] = mainProgram ( rgbImage, settings, figuresToDisplay )

%mainProgram Performs the image processing operations
%   as specified by the assignment specification
% 
% This is the main body of the solution, to be used through the UI
% contained within start.mlapp
     
close all
clc

% Initialise the hand object
hand = handObject;

% Define thresholds based on image inspection using impixelinfo()
%
% Please note that HSV thresholds, rather than RGB, are being used for
% Thumb (orange), Litte finger (red), and Skin
% 
%   [   Red_min, Red_max;
%     Green_min, Green_max;
%      Blue_min, Blue_max ]
%
% or in case of HSV:
%
%   [        Hue_min, Hue_max;
%     Saturation_min, Saturation_max;
%          Value_min, Value_max ]  

hand.fingers.thumb.colourSpace = 'HSV';
hand.fingers.thumb.threshold = [ 0.046, 0.063; ...
                                  0.69, 0.88; ...
                                   0.4, 0.67 ];

hand.fingers.index.colourSpace = 'RGB';
hand.fingers.index.threshold = [ 110, 180; ...
                                  90, 170; ...
                                  15, 60 ];

hand.fingers.middle.colourSpace = 'RGB';                                
hand.fingers.middle.threshold = [ 0, 30; ...
                                 40, 80; ...
                                 65, 130 ];

hand.fingers.ring.colourSpace = 'RGB';
hand.fingers.ring.threshold = [ 0, 65; ...
                               40, 100; ...
                               35, 70 ];

hand.fingers.little.colourSpace = 'HSV';
hand.fingers.little.threshold = [ 0.015, 0.03; ...
                                   0.52, 0.8; ...
                                   0.35, 0.73 ];
                                 
hand.palm.colourSpace = 'HSV';
hand.palm.threshold = [ 0.028, 0.065; ...
                         0.45, 0.7; ...
                         0.34, 0.6 ];

% Resize the image
rgbImage = imresize( rgbImage, settings.resizeRatio );

% Store image dimensions for future use
[ M, N, numberOfChannels ] = size( rgbImage );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             A1                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert to grayscale
grayscaleImage = ConvertToGrayscale( rgbImage, settings.grayscaleConversionMethod );

if figuresToDisplay.A1
    
    % Display images
    figure ( 'Name', 'Original and grayscale images', 'MenuBar', 'none' );
    subplot( 1, 2 ,1 );
    imshow( rgbImage ); title( 'Original image' );

    subplot( 1, 2, 2 );
    imshow( grayscaleImage ); colormap gray;
    title( strcat( 'Grayscale image (', settings.grayscaleConversionMethod, ')' ));

end % end if


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                             A2                             %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Split the original image into R,G,B Channels
redChannel = rgbImage( :, :, 1 );
greenChannel = rgbImage( :, :, 2 );
blueChannel = rgbImage( :, :, 3 );

% Get number of pixels. Note that grayscale image will contain the same number
% of pixels as each channel of the original image
numberOfPixels = numel( rgbImage ) / numberOfChannels;

% Get histogram values for each channel and grayscale image
% Red
[ histogramCountRed, binLocationsRed ] = imhist( redChannel );
histogramNormCountRed = histogramCountRed / numberOfPixels;

% Green
[ histogramCountGreen, binLocationsGreen ] = imhist( greenChannel ); 
histogramNormCountGreen = histogramCountGreen / numberOfPixels;

% Blue
[ histogramCountBlue, binLocationsBlue ] = imhist( blueChannel ); 
histogramNormCountBlue = histogramCountBlue / numberOfPixels;

% Grayscale
histogramCountGrayscale = imhist( grayscaleImage );
histogramNormCountGrayscale = histogramCountGrayscale / numberOfPixels;

% Find extremas and arithmetic means
% Red
redMax = max( max( redChannel ));
redMin = min( min( redChannel ));
redMean = mean2( redChannel );

% Green
greenMax = max( max( greenChannel ));
greenMin = min( min( greenChannel ));
greenMean = mean2( greenChannel );

% Blue
blueMax = max( max( blueChannel ));
blueMin = min( min( blueChannel ));
blueMean = mean2( blueChannel );

% Gray
grayMax = max( max( grayscaleImage ));
grayMin = min( min( grayscaleImage ));
grayMean = mean2( grayscaleImage );

% Initialise white canvas to display image statistics on
blankCanvas = ones( 550, 450 ) .* 255;
    
if figuresToDisplay.A2
    % Plot normalised histograms
    figure( 'Name', 'Histograms', 'MenuBar', 'none' );
   
    % R,G and B channels on one plot
    subplot( 2, 3, 4 );
    plot( binLocationsRed, histogramNormCountRed, 'Red', ...
          binLocationsGreen, histogramNormCountGreen, 'Green', ...
          binLocationsBlue, histogramNormCountBlue, 'Blue' );
    hold on

    title( 'R,G and B channels' );
    xlabel( 'Luminance', 'FontSize', 10 );
    ylabel( 'Normalised Count','FontSize', 10 );
    xlim([ 0 255 ]);
    ylim([ 0 max( max([ histogramNormCountRed, histogramNormCountGreen, ...
                        histogramNormCountBlue ]))]);

    % plot means
    plot([ redMean redMean ], get( gca, 'ylim' ), '--r' );
    plot([ greenMean greenMean ], get( gca, 'ylim' ), '--g' );
    plot([ blueMean blueMean ], get( gca, 'ylim' ), '--b' );

    hold off

    % Red channel
    subplot( 2, 3, 1);
    bar( histogramNormCountRed, 'r');
    hold on

    title( 'Red channel' );
    xlabel( 'Luminance', 'FontSize', 10 );
    ylabel( 'Normalised Count', 'FontSize', 10 );
    xlim([ 0 255 ]);
    ylim([ 0 ( max( histogramNormCountRed ))]);

    % Plot mean
    plot([ redMean redMean ], get( gca, 'ylim' ), '--r');

    hold off;

    % Green channel
    subplot( 2, 3, 2);
    bar( histogramNormCountGreen, 'g' );
    hold on

    title( 'Green channel' );
    xlabel( 'Luminance', 'FontSize', 10 );
    ylabel( 'Normalised Count', 'FontSize', 10 );
    xlim([ 0 255 ]);
    ylim([ 0 ( max( histogramNormCountGreen ))]);

    % Plot mean
    plot([ greenMean greenMean ], get( gca, 'ylim' ), '--g' )

    hold off

    % Blue channel
    subplot( 2, 3, 3 );
    bar( histogramNormCountBlue, 'b' );
    hold on

    title( 'Blue channel');
    xlabel( 'Luminance', 'FontSize', 10 );
    ylabel( 'Normalised Count', 'FontSize', 10 );
    xlim([ 0 255 ]);
    ylim([ 0 ( max( histogramNormCountBlue ))]);

    % Plot mean
    plot([ blueMean blueMean ], get( gca, 'ylim' ), '--b' );

    hold off

    % Grayscale
    subplot( 2, 3, 5 );
    bar( histogramCountGrayscale / numberOfPixels, 'black' );
    hold on

    title( 'Grayscale');
    xlabel( 'Luminance', 'FontSize', 10 );
    ylabel( 'Normalised Count', 'FontSize', 10 );
    xlim([ 0 255 ]);
    ylim([ 0 ( max( histogramNormCountGrayscale ))]);

    % Display extrema
    plot([ grayMean grayMean ], get( gca, 'ylim' ), '--black' );

    hold off
    
    figure( 'Name', 'Image statistics', 'MenuBar', 'none' );
    imshow( blankCanvas ); 
    
    text( 10, 30, 'Red min : ', 'FontSize', 14 ); 
    text( 300, 30, num2str( redMin ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 70, 'Red max : ', 'FontSize', 14 ); 
    text( 300, 70, num2str( redMax ), 'FontSize', 14, 'FontWeight', 'Bold' ); 
    
    text( 10, 110, 'Red mean : ', 'FontSize', 14 ); 
    text( 300, 110, num2str( redMean ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 170, 'Green min : ', 'FontSize', 14 ); 
    text( 300, 170, num2str( greenMin ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 210, 'Green max : ', 'FontSize', 14 ); 
    text( 300, 210, num2str( greenMax ), 'FontSize', 14, 'FontWeight', 'Bold' ); 
    
    text( 10, 250, 'Green mean : ', 'FontSize', 14 ); 
    text( 300, 250, num2str( greenMean ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 310, 'Blue min : ', 'FontSize', 14 ); 
    text( 300, 310, num2str( blueMin ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 350, 'Blue max : ', 'FontSize', 14 ); 
    text( 300, 350, num2str( blueMax ), 'FontSize', 14, 'FontWeight', 'Bold' ); 
    
    text( 10, 390, 'Blue mean : ', 'FontSize', 14 ); 
    text( 300, 390, num2str( blueMean ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 430, 'Grayscale min : ', 'FontSize', 14 ); 
    text( 300, 430, num2str( grayMin ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 470, 'Grayscale max : ', 'FontSize', 14 ); 
    text( 300, 470, num2str( grayMax ), 'FontSize', 14, 'FontWeight', 'Bold' ); 
    
    text( 10, 510, 'Grayscale mean : ', 'FontSize', 14 ); 
    text( 300, 510, num2str( grayMean ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
end % end if

% Clearing a bunch of variables that will not be used anymore
clear redMax redMin redMean greenMax greenMin greenMean blueMax blueMin blueMean ...
      grayMax grayMin grayMean binLocationsRed histogramCountRed histogramNormCountRed ...
      binLocationsGreen histogramCountGreen histogramNormCountGreen ...
      binLocationsBlue histogramCountBlue histogramNormCountBlue ...
      histogramCountGrayscale histogramNormCountGrayscale ...
      numberOfPixels blankCanvas;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             A3                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get binary masks for each of fingers and the skin
hand = GetBinaryMasks( rgbImage, hand, settings.applyHysteresisThresholding, settings.candidateBandRatio );

% Improve the binary masks by applying morphological operations
% Finger tips
for currentFinger = fieldnames(hand.fingers)'
    
    hand.fingers.(currentFinger{ 1 }).binaryMask = ...
        ApplyMorphologicalOperations( hand.fingers.( currentFinger{ 1 }).binaryMask, settings );

end % end for

% And same again for the palm
hand.palm.binaryMask = ApplyMorphologicalOperations( hand.palm.binaryMask, settings );


% Isolate the RGB pixel clusters corresponding to each binary mask
for currentFinger = fieldnames(hand.fingers)'
    
    hand.fingers.(currentFinger{ 1 }).isolatedPixels = ...
        GetRGBPixelClusters( rgbImage, hand.fingers.(currentFinger{ 1 }).binaryMask );
    
end % end for


% Initialize the array with the subplot's titles, so they could be iterated
% over
subPlotTitles_A3 = { 'Thumb binary mask', 'Thumb pixels isolated', ...
                     'Index finger binary mask', 'Index finger pixels isolated', ...
                     'Middle finger binary mask', 'Middle finger pixels isolated', ...
                     'Ring finger binary mask', 'Ring finger pixels isolated', ...
                     'Little finger binary mask', 'Little finger pixels isolated'};
                    
% Initialise counter variable
subplotCounter = 1;


if figuresToDisplay.A3
    % Display images 
    figure( 'Name', 'Binary masks and isolated RGB pixels', 'MenuBar', 'none');
    
    for currentFinger = fieldnames(hand.fingers)'
        for z = 1: 2
            subplot( 5, 2, subplotCounter );

            if  z == 1
                imshow( hand.fingers.(currentFinger{ 1 }).binaryMask );

            else
                imshow( hand.fingers.(currentFinger{ 1 }).isolatedPixels );

            end % end if

            title( subPlotTitles_A3{ subplotCounter }, 'FontSize', 6 );
            subplotCounter = subplotCounter + 1;

        end % end for
    end % end for 
end % end if

clear subPlotTitles_A3 subplotCounter;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             A4                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise the grayscale image matrix to be processed
grayscaleNoFingerTips = grayscaleImage;

% Remove finger tips' pixels from grayscale image, so they don't overlap
for currentFinger = fieldnames(hand.fingers)'
    
    grayscaleNoFingerTips( hand.fingers.(currentFinger{ 1 }).binaryMask ) = 0;
   
end % end for

% Initalise the matrix to store a RGB image, by copying a grayscale matrix
grayscaleWithColouredFingerTips = repmat( grayscaleNoFingerTips, [ 1 1 numberOfChannels ]);

% Iterate over figers and add its isolated pixel to the image
for currentFinger = fieldnames(hand.fingers)'
    
    grayscaleWithColouredFingerTips = ...
            grayscaleWithColouredFingerTips + hand.fingers.(currentFinger{ 1 }).isolatedPixels;
    
    % While iterating, calculate and save sizes of pixel clusters
    hand.fingers.(currentFinger{ 1 }).sizeOfPixelCluster = ...
            nnz ( hand.fingers.(currentFinger{ 1 }).binaryMask );
    
end % end for

if figuresToDisplay.A4
    % Display image
    figure( 'Name', 'Coloured finger tips superimposed on grayscale image', 'MenuBar', 'none' );
    imshow( grayscaleWithColouredFingerTips );
    
    % Display pixel cluster sizes
    figure( 'Name', 'Pixel cluster sizes', 'MenuBar', 'none' );
    blankCanvas = ones( 300, 500 ) .* 255;
    imshow( blankCanvas );
    
    text( 10, 50, 'Thumb : ', 'FontSize', 14 ); 
    text( 400, 50,  num2str( hand.fingers.thumb.sizeOfPixelCluster ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 100, 'Index finger : ', 'FontSize', 14 ); 
    text( 400, 100, num2str( hand.fingers.index.sizeOfPixelCluster ), 'FontSize', 14, 'FontWeight', 'Bold' ); 
    
    text( 10, 150, 'Middle finger: ', 'FontSize', 14 ); 
    text( 400, 150, num2str( hand.fingers.middle.sizeOfPixelCluster ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 200, 'Ring finger : ', 'FontSize', 14 ); 
    text( 400, 200, num2str( hand.fingers.ring.sizeOfPixelCluster ), 'FontSize', 14, 'FontWeight', 'Bold' );
    
    text( 10, 250, 'Little finger : ', 'FontSize', 14 ); 
    text( 400, 250, num2str( hand.fingers.little.sizeOfPixelCluster ), 'FontSize', 14, 'FontWeight', 'Bold' ); 
    
end % end if

clear grayscaleNoFingerTips;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             A5                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise array to hold distances between pairs of adjacent finger tips
euclideanDistance = cell( 4, 1 );

% Find weighted centroids using built-in method
for currentFinger = fieldnames( hand.fingers )'
    
    centroid = regionprops( true( M, N ), hand.fingers.(currentFinger{ 1 }).binaryMask, ...
                            'WeightedCentroid' );
                        
    hand.fingers.( currentFinger{ 1 }).center = cat (1, centroid.WeightedCentroid );

end % end for

% Same for the palm
centroid = regionprops(true( M, N ), hand.palm.binaryMask, 'WeightedCentroid' );
hand.palm.center = cat(1, centroid.WeightedCentroid );

if figuresToDisplay.A5
    % Display images
    figure ( 'Name', 'Average coordinates of finger tips', 'MenuBar', 'none' );
    imshow( grayscaleWithColouredFingerTips ); 

    fields = fieldnames( hand.fingers );

    for i = 1: numel( fields )
        % Plot a sphere at each finger tip
        viscircles( hand.fingers.( fields{ i }).center, round( 100 * settings.resizeRatio ));
        
        % Skipping last iteration, so the index will not get out of bounds
        if ( i ~= numel( fields ))
            % Plot lines connecting adjacent finger tips
            line([ hand.fingers.(fields{ i }).center( 1 ) ...
                   hand.fingers.(fields{ i+1 }).center( 1 )], ...
                 [ hand.fingers.(fields{ i }).center( 2 ) ...
                   hand.fingers.(fields{ i+1 }).center( 2 )], ...
                 'Color', 'green' );

            % Calculate the distances between pairs of adjacent fingertips and store in the cell array
            euclideanDistance{ i } = pdist2([ hand.fingers.( fields{ i }).center( 1 ) ...
                                              hand.fingers.( fields{ i }).center( 2 )], ...
                                            [ hand.fingers.( fields{ i+1 }).center( 1 ) ...
                                              hand.fingers.( fields{ i+1 }).center( 2 )], ...
                                            'euclidean' )';
        end % end if
    end % end for
end % end if

% Clear the variables that will not be used again
clear euclideanDistance centroid fields;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             A6                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Put names of the detection methods (consistent with parameters required by the edge() method) in
% a struct, to improve readibility of code when iterating
edgeDetectionMethods = struct( 'name', { 'Roberts' ...
                                         'Prewitt' ...
                                         'Sobel' ...
                                         'Canny' });


% Populate cell array with contours produced by the GetDilatedContours()
% method
edgeContours = GetDilatedContours( hand.palm.binaryMask, edgeDetectionMethods, settings.resizeRatio );

% Iterate over the contours and annotate each as a red line on the RGB image
if figuresToDisplay.A6
    % Display the approptiately titled RGB image
    figure ( 'Name', 'Skin contours', 'MenuBar', 'none' );
    for i = 1 : size( edgeContours , 1)

        % Create temporary copies of each colour channel, to be processed
        % within the for loop
        tmp_redChannel = redChannel;
        tmp_greenChannel = greenChannel;
        tmp_blueChannel = blueChannel;

        % Apply contour's binary mask to each of the R,G and B channels to
        % produce the red contour 
        tmp_redChannel( edgeContours{ i }) = 255;
        tmp_greenChannel( edgeContours{ i }) = 0;
        tmp_blueChannel( edgeContours{ i }) = 0;

        % Concatendate the R,G and B channels to obtain a RGB image
        tmp_rgb = cat( 3, tmp_redChannel, tmp_greenChannel, tmp_blueChannel );

        % Working out the grammatically correct possesive form of the edge
        % detection method's name
        if endsWith( edgeDetectionMethods( i ).name, 's' )
            methodNameInPosessiveForm = strcat( edgeDetectionMethods( i ).name, '''');       
        else
            methodNameInPosessiveForm = strcat( edgeDetectionMethods( i ).name, '''s');         
        end % end if

        subplot( 2, 2, i);
        imshow( tmp_rgb ); title( sprintf( 'Skin edge detected using %s method', ...
                                            methodNameInPosessiveForm ));
        
    end % end for
end % end if

clear edgeContours tmp_redChannel tmp_greenChannel tmp_blueChannel tmp_rgb methodNameInPosessiveForm;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             B1                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise the flag signaling detection error
error = false;

% Calculate the distances between the palm's centre and each finger tip
for currentFinger = fieldnames( hand.fingers )'
    if ( isnan( hand.fingers.( currentFinger{ 1 }).center( 1 )))
        error = true;
        break;
    end % end if
    
    hand.fingers.(currentFinger{ 1 }).distanceToPalm = ...
        pdist2([ hand.palm.center( 1 ) hand.palm.center( 2 )], ...
               [ hand.fingers.( currentFinger{ 1 }).center( 1 ) ...
                 hand.fingers.(currentFinger{ 1 }).center( 2 )], ...
               'euclidean' )';

end % end for



% Initalise variable to store the distance
% from palm to longest extended finger
longestDistance = -1;

for currentFinger = fieldnames( hand.fingers )'
    if ( hand.fingers.( currentFinger{ 1 }).distanceToPalm > longestDistance )
        longestDistance = hand.fingers.( currentFinger{ 1 }).distanceToPalm;
        
    end % end if
end % end for
 
distance_threshold = settings.detectionThreshold * longestDistance;

for currentFinger = fieldnames( hand.fingers )'
    
    if ( hand.fingers.( currentFinger{ 1 }).distanceToPalm > distance_threshold )
         hand.fingers.( currentFinger{ 1 }).extended = true;      
    else
        hand.fingers.( currentFinger{ 1 }).extended = false;  
        
    end % end if
end % end for

% Initalise variable to hold detected gesture (string)
gesture = '';

% Find which gesture is being shown
if hand.fingers.thumb.extended
    if hand.fingers.little.extended
        gesture = 'Five';

    elseif hand.fingers.middle.extended
        gesture = 'Three';

    else 
        gesture = 'Ten';

    end % end if
else
    if ( hand.fingers.index.extended && ~hand.fingers.middle.extended && ...
         ~hand.fingers.ring.extended && ~hand.fingers.little.extended )
        gesture = 'One';

    elseif ( hand.fingers.index.extended && hand.fingers.middle.extended && ...
             ~hand.fingers.ring.extended && ~hand.fingers.little.extended )
        gesture = 'two';

    elseif ( hand.fingers.index.extended && hand.fingers.middle.extended && ...
             hand.fingers.ring.extended && hand.fingers.little.extended )
        gesture = 'Four';

    elseif ( hand.fingers.index.extended && hand.fingers.middle.extended && ...
             hand.fingers.ring.extended && ~hand.fingers.little.extended )
        gesture = 'Six';

    elseif ( hand.fingers.index.extended && hand.fingers.middle.extended && ...
             hand.fingers.little.extended && ~hand.fingers.ring.extended )
        gesture = 'Seven';

    elseif ( hand.fingers.index.extended && hand.fingers.ring.extended && ...
             hand.fingers.little.extended && ~hand.fingers.middle.extended )
        gesture = 'Eight';

    elseif ( hand.fingers.middle.extended && hand.fingers.ring.extended && ...
             hand.fingers.little.extended && ~hand.fingers.index.extended )
        gesture = 'Nine';

    end % end if
end % end if

if error
    gesture = 'Not detected';
end % end if

if ( figuresToDisplay.B || figuresToDisplay.BLive )

    figure( 'Name', 'Gesture detected', 'MenuBar', 'none' );
    imshow( rgbImage );
    text(( N / 8 ), ( M / 8 ), gesture, 'Color', 'red', 'FontSize', 80 * settings.resizeRatio );
    
end % end if

% print('-f1', '-r600', '-dbmp', 'BLive.bmp');
    
clear longestDistance distance_threshold gesture rgbImage grayscaleWithColouredFingerTips;
end