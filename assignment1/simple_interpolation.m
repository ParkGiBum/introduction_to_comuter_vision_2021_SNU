function out=simple_interpolation(image)

    [x,y] = size(image);
    out = image;
    
    for i = 2:(x-1)
        for j = 2:(y-1)
            if image(i,j) == 0
                
                n = 0;
                s = 0;
                
                a = 1;
                b = 1;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = -1;
                b = 1;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = 1;
                b = -1;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = -1;
                b = -1;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = 0;
                b = 1;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = 0;
                b = -1;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = 1;
                b = 0;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                a = 1;
                b = 0;
                if image(i + a,j + b)>0
                    n = n + 1;
                    s = s + image(i + a,j + b)/8;
                end
                
                
                
                out(i,j) = s/n*8;
                
                
            end
            
        end
    end
    

end