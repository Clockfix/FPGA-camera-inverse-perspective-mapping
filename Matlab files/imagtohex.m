
bit=imread('RTU320x240_24bit.bmp'); % 24-bit BMP image RGB888 
bit4=bit./17;
bit2=bit./85;
k=1;
fid = fopen('imag_data.csv', 'wt');

for i=240:-1:1 % image is written from the last row to the first row
for j=1:320
r(k)=bit4(i,j,1);
g(k)=bit4(i,j,2);
b(k)=bit4(i,j,3);

mem_place = (i-1)*320+(j-1);

fprintf(fid, 'p\t%d\t%x\t%x\t%x\n', mem_place, r(k), g(k), b(k));

k=k+1;
end
end



disp('Text files write done');disp(' ');
fclose(fid);
%fclose(fid_green);
%fclose(fid_blue); 
% fpga4student.com FPGA projects, Verilog projects, VHDL projects