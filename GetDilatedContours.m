function [ edgeContours ] = GetDilatedContours( binaryMask, edgeDetectionMethods, RESIZE_RATIO)

    %GetDilatedContours Produces cell array containing set of binary images representing
    % contourof the edges detected using edge() function, according to the detection 
    % methods provided
    %
    %   The function takes three inputs :  ( binaryMask, edgeDetectionMethods, RESIZE_RATIO )
    %   
    %   binaryMask              - a binary mask which edges are to be detected
    %
    %   edgeDetectionMethods    - a struct containing the names of the detection methods, 
    %                             structured as follows:
    %
    %                                        'name', { 'param1' 'param2' (...) }
    %
    %                             where 'param1' and 'param2' are consistent with with
    %                             parameters required by the edge() function :
    %                             'Sobel', 'Prewitt', 'Roberts', 'Canny',
    %                             'log', 'zerocross', 'approxcanny'
    %
    %   RESIZE_RATIO            - constant representing the resize ratio applied to the
    %                             original image, which will be also applied to the the
    %                             size of the structuring element used to dilate the contour
  
    % Get the number of detection methods to be used
    numberOfDetectionMethods = size ( edgeDetectionMethods, 2 );
    
    % Initialise the cell array to store the binary images representing the
    % edge contours
    edgeContours = cell( numberOfDetectionMethods ,1 );
    
    % Declare a Structuring Element 
    %
    % Please note that the RESIZE_RATIO applied to image matrix on load is
    % also being applied to the size of the strel, so it remain
    % proportional to the image matrix
    strelSmallDiamond = strel( 'diamond', round( 6 * RESIZE_RATIO ));
    
    % Find the edges using the edge() function and detection methods provided
    % then dilate to make them more prominent
    for i = 1 : numberOfDetectionMethods
        
        % Store the contour in the cell array
        edgeContours{ i } = imdilate( edge( binaryMask, edgeDetectionMethods( i ).name), ...
                                            strelSmallDiamond );
        
    end % end for

end % end function