function H = dlt(points)

    n_of_points = size(points,1);
    A = [];
    for n = 1:n_of_points
        x = points(n,1);
        y = points(n,2);
        x_d = points(n,3);
        y_d = points(n,4);
        zeroT = [0,0,0];
        X = [x;y;1];
        Atemp =  [zeroT, transpose(X)  ,-transpose(X)*y_d  ; transpose(X) , zeroT, -x_d*transpose(X)];
        A = [A;Atemp];
    end
    [U,S,V] = svd(A);
    h = V(:,end);
    B = transpose([h(1:3),h(4:6),h(7:9)]);
    
    H = B ;
end