ARG TAG="20190327"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:openjdk-$TAG"
ARG CONTENTIMAGE1="$BASEIMAGE"
ARG CONTENTSOURCE1="/usr/local"
ARG CONTENTDESTINATION1="/buildfs/usr/local"
ARG CONTENTIMAGE2="huggla/build-gdal"
ARG CONTENTSOURCE2="/usr/share/gdal.jar"
ARG CONTENTDESTINATION2="/imagefs$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/gdal.jar"
ARG CONTENTIMAGE3="huggla/build-gdal"
ARG CONTENTSOURCE3="/opt/gdal"
ARG CONTENTDESTINATION3="/buildfs/opt/gdal"
ARG BUILDDEPS="openjdk8"
ARG GEOSERVER_VERSION="2.13.0"
ARG DOWNLOADS="https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip"
ARG INITCMDS=\
"   wget -P /tmp https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64-jre.bin"
#"&& cd /buildfs/usr/local "\
#"&& echo 'yes' | sh /tmp/jai-1_1_3-lib-linux-amd64-jre.bin"
#"&& rm -f /tmp/jai-1_1_3-lib-linux-amd64-jre.bin "\
#"&& wget -P /tmp https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64-jre.bin"
#"&& echo 'yes' | sh /tmp/jai_imageio-1_1-lib-linux-amd64-jre.bin"
#"&& rm -f /tmp/jai_imageio-1_1-lib-linux-amd64-jre.bin "\
#ARG BUILDCMDS=\
#"   cd /imagefs$CATALINA_HOME/webapps/geoserver "\
#"&& /usr/lib/jvm/java-1.8-openjdk/bin/jar xvf \$downloadsDir/geoserver.war "\
#"&& cp -a \$downloadsDir/*.jar WEB-INF/lib/"
#ARG REMOVEFILES="$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-*.jar"

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/buildfs/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/buildfs/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/buildfs/}"
ARG CLONEGITSDIR
ARG DOWNLOADSDIR
ARG MAKEDIRS
ARG MAKEFILES
ARG EXECUTABLES
ARG STARTUPEXECUTABLES
ARG EXPOSEFUNCTIONS
ARG GID0WRITABLES
ARG GID0WRITABLESRECURSIVE
ARG LINUXUSEROWNED
COPY --from=build /imagefs /
RUN [ -n "$LINUXUSEROWNED" ] && chown 102 $LINUXUSEROWNED || true
#---------------------------------------------


#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------

#FROM huggla/build-gdal as gdal
#FROM anapsix/alpine-java:9_jdk as jdk
#FROM huggla/tomcat-oracle

#COPY --from=gdal /opt/gdal /opt/gdal
#COPY --from=gdal /usr/share/gdal.jar /usr/share/gdal.jar
#COPY --from=jdk /opt/jdk /opt/jdk-full

#ENV GEOSERVER_VERSION="2.13.0"

#RUN downloadDir="$(mktemp -d)" \
# && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip -O "$downloadDir/geoserver.zip" \
# && unzip "$downloadDir/geoserver.zip" geoserver.war -d "$CATALINA_HOME/webapps" \
# && cd "$CATALINA_HOME/webapps" \
# && mkdir geoserver \
# && cd geoserver \
# && jar xvf "$CATALINA_HOME/webapps/geoserver.war" \
# && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip -O "$downloadDir/geoserver-ogr-plugin.zip" \
# && unzip -o "$downloadDir/geoserver-ogr-plugin.zip" -d "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib" \
# && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip -O "$downloadDir/geoserver-gdal-plugin.zip" \
# && unzip -o "$downloadDir/geoserver-gdal-plugin.zip" -d "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib" \
# && rm -rf $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-*.jar \

# && cp /usr/share/gdal.jar "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/gdal.jar" \
# && wget http://data.boundlessgeo.com/suite/jai/jai-1_1_3-lib-linux-amd64-jdk.bin -O "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin"
# && JAVA_HOME="/opt/jdk-full" \
# && cd "$JAVA_HOME" \
# && echo "yes" | sh "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin" \
# && wget http://data.opengeo.org/suite/jai/jai_imageio-1_1-lib-linux-amd64-jdk.bin -O "$downloadDir/jai_imageio-1_1-lib-linux-amd64-jdk.bin" \
# && echo "yes" | sh "$downloadDir/jai_imageio-1_1-lib-linux-amd64-jdk.bin" \
# && rm -rf "$downloadDir"
