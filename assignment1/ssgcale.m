function [x,y,minx,miny] = ssgcale(filter,sizex,sizey)

    scale_1 = transpose(filter)*transpose([sizey,sizex,1]);
    scale_2 = transpose(filter)*transpose([sizey,1,1]);
    scale_3 = transpose(filter)*transpose([1,sizex,1]);
    scale_4 = transpose(filter)*transpose([1,1,1]);
    
    s1 = [scale_1(1)/scale_1(3),scale_1(2)/scale_1(3)];
    s2 = [scale_2(1)/scale_2(3),scale_2(2)/scale_2(3)];
    s3 = [scale_3(1)/scale_3(3),scale_3(2)/scale_3(3)];
    s4 = [scale_4(1)/scale_4(3),scale_4(2)/scale_4(3)];
    
    x = round(max([s1(1),s2(1),s3(1),s4(1)]) - min([s1(1),s2(1),s3(1),s4(1)])) + 1;
    y = round(max([s1(2),s2(2),s3(2),s4(2)]) - min([s1(2),s2(2),s3(2),s4(2)])) + 1;
    
    minx = round(min([s1(1),s2(1),s3(1),s4(1)]));
    miny = round(min([s1(2),s2(2),s3(2),s4(2)]));
    
    
end
