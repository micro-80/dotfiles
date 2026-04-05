#!/usr/bin/env bash

BATTERY_EVENT_PREFIX="BAT|"
BATTERY_PERCENTAGE=0
BATTERY_STATE=""
function output_battery_info() {
    local state_output=""
    local battery_output="$BATTERY_PERCENTAGE"

    if [[ $BATTERY_STATE == "charging" || $BATTERY_STATE == "pending-charge" ]]; then
	battery_output="<span foreground='green'>$BATTERY_PERCENTAGE</span>"
    elif [[ $BATTERY_PERCENTAGE -lt 15 ]]; then
	battery_output="<span foreground='red'>$BATTERY_PERCENTAGE</span>"
    fi
    echo "BAT: $battery_output"
}
function get_initial_battery_info() {
    local upower_detail=$(upower -d)
    BATTERY_PERCENTAGE=$(echo "$upower_detail" | grep "percentage" | head -n1 | awk '{print $2}')
    BATTERY_STATE=$(echo "$upower_detail" | grep "state" | head -n1 | awk '{print $2}')
    output_battery_info
}
function module_battery() {
    #TODO: filter duplicates then maybe do upower -e?
    while read -r event; do
	if [[ $event =~ ^percentage.* ]]; then
	    BATTERY_PERCENTAGE=$(echo "$event" | head -n1 | awk '{print $2}')
	elif [[ $event =~ ^state.* ]]; then
	    BATTERY_STATE=$(echo "$event" | head -n1 | awk '{print $2}')
	fi
	echo "$BATTERY_EVENT_PREFIX $(output_battery_info)"
    done < <(upower --monitor-detail | grep --line-buffered -E "percentage|state")
}

CLOCK_EVENT_PREFIX="CLOCK|"
function get_time() {
    echo "$(date +'%a %F %H:%M:%S')"
}
function module_clock() {
    while true; do
	echo "$CLOCK_EVENT_PREFIX $(get_time)"
	sleep 1
    done
}

NETWORK_EVENT_PREFIX="NET|"
function get_network() {
    local network=$(nmcli -t -f NAME connection show --active | head -n1)
    if [[ $network == "lo" ]]; then
	echo "Disconnected"
    else
	echo "NETWORK: $network"	
    fi
}
function module_network() {
    while read -r line; do
	echo "$NETWORK_EVENT_PREFIX $(get_network)"
    done < <(nmcli monitor | grep --line-buffered "primary connection")
}

PW_SINK_EVENT_PREFIX="PW_SINK|"
PW_SOURCE_EVENT_PREFIX="PW_SOURCE|"
function get_pw_volume_info() {
    local source=$1
    local volume_output=$(wpctl get-volume $source)
    local volume=$(echo "$volume_output" | awk '{print $2 * 100 "%"}')
    local mute_status=$(echo "$volume_output" | awk '{print $3}')
    #local node_description=$(wpctl inspect $source | grep "node.description" | awk -F' = ' '{print $2}'  | tr -d '"')
    if [[ $mute_status == "[MUTED]" ]]; then
	volume="$mute_status"
    fi
    echo "$volume"
}
function get_pw_sink_info() {
    echo "VOL: $(get_pw_volume_info @DEFAULT_AUDIO_SINK@)"
}
function get_pw_source_info() {
    echo "MIC: $(get_pw_volume_info @DEFAULT_AUDIO_SOURCE@)"
}
function module_pipewire_sink() {
    while read -r event; do
	echo "$PW_SINK_EVENT_PREFIX $(get_pw_sink_info)"
    done < <(pactl subscribe | grep --line-buffered "^Event 'change' on sink")
}
function module_pipewire_source() {
    while read -r event; do
	echo "$PW_SOURCE_EVENT_PREFIX $(get_pw_source_info)"
    done < <(pactl subscribe | grep --line-buffered "^Event 'change' on source")
}

# wait for wireplumber
while ! pgrep -x wireplumber >/dev/null; do
    sleep 0.1
done

BATTERY=$(get_initial_battery_info)
NETWORK=$(get_network)
TIME=$(get_time)
PW_SINK_VOLUME=$(get_pw_sink_info)
PW_SOURCE_VOLUME=$(get_pw_source_info)

while read -r line; do
    #echo $line
    case $line in
	$BATTERY_EVENT_PREFIX*)
	BATTERY=${line#"$BATTERY_EVENT_PREFIX "}
	;;
	$CLOCK_EVENT_PREFIX*)
	TIME=${line#"$CLOCK_EVENT_PREFIX "}
	;;
	$NETWORK_EVENT_PREFIX*)
	NETWORK=${line#"$NETWORK_EVENT_PREFIX "}
	;;
	$PW_SINK_EVENT_PREFIX*)
	PW_SINK_VOLUME=${line#"$PW_SINK_EVENT_PREFIX "}
	;;
	#$PW_SOURCE_EVENT_PREFIX*)
	#PW_SOURCE_VOLUME=${line#"$PW_SOURCE_EVENT_PREFIX "}
	#;;
    esac
    echo "$PW_SINK_VOLUME | $NETWORK | $BATTERY | $TIME"
done < <(
    module_battery &
    module_clock &
    module_network &
    module_pipewire_sink &
    #module_pipewire_source &
    wait
     )
