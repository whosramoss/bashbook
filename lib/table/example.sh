#!/bin/bash

source "lib/logger/main.sh"
source "lib/table/main.sh"

sdx_log_section "Table Functions" \
  "function to dynamically print formatted tables with any number of columns using customizable headers and rows" 

HEADER="Emulator|Host:Port|View in Emulator UI"
ROWS=(
  "Functions|localhost:5001|http://localhost:4000/functions"
  "Database|localhost:9000|http://localhost:4000/database"
  "Hosting|localhost:5000|n/a"
  "Pub/Sub|localhost:8085|n/a"
)

sdx_log_topic "Example Table simple"
sdx_show_table "$HEADER" "${ROWS[@]}"

echo

sdx_log_topic "Example Table with borders"
sdx_show_table_with_borders "$HEADER" "${ROWS[@]}"

