a1=double(imread("afghan_clean.png"));
a3=double(imread("afghan_noise1.png"));
a5=double(imread("afghan_noise2.png"));
 
sizea = size(a1);


a1_gray = (a1(:,:,1)/3 + a1(:,:,2)/3 + a1(:,:,3)/3);
a3_gray = (a3(:,:,1)/3 + a3(:,:,2)/3 + a3(:,:,3)/3);
a5_gray = (a5(:,:,1)/3 + a5(:,:,2)/3 + a5(:,:,3)/3);
a3_R = (a3(:,:,1)); %guide??
a3_G = (a3(:,:,2));
a3_B = (a3(:,:,3));
a5_R = (a5(:,:,1)); %guide??
a5_G = (a5(:,:,2));
a5_B = (a5(:,:,3));

%use weighted_guided_filter2.m,weighted_guided_filter_colored.m
%f_mean.m,custom_psnr.m

%%%%%%%%%% noise1

lambda = double(701);%my optimal value
radius = 1;
var = 1;

testoutput = weighted_guided_filter2(a3_gray,a3_gray,var,lambda,radius);
testoutput2 = weighted_guided_filter2(a3_gray,a3_R,var,lambda,radius);
testoutput_color = weighted_guided_filter_colored(a3,a3_R,var,lambda,radius);
figure;
subplot(1,3,1),imshow(uint8(testoutput)),title('gray as guide');
subplot(1,3,2),imshow(uint8(testoutput2)),title('red as guide');
subplot(1,3,3),imshow(uint8(testoutput-testoutput2).^16),title('subtract^4');
figure;

subplot(2,3,1),imshow(uint8(a1_gray)),title('original-gray');
subplot(2,3,2),imshow(uint8(a3_gray)),title('noise1-gray');
subplot(2,3,3),imshow(uint8(testoutput)),title('filtered-gray');

subplot(2,3,4),imshow(uint8(a1)),title('original-color');
subplot(2,3,5),imshow(uint8(a3)),title('noise1-color');
subplot(2,3,6),imshow(uint8(testoutput_color)),title('filtered-gray');
sgtitle('noise1 best result') 
peaksnr= custom_psnr( int16(a1_gray),int16(testoutput));
peaksnr2 = custom_psnr( int16(a1),int16(testoutput_color));
disp("noise1_gray");
disp(peaksnr);
disp("noise1_color");
disp(peaksnr2);


lambda = double(2600);%my optimal value
radius = 3;
var = 1;

testoutput = weighted_guided_filter2(a5_gray,a5_R,var,lambda,radius);
testoutput_color = weighted_guided_filter_colored(a5,a5_R,var,lambda,radius);

figure;
title('noise2 best result') 
subplot(2,3,1),imshow(uint8(a1_gray)),title('original-gray');
subplot(2,3,2),imshow(uint8(a5_gray)),title('noise2-gray');
subplot(2,3,3),imshow(uint8(testoutput)),title('filtered-gray');

subplot(2,3,4),imshow(uint8(a1)),title('original-color');
subplot(2,3,5),imshow(uint8(a5)),title('noise2-color');
subplot(2,3,6),imshow(uint8(testoutput_color)),title('filtered-gray');
sgtitle('noise2 best result') 
peaksnr= custom_psnr( int16(a1_gray),int16(testoutput));
peaksnr2 = custom_psnr( int16(a1),int16(testoutput_color));
disp("noise2_gray");
disp(peaksnr);
disp("noise2_color");
disp(peaksnr2);





