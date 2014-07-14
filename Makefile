
prefix_path = $(shell pwd)

include_dir = include
include_path = $(prefix_path)/$(include_dir)

lib_dir = lib
lib_path = $(prefix_path)/$(lib_dir)

opt_dir = opt
opt_path = $(prefix_path)/$(opt_dir)

boost_url = http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.gz
boost_file = boost_1_55_0.tar.gz
boost_dir = boost_1_55_0
boost_path = $(opt_path)/$(boost_dir)

libgeoip_url = http://github.com/maxmind/geoip-api-c/releases/download/v1.6.2/GeoIP-1.6.2.tar.gz
libgeoip_file = GeoIP-1.6.2.tar.gz
libgeoip_dir = GeoIP-1.6.2
libgeoip_path = $(opt_path)/$(libgeoip_dir)

libtorrent_url = http://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.0.tar.gz
libtorrent_file = libtorrent-rasterbar-1.0.0.tar.gz
libtorrent_dir = libtorrent-rasterbar-1.0.0
libtorrent_path = $(opt_path)/$(libtorrent_dir)

openssl_url = http://www.openssl.org/source/openssl-1.0.1h.tar.gz
openssl_file = openssl-1.0.1h.tar.gz
openssl_dir = openssl-1.0.1h
openssl_path = $(opt_path)/$(openssl_dir)

zlib_url = http://zlib.net/zlib-1.2.8.tar.gz
zlib_file = zlib-1.2.8.tar.gz
zlib_dir = zlib-1.2.8
zlib_path = $(opt_path)/$(zlib_dir)

boost.get :
	-mkdir $(opt_path)
	wget -P $(opt_path) $(boost_url)
boost.extract :
	tar -x -f $(opt_path)/$(boost_file) -C $(opt_path)
boost.config :
	cd $(boost_path) && \
	./bootstrap.sh --prefix=$(prefix_path)
boost.build :
	cd $(boost_path) && \
	./b2 install
boost.clean :
	-rm -r $(boost_path)

libgeoip.get :
	-mkdir $(opt_path)
	wget -P $(opt_path) $(libgeoip_url)
libgeoip.extract :
	tar -x -f $(opt_path)/$(libgeoip_file) -C $(opt_path)
libgeoip.config :
	cd $(libgeoip_path) && \
	./configure --prefix=$(prefix_path)
libgeoip.build :
	cd $(libgeoip_path) && \
	make && \
	make install
libgeoip.clean :
	-rm -r $(boost_path)

libtorrent.get :
	-mkdir $(opt_path)
	wget -P $(opt_path) $(libtorrent_url)
libtorrent.extract :
	tar -x -f $(opt_path)/$(libtorrent_file) -C $(opt_path)
libtorrent.config :
	cp --remove-destination $(prefix_path)/libtorrent.Jamfile $(libtorrent_path)/Jamfile
libtorrent.build :
	cd $(libtorrent_path) && \
	BOOST_ROOT=$(boost_path) \
	BOOST_BUILD_PATH=$(boost_path)/tools/build/v2 \
	INCLUDE_PATH=$(include_path) \
	LIB_PATH=$(lib_path) \
	$(boost_path)/bjam boost=source boost-link=static link=static encryption=openssl geoip=shared
libtorrent.build.examples :
	cd $(libtorrent_path)/examples && \
	BOOST_ROOT=$(boost_path) \
	BOOST_BUILD_PATH=$(boost_path)/tools/build/v2 \
	INCLUDE_PATH=$(include_path) \
	LIB_PATH=$(lib_path) \
	$(boost_path)/bjam boost=source boost-link=static link=static encryption=openssl geoip=shared
libtorrent.clean :
	-rm -r $(libtorrent_path)

openssl.get :
	-mkdir $(opt_path)
	wget -P $(opt_path) $(openssl_url)
openssl.extract :
	tar -x -f $(opt_path)/$(openssl_file) -C $(opt_path)
openssl.config :
	cd $(openssl_path) && \
	./config --prefix=$(prefix_path) threads zlib no-shared -I$(include_path) -L$(lib_path)
openssl.build :
	cd $(openssl_path) && \
	make && \
	make install
openssl.clean :
	-rm -r $(openssl_path)

zlib.get :
	-mkdir $(opt_path)
	wget -P $(opt_path) $(zlib_url)
zlib.extract :
	tar -x -f $(opt_path)/$(zlib_file) -C $(opt_path)
zlib.config :
	cd $(zlib_path) && \
	./configure --prefix=$(prefix_path) --static
zlib.build :
	cd $(zlib_path) && \
	make && \
	make install
zlib.clean :
	-rm -r $(zlib_path)

.PHONY : clean
clean :
	-rm -r $(include_path)
	-rm -r $(lib_path)
	-rm -r $(opt_path)
