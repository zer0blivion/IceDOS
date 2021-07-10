#!/bin/bash

# Variables
username=$(whoami)

# Make child scripts executable
sudo chmod +x apps/apps.sh zsh/zsh-plugins.sh  single-gpu-passthrough/single-gpu-passthrough.sh

# Install needed applications
if ! command -v git &> /dev/null
then
    echo "Git is not installed"
    echo "Installing..."
    sudo pacman -S git
    exit
else
  echo "Git is installed"
  echo "Skipping..."
fi

if ! command -v subl &> /dev/null
then
    echo "Sublime Text is not installed"
    echo "Installing..."
    yay -S sublime-text-4
    exit
else
  echo "Sublime Text is installed"
  echo "Skipping..."
fi

# Generic applications installer
while true
do
	read -r -p "Do you want to install applications? [y/n] " input
 
 	case $input in [yY][eE][sS]|[yY])
		while true
		do
			read -r -p "Do you want to edit the applications script? [y/n] " input
 
 			case $input in [yY][eE][sS]|[yY])
				echo Press any button when you have finished editing the applications script...
				subl apps/apps.sh
				read -r -n 1 -s
				echo Installing applications...
 				./apps/apps.sh
 				break
 				;;
 			[nN][oO]|[nN])
				echo Installing applications...
 				./apps/apps.sh
 				break
        		;;
    		*)
 				echo "Invalid input..."
 				;;
 			esac
		done
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Startup items
if command -v gwe &> /dev/null
then
    echo "GreenWithEnvy is installed..."
    while true
    do
      read -r -p "Do you want to add GreenWithEnvy to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/GreenWithEnvy.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
    exit
fi

if command -v ksuperkey &> /dev/null
then
    echo "ksuperkey is installed..."
    while true
    do
      read -r -p "Do you want to add ksuperkey to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/ksuperkey.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
    exit
fi

if command -v discord-canary &> /dev/null
then
    echo "Discord Canary is installed..."
    while true
    do
      read -r -p "Do you want to add Discord Canary to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/Powercord.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
    exit
fi

while true
do
	read -r -p "Do you want to disable caps lock? [y/n] " input

 	case $input in [yY][eE][sS]|[yY])
		mv apps/NoCapsLock.desktop /home/"$username"/.config/autostart/
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Zsh installer
if ! command -v zsh &> /dev/null
then
    echo "zsh is not installed"
    while true
    do
      read -r -p "Do you want to install zsh? [y/n] " input

      case $input in [yY][eE][sS]|[yY])

        sudo pacman -S zsh

        while true
        do
          read -r -p "Do you want to install zsh plugins? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            while true
            do
              read -r -p "Do you want to edit the zsh plugins script? [y/n] " input

              case $input in [yY][eE][sS]|[yY])
                echo Press any button when you have finished editing the zsh plugins script...
                read -r -n 1 -s
                subl zsh/zsh-plugins.sh
                echo Installing zsh plugins...
                ./zsh/zsh-plugins.sh
                break
                ;;
              [nN][oO]|[nN])
                echo Installing zsh plugins...
                ./zsh/zsh-plugins.sh
                break
                    ;;
                *)
                echo "Invalid input..."
                ;;
              esac
            done
            echo Do not forget to add installed scripts to the zsh config file
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Make zsh the default shell for root? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            sudo chsh -s /bin/zsh root
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Make zsh the default shell for $username? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            sudo chsh -s /bin/zsh "$username"
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Do you want to install provided zsh's theme? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            mv zsh/promptline.sh ~/.promptline.sh
            echo Do not forget to add "'source ~/.promptline.sh'" and "'unsetopt PROMPT_SP'" into the zsh config file!
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Do you want to edit zsh's config? [y/n] " input

          case $input in [yY][eE][sS]|[yY])

            while true
            do
              read -r -p "Do you want to edit view recommended additions to the zsh config? [y/n] " input

              case $input in [yY][eE][sS]|[yY])
                subl zsh/zsh-config-additions.txt
                break
                ;;
              [nN][oO]|[nN])
                break
                    ;;
                *)
                echo "Invalid input..."
                ;;
              esac
            done

            echo Press any button when you have finished editing the zsh config...
            subl /home/"$username"/.zshrc
            read -r -n 1 -s
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
    exit
else
  echo "Zsh is installed"
  echo "Skipping..."
fi

# Movescreen python script installer
while true
do
	read -r -p "Do you want to install movescreen python script to /usr/local/bin? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
		wget https://github.com/calandoa/movescreen/raw/master/movescreen.py
		sudo mv movescreen.py /usr/local/bin
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Kitty config installer
if ! command -v kitty &> /dev/null
then
    while true
    do
      read -r -p "Do you want to install kitty? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        sudo pacman -S kitty

        while true
        do
          read -r -p "Do you want to install kitty's provided config? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            mv apps/kitty.conf ~/.config/kitty
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
    exit
else
  echo "Kitty is installed"
  echo "Skipping..."
fi

# Powercord installer
if command -v discord-canary &> /dev/null
then
  echo "Discord Canary is installed..."
  while true
  do
    read -r -p "Do you want to install powercord? [y/n] " input

    case $input in [yY][eE][sS]|[yY])
      mkdir ~/Projects
      git clone https://github.com/powercord-org/powercord ~/Projects
      (cd ~/Projects/powercord && npm i && npm run plug)
      break
      ;;
    [nN][oO]|[nN])
      break
          ;;
      *)
      echo "Invalid input..."
      ;;
    esac
  done
fi

# Samba installer
if ! command -v samba &> /dev/null
then
    while true
    do
      read -r -p "Do you want to install samba? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        sudo pacman -S samba
        sudo mv /etc/samba/smb.conf.arcolinux /etc/samba/smb.conf

        while true
        do
          read -r -p "Do you want to edit samba's config? [y/n] " input

          case $input in [yY][eE][sS]|[yY])

            echo Press any button when you have finished editing the samba config...
            sudo subl /etc/samba/smb.conf
            read -r -n 1 -s
            sudo smbpasswd -a "$username"
            sudo systemctl disable samba
            sudo systemctl stop samba
            sudo systemctl enable smb
            sudo systemctl start smb
            sudo systemctl status smb
            sudo systemctl enable nmb
            sudo systemctl start nmb
            sudo systemctl status nmb
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
    exit
else
  echo "Samba is installed"
  echo "Skipping..."
fi

# Pictures mover
while true
do
	read -r -p "Do you want to move provided pictures to the pictures folder? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
 		mv pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
 		mv pictures/panel.png ~/Pictures/.panel.png
 		mv pictures/wallpaper.png ~/Pictures/.wallpaper.png
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Enable ssh
while true
do
	read -r -p "Do you want to enable ssh? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
 		sudo systemctl enable sshd
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Single gpu passthrough setup
while true
do
	read -r -p "Do you want to setup single gpu passthrough? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
 		./single-gpu-passthrough/single-gpu-passthrough.sh
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

while true
do
	read -r -p "Do you want to reboot? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
		reboot
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done