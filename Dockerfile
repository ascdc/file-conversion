FROM ubuntu:trusty
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /script/run.sh
ADD command.sh /script/command.sh
ADD set_root_pw.sh /script/set_root_pw.sh
ADD locale.gen /etc/locale.gen
ADD locale-archive /usr/lib/locale/locale-archive	

RUN chmod +x /script/*.sh && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install software-properties-common python-software-properties cron mariadb-client-5.5 vim bc && \
	locale-gen en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	add-apt-repository -y ppa:ondrej/php && \
	add-apt-repository -y ppa:mc3man/trusty-media && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get install -y ffmpeg flac shntool libav-tools imagemagick sox tofrodos unrar-free p7zip-full php7.0-cli php7.0-mysql && \
	echo "SHELL=/bin/sh"> /etc/crontab && \
	echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin">> /etc/crontab && \
	echo "*/1 * * * * root /script/command.sh">> /etc/crontab && \
	apt-get install -y subversion build-essential libxvidcore4 zlib1g-dbg zlib1g-dev openssh-server pwgen rsync && \
	svn co https://svn.code.sf.net/p/gpac/code/trunk/gpac gpac && cd gpac && \
	./configure --disable-opengl --use-js=no --use-ft=no --use-jpeg=no --use-png=no --use-faad=no --use-mad=no --use-xvid=no --use-ffmpeg=no --use-ogg=no --use-vorbis=no --use-theora=no --use-openjpeg=no && make && make install && cp bin/gcc/libgpac.so /usr/lib && \
	mkdir -p /var/run/sshd && \
	sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
	sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
	sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
	apt-get install -y locales && \
	locale-gen zh_TW.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \ 
	locale-gen zh_TW.UTF-8 && \
	echo "export LANG=zh_TW.UTF-8" >> /root/.profile && \ 
	echo "export LANGUAGE=zh_TW" >> /root/.profile && \
	echo "export LC_ALL=zh_TW.UTF-8" >> /root/.profile && \
	apt-get install mediainfo


ENV AUTHORIZED_KEYS **None**
EXPOSE 22

WORKDIR /script
ENTRYPOINT ["/script/run.sh"]
