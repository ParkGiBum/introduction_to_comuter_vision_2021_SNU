function [out,best_psnr]=fining_best_lambda(input,guide,answer,sigma,radius,range)
    lambda = 1;
    best = 0;
   
    for i = 1:10:range
        result = weighted_guided_filter2(input,guide,sigma,i,radius);
        psnr = custom_psnr(int16(answer),int16(result));
        disp(psnr);
        if psnr > best
            lambda = i;
            best = psnr;
            disp(best);
            disp(lambda);
        end
    end
    
    best_psnr = best;
    out = lambda;
    
end
