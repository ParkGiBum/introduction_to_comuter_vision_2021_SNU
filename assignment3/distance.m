function d = distance(points1,points2,H)
    %H_inv = inv(H);
    points1 = [points1,1];
    points2 = [points2,1];
    points1_H = H*transpose(points1);
    points2_H = H\transpose(points2);
    
    points1_H = points1_H/points1_H(3);
    points2_H = points2_H/points2_H(3);
    
    d1 = (points1(1) - points2_H(1))^2 + (points1(2) - points2_H(2))^2;
    d2 = (points1_H(1) - points2(1))^2 + (points1_H(2) - points2(2))^2;
    
    d = d1 + d2;
    
end