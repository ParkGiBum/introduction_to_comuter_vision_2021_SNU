function imgout = stitch(H,H2,im1,im2,il_x)
 
 
    [a1, b1] = size(im1);
    [a2, b2] = size(im2);
    [a3, b3] = size(il_x);
 
    I1 =im1 ;
    I2 =im2 ;
    I3 =il_x ;
    
    K = maketform('projective',(H)');
    %K = projective2d(H');
    l = imtransform(I1,K);
    %l = imwarp(I1,K);
    
    K2 = maketform('projective',(H2)');
    %K = projective2d(H');
    l2 = imtransform(I3,K2);
    %l = imwarp(I1,K);
 
    pt = zeros(3,4);
    pt(:,1) = H*[1;1;1];
    pt(:,2) = H*[a1;1;1];
    pt(:,3) = H*[a1;b1;1];
    pt(:,4) = H*[1;a1;1];
    x2 = pt(1,:)./pt(3,:);
    y2 = pt(2,:)./pt(3,:); 
    
    pt2 = zeros(3,4);
    pt2(:,1) = H2*[1;1;1];
    pt2(:,2) = H2*[a1;1;1];
    pt2(:,3) = H2*[a1;b1;1];
    pt2(:,4) = H2*[1;a1;1];
    x3 = pt2(1,:)./pt2(3,:);
    y3 = pt2(2,:)./pt2(3,:);
 
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
 
    up2 = round(min(y3));
    Yoffset2 = 0;
    if up2 <= 0
        Yoffset2 = -up2+1;
        up2 = 1;
    end
 
    left2 = round(min(x3));
    Xoffset2 = 0;
    if left2<=0
        Xoffset2 = -left2+1;
        left2 = 1;
    end 
    
    
    [l_x, l_y, ~] = size(l);
    [l2_x, l2_y, ~] = size(l2);
    %imgout(Yoffset+1:Yoffset+l_x,Xoffset+1:Xoffset+l_y) = l;
    imgout(Yoffset2+1:Yoffset2+l_x,Xoffset2+left+1:Xoffset2+left+l_y) = l;
    imgout(Yoffset+1 :Yoffset+l2_x,Xoffset+1+left2:Xoffset+l2_y+left2) = l2;
    imgout(Yoffset+Yoffset2+1:Yoffset+Yoffset2+a2,Xoffset+Xoffset2+1+b1:Xoffset+Xoffset2+b2+b1) = I2;
    
    
    
    
    %figure
    %imshow(imgout);
   
end

