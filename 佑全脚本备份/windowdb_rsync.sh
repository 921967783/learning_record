#!/bin/bash

rm -rf /fastdfs2/window7_bk/VMSSystem.dbl

rsync -vzrtopg --progress --port=40000 115.238.86.124::test/VMSSystem.dbl   /fastdfs2/window7_bk/
