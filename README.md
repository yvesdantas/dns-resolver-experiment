# NXDOMAIN Error Answer for A Record Queries
This experiment consists in running the containerized version of [Knot Resolver](https://www.knot-resolver.cz/) and configure the DNS Resolver to return NXDOMAIN when running A record queries for blocklisted domains. To spin up the lab environment, clone this repo and run the following command:
```
user@ubuntu$ docker-compose up -d
```
In case you have the domain <code>google.com</code> configured in the <code>config/blocklist.rpz</code> file, the expected behavior of DNS Queries is presented as follows:
```
user@ubuntu:/$ dig google.com @127.0.0.1 A

; <<>> DiG 9.18.28-0ubuntu0.24.04.1-Ubuntu <<>> google.com @127.0.0.1 A
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 24752
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; EDE: 15 (Blocked): (CR36)
;; QUESTION SECTION:
;google.com.                    IN      A

;; AUTHORITY SECTION:
google.com.             10800   IN      SOA     google.com. nobody.invalid. 1 3600 1200 604800 10800

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Sun Nov 17 18:07:00 -03 2024
;; MSG SIZE  rcvd: 99

user@ubuntu:/$ dig google.com @127.0.0.1 AAAA

; <<>> DiG 9.18.28-0ubuntu0.24.04.1-Ubuntu <<>> google.com @127.0.0.1 AAAA
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3808
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      AAAA

;; ANSWER SECTION:
google.com.             300     IN      AAAA    2800:3f0:4001:806::200e

;; Query time: 259 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Sun Nov 17 18:07:08 -03 2024
;; MSG SIZE  rcvd: 67

```

For adding or removing domains from the blocklist, just edit the <code>config/blocklist.rpz</code> file and run the following command to reload the DNS Resolver:

```
user@ubuntu:/$ docker exec -it $(docker ps --filter "ancestor=cznic/knot-resolver:6" --format "{{.ID}}") kresctl reload
```

For a more detailed explanation, please refer to the document <code>tech-case-study.pdf</code> available here in this repository.