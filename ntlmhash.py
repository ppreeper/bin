#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import hashlib,binascii
hash = hashlib.new('md4', "thisismyhashvalue".encode('utf-16le')).digest()
print(binascii.hexlify(hash))
