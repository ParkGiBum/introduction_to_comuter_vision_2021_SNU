function H1 = getH(im1,im2,t,p,s,i,threshold)
 
    
    [a1, b1] = size(im1);
    [a2, b2] = size(im2);
 
    %figure
    I1 =im1 ;
    I2 =im2 ;
    
 
    [fa,da] = vl_sift(I1,'PeakThresh', 0);
    [fb,db] = vl_sift(I2,'PeakThresh', 0);
    
    
   
    
    [matches,scores] = vl_ubcmatch(da,db,threshold);
 
    [drop,perm] = sort(scores,'descend');
    matches = matches(:,perm);
    scores = scores(perm);
 
    
 
    figure(i);clf;
    imshow(uint8(cat(2,I1,I2)));
 
    xa = fa(1,matches(1,:));
    ya = fa(2,matches(1,:));
 
    xb = fb(1,matches(2,:)) + size(I1,2) ;
    yb = fb(2,matches(2,:));
 
    hold on;
    h = line([xa;xb],[ya;yb]);
    set(h,'linewidth',1,'color','b');
 
    vl_plotframe(fa(:,matches(1,:)));
    fb(1,:) = fb(1,:) + size(I1,2);
    vl_plotframe(fb(:,matches(2,:)));
 
    N = inf;
    iter = 0;
    n_of_sift = uint8(size(xa));
    n_of_sift = n_of_sift(2);
 
    H_best = [];
    counter_best = 0;
    
    while N>iter
        distance_total = 0;
        distance_total_revised = 0;
        distance_inlier_only = 0;
        distance_inlier_only_revised = 0;
        
        random_4_example = randperm(n_of_sift,4);
        
        p1 = [xa(random_4_example(1)),ya(random_4_example(1)),xb(random_4_example(1)),yb(random_4_example(1)) ];
        p2 = [xa(random_4_example(2)),ya(random_4_example(2)),xb(random_4_example(2)),yb(random_4_example(2)) ];
        p3 = [xa(random_4_example(3)),ya(random_4_example(3)),xb(random_4_example(3)),yb(random_4_example(3)) ];
        p4 = [xa(random_4_example(4)),ya(random_4_example(4)),xb(random_4_example(4)),yb(random_4_example(4)) ];
        points = [p1;p2;p3;p4];
 
        H = dlt(points);
        counter = 0; 
        inlier = [];
        
        for k = 1:n_of_sift
            p1 = [xa(k),ya(k)];
            p2 = [xb(k),yb(k)];
            [isitinline, distance ]  =inliner(p1,p2,H,t);
            distance_total = distance_total + distance;
            if isitinline
                distance_inlier_only = distance_inlier_only + distance;
                counter = counter + 1;
                inlier = [p1,p2;inlier];
            end
        end
        %extra##########
        H_temp = zeros(3,3);
        H_revised = ones(3,3);
        cot = 0;
        while norm(H_temp(1) - H_revised(1))+norm(H_temp(2) - H_revised(2))+norm(H_temp(3) - H_revised(3))>0.0001 && cot < 2000
            distance_total_revised = 0;
            distance_inlier_only_revised = 0;
            inlier_temp = [];
            H_temp = H_revised;
            try
                H_revised = dlt(inlier);
            end
            
            cot = cot + 1;
            
            counter_revised = 0;
            for k = 1:n_of_sift
                p1 = [xa(k),ya(k)];
                p2 = [xb(k),yb(k)];
                [isitinline_reivesed ,distance_revised] = inliner(p1,p2,H_revised,t);
                distance_total_revised = distance_total_revised + distance_revised;
                if isitinline_reivesed
                    distance_inlier_only_revised = distance_inlier_only_revised + distance_revised;
                    inlier_temp = [p1,p2;inlier_temp];
                    counter_revised = counter_revised + 1;
                end
            end
            inlier = inlier_temp;
            
        end
        
        if counter>counter_best
            average_non_revised_inlier_only = distance_inlier_only/counter;
            average_non_revised = double(distance_total)/double(n_of_sift);
            n_of = counter;
        end
        
        if counter_revised>counter_best
            average_revised_inlier_only = distance_inlier_only_revised/counter_revised;
            counter_best = counter_revised;
            average_revised = double(distance_total_revised)/double(n_of_sift);
            H_best = H_revised;
            n_of_revised = counter_best;
        end
        
        
        %extra_end###########
        
        
        e = double(1 - (double(counter)/double(n_of_sift)));
        N = uint8(log(1 - p)/(log(1 - (1 - e )^s)));
        iter = iter + 1;
 
 
    end
    n_of
    n_of_revised
    average_non_revised
    average_non_revised_inlier_only
    average_revised
    average_revised_inlier_only 
    H1 = H_best;
end