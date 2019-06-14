#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pickle
import json
import argparse
import sys

def main():
    parser = argparse.ArgumentParser("Reports")
    parser.add_argument("-f",action="store",dest="jsonfile",help="JSON File to read",default=None)
    args = parser.parse_args()
    if args.jsonfile is None:
        parser.error("No JSON file specified")
    else:
        try:
            json_data = json.load(open(args.jsonfile))
            print((json.dumps(json_data,indent=4)))
        except:
            print(("Unexpected error:", sys.exc_info()[0]))

    return


if __name__ == '__main__':
    main()
