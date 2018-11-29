#!/usr/bin/env python
import hashlib,binascii
hash = hashlib.new('md4', "thisismyhashvalue".encode('utf-16le')).digest()
print(binascii.hexlify(hash))
