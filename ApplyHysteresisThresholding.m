function [ binaryMask ] = ApplyHysteresisThresholding( channel_1, channel_2, channel_3, ...
                                                       threshold, binaryMask)

    %ApplyHysteresisThresholding Applies hysteresis thresholding binary
    % mask
    % 
    % Returns improved binary mask

    % This constant stores number of neighbouring pixels to check
    CONNECTIVITY = 8;
    
    % Channel 1
    % Band thresholding used to obtain outer binary mask
    channel_1Outer = channel_1 > threshold( 1, 1 ) & channel_1 < threshold( 1, 2 ); 
    
    % Get coordinates of inner mask's pixels
    [ ch_1Row, ch_1Col] = find( binaryMask );	
    
    % Find the pixels in the outer mask that are connected to ones in inner
    % mask
    channel_1Binary = bwselect( channel_1Outer, ch_1Col, ch_1Row, CONNECTIVITY); 
    
    % Repeat for 2nd channel
    channel_2Outer = channel_2 > threshold( 2, 1 ) & channel_2 < threshold( 2, 2 );   
    [ ch_2Row, ch_2Col] = find( binaryMask );	
    channel_2Binary = bwselect( channel_2Outer , ch_2Col, ch_2Row, CONNECTIVITY);   

    % Repeat for 3rd channel
    channel_3Outer = channel_3 > threshold( 3, 1 ) & channel_3 < threshold( 3, 2 );   
    [ ch_3Row, ch_3Col] = find( binaryMask );	
    channel_3Binary = bwselect( channel_3Outer , ch_3Col, ch_3Row, CONNECTIVITY);   

    % Update the original binary mask
    binaryMask = ( channel_1Binary & channel_2Binary & channel_3Binary );

end % end function
