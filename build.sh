#!/bin/bash
F_RESET="\033[0m"
F_BOLD="\033[1m"
C_FAIL="\033[38;5;9m"
C_OK="\033[38;5;29m"
C_THINK="\033[38;5;27m"
C_GREY="\033[38;5;242m"

echo -e "${C_FAIL}${F_BOLD}Running this program requires:${F_RESET}${C_FAIL}"
echo -e "* A clean copy of DRV3"
echo -e "* A clean copy of Resolute Rebellion" 
echo -e "* HarmonyTools on path"
echo ""
printf "${C_GREY}Continue? [y/N] ${F_RESET}"
read -n 1 answer
echo ""
if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
    echo -e "${C_GREY}Program aborted by user."
    exit 1
fi

echo -e "${C_THINK}[CHECK]${F_RESET} Checking if HarmonyTools is available..."
HarmonyTools --version > /dev/null
if [ $? != 0 ]; then
    echo -e "${C_FAIL}[FAIL]${F_RESET} HarmonyTools failed running. Is it on path?"
    exit 1
fi
echo -e "${C_OK}[OK]${F_RESET} HarmonyTools seems to be on path."
echo ""
read -p "* DRV3's path: " drv3_path
read -p "* Resolute rebellion's path: " rb_path

# If out folder already exists
if [ -e "out" ]; then
    printf "${C_FAIL}[!] Out folder already exists. ${C_GREY}Overwrite? [y/N] ${F_RESET}"
    read -n 1 answer
    echo ""
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        echo -e "${C_GREY}Program aborted by user."
        exit 1
    fi
    rm -rf out
fi
mkdir out
mkdir out/drv3.es-translation.resolute-rebellion
cp ModConfig.json out/drv3.es-translation.resolute-rebellion
