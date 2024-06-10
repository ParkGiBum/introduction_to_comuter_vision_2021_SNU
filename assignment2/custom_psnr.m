function out=custom_psnr(original,noisy)
    % works properly only when int16 type (or longer integer)
    [m , n] = size(original);
    MSE = ((original - noisy).*(original - noisy));
    MSE = sum(MSE,'all');
    
    MSE = MSE / (m*n);
    
    out = 20 * log10(255/sqrt(MSE));
    
    
end
