FROM debian:buster

# Preconfiguration setup
RUN groupadd mysql
RUN useradd -r -g mysql -s /bin/false mysql
RUN apt-get update
RUN apt-get install -y bison build-essential cmake cmake-gui libncurses-dev libudev-dev libssl-dev pkg-config
ADD . /mysql-server

# Compile and install
WORKDIR /mysql-server/bld
RUN cmake .. -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DINSTALL_LAYOUT=RPM
RUN make
RUN make install

# Postinstallation setup
WORKDIR /
RUN rm -rf /mysql-server
# WORKDIR /usr/local/mysql
# RUN mkdir mysql-files
# RUN chown mysql:mysql mysql-files
# RUN chmod 750 mysql-files
# RUN bin/mysqld --initialize --user=mysql
# RUN bin/mysqld --initialize
# RUN bin/mysql_ssl_rsa_setup
# RUN bin/mysqld_safe --user=mysql &
USER mysql

# TODO:
# RUN tzdata -> load ?
# Delete bld directory

# Next command is optional - for automatic startup
# cp support-files/mysql.server /etc/init.d/mysql.server
