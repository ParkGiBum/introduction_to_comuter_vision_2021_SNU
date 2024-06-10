clear
run('VLFEATROOT/toolbox/vl_setup') 

a1=(imread("im1.jpeg"));
a2=(imread("im2.jpeg"));
a3=(imread("im3.jpeg"));

b1 = rgb2gray(imresize(a1,[256 256]));
b2 = rgb2gray(imresize(a2,[256 256]));
b3 = rgb2gray(imresize(a3,[256 256]));

%I1 = single(imnoise(b1,'gaussian',0.0000000001));
%I2 = single(imnoise(b2,'gaussian',0.0000000001));
I1 = single(b1);
I2 = single(b2);
%I3 = single(b3);

%I1 = single(imsharpen(b1,'Amount',2));
%I2 = single(imsharpen(b2,'Amount',2));
%I3 = single(imsharpen(b3,'Amount',2));


imshow(b2);
[f,d] = vl_sift(I1) ;
perm = randperm(size(f,2)) ;
sel = perm(1:150) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

%figure
%H = getH(I1,I2,1.25,0.99,4,2,2);