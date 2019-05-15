#!/bin/bash

find / -type f -size +50000c -exec ./a.out {} \; 2>/dev/null
