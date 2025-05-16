#!/bin/bash

SESSION="tempest"

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_DIR="$SCRIPT_DIR/../"

tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR"

tmux rename-window -t "$SESSION:0" 'server'
tmux send-keys -t "$SESSION:0" 'npm run server' C-m

tmux new-window -t "$SESSION:1" -n 'scss' -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:1" 'npm run scss' C-m

tmux new-window -t "$SESSION:2" -n 'ts' -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:2" 'npm run ts' C-m

tmux new-window -t "$SESSION:4" -n 'editor' -c "$PROJECT_DIR"

tmux attach -t "$SESSION"
