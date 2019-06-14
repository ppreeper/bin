#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import hashlib
import binascii

def main():
    parser = argparse.ArgumentParser("ntml hash passwords")
    parser.add_argument("-p", action="store", dest="p", help="password to hash")
    args = parser.parse_args()

    if args.p is None:
        parser.error("no password specified")
        return
    p = args.p
    hash = hashlib.new('md4', p.encode('utf-16le')).digest()
    print(binascii.hexlify(hash))
    return

if __name__ == "__main__":
    main()
