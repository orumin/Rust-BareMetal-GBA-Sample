#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
from docopt import docopt

doc="""generate header for GBA rom raw binary

Usage: header.py <title_name>

Options:
    <title_name>    title name for game

"""
NINTENDO_LOGO = bytearray([
  0x24, 0xFF, 0xAE, 0x51, 0x69, 0x9A, 0xA2, 0x21, 0x3D, 0x84, 0x82, 0x0A, 0x84, 0xE4, 0x09, 0xAD,
  0x11, 0x24, 0x8B, 0x98, 0xC0, 0x81, 0x7F, 0x21, 0xA3, 0x52, 0xBE, 0x19, 0x93, 0x09, 0xCE, 0x20,
  0x10, 0x46, 0x4A, 0x4A, 0xF8, 0x27, 0x31, 0xEC, 0x58, 0xC7, 0xE8, 0x33, 0x82, 0xE3, 0xCE, 0xBF,
  0x85, 0xF4, 0xDF, 0x94, 0xCE, 0x4B, 0x09, 0xC1, 0x94, 0x56, 0x8A, 0xC0, 0x13, 0x72, 0xA7, 0xFC,
  0x9F, 0x84, 0x4D, 0x73, 0xA3, 0xCA, 0x9A, 0x61, 0x58, 0x97, 0xA3, 0x27, 0xFC, 0x03, 0x98, 0x76,
  0x23, 0x1D, 0xC7, 0x61, 0x03, 0x04, 0xAE, 0x56, 0xBF, 0x38, 0x84, 0x00, 0x40, 0xA7, 0x0E, 0xFD,
  0xFF, 0x52, 0xFE, 0x03, 0x6F, 0x95, 0x30, 0xF1, 0x97, 0xFB, 0xC0, 0x85, 0x60, 0xD6, 0x80, 0x25,
  0xA9, 0x63, 0xBE, 0x03, 0x01, 0x4E, 0x38, 0xE2, 0xF9, 0xA2, 0x34, 0xFF, 0xBB, 0x3E, 0x03, 0x44,
  0x78, 0x00, 0x90, 0xCB, 0x88, 0x11, 0x3A, 0x94, 0x65, 0xC0, 0x7C, 0x63, 0x87, 0xF0, 0x3C, 0xAF,
  0xD6, 0x25, 0xE4, 0x8B, 0x38, 0x0A, 0xAC, 0x72, 0x21, 0xD4, 0xF8, 0x07,
])

def check_byte( barray ):
    retval = 0
    for i in range(0xA0,0xBD):
        retval = retval + barray[i]
    retval = retval + 0x19
    retval = 256-(retval%256)
    return retval

if __name__ == '__main__':

    args = docopt(doc)

    if len(args["<title_name>"]) > 12:
        print(f"{args['<title_name>']} is too long. title is less than 12 characters")
        sys.exit()

    header_array = bytearray()
    # Jump instruction to start address
    header_array.extend( bytearray([0x2E,0x00,0x00,0xEA]) )
    # logo code
    header_array.extend( NINTENDO_LOGO )
    # title name
    header_array.extend( bytearray(args["<title_name>"], 'ascii') )
    if len(args["<title_name>"]) != 12:
        header_array.extend( bytearray([0x00]*(12-len(args["<title_name>"]))) )
    # game code (A type, JPN region)
    header_array.extend( bytearray([ord('A')]) )
    header_array.extend( bytearray([ord(args['<title_name>'][0]),ord(args['<title_name>'][1])]) )
    header_array.extend( bytearray([ord('J')]) )
    # maker code
    header_array.extend( bytearray([0x00]*2) )
    # modified value
    header_array.extend( bytearray([0x96]) )
    # main unit code
    header_array.extend( bytearray([0x00]) )
    # device type
    header_array.extend( bytearray([0x00]) )
    # reserved area
    header_array.extend( bytearray([0x00]*7) )
    # rom version (0x00 ... v1.0 0x01 ... v1.1)
    header_array.extend( bytearray([0x00]) )
    # check byte
    header_array.extend( bytearray([check_byte(header_array)]) )
    # reserved area
    header_array.extend( bytearray([0x00]*2) )

    with open("rom_header", "wb") as fout:
        fout.write(header_array)
