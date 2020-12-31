Implementation of a digital picture frame using DE10-LITE and a VGA display

This project shows the basic applications using FIFO, SDRAM, JTAG, VGA controller to built a digital picture frame.
If you have theoretical backround on these components you can use this project to understand how these components are used together to built a video system.
All components (except JTAG UART, PLL, C# JTAG library) were built from scratch using verilog. To give you better understanding of the design.
It took me about 8 months to make a functional prototype. Every component was built and simualted on modelsim to ensure fucntional spec.
And during integration Signal Tap Logic Analyzer was used extensively to troubleshoot the design. 

Steps:
  Any 640x480 JPG picture is transformed to 4-bit RGB and stored in Intel HEX format. Code provided in scilab
  Using visual Studio C# the file is uploaded to the SDRAM of the DE10-LITE board and this is displayed on the VGA screen.
  The JTAG unit listen for a start code and then send and acknoledge to the C# program so download can start.
  1024 bytes is send each time until end of file is reached. Every block received is acknowledge by the JTAG unit
  Every 1024 bytes received is stored in a FIFO then stored into the SDRAM
  The JTAG unit keeps listenening for a new file request.
  Once the picture has downloaded size 640x480 the VGA controller get notified to start fetching lines form the SDRAM.
  Every line consisting of 640x12-bit is stored in the FIFO during the horizontal blanking interval and it will be read and fethced to the screen.
  The SDRAM is refresh is triggered by the VGA controller vertical blanking interval. This ensure the SDRAM is in synch and no refresh is happening during reading of the pixels etc.
  The system controller controlling these activities is broken down into a couple of components.
