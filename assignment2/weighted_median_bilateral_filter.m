function out=weighted_median_bilateral_filter(input,sigma,sigma2,radius,mod)
    
    %get bilateral weighted mean
    %make histogram and scan histogram for searching median value
    %mode 1 makes replace image pixel when it is out of range of 2.5 std
    %deviation and swtich it to average value of neighbor

    sigma = sigma * 2;
    sigma2 = sigma2 *2;
    sizea = uint16(size(input));
    input = fix(input);
    out2 = zeros(sizea(1),sizea(2));
    
    Mean = 0;
    std = 0;
    if mod == 1
       Mean =  mean2(input);
       std = std2(input);
    end
    
    
    for x = 1:sizea(1)
        for y = 1:sizea(2)
            window = input(max(1,x-radius):min(sizea(1),x+radius),max(1,y-radius):min(sizea(2),y+radius));
            
            x0 = double(min(radius+1,x));
            y0 = double(min(radius+1,y));
            
            gsum = 0;
            
            size_window = size(window);
            coordi = [0:255];
            
            
            counter = 0;
            %making histogram
            hist = 0;
            
            origin = window(x0,y0);
            
            if mod == 1
                if origin >= Mean + 2.5*std -1 || origin <= Mean - 2.5*std +1
                    
                    origin = [];
                    if x0>1
                        origin(end+1) = window(x0-1,y0);
                    end
                    if y0>1
                        origin(end+1) = window(x0,y0-1);
                    end
                    if x0<size_window(1)
                        origin(end+1) = window(x0+1,y0);
                    end
                    if y0<size_window(2)
                        origin(end+1) =  window(x0,y0+1);
                    end
                    origin = mean(origin);
                end
                
            end
            
            
            for k = 1:size_window(1)
                for j = 1:size_window(2)
                   hist = hist + (0==(coordi - (window(k,j))))*exp(-(((x0 - k )^2 + (y0 - j)^2)/sigma) - ((origin - window(k,j))^2/sigma2));
                   gsum = gsum + exp(-(((x0 - k )^2 + (y0 - j)^2)/sigma) - ((origin - window(k,j))^2/sigma2));

                end
            end
            num = gsum/2;
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
    
    
    out = out2;
end
