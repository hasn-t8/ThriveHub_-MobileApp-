#!/bin/bash

# Start a new tmux session for flutter run
tmux new-session -d -s flutter_run_session 'flutter run'

# Wait for flutter run to initialize
sleep 5

# Start fswatch to monitor changes in the lib directory and send 'r' to flutter run session
fswatch -o lib | while read num; do
    tmux send-keys -t flutter_run_session "r" C-m
done
