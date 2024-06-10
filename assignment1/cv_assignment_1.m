

%1
%------------------------------------------------------------------------
a1=imread("img1.jpg");
a2=imread("img2.jpg");
figure;
subplot(1,2,1),imshow(a1);
subplot(1,2,2),imshow(a2);

a2 = imresize(a2, size(a1));
%resize image to match the size
b1=fft2(a1);
b2=fft2(a2);
figure;
subplot(2,2,1),imshow(mat2gray(log(abs(fftshift(b1)))));
subplot(2,2,2),imshow(mat2gray(log(abs(fftshift(b2)))));
subplot(2,2,3),imshow(mat2gray((angle(fftshift(b1)))));
subplot(2,2,4),imshow(mat2gray((angle(fftshift(b2)))));
%shift to move to center + log scale for more interpretable image


c2 = (abs(b1)) .* (cos(angle(b2)) + 1i * sin(angle(b2))); 
c1 = (abs(b2)) .* (cos(angle(b1)) + 1i * sin(angle(b1))); 
%No shift for image restoration

d1 = abs(ifft2(c1));
d2 = abs(ifft2(c2));

figure;
subplot(1,2,1),imshow(mat2gray(d1));
subplot(1,2,2),imshow(mat2gray(d2));
%------------------------------------------------------------------------


%2
%------------------------------------------------------------------------

filter_1 = [1.6322 , 0 ,0 ;0.2120, 1.6336, 0.0013 ;-101.9757, -0.6322 , 1];
filter_2 = [1.4219 , 0.3183 ,0.0013 ;0, 1.4206, 0 ;-0.4206, -101.8704 , 1];
filter_3 = [0.7033, -0.2339, -0.0009 ;0, 0.9991, 0 ;0.2958, 0.2239 , 1];
filter_4 = [1.1044 , -0.3493 ,0.0003 ;0.0011, 1.5066, 0.0011 ;-0.1041, -0.560 , 1];
%filter for perspective

[x1,y1,mx1,my1]= ssgcale(filter_1,375,512);
[x2,y2,mx2,my2]= ssgcale(filter_2,375,512);
[x3,y3,mx3,my3]= ssgcale(filter_3,375,500);
[x4,y4,mx4,my4]= ssgcale(filter_4,375,512);

fromscratch_1 = zeros(x1,y1,'uint8');
fromscratch_2 = zeros(x2,y2,'uint8');
fromscratch_3 = zeros(x3,y3,'uint8');
fromscratch_4 = zeros(y4,x4,'uint8');

for i =1:375
    for j = 1:500
        a = transpose(filter_1)*transpose([j,i,1]);
        u = round(a(1)/a(3));
        v = round(a(2)/a(3));
        fromscratch_1( v + 1 - my1,u + 1 - mx1 ) = a1(i,j);
    end
end

for i =1:375
    for j = 1:500
        a = transpose(filter_2)*transpose([j,i,1]);
        u = round(a(1)/a(3));
        v = round(a(2)/a(3));
        fromscratch_2( v + 1 - my2,u + 1 - mx2 ) = a1(i,j);
    end
end

for i =1:375
    for j = 1:500
        a = transpose(filter_3)*transpose([j,i,1]);
        u = round(a(1)/a(3));
        v = round(a(2)/a(3));
        fromscratch_3( v + 1 - my3,u + 1 - mx3 ) = a1(i,j);
    end
end

for i =1:375
    for j = 1:500
        a = transpose(filter_4)*transpose([j,i,1]);
        u = round(a(1)/a(3));
        v = round(a(2)/a(3));
        fromscratch_4( v + 1 - my4,u + 1 - mx4 ) = a1(i,j);
    end
end

f1 = simple_interpolation(fromscratch_1);
f2 = simple_interpolation(fromscratch_2);
f3 = simple_interpolation(fromscratch_3);
f4 = simple_interpolation(fromscratch_4);


