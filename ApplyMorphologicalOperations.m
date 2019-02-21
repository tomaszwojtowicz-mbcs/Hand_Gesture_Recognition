function [ binaryMask ] = ApplyMorphologicalOperations( binaryMask, settings )

    %ApplyMorphologicalOperations Applies user morphological operations to the binary masks
    % 
    %
    % Apply morphological operations to improve the binary masks

    % Apply erosion and dilation
    if settings.applyErosion
        binaryMask = imerode( binaryMask, ...
                              strel( 'diamond', round( settings.erosionStrelSize * ...
                                                       settings.resizeRatio )));
        
    end % end if

    if settings.applyDilation
         binaryMask = imdilate( binaryMask, ...
                                strel( 'diamond', round( settings.dilationStrelSize * ...
                                                         settings.resizeRatio )));
         
    end % end if
end % end function