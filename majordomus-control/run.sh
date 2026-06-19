#!/usr/bin/with-contenv bashio

# Read options from HA add-on configuration
MQTT_HOST=$(bashio::config 'mqtt_host')
MQTT_PORT=$(bashio::config 'mqtt_port')
MQTT_USER=$(bashio::config 'mqtt_user')
MQTT_PASS=$(bashio::config 'mqtt_password')
MQTT_TOPIC=$(bashio::config 'mqtt_topic')
HA_DISCOVERY=$(bashio::config 'ha_discovery')
HA_TOPIC=$(bashio::config 'ha_topic')

# Export env vars for the Java application
export MQTT_BROKER="tcp://${MQTT_HOST}:${MQTT_PORT}"
export MQTT_USERNAME="${MQTT_USER}"
export MQTT_PASSWORD="${MQTT_PASS}"
export MQTT_TOPIC="${MQTT_TOPIC}"
export HA_DISCOVERY="${HA_DISCOVERY}"
export HA_TOPIC="${HA_TOPIC}"

# Config file in persistent HA config volume
export CONFIG_PATH="/config/majordomus-control/config.xml"
mkdir -p /config/majordomus-control

bashio::log.info "Starting Majordomus Control..."
bashio::log.info "MQTT broker: tcp://${MQTT_HOST}:${MQTT_PORT}"
bashio::log.info "Config: ${CONFIG_PATH}"

exec java -jar /app/app.jar
