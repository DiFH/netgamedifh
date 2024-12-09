#!/system/bin/sh

# Display script info
ver="1.0"
cat << EOF

[ $0 ] Ver : $ver
Created by @Diffhgans
Dm me for Feedback

EOF

echo ""
echo "* Project Network And Game *"
echo ""
sleep 2
echo "[ > ] Detected $Info"
sleep 2
echo "[ > ] Installing Disable Network And Game In the Background"
sleep 2

{
# Aktifkan Vulkan
setprop debug.vulkan.layers VK_LAYER_KHRONOS_validation

#Aktifkan SkiaGL
setprop debug.hwui.renderer skiagl

# Aktifkan mode game
setprop debug.hwui.gsync 1
setprop debug.hwui.vsync 1

# Mengaktifkan mode gaming
settings put global low_power 0
settings put global power_save 0

# Mengoptimalkan jaringan
settings put global wifi_watchdog_on 0
settings put global mobile_data_always_on 1

# Mengaktifkan fitur IPv6
settings put global ipv6_addr_gen_mode 1


# Mengaktifkan fitur GPU boost (jika didukung)
dumpsys gpuinfo boost 1
sysctl -w cpu.turbo_boost=1
dumpsys gfxinfo --enable


#Tingkatkan kecepatan prosesor (terbatas)
settings put global performance_mode 1

#Matikan aplikasi latar belakang
am kill-all

# Matikan animasi
settings put global window_animation_scale 0
settings put global transition_animation_scale 0
settings put global animator_duration_scale 0


# Mengatur sensitivitas touchscreen
dumpsys input_method set_touch_sensitivity 1.5
settings put global touch_exploration_enabled 1
settings put global multi_touch_enabled 1
settings put global touch_screen_auto_calibration 1
settings put global touch_screen_calibration_enabled 1

# Mengaktifkan fitur gesture
settings put global gesture_button 1
settings put global gesture_mode_enabled 1
dumpsys input_method set_gesture_enabled 1

# NetworkStatus

# Mengatur buffer jaringan
sysctl -w net.core.rmem_max=67108864
sysctl -w net.core.wmem_max=67108864

# Mengaktifkan Multipath TCP
sysctl -w net.mptcp.enabled=1

# Mengatur DNS Google
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Mengatur DNS Cloudflare
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf

# Mengaktifkan TCP Fast Open
sysctl -w net.ipv4.tcp_fastopen=3

# Mengaktifkan TCP BBR
sysctl -w net.ipv4.tcp_congestion_control=bbr
settings put global show_network_speed true

# Mengatur Refresh Rate
settings put system screen_off_timeout 30000
settings put system screen_brightness_mode 1
settings put system screen_brightness 255
settings put system refresh_rate 120
} >/dev/null 2>&1 &


# Ensure a game package argument is provided
if [ -z "$1" ]; then
    echo "Game package name is required as an argument."
    exit 1
fi

# Get the full package name of the game
game=$(pm list packages | grep -i "$1" | sed 's/package://g')
if [ -z "$game" ]; then
    echo "No matching package found for '$1'."
    exit 1
else
    echo "App Detected As [ $game ]"
fi

# Apply Cmd Game Mode to Targeted App
cmd device_config put game_overlay "$game" mode=2,downscaleFactor=0.7,fps=240,useAngle=true,LoadingBoost=1
if [ $? -eq 0 ]; then
  echo "┌ Succes Network Installed ! ┐"
else
  echo "┌ Failed to Installed Gmode ┐"
fi




# Menampilkan Fps

case "$1" in
  "run")
    while true; do
     cp /sdcard/netgamedifh/prop/FPS /data/local/tmp && chmod +x /data/local/tmp/FPS &&
     nohup /data/local/tmp/FPS > /dev/null 2>&1
     sleep 30
    done &
    echo "Lattest FPS is Now Running !"
    ;;
   "stop")
    pkill -9 $(ps -ef | grep FPS)
    echo "Lattest FPS is Now Stopped !"
    ;;
    *)
    ;;
esac

# NetSpeed
case "$1" in
  "run")
    while true; do
      cp /sdcard/netgamedifh/prop/Net /data/local/tmp && chmod +x /data/local/tmp/Net
      nohup /data/local/tmp/Net > /dev/null 2>&1
      sleep 30
    done &
    echo "Net Speed is Now Running !"
    ;;
  "stop")
    pkill -9 $(ps -ef | grep "Net")
    echo "Net Speed is Now Stopped !"
    ;;
    *)
esac


# Post a notification about the launch
cmd notification post  -t "NetworkAndGame - Difhstore" -S inbox \
    --line "NetGame Installed !" \
    --line "Dm me for Feedback and Erorr" \
    --line "Telegram : @Difhstore" \
    myTag "Must Read !" >/dev/null
    
# Post A notifixation about the launch
cmd notification post -t "Download: $(printf '%.2fMB/s' "$SPEEDd") Upload: $(printf '%.2fMB/s' "$SPEEDu")" -S inbox \
  --line "File size: 1 MB" \
  --line "Time : $(date '+%H:%M')" \
  myTagNspeed "@Difhgans" >/dev/null
  
# Menampilkan hasil FPS terbaru melalui cmd notification
cmd notification post -t "Latest FPS | $fps_display" -S inbox \
  --line "Avarage FPS" \
  myTagFPS "@Difhgans" >/dev/null
