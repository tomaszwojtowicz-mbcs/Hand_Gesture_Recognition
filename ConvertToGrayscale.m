function [ grayscaleImage ] = ConvertToGrayscale( rgbImage, grayscaleConversionMethod )

    %ConvertToGrayscale Converts RGB matrix to grayscale
    %   This function converts an RGB image into grayscale image using user
    %   selected conversion method
    
    % Initialise grayscale matrix
    grayscaleImage = zeros( size( rgbImage ));

    switch grayscaleConversionMethod
        
        case 'Luminance'
            % using built in conversion based on Luminance, using ITU-R
            % BT.601-7
            % recommended values (NTSC colour space)
            % intensity = 0.2989 * R + 0.5870 * G + 0.1140 * B 
            grayscaleImage = rgb2gray( rgbImage );

        case 'Luminosity'
            % luminosity conversion using ITU-R BT.709-6 recommended values
            % intensity = 0.2126 * R + 0.7152 * G + 0.0722 * B 
            grayscaleImage = 0.2126 * rgbImage( :, :, 1 ) + ...
                             0.7152 * rgbImage( :, :, 2 ) + ...
                             0.0722 * rgbImage( :, :, 3 );

        case 'Luster'
            % Luster conversion
            grayscaleImage =  ( max( rgbImage, [] ,3 ) + min( rgbImage, [] ,3 )) / 2 ;

        case 'intensity'
            % Intensity conversion
            grayscaleImage = ( rgbImage( :, :, 1 ) + ...
                               rgbImage( :, :, 2 ) + ...
                               rgbImage( :, :, 3 )) / 3 ;
            
    end % end switch
end % end function
