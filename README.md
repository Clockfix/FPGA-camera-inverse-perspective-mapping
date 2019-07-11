# **FPGA camera inverse perspective mapping**
Using two **OV7670** cameras and *Digilent Basys3* board with *Xilinx Artix 7* series **FPGA** performing inverse perspective image mapping and displays result on **VGA** monitor.

A working model was created using **Verilog** HDL. This model is capable of setting up multiple cameras, as well as receiving videos from them. Received image before saving can be transformed into a black and white image or transformed using transformation matrices.

Online sources:
* https://github.com/luckasfb/Development_Documents/blob/master/MTK-Mediatek-Alps-Documents/OV7670%20software%20application%20note.pdf
* https://www.nandland.com/goboard/uart-go-board-project-part1.html
* https://www.nandland.com/goboard/vga-introduction-test-patterns.html
* http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera
* https://www.fpga4student.com/2018/08/basys-3-fpga-ov7670-camera.html
* http://www.johnloomis.org/ece564/notes/tform/planar/html/planar2.html
* https://se.mathworks.com/help/images/matrix-representation-of-geometric-transformations.html
* https://surf-vhdl.com/how-to-implement-division-in-vhdl/

# Result
![original image from camera](https://7aba7a.bl.files.1drv.com/y4pwKHQvpHW92CTrzWGtWLTa32wgLyZR7ErFuswySWTBlY8j5WtYXB2xbfdF26WbK1EfGdaF3LiP7dsH9M_XuHN_okZEtXPohPNBCi84w3aulIHkF0wPb84--H45VNhXt3-47r82Ix_T1TroHMugZ0_TprtKybh1QxSujA2HF-DQFTszwYvA0WPgdisB4mnXeZ5IfSo01VfeqXwQy-LYn_rMw/IMG_4925.jpg)
![original image from camera](https://ibtojw.bl.files.1drv.com/y4p7PqFYUu3T73ChgD9lcUQQr30ZjLp8Gu3eI3oc1VWcGKXLwqWrP7A9U28Wy5hYm2fQvLt6rEl0BcLMeK40ePYksOWo71oUfRo-XznyrGMwe91icEp4wZWVjwwkcH0sXkkDmGub92JJfYQ5HCn5T9VLUFQ4dBOe77hBJKBXPD7FEccUIP5sq_R9UScoh-Wl5gZFKBR4ELeVqNU42Ja33aewg/IMG_4927.jpg)
