echo "Installation de Docker ..."
apt update -y && apt upgrade -y
apt install curl  -y
curl -sSL https://get.docker.com/ | CHANNEL=stable bash
echo "Création des dossiers de stockage ..."
mkdir /srv/seedbox
mkdir /srv/seedbox/flix
mkdir /srv/seedbox/flix/movies
mkdir /srv/seedbox/flix/tv
mkdir /srv/seedbox/flix/music
mkdir /srv/seedbox/downloads
mkdir /srv/seedbox/config
mkdir /srv/seedbox/config/jackett
mkdir /srv/seedbox/config/torrent
mkdir /srv/seedbox/config/jellyfin
mkdir /srv/seedbox/config/index
mkdir /srv/seedbox/config/radarr
mkdir /srv/seedbox/config/sonarr
mkdir /srv/seedbox/config/sensorr
mkdir /srv/seedbox/config/lidarr
echo "Installation de la seedbox ..."
sleep 1
echo "Installation de qbittorent ..."
sleep 1
echo "Port redirection qbittorent: "  
read qbport
sleep 1
echo "Port interface web qbittorent: (default: 8080)"  
read qbportweb
#qbittorent install docker
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -e WEBUI_PORT=$qbportweb \
  -p $qbportweb:$qbportweb \
  -p $qbport:$qbport \
  -p $qbport:$qbport/udp \
  -v /srv/seedbox/config/torrent/:/config \
  -v /srv/seedbox/downloads/:/downloads \
  --restart unless-stopped \
  lscr.io/linuxserver/qbittorrent:latest
sleep 1
echo "Installation de jackett ..."
echo "Port interface web qbittorent: (default: 9117)"  
read jackettportweb
#jackett install docker
docker run -d \
  --name=jackett \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -p $jackettportweb:9117 \
  -v /srv/seedbox/config/jackett/:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/jackett:latest
sleep 1
echo "Installation de sensorr ..."
echo "Port interface web sensorr: (default: 5070)"  
read sensorrport
#sensorr install docker
docker run -p $sensorrport:5070 -v /srv/seedbox/config/sensorr/:/app/sensorr/config --name="sensorr" thcolin/sensorr

read -r -p "Voulez vous installer radarr ? [Y/n] " input
 
case $input in
      [yY][eE][sS]|[yY])
            echo "Installation de radarr ..."
echo "Port interface web radarr: (default: 7878)"  
read radarrportweb
#jackett install docker
docker run -d \
  --name=radarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -p $radarrportweb:7878 \
  -v /srv/seedbox/config/radarr/:/config \
  -v /srv/seedbox/flix/movies/:/movies \
  -v /srv/seedbox/downloads/:/downloads \
  --restart unless-stopped \
  lscr.io/linuxserver/radarr:latest
sleep 1
            ;;
      [nN][oO]|[nN])
            sleep 1
            ;;
      *)
            echo "Invalid input..."
            exit 1
            ;;
esac
sleep 1
read -r -p "Voulez vous installer sonarr ? [Y/n] " input
 
case $input in
      [yY][eE][sS]|[yY])
            echo "Installation de sonarr ..."
echo "Port interface web radarr: (default: 8989)"  
read sonarrportweb
#jackett install docker
ddocker run -d \
  --name=sonarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -p $sonarrportweb:8989 \
  -v /srv/seedbox/config/sonarr/:/config \
  -v /srv/seedbox/flix/tv/:/tv \
  -v /srv/seedbox/downloads/:/downloads \
  --restart unless-stopped \
  lscr.io/linuxserver/sonarr:latest
sleep 1
            ;;
      [nN][oO]|[nN])
            sleep 1
            ;;
      *)
            echo "Invalid input..."
            exit 1
            ;;
esac
sleep 1
read -r -p "Voulez vous installer wireguard ? [Y/n] " input
 
case $input in
      [yY][eE][sS]|[yY])
            echo "Installation de wireguard ..."

#jackett install docker
apt install wireguard wireguard-tools resolvconf
read -r -p "avez vous un fichier de config hébergé sur une url ? [Y/n] " input
 
case $input in
      [yY][eE][sS]|[yY])
echo "Url de fichier de configuration wireguard en .conf: "  
read wireguardurl
cd /etc/wireguard
wget -c $wireguardurl -o wg0.conf
systemctl enable wg-quick@wg0 --now
curl ifconfig.me
            ;;
      [nN][oO]|[nN])
            sleep 1
            ;;
      *)
            echo "Invalid input..."
            exit 1
            ;;
esac
sleep 1



sleep 1
            ;;
      [nN][oO]|[nN])
            sleep 1
            ;;
      *)
            echo "Invalid input..."
            exit 1
            ;;
esac
sleep 1
echo "La seedbox c'est installé !!"