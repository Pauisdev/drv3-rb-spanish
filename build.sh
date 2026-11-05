#!/bin/bash
F_RESET="\033[0m"
F_BOLD="\033[1m"
C_FAIL="\033[38;5;9m"
C_OK="\033[38;5;29m"
C_THINK="\033[38;5;27m"
C_GREY="\033[38;5;242m"
C_OK2="\033[38;5;6m"

manual () {
    echo -e "${C_OK}${F_BOLD}Resolute Rebellion's spanish building tool."
    echo -e "${C_OK2}Options:"
    echo -e "    -v, --v3_path ${F_RESET}${C_GREY}        Set V3's path"
    echo -e "    ${C_OK2}${F_BOLD}-r, --resolute_path ${F_RESET}${C_GREY}  Set Resolute Rebellion's path"
    echo -e "    ${C_OK2}${F_BOLD}-h, --help ${F_RESET}${C_GREY}           Show this manual"
}

while [ "$1" != "" ]; do
    case $1 in
        -v | --v3_path)
            shift # Remove --v3_path from $1 and move onto the next argument
            drv3_path=$1
            ;;
        -r | --resolute_path)
            shift
            rb_path=$1
            ;;
        -h | --help)
            manual   
            exit 0 
            ;;
        *)
            echo -e "${C_FAIL}[!] Unknown argument(s). Showing manual..."
            echo ""
            manual
            exit 1
            ;;
    esac
    shift # Move onto the next argument
done

echo "Drv3 path: $drv3_path"
echo "Rb path: $rb_path"

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

# Copy folder structure
mkdir out
mod="out/drv3.es-translation.resolute-rebellion"
mkdir $mod
cp ModConfig.json $mod
mkdir $mod/CRIFsV2Hook
tree -dfi --noreport CRIFsV2Hook | grep -v ".decompressed" | xargs -I{} mkdir -p "$mod/{}"

# Copy Resolute Rebellion chap0_text_US.SPC
cp $rb_path/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.SPC $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007
# Extract chap0_text_US.SPC
HarmonyTools spc extract -f $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.SPC
# That generates the folder $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed
# Bring script over there
cp CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed/* $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed
# Pack script
HarmonyTools stx pack -b $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed
# Remove no longer necessary .stx.txt files
find $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed -name "*.stx.txt" -type f -delete
# Pack SPC
HarmonyTools spc pack -f $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed
# Remove .spc.decompressed folder
rm $mod/CRIFsV2Hook/CPK/partition_data_win_us.cpk/wrd_script/007/chap0_text_US.spc.decompressed
