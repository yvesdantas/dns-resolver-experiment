FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y tcpdump && apt-get clean

ENTRYPOINT ["tcpdump"]