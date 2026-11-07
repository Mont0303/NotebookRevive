#!/bin/bash
# =========================================================
# Monitor Térmico, Frequência e Throttling para o Cyberdeck
# Permite validar o cooler de CPU adaptado com bateria
# =========================================================

clear
echo -e "\033[1;32m╔══════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║       CYBERDECK MONITOR TÉRMICO & CLOCK          ║\033[0m"
echo -e "\033[1;32m╚══════════════════════════════════════════════════╝\033[0m"
echo -e "\033[0;36mPressione Ctrl+C para sair\033[0m\n"

while true; do
    tput cup 4 0
    echo -e "\033[1;37mHorário:\033[0m $(date '+%H:%M:%S')"
    echo -e "──────────────────────────────────────────────────"
    
    # Temperaturas dos sensores térmicos
    echo -e "\033[1;32m[ Sensores de Temperatura ]\033[0m"
    found_temp=false
    if [ -d /sys/class/thermal ]; then
        for zone in /sys/class/thermal/thermal_zone*; do
            [ -e "$zone" ] || continue
            type=$(cat "$zone/type" 2>/dev/null)
            temp_raw=$(cat "$zone/temp" 2>/dev/null)
            if [ -n "$temp_raw" ]; then
                found_temp=true
                temp_c=$((temp_raw / 1000))
                if [ $temp_c -ge 75 ]; then
                    echo -e "  $type: \033[1;31m${temp_c}°C [ALERTA: QUENTE!]\033[0m       "
                elif [ $temp_c -ge 60 ]; then
                    echo -e "  $type: \033[1;33m${temp_c}°C [MODERADO]\033[0m             "
                else
                    echo -e "  $type: \033[1;32m${temp_c}°C [COOLER EFICIENTE]\033[0m     "
                fi
            fi
        done
    fi
    if [ "$found_temp" = false ]; then
        echo -e "  Nenhum sensor ACPI acessível diretamente.        "
    fi
    echo -e "──────────────────────────────────────────────────"
    
    # Frequência dos 4 núcleos da CPU (Atom x5-Z8350)
    echo -e "\033[1;32m[ Frequência dos Núcleos (Intel Atom x5-Z8350) ]\033[0m"
    for cpu in /sys/devices/system/cpu/cpu[0-3]; do
        [ -e "$cpu" ] || continue
        cpuid=$(basename "$cpu")
        freq_raw=$(cat "$cpu/cpufreq/scaling_cur_freq" 2>/dev/null)
        if [ -n "$freq_raw" ]; then
            freq_mhz=$((freq_raw / 1000))
            if [ $freq_mhz -le 500 ]; then
                echo -e "  $cpuid: \033[1;31m${freq_mhz} MHz [THROTTLING ATIVO!]\033[0m       "
            elif [ $freq_mhz -ge 1800 ]; then
                echo -e "  $cpuid: \033[1;32m${freq_mhz} MHz [BOOST MÁXIMO]\033[0m          "
            else
                echo -e "  $cpuid: \033[0;32m${freq_mhz} MHz\033[0m                        "
            fi
        fi
    done
    echo -e "──────────────────────────────────────────────────"
    
    # Consumo e bateria (se presente)
    if [ -d /sys/class/power_supply/BAT0 ]; then
        bat_status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        bat_cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        echo -e "\033[1;32m[ Bateria Interna ]\033[0m: $bat_cap% ($bat_status)         "
        echo -e "──────────────────────────────────────────────────"
    fi

    sleep 1.5
done
