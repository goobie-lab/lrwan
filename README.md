# Install development environement

## Tools
Download `gcc-arm-none-eabi-7-2018-q2-update` tarball from 
[ARM toolchain repository](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads).

Extract tarball in directory `/opt/`.

## SDK
Download file `en.i-cube_lrwan.zip` from
[ST website](https://www.st.com/en/embedded-software/i-cube-lrwan.html).

Extract archive in the workspace directory (where this file resides).

# Build

## Compile application AT_Slave
    $ make APP=AT_Slave

## Compile application PingPong
    $ make APP=PingPong

## Compile with debug enabled
   $ make APP=Xxx DEBUG=1

# Debug

## Setup GDB config

### Create file `$HOME/.gdbinit`:
    target remote localhost:3333
    set remotetimeout 5

### Start openocd in a terminal:
    $ sudo openocd -f st_lrwan_l0.cfg

### Start gdb in another terminal:
    $ /opt/gcc-arm-none-eabi-7-2018-q2-update/bin/arm-none-eabi-gdb -tui lora.elf