imwrite(f1,"projected1.jpg");
imwrite(f2,"projected2.jpg");
imwrite(f3,"projected3.jpg");
imwrite(f4,"projected4.jpg");

%------------------------------------------------------------------------



%3
%------------------------------------------------------------------------
A_before = [ 880 214 312.747 309.140 30.086;
43 203 305.796 311.649 30.356;
270 197 307.694 312.358 30.418;
886 347 310.149 307.186 29.298;
745 302 311.937 310.105 29.216;
943 128 311.202 307.572 30.682;
476 590 307.106 306.876 28.660;
419 214 309.317 312.490 30.230;
317 335 307.435 310.151 29.318;
783 521 308.253 306.300 28.881;
235 427 306.650 309.301 28.905;
665 429 308.069 306.831 29.189;
655 362 309.671 308.834 29.029;
427 333 308.255 309.955 29.267;
412 415 307.546 308.613 28.963;
746 351 311.036 309.206 28.913;
434 415 307.518 308.175 29.069;
525 234 309.950 311.262 29.990;
716 308 312.160 310.772 29.080;
602 187 311.988 312.709 30.514 ];


%B calculating with SVD
A = [];
b = [];
for i = 1:20
    u = A_before(i,1);
    v = A_before(i,2);
    x = A_before(i,3);
    y = A_before(i,4);
    z = A_before(i,5);
    
    tmp1 = [x,y,z,1,0,0,0,0,-u*x,-u*y,-u*z,-u ];
    tmp2 = [0,0,0,0,x,y,z,1,-v*x,-v*y,-v*z,-v ];
    A = [A;tmp1;tmp2];
end

[U, S, V] = svd(A);
M = V(:,end);
M = reshape(M,[],3)';


%With pseudo inverse method (use \ for accuaracy)
A = [];
for i = 1:20
    u = A_before(i,1);
    v = A_before(i,2);
    x = A_before(i,3);
    y = A_before(i,4);
    z = A_before(i,5);
    
    tmp1 = [x,y,z,1,0,0,0,0,-u*x,-u*y,-u*z ];
    tmp2 = [0,0,0,0,x,y,z,1,-v*x,-v*y,-v*z ];
    A = [A;tmp1;tmp2];
    b = [b;u;v];
end
M2 = A\b;
M2 = [M2;1];
M2 = reshape(M2,[],3)';
%k = norm(M2);
%M2 = M2/k;

%same as above but use inv instead of \
A = [];
b = [];
for i = 1:20
    u = A_before(i,1);
    v = A_before(i,2);
    x = A_before(i,3);
    y = A_before(i,4);
    z = A_before(i,5);
    
    tmp1 = [x,y,z,1,0,0,0,0,-u*x,-u*y,-u*z ];
    tmp2 = [0,0,0,0,x,y,z,1,-v*x,-v*y,-v*z ];
    A = [A;tmp1;tmp2];
    b = [b;u;v];
end
M3 = inv(transpose(A)*A)*(transpose(A))*b;
M3 = [M3;1];
M3 = reshape(M3,[],3)';
k = norm(M3);
M3 = M3/k;


% find out how small ||Ap|| are
k=0;
k2=0;
for i = 1:20
   u = A_before(i,1);
   v = A_before(i,2);
   x = A_before(i,3);
   y = A_before(i,4);
   z = A_before(i,5); 
   kt = x*M(1,1) + y*M(1,2) + z*M(1,3) +M(1,4) - M(3,1)*u*x - M(3,2)*u*y - M(3,3)*u*z - M(3,4)*u;
   kt2 = x*M(2,1) + y*M(2,2) + z*M(2,3) +M(2,4) - M(3,1)*v*x - M(3,2)*v*y - M(3,3)*v*z - M(3,4)*v;
   k = max(k,kt);
   k2 = max(k2,kt2);


end
%------------------------------------------------------------------------

