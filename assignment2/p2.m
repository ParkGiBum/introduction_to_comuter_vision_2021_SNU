 
a2=double(imread("monkey_clean.png"));
a4=double(imread("monkey_noise1.png"));
a6=double(imread("monkey_noise2.png"));
 
 
 
a2_gray = (a2(:,:,1)/3 + a2(:,:,2)/3 + a2(:,:,3)/3);
a4_gray = (a4(:,:,1)/3 + a4(:,:,2)/3 + a4(:,:,3)/3);
a6_gray = (a6(:,:,1)/3 + a6(:,:,2)/3 + a6(:,:,3)/3);
a4_R = (a4(:,:,1)); %guide??
a4_G = (a4(:,:,2));
a4_B = (a4(:,:,3));
a6_R = (a6(:,:,1)); %guide??
a6_G = (a6(:,:,2));
a6_B = (a6(:,:,3));
 
 
radius = 2;
var = 0.35;
mod = 1; % only used in bilateral filter
% mod 1 makes bilateral filter more accurate

 
 
%%%%%%%%%%
%block
radius = 1;
mode_box = 1;%for boxfilter
customfilter = ones(2*radius+1,2*radius+1);
%for boxfilter so when mode_box == 1 and custom filter given it us custom filter value as
%weight
%in this case it is set to default value
%if you want to change custom filter please give the filter matching size
%as 2*radius+1,2*radius+1

tic
testoutput = weighted_median_filter(a4_gray,var,radius,mode_box,customfilter);
toc
figure;
subplot(2,3,1),imshow(uint8(a2_gray)),title('original-gray');
subplot(2,3,2),imshow(uint8(a4_gray)),title('noise1-gray');
subplot(2,3,3),imshow(uint8(testoutput)),title('filtered-noise1');
 
 
peaksnr= custom_psnr( int16(a2_gray),int16(a4_gray));
peaksnr2 = custom_psnr( int16(a2_gray),int16(testoutput));
disp("original_a4");
disp(peaksnr);
disp("fitlered_gray_a4-box");
disp(peaksnr2);
testoutput2 = weighted_median_filter(a6_gray,var,radius,mode_box,customfilter);
 
%subplot(2,3,4),imshow(uint8(a2_gray));('original-gray');
subplot(2,3,5),imshow(uint8(a6_gray)),title('noise2-gray');
subplot(2,3,6),imshow(uint8(testoutput2)),title('filtered-noise2');
sgtitle('boxfilter best result')  
 
peaksnr= custom_psnr( int16(a2_gray),int16(a6_gray));
peaksnr2 = custom_psnr( int16(a2_gray),int16(testoutput2));
disp("fitlered_gray_a6-box");
disp(peaksnr2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 
 
%%%%%%%%%%
%gaussian
 
radius = 1;
var = 0.35;
tic
testoutput = weighted_median_gaussian_filter(a4_gray,var,radius,mod);
toc
 
figure;
subplot(2,3,1),imshow(uint8(a2_gray)),title('original-gray');
subplot(2,3,2),imshow(uint8(a4_gray)),title('noise1-gray');
subplot(2,3,3),imshow(uint8(testoutput)),title('filtered-noise1');
 
peaksnr2 = custom_psnr( int16(a2_gray),int16(testoutput));
disp("fitlered_gray_a4-gaussian");
disp(peaksnr2);
 
radius = 2;
var = 0.43;
 
testoutput2 = weighted_median_gaussian_filter(a6_gray,var,radius,mod);
 
%subplot(2,3,4),imshow(uint8(a2_gray));('original-gray');
subplot(2,3,5),imshow(uint8(a6_gray)),title('noise2-gray');
subplot(2,3,6),imshow(uint8(testoutput2)),title('filtered-noise2');
sgtitle('gaussian weighted filter best result')  
 
peaksnr2 = custom_psnr( int16(a2_gray),int16(testoutput2));
disp("fitlered_gray_a6-gaussian");
disp(peaksnr2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 
%%%%%%%%%%
%bilateral
radius = 1;
var = 0.35;
var2 =169;
tic
testoutput = weighted_median_bilateral_filter(a4_gray,var,var2,radius,mod);
toc
figure;
subplot(2,3,1),imshow(uint8(a2_gray)),title('original-gray');
subplot(2,3,2),imshow(uint8(a4_gray)),title('noise1-gray');
subplot(2,3,3),imshow(uint8(testoutput)),title('filtered-noise1');
 
 
peaksnr2 = custom_psnr( int16(a2_gray),int16(testoutput));
disp("fitlered_gray_a4-bilateral");
disp(peaksnr2);
 
testoutput2 = weighted_median_bilateral_filter(a6_gray,var,var2,radius,mod);
 
%subplot(2,3,4),imshow(uint8(a2_gray));('original-gray');
subplot(2,3,5),imshow(uint8(a6_gray)),title('noise2-gray');
subplot(2,3,6),imshow(uint8(testoutput2)),title('filtered-noise2');
sgtitle('bilateral weighted filter best result')  
 
 
peaksnr2 = custom_psnr( int16(a2_gray),int16(testoutput2));
disp("fitlered_gray_a6-bilateral");
disp(peaksnr2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 

