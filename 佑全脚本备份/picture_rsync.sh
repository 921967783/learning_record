#!/bin/sh

rsync -avz --ignore-existing /1tftp/html/ /fastdfs1/html/ >/usr/local/rsync/rsync.log
