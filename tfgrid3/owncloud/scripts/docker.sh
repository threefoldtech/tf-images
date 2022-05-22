#!/bin/bash
echo -500 >/proc/self/oom_score_adj
ulimit -Hn 1048576
ulimit -Sn 1048576
exec /usr/bin/dockerd -H unix:// --containerd=/run/containerd/containerd.sock
