#!/bin/bash
# recon-simple.sh
# My own simple scan script - written by Nour Salepan
# No colours, no tricks. Just the Nmap steps I learned.
#
# Run it like this:  ./recon-simple.sh scanme.nmap.org

TARGET=$1

echo "Scanning $TARGET"

echo "Step 1: is the host up?"
nmap -sn $TARGET

echo "Step 2: scan ports"
nmap $TARGET

echo "Step 3: service versions"
nmap -sV $TARGET

echo "Step 4: default scripts"
nmap -sC $TARGET

echo "Finished scanning $TARGET"
