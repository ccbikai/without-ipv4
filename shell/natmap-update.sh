#!/bin/sh

# from: https://gist.github.com/veltlion/b59d73654f0ae36725f5a571602729cb

# NATMap

outter_ip=$1
outter_port=$2
inner_ip=$3
inner_port=$4
protocol=$5

logger -t "NATMap" "[NATMap] start NAT : ${protocol}: ${outter_ip}:${outter_port} to ${inner_port}"

case ${inner_port} in
  # qBittorrent
  9001)
    sleep 1
    qbv4="10.10.10.100"
    qbwebport="9091"
    qbusername="mt"
    qbpassword="chimiantiaome"
    # ipv4 redirect
    uci set firewall.redirectqbv41=redirect
    uci set firewall.redirectqbv41.name='qBittorrent9091'
    uci set firewall.redirectqbv41.proto='tcp'
    uci set firewall.redirectqbv41.src='wan'
    uci set firewall.redirectqbv41.dest='lan'
    uci set firewall.redirectqbv41.target='DNAT'
    uci set firewall.redirectqbv41.src_dport="${inner_port}"
    uci set firewall.redirectqbv41.dest_ip="${qbv4}"
    uci set firewall.redirectqbv41.dest_port="${outter_port}"
    # reload
    uci commit firewall
    /etc/init.d/firewall reload > /dev/null
    sleep 3
    # update port
    qbcookie=$(\
      curl -Ssi -X POST \
        -d "username=${qbusername}&password=${qbpassword}" \
        "http://${qbv4}:${qbwebport}/api/v2/auth/login" | \
      sed -n 's/.*\(SID=.\{32\}\);.*/\1/p' )
    curl -X POST \
      -s \
      -b "${qbcookie}" \
      -d 'json={"listen_port":"'${outter_port}'"}' \
      "http://${qbv4}:${qbwebport}/api/v2/app/setPreferences"
    text="[NATMap] qBittorrent TCP Port: ${outter_ip}:${outter_port} to ${inner_port} to $(uci get firewall.redirectqbv41.dest_ip):$(uci get firewall.redirectqbv41.dest_port)"
    ;;
  # qBittorrent
  # 9002)
  #   sleep 10
  #   qbv4="10.10.10.100"
  #   qbwebport="9092"
  #   qbusername="mt"
  #   qbpassword="chimiantiaome"
  #   # ipv4 redirect
  #   uci set firewall.redirectqbv42=redirect
  #   uci set firewall.redirectqbv42.name='qBittorrent9092'
  #   uci set firewall.redirectqbv42.proto='tcp'
  #   uci set firewall.redirectqbv42.src='wan'
  #   uci set firewall.redirectqbv42.dest='lan'
  #   uci set firewall.redirectqbv42.target='DNAT'
  #   uci set firewall.redirectqbv42.src_dport="${inner_port}"
  #   uci set firewall.redirectqbv42.dest_ip="${qbv4}"
  #   uci set firewall.redirectqbv42.dest_port="${outter_port}"
  #   # reload
  #   uci commit firewall
  #   /etc/init.d/firewall reload > /dev/null
  #   sleep 3
  #   # update port
  #   qbcookie=$(\
  #     curl -Ssi -X POST \
  #       -d "username=${qbusername}&password=${qbpassword}" \
  #       "http://${qbv4}:${qbwebport}/api/v2/auth/login" | \
  #     sed -n 's/.*\(SID=.\{32\}\);.*/\1/p' )
  #   curl -X POST \
  #     -s \
  #     -b "${qbcookie}" \
  #     -d 'json={"listen_port":"'${outter_port}'"}' \
  #     "http://${qbv4}:${qbwebport}/api/v2/app/setPreferences"
  #   text="[NATMap] qBittorrent TCP Port: ${outter_ip}:${outter_port} to ${inner_port} to $(uci get firewall.redirectqbv42.dest_ip):$(uci get firewall.redirectqbv42.dest_port)"
  #   ;;
  *)
    text="[NATMap] not NAT: ${protocol}: ${outter_ip}:${outter_port} to ${inner_port}"
    ;;
esac

if [ "${text}" ]; then
  logger -t "NATMap" "${text}"
  # 通知端口信息到 Bark, 不需要可以注释掉下面的 curl
  curl -Ss -o /dev/null -X POST \
    -H 'Content-Type: application/json' \
    -d '{"title": "NATMap", "body": "'"${text}"'"}' \
    "https://api.day.app/BARK_KEY" # Bark API
fi

logger -t "NATMap" "[NATMap] ${inner_port} NAT end"