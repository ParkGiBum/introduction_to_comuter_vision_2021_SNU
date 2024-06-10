
a1=double(imread("afghan_clean.png"));
a3=double(imread("afghan_noise1.png"));
a5=double(imread("afghan_noise2.png"));

a1_gray = (a1(:,:,1)/3 + a1(:,:,2)/3 + a1(:,:,3)/3);
a3_gray = (a3(:,:,1)/3 + a3(:,:,2)/3 + a3(:,:,3)/3);
a5_gray = (a5(:,:,1)/3 + a5(:,:,2)/3 + a5(:,:,3)/3);
a3_R = (a3(:,:,1)); %guide??
a3_G = (a3(:,:,2));
a3_B = (a3(:,:,3));
a5_R = (a5(:,:,1)); %guide??
a5_G = (a5(:,:,2));
a5_B = (a5(:,:,3));
radius =1;
sigma = 0.7;
tic
[out,best]=fining_best_lambda(a3_gray,a3_gray,a1_gray,sigma,radius,30);
toc
disp(out);
disp(best);

%noise2

%1,0.5 30.7339 at 23000 keep goes up but damage too much
%2,0.5 30.8898 at 16000

%1,1 30.97 at 6700
%2,1 31.2 at 4300
%3,1 31.2 at 4050

%1,2 31.0175 at 5700
%2,2 31.0856 at 3100
%4,2 30.8898 at 2600


%noise1
%10,4=>328.65 33.65
%3,4=>350,24.1382

%5,1=>523 35.0.793
%3,1=>525 35.0814
%2,1=>510 35.123
%1,1=>668 33.2283

%1,0.5=>821 35.0310
%2,0.5=>756 35.0836
%3,0.5 =>759 35.084
%10,0.5 =>same