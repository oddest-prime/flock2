#!/bin/bash

# Dependencies:
#   apt install xvfb tmux ffmpeg

RUN_TIMEOUT=1000
DISP_NUM=43
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

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
R_PID=`pgrep -x "flock2"`
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
mkdir -p $SCRIPT_DIR/run-outputs
mv /tmp/flock2.stdout $SCRIPT_DIR/run-outputs/${SIMULATION_ID}_stdout.txt
mv /tmp/flock2.stderr $SCRIPT_DIR/run-outputs/${SIMULATION_ID}_stderr.txt
mv /tmp/video.mp4 $SCRIPT_DIR/run-outputs/${SIMULATION_ID}_video.mp4
mv ./${SIMULATION_ID}*.txt $SCRIPT_DIR/run-outputs/.
mv ./${SIMULATION_ID}*.csv $SCRIPT_DIR/run-outputs/.

popd

