#!/bin/bash

echo "+-------------------+"
echo "|     Sharingan     |"
echo "| by deathflash1411 |"
echo "+-------------------+"

set -e
if [ ! -d $PWD/output ]; then
    mkdir output
fi
if [ ! -d $PWD/output/$1 ]; then
    mkdir output/$1
fi
if [ ! -d $PWD/output/$1/subs ]; then
    mkdir output/$1/subs
fi
if [ ! -d $PWD/output/$1/aqua ]; then
    mkdir output/$1/aqua
fi
if [ ! -d $PWD/output/$1/naabu ]; then
    mkdir output/$1/naabu
fi

echo "[!] Running amass..."
amass enum --passive -d $1 -o output/$1/subs/sub_amass.txt

echo "[!] Running subfinder..."
subfinder -d $1 -o output/$1/subs/sub_subf.txt

echo "[!] Running assetfinder..."
assetfinder --subs-only $1 > output/$1/subs/sub_asset.txt

echo "[!] Merging results..."
cat output/$1/subs/sub_amass.txt >> output/$1/subs/sub_full.txt
cat output/$1/subs/sub_subf.txt >> output/$1/subs/sub_full.txt
cat output/$1/subs/sub_asset.txt >> output/$1/subs/sub_full.txt
sort -u output/$1/subs/sub_full.txt > output/$1/subs/sub_sort.txt

echo "[!] Running httprobe..."
cat output/$1/subs/sub_sort.txt | httprobe > output/$1/subs/sub_alive.txt

echo "[!] Running aquatone..."
cat output/$1/subs/sub_alive.txt | aquatone -out output/$1/aqua/

echo "[!] Running naabu..."
naabu -iL output/$1/subs/sub_sort.txt -o output/$1/naabu/
