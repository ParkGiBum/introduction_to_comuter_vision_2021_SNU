clear
run('VLFEATROOT/toolbox/vl_setup') 
a1=(imread("im1.jpeg"));
a2=(imread("im2.jpeg"));
a3=(imread("im3.jpeg"));
warning('off','all');
b1 = rgb2gray(imresize(a1,[256 256]));
b2 = rgb2gray(imresize(a2,[256 256]));
b3 = rgb2gray(imresize(a3,[256 256]));

%I1 = single(imnoise(b1,'salt & pepper',0.01));
%I2 = single(imnoise(b2,'salt & pepper',0.01));
%I3 = single(imnoise(b3,'salt & pepper',0.01));

%I1 = single(imgaussfilt(b1,3));
%I2 = single(imgaussfilt(b2,3));
%I3 = single(imgaussfilt(b3,3));

%I1 = single(imsharpen(b1,'Amount',2));
%I2 = single(imsharpen(b2,'Amount',2));
%I3 = single(imsharpen(b3,'Amount',2));

I1 = single(b1);
I2 = single(b2);
I3 = single(b3);

I1_color = single(imresize(a1,[256 256]));
I2_color = single(imresize(a2,[256 256]));
I3_color = single(imresize(a3,[256 256]));


threshold = 2;
figure
%I = imnoise(I1,'gaussian');

H = getH(I1,I2,1.25,0.99,4,1,threshold);
figure
H2 = getH(I3,I2,1.25,0.99,4,2,threshold);


imgout(:,:,1) = stitch(H,H2,I1_color(:,:,1),I2_color(:,:,1),I3_color(:,:,1));
imgout(:,:,2) = stitch(H,H2,I1_color(:,:,2),I2_color(:,:,2),I3_color(:,:,2));
imgout(:,:,3) = stitch(H,H2,I1_color(:,:,3),I2_color(:,:,3),I3_color(:,:,3));
figure
imshow(uint8(imgout));

imwrite(uint8(imgout),"panorama.jpeg");
