#!/bin/bash

while sleep 1; do  ps -C ./a.out -o pcpu= -o pmem= -o rss=; done;
