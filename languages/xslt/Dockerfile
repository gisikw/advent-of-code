FROM openjdk:11-jre-slim

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget -O /opt/SaxonHE9-9-1-7J.zip https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/SaxonHE9-9-1-7J.zip/download && \
    unzip /opt/SaxonHE9-9-1-7J.zip -d /opt/saxon && \
    wget -O /opt/xmlresolver-1.2.jar https://repo1.maven.org/maven2/org/xmlresolver/xmlresolver/1.2/xmlresolver-1.2.jar && \
    rm /opt/SaxonHE9-9-1-7J.zip

ENV CLASSPATH="/opt/saxon/saxon9he.jar:/opt/xmlresolver-1.2.jar"
