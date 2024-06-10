function out = f_mean(image,radius,sigma)

    %get gaussian mean of image
    %for loop in 2 layer takes too much time
    %So applying 1D two times help
    %(It works because gaussian(x0-r,y0-r)=gaussian(x0-r,y0)*gaussian(x0,y0-r))
    
    size_input = size(image);
    
    w = size_input(1);
    h = size_input(2);
    
    out2 = zeros(w,h);
    
    gFilter = zeros(2*radius + 1,1);
    for col = 1 : radius * 2 + 1
        gFilter(col) = exp(-((col-(radius + 1))^2)/(sigma*2));
    end
    for i = 1:w
        out2(i,:)=sum(gFilter(1 + max(0,radius - i + 1):radius + min(radius+1,w - i + 1 )).*image(max(1,i - radius):min(i+radius,w),:),1)/sum(gFilter(1 + max(0,radius - i + 1):radius + min(radius+1,w - i + 1 )));
    end
    gFilter = transpose(gFilter);
    image2 = out2;
    for i = 1:h
        out2(:,i)=sum(gFilter(1 + max(0,radius - i + 1):radius + min(radius+1,h - i + 1 )).*image2(:,max(1,i - radius):min(i+radius,h)),2)/sum(gFilter(1 + max(0,radius - i + 1):radius + min(radius+1,h - i + 1 )));
    end
    
    %2d convolution(takes too much time)
    %gFilter = zeros(2*radius + 1,2*radius + 1);
    %for col = 1 : w
    %  for row = 1 : h
    %    gFilter(col,row) = exp(-((col-(radius + 1))^2+(row-(radius + 1))^2)/(2*sigma));
    %  end
    %end
    %for i = 1:w
    %    for j = 1:h
    %        out2(i,j)=sum(gFilter(1 + max(0,radius - i + 1):radius + min(radius+1,w - i + 1 ),1 + max(0,radius - j + 1):radius + min(radius+1,h - j + 1 )).*image(max(1,i - radius):min(i+radius,w),max(1,j - radius):min(j+radius,h)),'all')/sum(gFilter(1 + max(0,radius - i + 1):radius + min(radius+1,w - i + 1 ),1 + max(0,radius - j + 1):radius + min(radius+1,h - j + 1 )),'all');
    %    end
    %end
    
    
    out = out2;

end