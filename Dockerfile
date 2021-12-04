## (1) Build
FROM us.gcr.io/sharpspring-us/mysql-builder:debian as build

COPY . /mysql-server
WORKDIR /bld
RUN cmake ../mysql-server -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DCMAKE_BUILD_TYPE=Release -DWITH_UNIT_TESTS=OFF -DINSTALL_LAYOUT=DEB -DINSTALL_MYSQLTESTDIR=
# RUN cmake ../mysql-server -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DCMAKE_BUILD_TYPE=Release -DWITH_UNIT_TESTS=OFF -DINSTALL_LAYOUT=DEB
RUN make
RUN make install

## (2) Minimize
# FROM us.gcr.io/sharpspring-us/mysql-builder:debian AS runtime
FROM debian:buster
RUN apt-get update
RUN apt-get install -y libssl-dev libncurses-dev

# COPY --from=build /usr/local/mysql /usr/local/mysql
# COPY --from=build /usr /usr
COPY --from=build /usr/include/mysql /usr/include/mysql
COPY --from=build /usr/lib/mysql /usr/lib/mysql
COPY --from=build /usr/share/mysql /usr/share/mysql
COPY --from=build /usr/share/mysql-8.0 /usr/share/mysql-8.0
COPY --from=build /usr/bin/mysql* /usr/bin/
COPY --from=build /usr/sbin/mysql* /usr/sbin/
# RUN ln -s /usr/local/mysql/bin/* /usr/bin/
# RUN groupadd mysql
# RUN useradd -r -g mysql -s /bin/false mysql
#USER mysql
