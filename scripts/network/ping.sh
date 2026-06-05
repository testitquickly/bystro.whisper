# Список IP-адресов, которые нужно пропинговать
IPs=("192.168.50.11" "192.168.50.12" "192.168.50.16" "192.168.50.17" "192.168.50.18" "192.168.100.8" "192.168.100.9")

# Пытаемся пинговать каждый IP
for ip in "${IPs[@]}"; do
    if ping -c 1 "$ip" &> /dev/null; then
        echo -e "\nСвязался с $ip Посылаю аудиосигнал."
        ssh astenix@$ip -i $ssh_keys 'paplay /usr/share/sounds/Oxygen-Sys-Log-In-Short.ogg'
        break
    else
        echo "Не нашёл ноутбук в сети."
    fi
done