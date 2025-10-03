#!/bin/bash

source "lib/logger/main.sh"
source 'lib/validations/main.sh'

sdx_log_section "Validations Functions" \
  "Validates the presence of CLI tools, runs version checks, and summarizes the results." 


sdx_has_tool "git" "git --version"
sdx_has_tool "node" "node --version"
sdx_has_tool "jq" "jq --version"
sdx_has_tool "docker" "docker --version"
sdx_has_tool "curl" "curl --version"

sdx_summary_tool_validation