openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout site1_public_private.key -out site1_public_certificate.crt

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout site2_public_private.key -out site2_public_certificate.crt
