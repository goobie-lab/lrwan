# Install development environement

## Tools

Download gcc-arm-none-eabi-7-2018-q2-update tarball from 
https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads.
Extract tarball in directory /opt/.

## SDK

Download en.i-cube_lrwan.zip from
https://www.st.com/en/embedded-software/i-cube-lrwan.html.
Extract archive in a workspace directory (where this file resides).

# Build

## Compile for debug
    $ make DEBUG=1

## or compile for release
 $ make

# Debug

Setup GDB config file ~/.gdbinit:
 target remote localhost:3333
 set remotetimeout 5

Start openocd in a terminal:
 $ sudo openocd -f st_lrwan_l0.cfg

Start gdb in another terminal:
 $ /opt/gcc-arm-none-eabi-7-2018-q2-update/bin/arm-none-eabi-gdb -tui lora.elf
