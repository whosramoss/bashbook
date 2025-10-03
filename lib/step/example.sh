#!/bin/bash

source "lib/logger/main.sh"
source "lib/step/main.sh"

sdx_log_section "Step Functions" \
  "Utility script for running named steps with confirmation prompts and spinner feedback." 

file="temporary.txt"

step1() {
  sleep 3
}

step2() {
  touch "$file"
  echo "File '$file' created."
  sleep 3
}

step3() {
  rm -f "$file"
  echo "File '$file' deleted."
  sleep 3
}

if sdx_log_question_yes_no "Do you want create files?"; then
  sdx_run_step step1 "1. Waiting 3 seconds before creating the file"
  sdx_run_step step2 "2. Creating the file"
  sdx_run_step step3 "3. Deleting the file"
fi