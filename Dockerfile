## (1) Build
FROM debian:buster AS build

# 1.1 Preconfiguration setup
RUN apt-get update
RUN apt-get install -y bison build-essential cmake cmake-gui libncurses-dev libudev-dev libssl-dev pkg-config

# 1.2 Compile and install
COPY . /mysql-server
WORKDIR /bld
# RUN cmake ../mysql-server -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DINSTALL_LAYOUT=RPM -DCMAKE_BUILD_TYPE=Release -DWITH_UNIT_TESTS=OFF
RUN cmake ../mysql-server -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DCMAKE_BUILD_TYPE=Release -DWITH_UNIT_TESTS=OFF
RUN make
RUN make install

## (2) Minimize
FROM debian:buster AS runtime
COPY --from=build /usr/local/mysql /usr/local/mysql
RUN ln -s /usr/local/mysql/bin/* /usr/bin/
RUN groupadd mysql
RUN useradd -r -g mysql -s /bin/false mysql
USER mysql
