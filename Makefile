PROJECT_ROOT = $(shell pwd)

all : lib

lib : lib.boost lib.openssl lib.torrent

lib.boost : lib.boost.prepare lib.boost.build

lib.boost.prepare :
	mkdir ./libboost && \
	cd ./libboost && \
	wget http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.gz && \
	tar -xf ./boost_1_55_0.tar.gz

lib.boost.build :
	cd ./libboost/boost_1_55_0 && \
	./bootstrap.sh --with-libraries=date_time,filesystem,system,thread && \
	#./bootstrap.sh && \
	./b2

lib.boost.clean :
	-rm -r ./libboost

lib.torrent : lib.torrent.prepare lib.torrent.build

lib.torrent.prepare :
	mkdir ./libtorrent && \
	cd ./libtorrent && \
	wget http://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.0.tar.gz && \
	tar -xf ./libtorrent-rasterbar-1.0.0.tar.gz

lib.torrent.build :
	cd ./libtorrent/libtorrent-rasterbar-1.0.0 && \
	./configure --enable-examples --prefix=$(PROJECT_ROOT) LDFLAGS=-L$(PROJECT_ROOT)/libopenssl/ssl/lib LIBS=-ldl BOOST_ROOT=$(PROJECT_ROOT)/libboost/boost_1_55_0 --with-openssl=$(PROJECT_ROOT)/libopenssl/ssl && \
	make V=1 && \
	make install

lib.torrent.clean :
	-rm -r ./libtorrent

lib.openssl : lib.openssl.prepare lib.openssl.build

lib.openssl.prepare :
	mkdir ./libopenssl && \
	mkdir ./libopenssl/ssl && \
	cd ./libopenssl && \
	wget http://www.openssl.org/source/openssl-1.0.1h.tar.gz && \
	tar -xf openssl-1.0.1h.tar.gz

lib.openssl.build :
	cd ./libopenssl/openssl-1.0.1h && \
	./config --openssldir=$(PROJECT_ROOT)/libopenssl/ssl && \
	make && \
	make install

lib.openssl.clean :
	-rm -r ./libopenssl

.PHONY : clean
clean : lib.boost.clean lib.openssl.clean lib.torrent.clean
	-rm -r ./bin/*
