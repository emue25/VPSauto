#!/bin/bash
#Script by weduz
cd /root

apt update
apt-get -y install ca-certificates gnupg
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
#Requirement
apt update
apt upgrade -y
apt install openvpn php7.3-fpm stunnel4 squid3 dropbear vnstat ufw build-essential fail2ban zip yum -y

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

yum -y install make automake autoconf gcc gcc++
wget "https://raw.githubusercontent.com/emue25/VPSauto/master/tool/plugin.tgz"
tar -xzvf plugin.tgz

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# install webmin
#cd
#wget "https://github.com/emue25/VPSauto/raw/master/webmin_1.930_all.deb"
#apt-get -y -f install;
#sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
#rm /root/webmin_1.930_all.deb
#/etc/init.d/webmin restart

# install screenfetch
cd
rm -rf /root/.bashrc
wget -O /root/.bashrc https://raw.githubusercontent.com/emue25/cream/mei/.bashrc

#text gambar
apt install boxes
# text pelangi
sudo apt install ruby
sudo apt gem install lolcat

# install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=442/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 777 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells

function InsOpenVPN(){
 # Checking if openvpn folder is accidentally deleted or purged
 if [[ ! -e /etc/openvpn ]]; then
  mkdir -p /etc/openvpn
 fi

 # Removing all existing openvpn server files
 rm -rf /etc/openvpn/*

 # Creating server.conf, ca.crt, server.crt and server.key
 cat <<'myOpenVPNconf' > /etc/openvpn/server_tcp.conf
# OpenVPN TCP
port 110
proto tcp
dev tun
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem
verify-client-cert none
username-as-common-name
key-direction 0
plugin /etc/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.200.0.0 255.255.0.0
ifconfig-pool-persist ipp.txt
push "route-method exe"
push "route-delay 2"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log tcp.log
verb 2
ncp-disable
cipher none
auth none
myOpenVPNconf

cat <<'myOpenVPNconf2' > /etc/openvpn/server_udp.conf
# OpenVPN UDP
port 2500
proto udp
dev tun
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem
verify-client-cert none
username-as-common-name
key-direction 0
plugin /etc/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.201.0.0 255.255.0.0
ifconfig-pool-persist ipp.txt
push "route-method exe"
push "route-delay 2"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log udp.log
verb 2
ncp-disable
cipher none
auth none
myOpenVPNconf2

 cat <<'EOF7'> /etc/openvpn/ca.crt
-----BEGIN CERTIFICATE-----
MIIFDDCCA/SgAwIBAgIJAIxbDcvh6vPEMA0GCSqGSIb3DQEBCwUAMIG0MQswCQYD
VQQGEwJQSDEPMA0GA1UECBMGVGFybGFjMRMwEQYDVQQHEwpDb25jZXBjaW9uMRMw
EQYDVQQKEwpKb2huRm9yZFRWMRMwEQYDVQQLEwpKb2huRm9yZFRWMRIwEAYDVQQD
EwlEZWJpYW5WUE4xHTAbBgNVBCkTFEpvaG4gRm9yZCBNYW5naWxpbWFuMSIwIAYJ
KoZIhvcNAQkBFhNhZG1pbkBqb2huZm9yZHR2Lm1lMB4XDTE5MTEyNTA4MDUzMFoX
DTI5MTEyMjA4MDUzMFowgbQxCzAJBgNVBAYTAlBIMQ8wDQYDVQQIEwZUYXJsYWMx
EzARBgNVBAcTCkNvbmNlcGNpb24xEzARBgNVBAoTCkpvaG5Gb3JkVFYxEzARBgNV
BAsTCkpvaG5Gb3JkVFYxEjAQBgNVBAMTCURlYmlhblZQTjEdMBsGA1UEKRMUSm9o
biBGb3JkIE1hbmdpbGltYW4xIjAgBgkqhkiG9w0BCQEWE2FkbWluQGpvaG5mb3Jk
dHYubWUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCf+WkN868YMiCl
d3z1Tq2OeRNb6ljiRGzEi1qrIvj/gXq6o0QD0SD+Nf3QWJrrJYFi1GECq72PNFhy
2jLFgZH0RRLOVZfG+jwZ9itxofweiwALvgMdz2e+mpQItMxKh1ZYkzNw+4zJ7zJV
u0Tq7YGPaMFPkLNU3V454rDYCdI8GG/wPDoW5FMc3FogI8fwylQvTWyE0yxHMxH6
FkISA5hOuSo6MO1FgAfDdNNwxa/MAbpHwJ+W6RBHv4lhE6bQePMCj/90pgt3NpxF
i++qwpSRfOR6OuuyDr1c++z6qhjLB7YzDLzj+HXCyfsPWPj+gJ0+3ckhW4gf/nhR
uB+BTd8fAgMBAAGjggEdMIIBGTAdBgNVHQ4EFgQULXGeDQBLXCPId0F3r/58FDCm
jC4wgekGA1UdIwSB4TCB3oAULXGeDQBLXCPId0F3r/58FDCmjC6hgbqkgbcwgbQx
CzAJBgNVBAYTAlBIMQ8wDQYDVQQIEwZUYXJsYWMxEzARBgNVBAcTCkNvbmNlcGNp
b24xEzARBgNVBAoTCkpvaG5Gb3JkVFYxEzARBgNVBAsTCkpvaG5Gb3JkVFYxEjAQ
BgNVBAMTCURlYmlhblZQTjEdMBsGA1UEKRMUSm9obiBGb3JkIE1hbmdpbGltYW4x
IjAgBgkqhkiG9w0BCQEWE2FkbWluQGpvaG5mb3JkdHYubWWCCQCMWw3L4erzxDAM
BgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBZUpwZ+LQWAQI8VW3hdZVN
WV+P12yYQ1UzyagtB3MqBR4aZhjk42NFBrwPZwpvWUXB0GB4DhBuvbVPtqnt5p4V
sDtQ6vKYeDlE/KDGDc0oJDsgxo2wwIXy+y/14EDqidAVjtf1rk5MDAAEVvonHxkP
861kzoIOZ0+D7sJDo3aZ8uNy8UznrRSzLDT63o28DkL3iLASyt1GHWu05wYmgzsg
m+w+AWvN5rL65mzyn/Bipf0I9snVB4saCgfy7TCI/4slOcMCNc2e6oOwOLvFA+s8
dZMt2qg62PEOj/LblYGD+qLn0xLRwqK0UWSmWobz5LXoxyssZLK2KiMkS41PHkfh
-----END CERTIFICATE-----
EOF7
 cat <<'EOF9'> /etc/openvpn/server.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=PH, ST=Tarlac, L=Concepcion, O=JohnFordTV, OU=JohnFordTV, CN=DebianVPN/name=John Ford Mangiliman/emailAddress=admin@johnfordtv.me
        Validity
            Not Before: Nov 25 08:06:59 2019 GMT
            Not After : Nov 22 08:06:59 2029 GMT
        Subject: C=PH, ST=Tarlac, L=Concepcion, O=JohnFordTV, OU=JohnFordTV, CN=DebianVPN/name=John Ford Mangiliman/emailAddress=admin@johnfordtv.me
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c6:6d:3d:64:58:08:e2:70:9b:a3:55:75:ec:5a:
                    6e:9d:bc:7c:45:f5:64:c5:f6:23:2e:b0:1f:28:2e:
                    cb:60:8d:71:73:3d:c4:e6:f7:e3:36:0b:ad:9d:87:
                    f5:4b:2f:85:5f:d8:c9:88:d9:86:4a:52:ce:2b:39:
                    c6:b9:83:e0:7e:ab:8e:1f:2f:11:cc:08:15:12:62:
                    dd:8d:94:b1:79:3c:52:d9:cb:0a:6a:db:64:8b:ff:
                    c7:41:5c:cc:f9:18:4f:74:1a:e7:c1:b4:b8:89:fd:
                    56:5f:5c:65:c4:21:a8:08:98:3d:8e:35:44:b3:6f:
                    93:b5:01:59:b4:35:23:99:00:79:fa:44:df:b3:4c:
                    76:bf:3c:e4:f7:39:3e:50:e0:fe:85:8c:a0:e2:63:
                    b1:ec:a3:32:cd:6b:9d:5a:0e:f6:66:92:ac:6f:15:
                    5e:bb:3a:48:d9:3d:63:94:ff:9c:fb:d2:fe:5a:11:
                    b5:1a:c1:6c:8a:9e:d3:29:8d:d6:ff:fc:9f:9f:a4:
                    ad:9d:a0:ca:2b:6f:63:47:7f:7b:3c:98:bf:14:18:
                    6c:36:38:7a:c3:5d:a9:5a:26:28:12:33:9d:17:1b:
                    6f:2f:5d:33:e7:b5:8f:57:3a:3a:29:57:6a:0e:9e:
                    84:7a:60:d9:9c:fb:c7:f3:f8:93:a7:cd:43:89:ec:
                    3f:d3
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            Netscape Cert Type:
                SSL Server
            Netscape Comment:
                Easy-RSA Generated Server Certificate
            X509v3 Subject Key Identifier:
                50:31:04:C4:7A:47:C1:DA:46:CC:77:38:DE:1C:63:10:40:C3:80:22
            X509v3 Authority Key Identifier:
                keyid:2D:71:9E:0D:00:4B:5C:23:C8:77:41:77:AF:FE:7C:14:30:A6:8C:2E
                DirName:/C=PH/ST=Tarlac/L=Concepcion/O=JohnFordTV/OU=JohnFordTV/CN=DebianVPN/name=John Ford Mangiliman/emailAddress=admin@johnfordtv.me
                serial:8C:5B:0D:CB:E1:EA:F3:C4

            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Key Usage:
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name:
                DNS:server
    Signature Algorithm: sha256WithRSAEncryption
         87:59:21:fd:7d:41:c8:87:8f:ff:13:85:e9:ae:31:da:43:bc:
         48:3b:32:41:ba:65:82:9e:76:25:cd:43:8b:fc:07:16:49:c3:
         8d:bd:ad:bf:0e:f6:d3:53:35:de:f2:c6:a6:62:c2:79:e1:49:
         a5:ba:55:cf:b9:e9:58:d8:e5:02:96:0a:2a:97:7d:82:85:0b:
         38:b5:dc:0d:6b:bd:51:a6:f7:3f:71:94:90:c9:ad:51:69:15:
         24:58:04:99:96:69:40:9d:a1:9c:1c:a3:34:be:b9:c2:86:61:
         ab:18:03:9b:27:b1:9f:1d:a3:5e:29:47:16:6f:7e:55:62:93:
         57:85:45:34:2c:cb:10:2c:da:f0:9a:ee:3d:b2:92:87:d4:7e:
         1b:c7:66:22:e9:4c:a2:95:d0:df:32:1a:87:ce:8a:27:08:f2:
         87:a9:e6:eb:16:37:71:35:37:4d:8c:0e:df:12:d3:e0:63:0a:
         53:7d:c8:02:c5:34:c5:23:68:c3:ba:33:5b:ad:92:bd:e2:d0:
         9d:bc:bd:bd:0d:64:50:0f:f4:bd:91:fc:10:e0:ec:01:e8:a1:
         50:ed:79:bf:12:49:bc:a4:93:17:d6:71:ed:9e:99:f3:42:6d:
         26:b3:2d:ac:32:62:98:71:d1:e4:83:6c:58:02:e6:49:b6:c9:
         73:76:eb:8b
-----BEGIN CERTIFICATE-----
MIIFfzCCBGegAwIBAgIBATANBgkqhkiG9w0BAQsFADCBtDELMAkGA1UEBhMCUEgx
DzANBgNVBAgTBlRhcmxhYzETMBEGA1UEBxMKQ29uY2VwY2lvbjETMBEGA1UEChMK
Sm9obkZvcmRUVjETMBEGA1UECxMKSm9obkZvcmRUVjESMBAGA1UEAxMJRGViaWFu
VlBOMR0wGwYDVQQpExRKb2huIEZvcmQgTWFuZ2lsaW1hbjEiMCAGCSqGSIb3DQEJ
ARYTYWRtaW5Aam9obmZvcmR0di5tZTAeFw0xOTExMjUwODA2NTlaFw0yOTExMjIw
ODA2NTlaMIG0MQswCQYDVQQGEwJQSDEPMA0GA1UECBMGVGFybGFjMRMwEQYDVQQH
EwpDb25jZXBjaW9uMRMwEQYDVQQKEwpKb2huRm9yZFRWMRMwEQYDVQQLEwpKb2hu
Rm9yZFRWMRIwEAYDVQQDEwlEZWJpYW5WUE4xHTAbBgNVBCkTFEpvaG4gRm9yZCBN
YW5naWxpbWFuMSIwIAYJKoZIhvcNAQkBFhNhZG1pbkBqb2huZm9yZHR2Lm1lMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxm09ZFgI4nCbo1V17Fpunbx8
RfVkxfYjLrAfKC7LYI1xcz3E5vfjNgutnYf1Sy+FX9jJiNmGSlLOKznGuYPgfquO
Hy8RzAgVEmLdjZSxeTxS2csKattki//HQVzM+RhPdBrnwbS4if1WX1xlxCGoCJg9
jjVEs2+TtQFZtDUjmQB5+kTfs0x2vzzk9zk+UOD+hYyg4mOx7KMyzWudWg72ZpKs
bxVeuzpI2T1jlP+c+9L+WhG1GsFsip7TKY3W//yfn6StnaDKK29jR397PJi/FBhs
Njh6w12pWiYoEjOdFxtvL10z57WPVzo6KVdqDp6EemDZnPvH8/iTp81Diew/0wID
AQABo4IBmDCCAZQwCQYDVR0TBAIwADARBglghkgBhvhCAQEEBAMCBkAwNAYJYIZI
AYb4QgENBCcWJUVhc3ktUlNBIEdlbmVyYXRlZCBTZXJ2ZXIgQ2VydGlmaWNhdGUw
HQYDVR0OBBYEFFAxBMR6R8HaRsx3ON4cYxBAw4AiMIHpBgNVHSMEgeEwgd6AFC1x
ng0AS1wjyHdBd6/+fBQwpowuoYG6pIG3MIG0MQswCQYDVQQGEwJQSDEPMA0GA1UE
CBMGVGFybGFjMRMwEQYDVQQHEwpDb25jZXBjaW9uMRMwEQYDVQQKEwpKb2huRm9y
ZFRWMRMwEQYDVQQLEwpKb2huRm9yZFRWMRIwEAYDVQQDEwlEZWJpYW5WUE4xHTAb
BgNVBCkTFEpvaG4gRm9yZCBNYW5naWxpbWFuMSIwIAYJKoZIhvcNAQkBFhNhZG1p
bkBqb2huZm9yZHR2Lm1lggkAjFsNy+Hq88QwEwYDVR0lBAwwCgYIKwYBBQUHAwEw
CwYDVR0PBAQDAgWgMBEGA1UdEQQKMAiCBnNlcnZlcjANBgkqhkiG9w0BAQsFAAOC
AQEAh1kh/X1ByIeP/xOF6a4x2kO8SDsyQbplgp52Jc1Di/wHFknDjb2tvw7201M1
3vLGpmLCeeFJpbpVz7npWNjlApYKKpd9goULOLXcDWu9Uab3P3GUkMmtUWkVJFgE
mZZpQJ2hnByjNL65woZhqxgDmyexnx2jXilHFm9+VWKTV4VFNCzLECza8JruPbKS
h9R+G8dmIulMopXQ3zIah86KJwjyh6nm6xY3cTU3TYwO3xLT4GMKU33IAsU0xSNo
w7ozW62SveLQnby9vQ1kUA/0vZH8EODsAeihUO15vxJJvKSTF9Zx7Z6Z80JtJrMt
rDJimHHR5INsWALmSbbJc3briw==
-----END CERTIFICATE-----
EOF9
 cat <<'EOF10'> /etc/openvpn/server.key
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDGbT1kWAjicJuj
VXXsWm6dvHxF9WTF9iMusB8oLstgjXFzPcTm9+M2C62dh/VLL4Vf2MmI2YZKUs4r
Oca5g+B+q44fLxHMCBUSYt2NlLF5PFLZywpq22SL/8dBXMz5GE90GufBtLiJ/VZf
XGXEIagImD2ONUSzb5O1AVm0NSOZAHn6RN+zTHa/POT3OT5Q4P6FjKDiY7HsozLN
a51aDvZmkqxvFV67OkjZPWOU/5z70v5aEbUawWyKntMpjdb//J+fpK2doMorb2NH
f3s8mL8UGGw2OHrDXalaJigSM50XG28vXTPntY9XOjopV2oOnoR6YNmc+8fz+JOn
zUOJ7D/TAgMBAAECggEBALidRIRKwCFmIfhKeAfqb4aEqp8wXI0un7c9mA970i9I
CijtbHh0ZEqRfPvXViqY0R/HBGM195LJDhb7j2BlSYaxOO7cjVNmpaxQnc+va5vf
uzn1hgC7lQYIeSvgGrkbnDjrG3uHGDcSpLzeq7RamAs/Ee5wszW7dxLuabaXxkH/
owRXl6wvwD1WNGZsWJe8eP6GtBePm9+Ls5VLN0DPWyuJCFxhN/VpvvphECFt7EPF
qY+ysAFqfSYkCyH7OklnLIx1jQ04iLbZ4HI+S9QH+w1261fDgCXAmf1kgXkgLaM6
4wK+e93JRyqw87NZZIKN3ooq35n6wAUaS2erIYQFjrkCgYEA5c6qeNORIuq4F1jP
JS9aaXEjaAKIgw20qTyZfhQv6AhkJ7GASgWSdBIIfZQo1JG4EsXwqQ/0x9EwDOVu
glTYMT3tMi0zrzMklYS1G8iQElywAfTro/8sngfimvkQeRljoNdlrzO4+knUXmV8
DymPDH6UGlhj2FwCFN+obhT1f48CgYEA3QrzBK+YRu6iqeMuifwXlcbUS/A+dBPJ
qoYDzM6Zc0LYRTZSqhEHC8XkcQp/18LUxXFSrZXP2lcKmkqg4pgeAxALRLJW2pfz
yAm1Hah5JXlvTjX4HnMTFL4fvB0oGZXsAimPNa/wUZvTSPYJRziZdEwVubW3AAxE
THN3qxXoGX0CgYAWeSxwnnf+CygvmE7BmyzjTN4iiMTi1A9L0ZJNIxpAPbnVq+UY
2AynbzAHX9rSVuHCbDsJvXa5p7pkOHejJTrzLdQpaQQ56O119cFkUyvLr+bCejol
EopBdhHyB9NVlGcKzqWyCYPYbinnhVMphG3p0eMX5Hb3LKBDfE/TXBdZ/wKBgEwe
3iup8M3Ulk3c/4TjPJgGvctc85Tzz4oa1qosJ6oKxgGnwHXyoTOLtay8CeSaor1P
1kITCl5NhUg3FQqTihpR5x+ELubeV0R3G1kYUIf4Nr1/Vm/d/x8wjisw+0M8Xucr
urapXSAtgmho2i8drbLgFMc8bcXlc4vEY9yWEbTdAoGAMa6KTb0U9M47mpJb23zu
WiO8mFqSPYAnhHmXOiBOPlCoVpRbPquk3Xq32g9KU97jPNrH4X2HKgYpboMTWYOJ
kR3Y5UeFF1xurA/RXUEREcP1zg6Uei5aj7S4Sp7CVfIQCOpJ8S/I4CZdAcvwY+pI
ZTC1+KZJbFyPwFcrIylEeBc=
-----END PRIVATE KEY-----
EOF10
 cat <<'EOF13'> /etc/openvpn/dh2048.pem
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEAlrn8QcDrwXzqWCI7NMhPJVgEjdSxvyHw3EDVN8JrVfMegnvZA0VZ
St3hduXTzlT7ceUGIxTJpM8RE6d3f1mMPnZJ4hBxJzzjrwMgSCupJrQDjSAIWGLZ
elcmJS6WOAibpxzFIiPB6pRjoLaJF8b/J+YnO0bLUt1senWkg9ql8mU74VM1aG3A
jOPztpLqYIRwla11bqAl4UcFLBI+PXAcPJsAIfzZ3DMn7aOa3Or6UjSmVQ8jGY/8
1F0T67NgB8U7FrOVNimRlWfSJ//FiJkP0PScHVX2NQ0Cgwdo+wekjoFN5xbPxicc
LxNkdRPpCACgzdo1M77xVsurtfcxsz+RswIBAg==
-----END DH PARAMETERS-----
EOF13

 # Getting all dns inside resolv.conf then use as Default DNS for our openvpn server
 grep -v '#' /etc/resolv.conf | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read -r line; do
	echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server_tcp.conf
done

 # Creating a New update message in server.conf
 cat <<'NUovpn' > /etc/openvpn/server.conf
 # New Update are now released, OpenVPN Server
 # are now running both TCP and UDP Protocol. (Both are only running on IPv4)
 # But our native server.conf are now removed and divided
 # Into two different configs base on their Protocols:
 #  * OpenVPN TCP (located at /etc/openvpn/server_tcp.conf
 #  * OpenVPN UDP (located at /etc/openvpn/server_udp.conf
 # 
 # Also other logging files like
 # status logs and server logs
 # are moved into new different file names:
 #  * OpenVPN TCP Server logs (/etc/openvpn/tcp.log)
 #  * OpenVPN UDP Server logs (/etc/openvpn/udp.log)
 #  * OpenVPN TCP Status logs (/etc/openvpn/tcp_stats.log)
 #  * OpenVPN UDP Status logs (/etc/openvpn/udp_stats.log)
 #
 # Server ports are configured base on env vars
 # executed/raised from this script (OpenVPN_TCP_Port/OpenVPN_UDP_Port)
 #
 # Enjoy the new update
 # Script Updated by JohnFordTV
NUovpn

 # setting openvpn server port
 sed -i "s|OVPNTCP|$OpenVPN_TCP_Port|g" /etc/openvpn/server_tcp.conf
 sed -i "s|OVPNUDP|$OpenVPN_UDP_Port|g" /etc/openvpn/server_udp.conf
 
 # Getting some OpenVPN plugins for unix authentication
 cd
 wget https://github.com/johndesu090/AutoScriptDB/raw/master/Files/Plugins/plugin.tgz
 tar -xzvf /root/plugin.tgz -C /etc/openvpn/
 rm -f plugin.tgz
 
 # Some workaround for OpenVZ machines for "Startup error" openvpn service
 if [[ "$(hostnamectl | grep -i Virtualization | awk '{print $2}' | head -n1)" == 'openvz' ]]; then
 sed -i 's|LimitNPROC|#LimitNPROC|g' /lib/systemd/system/openvpn*
 systemctl daemon-reload
fi

 # Allow IPv4 Forwarding
 sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.conf
 sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.d/*.conf
 echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/20-openvpn.conf
 sysctl --system &> /dev/null

 # Iptables Rule for OpenVPN server
 cat <<'EOFipt' > /etc/openvpn/openvpn.bash
#!/bin/bash
PUBLIC_INET="$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)"
IPCIDR='10.200.0.0/16'
IPCIDR2='10.201.0.0/16'
iptables -I FORWARD -s $IPCIDR -j ACCEPT
iptables -I FORWARD -s $IPCIDR2 -j ACCEPT
iptables -t nat -A POSTROUTING -o $PUBLIC_INET -j MASQUERADE
iptables -t nat -A POSTROUTING -s $IPCIDR -o $PUBLIC_INET -j MASQUERADE
iptables -t nat -A POSTROUTING -s $IPCIDR2 -o $PUBLIC_INET -j MASQUERADE
EOFipt
 chmod +x /etc/openvpn/openvpn.bash
 bash /etc/openvpn/openvpn.bash

 # Enabling IPv4 Forwarding
 echo 1 > /proc/sys/net/ipv4/ip_forward
 
 # Starting OpenVPN server
 systemctl start openvpn@server_tcp
 systemctl enable openvpn@server_tcp
 systemctl start openvpn@server_udp
 systemctl enable openvpn@server_udp
 
 #config
 
cat <<EOF16> /var/www/openvpn/vpnstunnel.ovpn
# JohnFordTV's VPN Premium Script
# © Github.com/johndesu090
# Official Repository: https://github.com/johndesu090/AutoScriptDB
# For Updates, Suggestions, and Bug Reports, Join to my Messenger Groupchat(VPS Owners): https://m.me/join/AbbHxIHfrY9SmoBO
# For Donations, Im accepting prepaid loads or GCash transactions:
# Smart: 09206200840
# Facebook: https://fb.me/johndesu090
# Thanks for using this script, Enjoy Highspeed OpenVPN Service
client
dev tun
proto tcp
setenv FRIENDLY_NAME "VPNstunnel"
remote $IPADDR 110
remote-cert-tls server
connect-retry infinite
resolv-retry infinite
nobind
persist-key
persist-tun
auth-user-pass
auth none
auth-nocache
cipher none
comp-lzo
redirect-gateway def1
setenv CLIENT_CERT 0
reneg-sec 0
verb 1
http-proxy $IPADDR 8080

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
EOF16

cat <<EOF162> /var/www/openvpn/vpnudp.ovpn
# JohnFordTV's VPN Premium Script
# © Github.com/johndesu090
# Official Repository: https://github.com/johndesu090/AutoScriptDB
# For Updates, Suggestions, and Bug Reports, Join to my Messenger Groupchat(VPS Owners): https://m.me/join/AbbHxIHfrY9SmoBO
# For Donations, Im accepting prepaid loads or GCash transactions:
# Smart: 09206200840
# Facebook: https://fb.me/johndesu090
# Thanks for using this script, Enjoy Highspeed OpenVPN Service
client
dev tun
proto udp
setenv FRIENDLY_NAME "Debian VPN SUN"
remote $IPADDR 2500
remote-cert-tls server
resolv-retry infinite
float
fast-io
nobind
persist-key
persist-remote-ip
persist-tun
auth-user-pass
auth none
auth-nocache
cipher none
comp-lzo
redirect-gateway def1
setenv CLIENT_CERT 0
reneg-sec 0
verb 1

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
EOF162

# Creating OVPN download site index.html
cat <<'mySiteOvpn' > /var/www/openvpn/index.html
<!DOCTYPE html>
<html lang="en">

<!-- Simple OVPN Download site by JohnFordTV -->

<head><meta charset="utf-8" /><title>JohnFordTV OVPN Config Download</title><meta name="description" content="MyScriptName Server" /><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" /><meta name="theme-color" content="#000000" /><link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css"><link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet"><link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.3/css/mdb.min.css" rel="stylesheet"></head><body><div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;"><div class="col-md"><div class="view"><img src="https://openvpn.net/wp-content/uploads/openvpn.jpg" class="card-img-top"><div class="mask rgba-white-slight"></div></div><div class="card"><div class="card-body"><h5 class="card-title">Config List</h5><br /><ul class="list-group"><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> UDP Server For TU/CTC/CTU Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/sun-tuudp.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> TCP+Proxy Server For TU/CTC/CTU Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/sun-tuudp.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Globe/TM <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For EasySURF/GoSURF/GoSAKTO Promos with WNP,SNS,FB and IG freebies</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/gtmwnp.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Modem</span><br /><small> Without Promo/Noload (Reconnecting Server, Use Low-latency VPS for fast reconnectivity)</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/sun-noload.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li></ul></div></div></div></div></body></html>
mySiteOvpn
 
 # Setting template's correct name,IP address and nginx Port
 sed -i "s|NGINXPORT|$OvpnDownload_Port|g" /var/www/openvpn/index.html
 sed -i "s|IP-ADDRESS|$IPADDR|g" /var/www/openvpn/index.html

 # Restarting nginx service
 systemctl restart nginx
 
 # Creating all .ovpn config archives
 cd /var/www/openvpn
 zip -qq -r configs.zip *.ovpn
 cd
}

function ip_address(){
  local IP="$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )"
  [ -z "${IP}" ] && IP="$( wget -qO- -t1 -T2 ipv4.icanhazip.com )"
  [ -z "${IP}" ] && IP="$( wget -qO- -t1 -T2 ipinfo.io/ip )"
  [ ! -z "${IP}" ] && echo "${IP}" || echo
} 
IPADDR="$(ip_address)"

# Creating startup script using cat eof tricks
 cat <<'EOFSH' > /etc/johnfordtv/startup.sh
#!/bin/bash
# Setting server local time
ln -fs /usr/share/zoneinfo/MyVPS_Time /etc/localtime

# Prevent DOS-like UI when installing using APT (Disabling APT interactive dialog)
export DEBIAN_FRONTEND=noninteractive

# Allowing ALL TCP ports for our machine (Simple workaround for policy-based VPS)
iptables -A INPUT -s $(wget -4qO- http://ipinfo.io/ip) -p tcp -m multiport --dport 1:65535 -j ACCEPT

# Allowing OpenVPN to Forward traffic
/bin/bash /etc/openvpn/openvpn.bash

# Deleting Expired SSH Accounts
/usr/local/sbin/delete_expired &> /dev/null
exit 0
EOFSH
 chmod +x /etc/johnfordtv/startup.sh
 
 # Setting server local time every time this machine reboots
 sed -i "s|MyVPS_Time|$MyVPS_Time|g" /etc/johnfordtv/startup.sh

 # 
 rm -rf /etc/sysctl.d/99*

 # Setting our startup script to run every machine boots 
 cat <<'FordServ' > /etc/systemd/system/johnfordtv.service
[Unit]
Description=JohnfordTV Startup Script
Before=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/johnfordtv/startup.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
FordServ
 chmod +x /etc/systemd/system/johnfordtv.service
 systemctl daemon-reload
 systemctl start johnfordtv
 systemctl enable johnfordtv &> /dev/null
 systemctl enable fail2ban &> /dev/null
 systemctl start fail2ban &> /dev/null

 # Rebooting cron service
 systemctl restart cron
 systemctl enable cron
 
}
 #Create Admin
 useradd -m admin
 echo "admin:kopet" | chpasswd
 
# install squid3
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 442
acl Safe_ports port 443
acl Safe_ports port 444
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
http_port 8000
http_port 80
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname ZhangZi
END
sed -i $MYIP2 /etc/squid/squid.conf;
/etc/init.d/squid.restart

# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/emue25/cream/mei/bannerssh"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://github.com/emue25/AutoScriptDebianStretch/raw/master/Files/Plugins/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://github.com/emue25/AutoScriptDebianStretch/raw/master/Files/Plugins/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# Configure Stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -subj '/CN=127.0.0.1/O=localhost/C=PH' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
cat > /etc/stunnel/stunnel.conf <<-END
sslVersion = all
pid = /stunnel.pid
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
client = no

[dropbear]
accept = 443
connect = 127.0.0.1:442
cert = /etc/stunnel/stunnel.pem
END

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j SNAT --to-source xxxxxxxxx
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:fail2ban-ssh - [0:0]
-A INPUT -p tcp -m multiport --dports 22 -j fail2ban-ssh
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 143  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 442  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 444  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 587  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 55  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 55  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8085  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8085  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8888  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8888  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8080  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8080  -m state --state NEW -j ACCEPT 
-A INPUT -p tcp --dport 7300  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 7300  -m state --state NEW -j ACCEPT 
-A INPUT -p tcp --dport 10000  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 587 -j ACCEPT
-A OUTPUT -p tcp --dport 6881:6889 -j DROP
-A OUTPUT -p udp --dport 1024:65534 -j DROP
-A FORWARD -m string --string "get_peers" --algo bm -j DROP
-A FORWARD -m string --string "announce_peer" --algo bm -j DROP
-A FORWARD -m string --string "find_node" --algo bm -j DROP
-A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
-A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
-A FORWARD -m string --algo bm --string "peer_id=" -j DROP
-A FORWARD -m string --algo bm --string ".torrent" -j DROP
-A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
-A FORWARD -m string --algo bm --string "torrent" -j DROP
-A FORWARD -m string --algo bm --string "announce" -j DROP
-A FORWARD -m string --algo bm --string "info_hash" -j DROP
-A fail2ban-ssh -j RETURN
COMMIT
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
END
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules


# Create and Configure rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
exit 0
END
chmod +x /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local

# Configure menu
apt-get -y remove --purge unscd
apt-get -y install dnsutils
apt-get -y install unzip
cd /usr/local/bin/
wget "https://github.com/emue25/cream/raw/mei/menu.zip"
unzip menu.zip
chmod +x /usr/local/bin/*

# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip
unzip master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/master.zip
# cronjob
echo "02 */12 * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "00 23 * * * root /usr/bin/disable-user-expire" > /etc/cron.d/disable-user-expire
echo "0 */12 * * * root /sbin/reboot" > /etc/cron.d/reboot
echo "00 01 * * * root echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a" > /etc/cron.d/clearcacheram3swap
echo "*/3 * * * * root /usr/bin/clearcache.sh" > /etc/cron.d/clearcache1
# add eth0 to vnstat
vnstat -u -i eth0

# install libxml-parser
apt-get install libxml-parser-perl -y -f

# finalizing
vnstat -u -i eth0
apt-get -y autoremove
chown -R www-data:www-data /home/vps/public_html
#/etc/init.d/nginx start
/etc/init.d/php7.3-fpm start
/etc/init.d/vnstat restart
#/etc/init.d/openvpn restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/squid restart

#clearing history
history -c
rm -rf /root/*
cd /root
# info
clear
echo " "
echo "Installation has been completed!!"
echo " Please Reboot your VPS"
echo "--------------------------- Configuration Setup Server -------------------------"
echo "                       Debian9 Script HostingTermurah Based                      "
echo "                                 -modifikasi by zhangzi-                                   "
echo "--------------------------------------------------------------------------------"
echo ""  | tee -a log-install.txt
echo "Server Information"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Malingsial asu (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban    : [ON]"  | tee -a log-install.txt
echo "   - IPtables    : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF]"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN		: TCP 55 "  | tee -a log-install.txt
echo "   - OpenVPN-SSL   	: 444 "  | tee -a log-install.txt
echo "   - Dropbear		: 442"  | tee -a log-install.txt
echo "   - Stunnel		: 443"  | tee -a log-install.txt
echo "   - BadVPN  	: 7300"  | tee -a log-install.txt
echo "   - Squid Proxy	: 8080, 8000, 3128, 80 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Nginx		: 85"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Premium Script Information"  | tee -a log-install.txt
echo "   To display list of commands: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Important Information"  | tee -a log-install.txt
echo "   - Download Config OpenVPN : http://$MYIP/configs.zip"  | tee -a log-install.txt
echo "   - Installation Log        : cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - Webmin                  : http://$MYIP:10000/"  | tee -a log-install.txt
echo ""
echo "------------------------------ Script by ZhangZi -----------------------------"
echo "-----Please Reboot your VPS -----"
sleep 5
