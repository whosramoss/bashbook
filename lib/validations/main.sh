#!/bin/bash

source "lib/logger/main.sh"
source "lib/table/main.sh"

VT_SUCCESS_COUNT=0
VT_ERROR_COUNT=0
VT_SUCCESS_LIST=()
VT_ERROR_LIST=()

# -------------------------------------------------------
# Category    :: VALIDATIONS
# Description :: Checks if a tool exists and runs a success command if found.
#                Registers the result for summary reporting.
# -------------------------------------------------------
function sdx_has_tool() {
  local tool_name="$1"
  local success_cmd="$2"

  local tool_path
  tool_path=$(command -v "$tool_name" 2>/dev/null)
  sdx_log_icon_info "$tool_name: ${DARK_GRAY}($success_cmd)${RESET}"

  if [ -n "$tool_path" ]; then
    sdx_log_icon_success "$tool_name installed"
    echo
    if [[ "$success_cmd" == *"%s"* ]]; then
      eval "$(printf "$success_cmd" "$tool_path")"
    else
      eval "$success_cmd"
    fi
    VT_SUCCESS_COUNT=$((VT_SUCCESS_COUNT + 1))
    VT_SUCCESS_LIST+=("$tool_name")
  else
    sdx_log_icon_error "$tool_name not found"
    VT_ERROR_COUNT=$((VT_ERROR_COUNT + 1))
    VT_ERROR_LIST+=("$tool_name")
  fi

  sdx_log_dark_gray "--------------"
}

# -------------------------------------------------------
# Category    :: VALIDATIONS
# Description :: Displays a summary of tool validation results, listing
#                successes and failures in a clear format.
# -------------------------------------------------------
function sdx_summary_tool_validation() {
  HEADER="Versions checked|Successes|Errors"
  ROWS=(
    "$((VT_SUCCESS_COUNT + VT_ERROR_COUNT))|$VT_SUCCESS_COUNT|$VT_ERROR_COUNT"
  )
  sdx_show_table_with_borders "$HEADER" "${ROWS[@]}"
  echo
  if [ ${#VT_SUCCESS_LIST[@]} -gt 0 ]; then
    sdx_log_icon_success "${WHITE}Successful tools${RESET}:"
    for tool in "${VT_SUCCESS_LIST[@]}"; do
      sdx_log_light_green "  - $tool"
    done
    echo
  fi

  if [ ${#VT_ERROR_LIST[@]} -gt 0 ]; then
    sdx_log_icon_error "${WHITE}Error tools${RESET}:"
    for tool in "${VT_ERROR_LIST[@]}"; do
      sdx_log_light_red "  - $tool"
    done
    echo
  fi
}