# FPGA-camera-inverse-perspective-mapping
Using two OV7670 cameras and Digilent Basys3 board with Xilinx Artix 7 series FPGA performing inverse perspective image mapping and displays result on VGA monitor.

A working model was created using Verilog HDL. This model is capable of setting up multiple cameras, as well as receiving videos from them. Received image before saving can be transformed into a black and white image or transformed using transformation matrices.

Online sources:
* https://github.com/luckasfb/Development_Documents/blob/master/MTK-Mediatek-Alps-Documents/OV7670%20software%20application%20note.pdf
* https://www.nandland.com/goboard/uart-go-board-project-part1.html
* https://www.nandland.com/goboard/vga-introduction-test-patterns.html
* http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera
* https://www.fpga4student.com/2018/08/basys-3-fpga-ov7670-camera.html
* http://www.johnloomis.org/ece564/notes/tform/planar/html/planar2.html
* https://se.mathworks.com/help/images/matrix-representation-of-geometric-transformations.html
* https://surf-vhdl.com/how-to-implement-division-in-vhdl/
