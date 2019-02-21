function [ isolatedRGBPixelCluster ] = GetRGBPixelClusters( rgbImage, binaryMask )

    %GetRGBPixelClusters Isolates the clusters of RGB pixels corresponding
    % to the binary masks
    % 
    %   The method accepts an RGB image matrix and binary mask 

    isolatedRGBPixelCluster = uint8( binaryMask ) .* rgbImage;
        
end % end function