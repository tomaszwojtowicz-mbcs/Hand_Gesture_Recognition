function [ hand ] = GetBinaryMasks( rgbImage, hand, useHysteresis, hysteresisBandWidthRatio )

    % GetBinaryMasks2 Applies user selected thresholding to the RGB image
    % 
    %
    %   Finds binary masks coresponding to the thresholds, and updates the
    %   'hand' object

    % Split the original image into R,G,B channels
    redChannel = rgbImage( :, :, 1 );
    greenChannel = rgbImage( :, :, 2 );   
    blueChannel = rgbImage( :, :, 3 );
    
    % Convert to HSV image
    hsvImage = rgb2hsv( rgbImage );
    
    % and split into channels
    hueChannel = hsvImage( :, :, 1 );
    saturationChannel = hsvImage( :, :, 2 );
    valueChannel = hsvImage( :, :, 3 );
    
    % Iterate over fingers
    for currentFinger = fieldnames(hand.fingers)'

        % If performing hysteresis thresholding, will calculate 'inner'
        % threshold values, and save them in respective finger objects
        if useHysteresis

            % Copy original set of threshold values to the 'outer'
            hand.fingers.(currentFinger{ 1 }).thresholdOuter = ...
                        hand.fingers.(currentFinger{ 1 }).threshold;

            % For readablity only
            thresholdOuter = hand.fingers.(currentFinger{ 1 }).thresholdOuter;
                
            for j = 1: 3

                % calculate the width of the bands containing candidate pixels
                candidateBandWidth = hysteresisBandWidthRatio * ...
                                     ( thresholdOuter( j, 2 ) - thresholdOuter( j, 1 ));

                hand.fingers.(currentFinger{ 1 }).threshold( j, 1 ) = ...
                        thresholdOuter( j, 1 ) + candidateBandWidth;
                                                                  
                hand.fingers.(currentFinger{ 1 }).threshold( j, 2 ) = ...
                        thresholdOuter( j, 2 ) - candidateBandWidth;

            end % end for
        end % end if
        
        switch ( hand.fingers.(currentFinger{ 1 }).colourSpace )
            case 'RGB'
                channel_1 = redChannel;
                channel_2 = greenChannel;
                channel_3 = blueChannel;
                
            case 'HSV'
                channel_1 = hueChannel;
                channel_2 = saturationChannel;
                channel_3 = valueChannel;

        end % end switch
        
        % For readablity only
        threshold = hand.fingers.(currentFinger{ 1 }).threshold;
        
        hand.fingers.(currentFinger{ 1 }).binaryMask = ( channel_1 >= threshold( 1, 1 )) & ...
                                                       ( channel_1 <= threshold( 1, 2 )) & ...
                                                       ( channel_2 >= threshold( 2, 1 )) & ...
                                                       ( channel_2 <= threshold( 2, 2 )) & ...
                                                       ( channel_3 >= threshold( 3, 1 )) & ...
                                                       ( channel_3 <= threshold( 3, 2 ));

     end % end for
     
     % Repeat the same for the skin
     if useHysteresis
        % Copy original set of threshold values to the 'outer'
        hand.palm.thresholdOuter = hand.palm.threshold;

        % For readablity only
        thresholdOuter = hand.palm.thresholdOuter;
            
        for j = 1: 3 
            % calculate the width of the bands containing candidate pixels
            candidateBandWidth = hysteresisBandWidthRatio * ...
                                 ( thresholdOuter( j, 2 ) - thresholdOuter( j, 1 ));

            hand.palm.threshold( j, 1 ) = thresholdOuter( j, 1 ) + candidateBandWidth;
            hand.palm.threshold( j, 2 ) = thresholdOuter( j, 2 ) - candidateBandWidth;

        end % end for
    end % end if
    
    switch ( hand.palm.colourSpace )
        case 'RGB'
            channel_1 = redChannel;
            channel_2 = greenChannel;
            channel_3 = blueChannel;

        case 'HSV'
            channel_1 = hueChannel;
            channel_2 = saturationChannel;
            channel_3 = valueChannel;

    end % end switch
        
    % For readablity only
    threshold = hand.palm.threshold;

    hand.palm.binaryMask = ( channel_1 >= threshold( 1, 1 )) & ...
                           ( channel_1 <= threshold( 1, 2 )) & ...
                           ( channel_2 >= threshold( 2, 1 )) & ...
                           ( channel_2 <= threshold( 2, 2 )) & ...
                           ( channel_3 >= threshold( 3, 1 )) & ...
                           ( channel_3 <= threshold( 3, 2 ));
                     
    % Apply Hysteresis Thresholding
    if useHysteresis

        switch ( hand.palm.colourSpace )
            case 'RGB'
                channel_1 = redChannel;
                channel_2 = greenChannel;
                channel_3 = blueChannel;

            case 'HSV'
                channel_1 = hueChannel;
                channel_2 = saturationChannel;
                channel_3 = valueChannel;

        end % end switch

        hand.palm.binaryMask = ...
            ApplyHysteresisThresholding( channel_1, channel_2, channel_3, ...
                                         hand.palm.thresholdOuter, ...
                                         hand.palm.binaryMask );


        for currentFinger = fieldnames(hand.fingers)'

            switch ( hand.fingers.(currentFinger{ 1 }).colourSpace )    
                case 'RGB'
                    channel_1 = redChannel;
                    channel_2 = greenChannel;
                    channel_3 = blueChannel;

                case 'HSV'
                    channel_1 = hueChannel;
                    channel_2 = saturationChannel;
                    channel_3 = valueChannel;

            end % end switch

            hand.fingers.(currentFinger{ 1 }).binaryMask = ...
                ApplyHysteresisThresholding( channel_1, channel_2, channel_3, ...
                hand.fingers.(currentFinger{ 1 }).thresholdOuter, ...
                hand.fingers.(currentFinger{ 1 }).binaryMask );
            
        end % end for
    end % end if
end % end function
