function out=weighted_guided_filter2(input,guide,sigma,lambda,radius)
    
    %almost same as pdf guideline
    %only modification is in f_mean which get gaussian mean instead
    %as guideline suggest I only used single channel guided image
    

    mean_I = f_mean(guide,radius,sigma);
    mean_p = f_mean(input,radius,sigma);
    corr_I = f_mean(guide.* guide,radius,sigma);
    corr_Ip = f_mean(guide.* input,radius,sigma);
    
    var_I = corr_I - mean_I.* mean_I;
    cov_Ip = corr_Ip - mean_I.* mean_p;
    
    a = cov_Ip./(var_I + lambda );
    b = mean_p - a.* mean_I;
    
    mean_a = f_mean(a,radius,sigma);
    mean_b = f_mean(b,radius,sigma);
    out2 = mean_a.*guide + mean_b;
    
    out = out2;
end
