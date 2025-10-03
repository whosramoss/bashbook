#!/bin/bash

source "lib/logger/main.sh"
source "lib/loading/main.sh"

sdx_log_section "Loading Functions" \
  "Contains animated Bash loading effects designed for terminal feedback." 

echo
sdx_log_topic "Example Linear Loading"
sdx_linear_loading "∴∵∴∵∴∵"
sdx_linear_loading "% -- % -- % --"
sdx_linear_loading "▁▂▃▅▆▇▇▆▅▃▂▁"
sdx_linear_loading "┌──┐└──┘"

echo
sdx_log_topic "Example Boomerang Loading"
sdx_boomerang_loading " ┌──┐└──┘ "
sdx_boomerang_loading "[============]"
sdx_boomerang_loading " > > > > > "
sdx_boomerang_loading "###########"
sdx_boomerang_loading " LOADING "