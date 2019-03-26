#!/bin/bash
#BY: D4RKR0N
#Encaminhamento de tráfego de toda conexão TCP com tor-trans + IPTABLES
clear

echo -e "
 \033[01;32m 
 _____ ___  ____  __  __
|_   _/ _ \|  _ \ \ \/ /
  | || | | | |_) | \  / 
  | || |_| |  _ <  /  \_
  |_| \___/|_| \_\/_/\_/
 \033[01;37m 
 "
 echo -e "\033[01;34m - Script simples em bash para encaminhar todo tráfego de conexão TCP do seu linux para rede tor;
 - Serviço usado: Tor-Trans | Porta: 9040(TCP);
 - Firewall usado: IPTABLES;
 - Apenas para Debian/Ubuntu;
 - Executar o script como root;
 - Ter instalado: curl,tor,iptables.

 - BY:D4RKR0N

 - Greetz: Xin0x - Plastyne - VandaTheGod - Clandestine - Charlie BCA - Chacal - Luiz - Rildo Sthill - Bruno Oliv.

 Contatos;
 https://www.facebook.com/J0rdan.NT
 https://www.twitter.com/D4RKR0N
 \033[01;37m
"

verificausuario=`whoami`

echo "- Verificando usuário..."
if [ "$verificausuario" == "root" ]; then
	echo "- Ok, usuario atual é $verificausuario :)."
	printf "Você deseja iniciar ou parar?[1=INICIAR|2=PARAR]: "; read escolher
	if [ $escolher -eq 1 ]; then
		if [[ -f /usr/bin/tor && -f /etc/tor/torrc ]]; then
		verifica_alt=`cat /etc/tor/torrc | grep 'TransPort 9040'`
		if [ "$verifica_alt" == "TransPort 9040" ]; then
			service tor restart
			echo "- Ok, tudo certo, criando regra no iptables."
			sleep 5
            iptables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9040
            ip6tables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9040
            clear
            if [ -f /usr/bin/curl ]; then
            	echo "Seu atual IP: "; curl "https://api.ipify.org"; echo -e "\n"
            else
            	sudo apt-get install curl
            	echo "Seu atual IP: "; curl "https://api.ipify.org"; echo -e "\n"
            fi
        else
        	echo "Arquivo torrc não está com a linha 'TransPort 9040', editando e adicionando linha e restartando serviço."
        	pegac=`cat /etc/tor/torrc` 
        	touch torrc
        	echo "TransPort 9040" > torrc
        	echo $pegac >> torrc
        	rm /etc/tor/torrc
        	mv torrc /etc/tor/
        	service tor restart
            echo "Criando regra no iptables..."
            sleep 4
            iptables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9040
            ip6tables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9040
            clear
            if [ -f /usr/bin/curl ]; then
            	printf "Seu atual IP: "; curl "https://api.ipify.org"; echo -e "\n"
            else
            	sudo apt-get install curl
            	printf "Seu atual IP: "; curl "https://api.ipify.org"; echo -e "\n"
            fi
        fi
    else
    	echo "Você não está com o tor instalado, instalando tor com APT."
    	sudo apt-get install tor
    	clear
    	echo "Pronto, tor instalado, execute  novamente o script."
    fi
elif [ $escolher -eq 2 ]; then
	echo "Ok, regras sendo flushadas."
	iptables -t nat -F 
	ip6tables -t nat -F
	sleep 4 
	clear
	if [ -f /usr/bin/curl ]; then
            	printf "Seu atual IP: "; curl "https://api.ipify.org"; echo -e "\n"
            else
            	sudo apt-get install curl
            	printf "Seu atual IP: "; curl "https://api.ipify.org"; echo -e "\n"
            fi
else
	echo "Você não digitou uma opção válida, digite 1 para INICIAR e 2 para PARAR."
	sleep 7
	$0
	fi
else
	echo "Você precisa executar o script como root, usuario atual é $verificausuario, e não o root."
fi





