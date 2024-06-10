function imgout = stitch(im1,im2,t,p,s)
    %figure
    imshow((b2));
    I1 = single(b1) ;
    I2 = single(b2) ;
    
 
    [fa,da] = vl_sift(I1,'PeakThresh', 0);
    [fb,db] = vl_sift(I2,'PeakThresh', 0);
 
    [matches,scores] = vl_ubcmatch(da,db,3);
 
    [drop,perm] = sort(scores,'descend');
    matches = matches(:,perm);
    scores = scores(perm);
 
    
 
    figure(1);clf;
    imshow(cat(2,b1,b2));
 
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
    best_inliers = [];
 
    while N>iter
        random_4_example = randperm(n_of_sift,4);
 
        p1 = [xa(random_4_example(1)),ya(random_4_example(1)),xb(random_4_example(1)),yb(random_4_example(1)) ];
        p2 = [xa(random_4_example(2)),ya(random_4_example(2)),xb(random_4_example(2)),yb(random_4_example(2)) ];
        p3 = [xa(random_4_example(3)),ya(random_4_example(3)),xb(random_4_example(3)),yb(random_4_example(3)) ];
        p4 = [xa(random_4_example(4)),ya(random_4_example(4)),xb(random_4_example(4)),yb(random_4_example(4)) ];
        points = [p1;p2;p3;p4];
 
        H = dlt(points);
        counter = 0;
 
        for k = 1:n_of_sift
            p1 = [xa(k),ya(k)];
            p2 = [xb(k),yb(k)];
            if inliner(p1,p2,H,t)
                counter = counter + 1;
            end
        end
 
        if counter>counter_best
 
            counter_best = counter;
            H_best = H;
 
        end
 
        e = double(1 - (double(counter)/double(n_of_sift)));
        N = uint8(log(1 - p)/(log(1 - (1 - e )^s)));
        iter = iter + 1;
 
 
    end
 
    %figure
    %K = maketform('projective',(H)');
    K = projective2d(H');
    %l = imtransform(b1,K);
    l = imwarp(b1,K);
    %imshow(l);
 
 
 
    % do the mosaic
    pt = zeros(3,4);
    pt(:,1) = H*[1;1;1];
    pt(:,2) = H*[256;1;1];
    pt(:,3) = H*[256;256;1];
    pt(:,4) = H*[1;256;1];
    x2 = pt(1,:)./pt(3,:);
    y2 = pt(2,:)./pt(3,:);
 
 
 
    up = round(min(y2));
    Yoffset = 0;
    if up <= 0
        Yoffset = -up+1;
        up = 1;
    end
 
    left = round(min(x2));
    Xoffset = 0;
    if left<=0
        Xoffset = -left+1;
        left = 1;
    end
 
    [M3, N3, ~] = size(l);
    %imgout(Yoffset+1:Yoffset+M3,Xoffset+1:Xoffset+N3) = l;
    imgout(up+1:up+M3,left+1:left+N3) = l;
    %figure
    %imshow(imgout);
 
    imgout(Yoffset+1:Yoffset+256,Xoffset+256+1:Xoffset+256+256) = I2;
    figure
    %imshow(imgout);
   
end
