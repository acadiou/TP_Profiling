#!/bin/bash

while sleep 1; do  ps -C nadiaCN -o pcpu= -o pmem= -o rss=; done;
