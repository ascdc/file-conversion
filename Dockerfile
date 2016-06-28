FROM ubuntu:trusty
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /script/run.sh
ADD command.sh /script/command.sh

RUN chmod +x /script/*.sh && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install software-properties-common python-software-properties cron && \
	locale-gen en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	add-apt-repository -y ppa:ondrej/php && \
	add-apt-repository -y ppa:mc3man/trusty-media && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get install -y ffmpeg flac shntool libav-tools imagemagick tofrodos unrar-free p7zip-full php7.0-cli php7.0-mysql && \
	echo "SHELL=/bin/sh"> /etc/crontab && \
	echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin">> /etc/crontab && \
	echo "*/1 * * * * root /script/command.sh">> /etc/crontab

WORKDIR /script
ENTRYPOINT ["/run.sh"]