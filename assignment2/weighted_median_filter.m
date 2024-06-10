function out=weighted_median_filter(input,sigma,radius,mod,customfilter)
    
    
    %get box weighted mean
    %but since box blur filtet means it gets same weights for whole
    %it is same as normal median filter
    %when mode = 1 it use custom filter
    if mod == 0
        sizea = uint16(size(input));
        customfilter = zeros(radius * 2 + 1,radius * 2 + 1);
        input = fix(input);
        x0 = radius + 1; 
        y0 = radius + 1; 

        out2 = zeros(sizea(1),sizea(2));

        for col = 1 : radius * 2 + 1
          for row = 1 : radius * 2 + 1
            customfilter(col,row) = exp(-((col-x0)^2+(row-y0)^2)/sigma);
          end
        end

        for x = 1:sizea(1)
            for y = 1:sizea(2)
                window = input(max(1,x-radius):min(sizea(1),x+radius),max(1,y-radius):min(sizea(2),y+radius));
                size_window = size(window);
                coordi = [0:255];

                num = (size_window(1)*size_window(2));
                even = 1;

                if rem(num,2) == 0
                    num = num /2;
                else
                    even = 0;
                    num = num/2;
                end

                counter = 0;
                %making histogram
                hist = 0;
                for k = 1:size_window(1)
                    for j = 1:size_window(2)
                        hist = hist + (0==(coordi - (window(k,j))));
                    end
                end
                %getting median value
                for n = 1:255
                    if hist(n) ~= 0
                        counter = counter + hist(n);
                        if counter >= num
                            if even == 1 && hist(n) == 1
                                out2(x,y) = (n-1)/2;
                                counter = num-1;
                                even = 0;
                            else
                                if out2(x,y) ==0   
                                    out2(x,y) = (n-1);
                                    break;
                                else            
                                    out2(x,y) = out2(x,y) +  (n-1)/2;
                                    break;
                                end
                            end
                        end
                    end
                end

            %disp(out2(x,y));  
            end
        end
        out = out2;
    end 
    %when custom box filters are given
    if mod == 1
        sizea = uint16(size(input));
        input = fix(input);
        x0 = radius + 1; 
        y0 = radius + 1; 

        out2 = zeros(sizea(1),sizea(2));

        

        if mod == 1
           mean =  mean2(input);
           std = std2(input);
        end


        for x = 1:sizea(1)
            for y = 1:sizea(2)
                window = input(max(1,x-radius):min(sizea(1),x+radius),max(1,y-radius):min(sizea(2),y+radius));

                x_left =1 +  radius - x ;
                x_right =  x+radius - min(sizea(1),x+radius);
                y_left =1 + radius - y ;
                y_right =  y+radius - min(sizea(1),y+radius);
                x0 = double(min(radius+1,x));
                y0 = double(min(radius+1,y));



                customfilter_edge = customfilter(1 + x_left : 2*radius + 1 - x_right, 1 + y_left: 2*radius + 1 - y_right);
                gsum = sum(customfilter_edge,'all');

                size_window = size(window);
                coordi = [0:255];


                num = gsum/2;
                counter = 0;
                %making histogram
                hist = 0;
                for k = 1:size_window(1)
                    for j = 1:size_window(2)
                        if mod ==1
                            if window(k,j) >= mean + 2.5*std -1 || window(k,j) <= mean - 2.5*std +1
                                %origins = window(k,j);
                                gsum = gsum - customfilter_edge(k,j);
                            else
                                hist = hist + (0==(coordi - (window(k,j))))*customfilter_edge(k,j);
                            end

                        else
                            hist = hist + (0==(coordi - (window(k,j))))*customfilter_edge(k,j);
                        end

                    end
                end
                %getting median value
                for n = 1:255
                    if hist(n) ~= 0
                        counter = counter + hist(n);
                        if counter >= num
                            out2(x,y) = (n-1);
                            break;
                        end
                    end
                end

            end
        end
    end
    
    
    out = out2;
end
