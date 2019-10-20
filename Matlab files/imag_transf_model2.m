%% FPGA image trasform module
%   Configuretion script generator
%
% Coordinates for perspective transform matrix
%           640x480
% -------------------------------
% |                      P2     |
% |       P1                    |
% |                             |
% |                             |
% |                             |
% |      P4                     |
% |                      P3     |
% -------------------------------
%   Px = (x , y );
% 
% %Pre fefined output image size
% width = 320;        % for output image
% higth = 240;
% %Generate settings for:
% camera = 1;         % camera 0 or 1
% mode = 0;            % from 0 to 3, but 0 is reserved for 
%
% P1 = [ 0 , 0 ];
% P2 = [ 639 , 0 ];
% P3 = [ 639 , 479 ];
% P4 = [ 0 , 479 ];

% Or use popup menu
prompt = {'Enter output image width(0-320):','Enter output image higth(0-240):','Enter camera No.(0-1):','Enter mode No.(0-3):'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'320','240','0','1' };
answer = inputdlg(prompt,dlgtitle,dims,definput);
width = str2num(answer{1});
    width = min(width, 320);
    width = max(width, 1);
higth = str2num(answer{2});
    higth = min(higth, 240);
    higth = max(higth, 1);
camera = str2num(answer{3});
    camera = min(camera, 1);
    camera = max(camera, 0);
mode = str2num(answer{4});
    mode = min(mode, 3);
    mode = max(mode, 0);
%
%% reading image
%  f = imread('star640x480.jpg');
f = imread('overlay.jpg');
f = im2double(f);
f = mean(f,3);

figure(1);% subplot(2,2,[1,3]); 
imshow(f, []);


%% Perspective transform matrix
%
% T = [ 1.4839, 0.23638, 0.0030649; ...
% 	0, 1.652, 0; ...
% 	-4.4516, -207.21, 1];
%
% input corners (using impixel) and compute transform
% use(uncomment):
[c r p] = impixel;
% or use those coordinates(comment if using impixel):
% c = [ P1(1) P2(1) P3(1) P4(1) ]';  % x coordinates
% r = [ P1(2) P2(2) P3(2) P4(2) ]';  % y coordinates
base = [0 0; (width-1) 0; (width-1) (higth-1); 0 (higth-1)];        % output dimentions

tf = fitgeotrans([c r],base,'projective');
% disp('tf = ');
% disp(tf)

T = tf.T;
disp('T =');
format short g
disp(T);
disp('After rounding and converting ');
T = round(T * 2^12) / 2^12  % faster rounding
% T = sfi(T,25,12);   % very slow
format
figure(1);%subplot(2,2,[1,3]);
hold on;
% plot red box
plot([c;c(1)],[r;r(1)],'r','Linewidth',2);
text(c(1),r(1)+20,'P1','Color','r');
text(c(2),r(2)+20,'P2','Color','r');
text(c(3),r(3)-20,'P3','Color','r');
text(c(4),r(4)-20,'P4','Color','r');

% % plot lines like in prototype model
%             plot([1;1],[0;480],'g','Linewidth',2);
%             plot([80;80],[0;480],'g','Linewidth',2);
%             plot([160;160],[0;480],'g','Linewidth',2);
%             plot([240;240],[0;480],'g','Linewidth',2);
%             plot([320;320],[0;480],'g','Linewidth',2);
%             plot([400;400],[0;480],'g','Linewidth',2);
%             plot([480;480],[0;480],'g','Linewidth',2);
%             plot([560;560],[0;480],'g','Linewidth',2);
%             plot([639;639],[0;480],'g','Linewidth',2);
%             
%             plot([0;640],[1;1],'g','Linewidth',2);
%             plot([0;640],[80;80],'g','Linewidth',2);
%             plot([0;640],[160;160],'g','Linewidth',2);
%             plot([0;640],[240;240],'g','Linewidth',2);
%             plot([0;640],[320;320],'g','Linewidth',2);
%             plot([0;640],[400;400],'g','Linewidth',2);
%             plot([0;640],[479;479],'g','Linewidth',2);
%             
%             F = getframe();
%             gg = frame2im(F);
%             imwrite(gg,'overlay.jpg');       % save image
hold off;

%% calculating new values
g = zeros(higth, width);

v_tr_all = zeros(numel(f), 3);

n = 0;
for y = 1:size(f, 1),
	for x = 1:size(f, 2),
		% x and y are from ORIGINAL (untransformed) image from camera
		n = n + 1;
		
		v = [x, y, 1];
		v_tr = v * T;
		
		v_tr_all(n,:) = v_tr;
		
       
        w_tr_inv = 1/ v_tr(3);
        w_tr_inv = round(w_tr_inv * 2^8) / 2^8;
		x_tr = v_tr(1) * w_tr_inv;
		y_tr = v_tr(2) * w_tr_inv;
        
% 		x_tr = v_tr(1) / v_tr(3);
% 		y_tr = v_tr(2) / v_tr(3);
% 		
% 		x_tr = round(x_tr);
% 		y_tr = round(y_tr);
		x_tr = fix(x_tr);   % integer part of real number
		y_tr = fix(y_tr);

		x_tr = min(x_tr, size(g, 2));
		x_tr = max(x_tr, 1);
		y_tr = min(y_tr, size(g, 1));
		y_tr = max(y_tr, 1);
		
		% x_tr, y_tr are TARGET COORDINATES WHERE TO WRITE DATA
		g(y_tr, x_tr) = f(y, x);
		
	end;
