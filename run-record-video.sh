#!/bin/bash

# Dependencies:
#   apt install xvfb tmux ffmpeg

RUN_TIMEOUT=10000
DISP_NUM=42

pushd ./build

rm -rf /tmp/video.mp4
killall Xvfb > /dev/null 2> /dev/null # kill orphaned process

echo "##  starting flock2 and record video (timeout $RUN_TIMEOUT seconds)"
xvfb-run --listen-tcp --server-num $DISP_NUM --auth-file /tmp/xvfb.auth -s "-ac -screen 0 1920x1080x24" -- ./flock2 -i ../assets/batch_run.txt > /tmp/flock2.stdout 2> /tmp/flock2.stderr &
echo "##  (recording progress...)"
tmux new-session -d -s VideoRecording$DISP_NUM "ffmpeg -draw_mouse 0 -framerate 15 -f x11grab -video_size 1920x1080 -i :$DISP_NUM -codec:v mpeg2video -b:v 10000k /tmp/video.mp4" &
#tmux new-session -d -s VideoRecording$DISP_NUM "ffmpeg -draw_mouse 0 -framerate 15 -f x11grab -video_size 1920x1080 -i :$DISP_NUM -codec:v mpeg2video -b:v 6000k /tmp/video.mp4" &
#tmux new-session -d -s VideoRecording$DISP_NUM "ffmpeg -framerate 15 -f x11grab -video_size 1920x1080 -i :$DISP_NUM -codec:v libx264 -b:v 6000k /tmp/video.mp4" &
sleep 1
R_PID=`pgrep -f "flock2"`
for i in `seq 1 $RUN_TIMEOUT`
do
    kill -0 $R_PID 2>/dev/null || break;
    echo -n "$i "
    sleep 1
done;

tmux send-keys -t VideoRecording$DISP_NUM q
F_PID=`pgrep ffmpeg`
for i in `seq 1 10`
do
    kill -0 $F_PID 2>/dev/null || break;
    echo -n ". "
    sleep 1
done;
echo ""
echo "##  killing ffmpeg";
kill $F_PID 2>/dev/null

wait
sleep 2

SIMULATION_ID=`grep "simulation_id: " /tmp/flock2.stdout | cut -d " " -f 2`
mv /tmp/flock2.stdout ./${SIMULATION_ID}_stdout.txt
mv /tmp/flock2.stderr ./${SIMULATION_ID}_stderr.txt
mv /tmp/video.mp4 ./${SIMULATION_ID}_video.mp4

popd

