#!/bin/bash

ip=$1
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
nc='\033[0m'
echo "[*] Starting TryHackMe Script"
if [ "$#" -ne 1 ]; then
    echo "--------------------------------------------------------------"
    echo -e "${red}[-] Error: Invalid number of arguments"
    echo "[-] Syntax: tryhackme.sh <ip address${nc}>"
else
    echo -e "[*] IP of machine --> ${green}$ip${nc}"
    echo "--------------------------------------------------------------"

    # Nmap Scan
    echo -e "${blue}[*] Nmap Scan${nc}"

    # Creating directory
    echo -e "[*] Checking for ${green}Nmap directory${nc}"
    if [ -d ./nmap ]; then
        echo -e "   [+] ${green}Nmap directory${nc} exists"
    else
        echo -e "   [-] ${green}Nmap directory${nc} doesn't exist"
        echo -e "   [*] Creating ${green}Nmap directory${nc}"
        mkdir nmap
        echo -e "   [+] ${green}Nmap directory${nc} created succesfully"
    fi

    echo -e "[*] Beginning ${green}Nmap Scan${nc}"
    # nmap -T4 -A $ip -oN nmap/nmap_initial.txt > /dev/null
    echo -e "[+] ${green}Nmap Scan${nc} completed"
    echo -e "[+] Nmap Scan result stored in ${green}./nmap/nmap_initial.txt${nc}"
    echo -e "[*] Would you like to view the scan results (${blue}Yes[y]${nc} & ${red}No[n]${nc})?"
    read -p "    Reply: " ans
    if [ $ans == "y" ]; then
        less ./nmap/nmap_initial.txt 
    elif [ $ans == "n" ]; then
        echo -e "[*] Moving to ${blue}Gobuster Scan${nc}"
    else
        echo -e "${red}[-] Error: Invalid input supplied${nc}"
        echo -e "[*] Moving to ${blue}Gobuster Scan${nc}"
    fi
    echo "--------------------------------------------------------------"

    # Gobuster scan
    echo -e "${blue}[*] Gobuster Scan${nc}"
    if [ -a ./nmap/nmap_initial.txt ]; then
        port_http=$(cat ./nmap/nmap_initial.txt | grep http | grep tcp | cut -d "/" -f 1)
        if [ ! -z $port_http ]; then
            echo -e "[+] Website being hosted at ${green}port $port_http${nc}"
            echo -e "[*] Do you want to run a gobuster scan (${blue}Yes[y]${nc} & ${red}No[n]${nc})?"
            read -p '    Reply: ' ans

            # Creating directory
            if [ $ans == "y" ]; then
                echo -e "[*] Checking for ${green}Gobuster directory${nc}"
                if [ -d ./gobuster ]; then
                    echo -e "   [+] ${green}Gobuster directory${nc} exists"
                else
                    echo -e "   [-] ${green}Gobuster directory${nc} doesn't exist"
                    echo -e "   [*] Creating ${green}Gobuster directory${nc}"
                    mkdir gobuster
                    echo -e "   [+] ${green}Gobuster directory${nc} created succesfully"
                fi

                echo -e "[*] Beginning ${green}Gobuster Scan${nc}"
                echo -e "[*] Enter path for wordlist to be used [${green}default: directory-list-2.3-medium.txt]${nc}"
                read -p "    Reply [Leave blank to use default wordlist]: " $wordlist
                if [ -z $wordlist ]; then
                    wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
                fi
                gobuster dir -w $wordlist -u http://$ip -o gobuster/gobuster_initial.txt > /dev/null
                echo -e "[+] ${green}Gobuster Scan${nc} completed"
                echo -e "[+] Gobuster Scan result stored in ${green}./gobuster/gobuster_initial.txt${nc}"
                echo "--------------------------------------------------------------"

            elif [ $ans == "n" ]; then
                echo -e "[*] Cancelling ${blue}gobuster scan${nc}"
            else
                echo -e "${red}[-] Error: Invalid input supplied${nc}"
            fi
        else
            echo -e "[*] No website is being hosted by the machine"
        fi
    else
        echo -e "${red}[-] Error: Couldn't find nmap scan results${nc}"
    fi
fi