end;

figure(2);%subplot(2,1,1);
imshow(g, []);

% plots all calculated x, y and w values
figure(3);%subplot(2,1,2);
plot(v_tr_all);
legend('x', 'y', 'w');
X = ['MAX   w  = ', num2str(max(v_tr_all(:,3)))];  
disp(X),
Y = ['MIN   w  = ', num2str(min(v_tr_all(:,3)))];  
disp(Y),
disp(' ');
% prints w max an min values on plot
text( 0 , 0 , [ X,' ', Y] );

%% Print perspective trasform matrix values in hex
%
%   first bit is sign bit, 12bit integer part ans 12bit fraction part
%
            Tbin = [];
            Thex = [];
            for i=1:3
                for k=1:3
                    a = sfi(T(i,k),25,12);
                    Tbin = [Tbin; a.bin];
                    Thex = [Thex; a.hex];
                end
            end
%        % Displaying transform matrix in Verilog code style, for easy copying and pasting
%
% step = 0.001;       % step for lookuptable file generator loop
%             disp('Copy those constants in Verilog code'),
%             X = ['TRA_IMG_WIDTH   = ''d', num2str(width),','];  
%             disp(X),
%             X = ['TRA_IMG_DEPTH   = ''d', num2str(higth),','];  
%             disp(X),
%             a = 0;
%             for n=1:3 
%                 for k=1:3
%                     a = a + 1;
%                     X = ['T', num2str(n) , num2str(k) ,' = 25''sb', Tbin(a,1), '_' ,Tbin(a,2:13),'_',Tbin(a,14:25),','];
%                     disp(X),
%                 end
%             end
%
% % Make file for case statement in Verilog
%         %
%         %   This file contains code for loopuptable module
%         %
%         w_dec = [];
%         %w_hex = [];
%         w_dec_inv = [];
%         temp = ['000000000000'];      % just random values
%         temp_old = ['000000100000'];  % just random values
%         for i=   -1.5   :   step   :  4  % min and max w values
%                 w_dec = [ w_dec; sfi(i,12,8)];
%                 if (i ~= 0 ) 
%                     w_dec_inv = [ w_dec_inv; sfi(1/i,12,8)];
%                 end
%         end
%         %w_hex = w_dec.hex;
%         w_bin = w_dec.bin;
%         w_bin_inv = w_dec_inv.bin;
% 
%         %   lookuptable file generator
%         %
%         fid = fopen('lookuptable.v', 'wt');
%             fprintf(fid, 'module lookuptable();\n');
%             fprintf(fid, 'always@(negedge clk) begin\n ');
%             fprintf(fid, 'case (w)\n');
% 
%         for i=1:length(w_bin) 
%             temp_old = temp;
%             temp = w_bin(i,1:12);
%             if temp_old == temp
%                 % if same as previus value, do nothing
%             else
%                 fprintf(fid, '\t12''b%s_%s_%s : r_w_inv <= 12''b%s_%s_%s;\n', w_bin(i,1:1), w_bin(i,2:4), w_bin(i,5:12), w_bin_inv(i,1:1), w_bin_inv(i,2:4), w_bin_inv(i,5:12) );
%             end
%         end
%             fprintf(fid, '\tdefault   : r_w_inv <= 12''d1;\n ');% %s_%s_%s;\n ' , w_bin_inv(i,1:12) );
%             fprintf(fid, 'endcase;\n');
%             fprintf(fid, 'end\n');
%             fprintf(fid, 'endmodule');
%         disp(' ');
%         disp('Text file lookuptable.v write done');disp(' ');
%         fclose(fid);
% 
%% Making configuretion file for Registers

      X = ['Configuration script for CAM',num2str(camera),' and for mode',num2str(mode), ':'];
      disp(X),
            sw = ufi(mode,2,0);
            cam = ufi(camera,1,0);
            param = ufi(0,4,0);
            value = ufi(width,25,0);
            temp = ufi(bin2dec([param.bin , sw.bin , cam.bin]),7,0);
            X = ['P', temp.hex]; 
            temp = ufi(bin2dec(value.bin),25,0);
            X = [X, temp.hex]; 
      disp(X),
            param = ufi(1,4,0);
            value = ufi(higth,25,0);
            temp = ufi(bin2dec([param.bin , sw.bin , cam.bin]),7,0);
            X = ['P', temp.hex]; 
            temp = ufi(bin2dec(value.bin),25,0);
            X = [X, temp.hex]; 
      disp(X),
            a = 0;
            for n=1:3 
                for k=1:3
                    a = a + 1;
                    param = ufi(a+1,4,0);
                    temp = ufi(bin2dec([param.bin , sw.bin , cam.bin]),7,0);
                    X = ['P', temp.hex, Thex(a,1:7)];
%                     X = ['h',Thex(a,1:7)];  % print just values of matrix
                    disp(X),
                end
            end
