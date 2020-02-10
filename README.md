[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg?style=plastic)](https://lbesson.mit-license.org/)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/clockfix/FPGA-camera-inverse-perspective-mapping?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/clockfix/FPGA-camera-inverse-perspective-mapping?style=plastic)
![GitHub contributors](https://img.shields.io/github/contributors/clockfix/FPGA-camera-inverse-perspective-mapping?style=plastic)
![GitHub top language](https://img.shields.io/github/languages/top/clockfix/FPGA-camera-inverse-perspective-mapping?style=plastic)

# **FPGA camera inverse perspective mapping (Bird's-eye view)**
Using two **OV7670** cameras and *Digilent Basys3* board with *Xilinx Artix 7* series **FPGA** performing inverse perspective image mapping and displays result on **VGA** monitor.

A working model was created using **Verilog** HDL. This model is capable of setting up multiple cameras, as well as receiving videos from them. Received image before saving can be transformed into a black and white image or transformed using transformation matrices.

![Usage](https://e43kna.bl.files.1drv.com/y4mblnACFjxVnxxrWqAzc0baAkMnByvkHqyAAtRhvZx5n2ddzly7DiJPIlAuLtMVR8BTLlpInTbnrEBdfujHlR9mRjxEK9Yz54qthLOcxqIG5RLtdV-5s6vD1pC5_R1jkxbEhx-V8CO-uljYtysmkwTnGRz718A-3cvYGTHlZ7reqjMs293BL4EBk7tSGXXPyNwKycOy9y59-4tOQO1l3Nerw/perspective_transformation.jpg?psid=1)

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

Original image from camera

![original image from camera](https://7aba7a.bl.files.1drv.com/y4mjm7jOQLVZLG698C2Q89lSiJpgaUXb5QJ5O4aPJ7brX9Memvs9MDf5o8K7PG3NiiOQKGO7-PcO1JAX-iztIKA9llJfilCvZYvJtWOGK6quP3hqJP3wYk-h5nsNKdHY_lHdq7NY-SEXolzWbNMFiJaYrOYF_CjUxmr1eX1wdDWzDDj3UjYfb31RmOmqQkrlyLVmBpNGrpokqwuvX6Sxa9ykA/IMG_4925.jpg?psid=1)

After uploading the configuration to FPGA board in the corner of the monitor, You can see chessboard without perspective

![image after transformation](https://ibtojw.bl.files.1drv.com/y4m6_OiMO_spokt3SNQntEU2D6G4V3mWKGo79hVMY420dGuj1e51Qw-tb6YGBXY8ual0gH2qLpVP_3XPnsfPWBoqJ2-NawmLFin8PmYrcm3sKn0epzZLAVmIJaX6SW6t-qGtug88LxmRxLAldHde_YJBau-WB1gaiCiKoaAiy4mZTvwhpTmyhfLKxCcCcMgOCJAYpgh1WZ7_0UKuaarLdN5ug/IMG_4927.jpg?psid=1)

# How cameras connected with the board

![Basys3](https://rasv7w.bl.files.1drv.com/y4mAoPcNULZ7KFfe_9pM95q_px_RCpv7YOZgSKTsRCfEHDp7D5BJCBOtnA4oFRZeKr1pWHlaKprguELQ0_67uPMYZx_AHpcq91-0I5LENw4HEBAArny1z7W22VLienP15ZhxIFNKmf3EvNJn5ZzhXBZQ2Hqa8V58lyD2NNRn4FQw29xDjhehsM_ZfiMMosfaE1tUvCwPGgEJC9fkK7RUSApIw/pmod-pinout.png?psid=1)
![pinout](https://fgkm1w.bl.files.1drv.com/y4mYvu2r_T4Mv91oiLmIPjggQrIXIDWy5FKZhU09sKQ3F8gNJO5FsMyYJ_KKzjZIg7xod5W9ru7YzTrMn8ib5QkbafE3yVFfL-AR0MUKOkgFc2e8nMGdDohYi3JcvHDohoXyIHHvXdYH4XdBnXwQ-a1uEH1E2nRVFMfS2Q9Z5Bms4Dw1IhHRer-cfWyyPkzUdHJn_RxtHmQJFUhwayYYR5bGg/ov7670-pinout.png?psid=1)

# Full paper(in Latvian) can be found here:
https://www.overleaf.com/read/bjbpxsysfyvt
