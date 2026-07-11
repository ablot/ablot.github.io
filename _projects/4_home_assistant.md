---
layout: page
title: Turning on the light
description: Installation of Home Assistant and integration with Lutron Grafik Eye 3000
img: assets/img/home_assistant_lutron/thumbnail.png
importance: 1
category: home-automation
giscus_comments: true
related_publications: false
---

After two years in a new flat, I still haven't found a way to turn on/off the lights in 
the staircase without changing all the other lights in the house. I recently started my journey into home automation, with the main goal of integrating my legacy **Lutron Grafik Eye 3000** system into **Home Assistant**.

## The Goal

The Lutron Grafik Eye 3000 is a fantastic, robust lighting controller, but it's from an era where "smart" meant RS232 commands rather than Zigbee or Wi-Fi. My objective was to bridge this gap to allow for modern scheduling, remote control, and integration with other sensors in the house.

## The Setup

### Home Assistant Installation
I decided to run Home Assistant on ... <!-- User to fill in hardware details -->

### Hardware Bridge
To talk to the Grafik Eye, I'm using ... <!-- e.g. Lutron GRX-PRG or an RS232 to Ethernet adapter -->

## Implementation Steps

1. **Hardware connection**: Connecting the Grafik Eye to the network.
2. **Serial communication**: Testing the raw commands via terminal.
3. **Home Assistant Integration**: Configuring the `lutron` or `manual_serial` integration.
4. **Automations**: Creating the first "Movie Mode" and "Dinner" scenes.

***

*More details to come as the project progresses!*
