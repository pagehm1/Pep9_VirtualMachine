#!/bin/bash

cd . && gdb-multiarch -ex "set srchitecture arm" -ex "set sysroot /usr/arm-linux-gnueabihf" -ex "file proj3_dbg" -ex "target remote localhost:1235"
