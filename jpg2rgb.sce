//scilab
//Reference: https://en.wikipedia.org/wiki/Intel_HEX#Record_types
//
//Convert 480 by 640 jpg to 4-bit RGB for DE10 LITE VGA
//Author:Andrew Boelbaai
//Email:acawhiz@gmail.com
//

img=imread('C:\intelFPGA_lite\DE10-LiteBoard\vga_pics\1.jpg');
//imshow(img);
fd = mopen("C:\intelFPGA_lite\DE10-LiteBoard\Projects\UDEMY\vga1.hex",'wt');
//mputl('Hello World',fd);


byte_count=2;
address =0;
address_lsb=0;
address_msb=0;
record_type=0;
Extended_Linear_Address=0;
data_size = 480 * 640;
for y = 1:480
    for x = 1:640 
        
        if( modulo(address,65535)==0 && address ~=0 ) then 
            record_type=hex2dec('0x04');
            Extended_Linear_Address = Extended_Linear_Address+1;
            
            checksum=bitxor(uint8(byte_count+record_type+Extended_Linear_Address),uint8(255))+uint8(1);
                        
            printf(":%02X%04X%02X%04X%02X\n",byte_count,0,record_type,Extended_Linear_Address,checksum);
            str= msprintf(":%02X%04X%02X%04X%02X\n",byte_count,0,record_type,Extended_Linear_Address,checksum);
            mputl(str',fd);
         end
         
            record_type=hex2dec('0x00');
            r=img(y,x,1)/16;//get most significant nibble
            g=img(y,x,2)/16;//get most significant nibble
            b=img(y,x,3)/16;//get most significant nibble
            rgb="0"+dec2hex(r) + dec2hex(g) + dec2hex(b);//4-nibble 0-r-g-b
            gb= dec2hex(g) + dec2hex(b); //concatonate Green and Blue to form 8 bit-1 Byte
            gbdec=hex2dec(gb);//convert back to integer
            address_lsb= uint8(address);//Slice off MSB and keep LSB
            address_msb= uint8(address/256);//shift MSB to LSB position
            
            checksum=bitxor(uint8(byte_count+address_lsb+address_msb+record_type+r+gbdec),uint8(255))+uint8(1);
            
            str= msprintf(":%02X%02X%02X%02X%s%02X\n",byte_count,address_msb,address_lsb,record_type,rgb,checksum);
            mputl(str,fd);
            address=address+1;  

    end
end
mputl(":00000001FF",fd);
mclose(fd);
printf("Done");


