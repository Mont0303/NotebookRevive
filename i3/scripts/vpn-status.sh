#!/bin/bash
# =========================================================
# VPN Status Script para Polybar (Cyberdeck)
# Mostra o IP do tun0 (TryHackMe / HackTheBox / OpenVPN)
# =========================================================

IP=$(ip -4 addr show dev tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

if [ -n "$IP" ]; then
    echo "%{F#ff9e3b}VPN $IP%{F-}"
else
    echo "%{F#70624e}VPN OFF%{F-}"
fi
