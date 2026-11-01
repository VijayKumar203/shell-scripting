#!/bin/bash

#!/bin/bash

# Define color variables
RESET="\e[0m"
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE_BG="\e[44m"

# Examples of usage
echo -e "${GREEN}Success! The backup is complete."
echo -e "${RED}${BOLD}ERROR:${RESET} ${RED}Failed to connect to the server."
echo -e "${YELLOW}Warning: Disk space is running low."
echo -e "${BLUE_BG} This text has a blue background"
