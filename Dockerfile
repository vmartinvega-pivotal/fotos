FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install ffmpeg -y
	
RUN apt-get install --only-upgrade bash -y
	
RUN mkdir /scripts

ADD script.sh /scripts/script.sh

RUN chmod +x /scripts/script.sh

ENTRYPOINT ["/scripts/script.sh"]

CMD ["/fotos"]