FROM ubuntu

RUN apt-get update \
    && apt-get install ffmpeg -y
	
RUN mkdir /scripts

ADD script.sh /scripts/script.sh

RUN chmod +x /scripts/script.sh

ENTRYPOINT ["/scripts/script.sh"]

CMD ["/fotos"]