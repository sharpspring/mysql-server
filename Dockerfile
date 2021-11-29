## (1) Build
FROM us.gcr.io/sharpspring-us/mysql-builder:debian as build

COPY . /mysql-server
WORKDIR /bld
RUN cmake ../mysql-server -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost -DCMAKE_BUILD_TYPE=Release -DWITH_UNIT_TESTS=OFF
RUN make
RUN make install

## (2) Minimize
FROM us.gcr.io/sharpspring-us/mysql-builder:debian AS runtime

COPY --from=build /usr/local/mysql /usr/local/mysql
RUN ln -s /usr/local/mysql/bin/* /usr/bin/
RUN groupadd mysql
RUN useradd -r -g mysql -s /bin/false mysql
USER mysql
