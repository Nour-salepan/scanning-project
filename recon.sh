#!/bin/bash
# =============================================================
# recon.sh - Network reconnaissance script (improved version)
# Author: Nour Salepan  (github.com/Nour-salepan)
#
# This is the "nicer" version of my simple script. I used an AI
# assistant to help me add colours, save the results to a folder,
# and check the input. The Nmap commands and the scanning steps
# are the ones I learned and tested myself.
#
# HOW TO RUN:  ./recon.sh <target>
# EXAMPLE:     ./recon.sh scanme.nmap.org
#
# RULE: only scan machines I own or have permission to test.
# =============================================================

# Colours (AI helped me with this part)
GREEN='\033[0;32m'; BLUE='\033[1;34m'; NC='\033[0m'

# Check the user typed a target
if [ -z "$1" ]; then
    echo "Please give me a target. Example: ./recon.sh scanme.nmap.org"
    exit 1
fi

TARGET="$1"
OUTDIR="recon_$TARGET"
mkdir -p "$OUTDIR"

echo -e "${BLUE}Scanning $TARGET ...${NC}"

# Step 1 - Is the host alive?
echo -e "${GREEN}[1] Checking if the host is up...${NC}"
nmap -sn "$TARGET" -oN "$OUTDIR/1_host.txt"

# Step 2 - Which ports are open?
echo -e "${GREEN}[2] Scanning ports...${NC}"
nmap -T4 "$TARGET" -oN "$OUTDIR/2_ports.txt"

# Step 3 - What versions are running?
echo -e "${GREEN}[3] Detecting service versions...${NC}"
nmap -sV -T4 "$TARGET" -oN "$OUTDIR/3_versions.txt"

# Step 4 - Run the default safe scripts
echo -e "${GREEN}[4] Running default scripts...${NC}"
nmap -sC -T4 "$TARGET" -oN "$OUTDIR/4_scripts.txt"

echo -e "${BLUE}Done. Reports saved in: $OUTDIR/${NC}"
