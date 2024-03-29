#!/bin/bash
 
red="\033[1;31m"
gray="\033[1;37m"
reset="\033[0m"
 
printf "\nFirst check for gremlins, please wait...\n\n"
 
wincr=$(ggrep -cP "\r" "$1")
if [ "$wincr" -eq "0" ]; then
wc=none
else
wc=$(awk -F"\r" 'NF>1 {a+=(NF-1); b++} END {print a" on "b" lines"}' "$1")
fi
 
shy=$(ggrep -c $'\\x18' "$1")
if [ "$shy" -eq "0" ]; then
sh=none
else
sh=$(awk -F"\xc2\xad" 'NF>1 {c+=(NF-1); d++} END {print c" on "d" lines"}' "$1")
fi
 
nbsp=$(ggrep -c $'\xc2\xa0' "$1")
if [ "$nbsp" -eq "0" ]; then
nb=none
else
nb=$(awk -F"\xc2\xa0" 'NF>1 {c+=(NF-1); d++} END {print c" on "d" lines"}' "$1")
fi
 
repcha=$(ggrep -c "["$'\xef\xbf\xbd'"]" "$1")
if [ "$repcha" -eq "0" ]; then
rc=none
else
count=$(ggrep -o "["$'\xef\xbf\xbd'"]" "$1" | wc -l)
lines=$(ggrep -c "["$'\xef\xbf\xbd'"]" "$1")
rc=$(printf "$count on $lines lines\n")
fi
 
printf "$red$1$reset has:\n\nWindows carriage returns (\\\r): $gray$wc$reset\nSoft hyphens (\\\xad): $gray$sh$reset\nNon-breaking spaces (\\\xa0): $gray$nb$reset\nReplacement characters (\\\xef\\\xbf\\\xbd): $gray$count on $lines lines$reset\n"
 
printf "_ _ _ _ _ _ _ _ _ _ _ \n"
 
printf "\nChecking now for gremlin control characters, please wait...\n"
 
awk 'BEGIN {FS=""; for (n=0;n<256;n++) ord[sprintf("%c",n)]=n; \ list="\x00|\x01|\x02|\x03|\x04|\x05|\x06|\x07|\x08|\x0b|\x0c|\x0e| \ \x0f|\x10|\x11|\x12|\x13|\x14|\x15|\x16|\x17|\x18|\x19|\x1a|\x1b| \ \x1c|\x1d|\x1e|\x1f|\x7f|\xc2\x80|\xc2\x81|\xc2\x82|\xc2\x83|\xc2\x84 \ |\xc2\x85|\xc2\x86|\xc2\x87|\xc2\x88|\xc2\x89|\xc2\x8a|\xc2\x8b| \ \xc2\x8c|\xc2\x8d|\xc2\x8e|\xc2\x8f|\xc2\x90|\xc2\x91|\xc2\x92|\xc2\x93 \ |\xc2\x94|\xc2\x95|\xc2\x96|\xc2\x97|\xc2\x98|\xc2\x99|\xc2\x9a| \ \xc2\x9b|\xc2\x9c|\xc2\x9d|\xc2\x9e|\xc2\x9f"} \
{if ($0 ~ list) \
{for (i=1;i<=NF;i++) if ($i ~ /[^[:graph:]]/ && $i !~ /[[:blank:]]/ && $i !~ /\r/) {b[$i]++}}} \
END {for (j in b) printf("%s\t%02x\n", b[j],ord[j])}' "$1" > /tmp/list
 
echo
 
if [ -s /tmp/list ]; then
awk -v GRAY="$gray" -v RESET="$reset" 'BEGIN {FS=OFS="\t"} FNR==NR {a[$1]=$2;next} {print a[$2]" (hex "$2"): " ,GRAY$1RESET}' ~/scripts/chars /tmp/list
else
printf "No gremlin control characters found\n\n"
fi
 
echo
 
rm /tmp/list
 
exit 
