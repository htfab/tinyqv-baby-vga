<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

The peripheral index is the number TinyQV will use to select your peripheral.  You will pick a free
slot when raising the pull request against the main TinyQV repository, and can fill this in then.  You
also need to set this value as the PERIPHERAL_NUM in your test script.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Baby VGA Peripheral for TinyQV

Author: htfab

Peripheral index: 5

## What it does

Displays a grid of 32x16 "pixels" over VGA using the Tiny VGA Pmod.

Each line of the grid corresponds to a 32 bit register (where the LSB maps to the leftmost column).

Registers can be read or written using 32-bit word-aligned transactions only.

## Register map

| Address | Name   | Access | Description                                                         |
|---------|--------|--------|---------------------------------------------------------------------|
| 0x00    | LINE00 | R/W    | Line 0 (top of screen)                                              |
| 0x04    | LINE01 | R/W    | Line 1                                                              |
| 0x08    | LINE02 | R/W    | Line 2                                                              |
| 0x0c    | LINE03 | R/W    | Line 3                                                              |
| ...     | ...    | ...    | ...                                                                 |
| 0x38    | LINE14 | R/W    | Line 14                                                             |
| 0x3c    | LINE15 | R/W    | Line 15 (bottom of screen)                                          |

## How to test

1. Write to any register and read it back, you should get the same value.

2. Connect a Tiny VGA Pmod to the output connector and observe the grid on the display.
   Note that the MicroPython firmware uses `uo[0]` for UART which will corrupt the red
   color channel. You can either build your own firmware that doesn't override `uo[0]`
   or wire up the Tiny VGA Pmod manually (you can exploit the fact that the display is
   monochrome, so `uo[1]` and `uo[2]` carries the same value as `uo[0]`).

## External hardware

Tiny VGA Pmod
