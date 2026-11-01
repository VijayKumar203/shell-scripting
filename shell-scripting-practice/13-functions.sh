#!/bin/bash

# Define tput styles
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BOLD=$(tput bold)

echo "${GREEN}Operation successful.${RESET}"
echo "${RED}${BOLD}Critical failure!${RESET}"
