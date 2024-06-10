function out=weighted_guided_filter_colored(input,guide,sigma,lambda,radius)
    %almost same as pdf guideline
    %only modification is in handling multi channel inptut
    %as guideline suggest I only used single channel guided image
    
    input_r = input(:,:,1);
    input_g = input(:,:,2);
    input_b = input(:,:,3);

   
    
    %step1
    mean_I = f_mean(guide,radius,sigma); %same as singlechannel
    
    mean_p_r = f_mean(input_r,radius,sigma);
    mean_p_g = f_mean(input_g,radius,sigma);
    mean_p_b = f_mean(input_b,radius,sigma);
    
    corr_I = f_mean(guide.* guide,radius,sigma); %same as singlechannel
    
    corr_Ip_r = f_mean(guide.* input_r,radius,sigma);
    corr_Ip_g = f_mean(guide.* input_g,radius,sigma);
    corr_Ip_b = f_mean(guide.* input_b,radius,sigma);
    %
    
    %step2
    %rel_BG = f_mean((guide3-guide2).* (guid3-guide2),smooth);
    
    var_I = corr_I - mean_I.* mean_I;
    
    cov_Ipr = corr_Ip_r - mean_I.* mean_p_r;
    cov_Ipg = corr_Ip_g - mean_I.* mean_p_g;
    cov_Ipb = corr_Ip_b - mean_I.* mean_p_b;
    
    a_r = cov_Ipr./(var_I + lambda );
    a_g = cov_Ipg./(var_I + lambda );
    a_b = cov_Ipb./(var_I + lambda );
    
    
    b_r = mean_p_r - a_r.* mean_I;
    b_g = mean_p_g - a_g.* mean_I;
    b_b = mean_p_b - a_b.* mean_I;
    
    mean_a_r = f_mean(a_r,radius,sigma);
    mean_a_g = f_mean(a_g,radius,sigma);
    mean_a_b = f_mean(a_b,radius,sigma);
    
    mean_b_r = f_mean(b_r,radius,sigma);
    mean_b_g = f_mean(b_g,radius,sigma);
    mean_b_b = f_mean(b_b,radius,sigma);
    
    [m,n] = size(mean_a_r);
    
    mean_a = ones(m,n,3);
    mean_a(:,:,1) = mean_a_r;
    mean_a(:,:,2) = mean_a_g;
    mean_a(:,:,3) = mean_a_b;
    
    mean_b = ones(m,n,3);
    mean_b(:,:,1) = mean_b_r;
    mean_b(:,:,2) = mean_b_g;
    mean_b(:,:,3) = mean_b_b;
    
    out2 = mean_a.*guide + mean_b;
    
    out = out2;
end
