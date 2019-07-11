% Source:
% http://www.johnloomis.org/ece564/notes/tform/planar/html/planar2.html
%
%% Produce orthonormal view from oblique projective image
% read original image
%
clear; close all
filename = 'floor640x480.jpg';
img = im2double(rgb2gray(imread(filename)));
name = 'check2';
msgid = 'Images:initSize:adjustingMag';
warning('off',msgid);
imshow(img);
%
%%
%
% input corners (using impixel) and compute transform
%[c r p] = impixel;
c = [ 320 639 639 320 ]';               % x
r = [ 60  1  479 390 ]';                % y
base = [0 0; 159 0; 159 239; 0 239];        % output dimentions
tf = fitgeotrans([c r],base,'projective');
disp('tf = ');
disp(tf)
%
%% 
%
T = tf.T;
disp('T =');
format short g
disp(T);
disp('After rounding and converting ');
T = round(T * 2^12) / 2^12
format
%
%% overlay control points on image
%
imshow(img);
hold on;
plot([c;c(1)],[r;r(1)],'r','Linewidth',2);
%text(c(1),r(1)+20,'0, 11','Color','y');
%text(c(2),r(2)+20,'11, 11','Color','y');
%text(c(3),r(3)-20,'11, 0','Color','y');
%text(c(4),r(4)-20,'0, 0','Color','y');
hold off;
F = getframe();
g = frame2im(F);
imwrite(g,[name '_overlay.jpg']);
%
%% do image transform
%
[xf1, xf1_ref] = imwarp(img,tf);
imshow(xf1)
xf1_ref
imwrite(xf1,[name '_registered.jpg']);

%% Crop image - added not in original code file 
%
% xf2 = imcrop(xf1,[476 118 240 240]);
% imshow(xf2)
% imwrite(xf2,[name '_croped.jpg']);

%% Print perspective trasform matrix values in hex
Thex = [];
for i=1:3
    for k=1:3
        a = sfi(T(i,k),25,12);
        Thex = [Thex; a.hex];
    end
end
Thex,

%% Calculatin w values
w=  [];
w_inv=  [];
table = [];
P=  [];
Pnew= [];
for x=320:639 
    for y=0:480
       P = [ x , y, 1] * T; 
       w = [w ; P(3)]; 
       w_inv = [w_inv; 1/P(3) ];
       table = [ table; P(3) , 1/P(3)  ];
       Pnew= [ Pnew ; floor(P(1)/P(3)), floor(P(2)/P(3)) ];
    end
end
w = unique(w);
w_inv = unique(w_inv);
min(w),
max(w),
min(w_inv),
max(w_inv),

%% % make fale for case statement in Verilog

w_dec = [];
%w_hex = [];
w_dec_inv = [];
temp = ['0000000000'];
temp_old = ['0000010000'];
for i=1:0.001:2.999
        w_dec = [ w_dec; ufi(i,10,8)];
        w_dec_inv = [ w_dec_inv; ufi(1/i,10,8)];
end
%w_hex = w_dec.hex;
w_bin = w_dec.bin;
w_bin_inv = w_dec_inv.bin;

fid = fopen('lookuptable.txt', 'wt');
    fprintf(fid, 'case (w)\n');

for i=1:length(w_bin) 
    temp_old = temp;
    temp = w_bin(i,1:10);
    if temp_old == temp
        
    else
        fprintf(fid, '\t10''b%s : r_w_inv <= 10''b%s;\n', w_bin(i,1:10), w_bin_inv(i,1:10) );
    end
end
    fprintf(fid, '\tdefault   : r_w_inv <= 10''b%s;\n ', w_bin(1,1:10) );
    fprintf(fid, 'endcase; ');
disp('Text files write done');disp(' ');
fclose(fid);
