---
layout: post
title: Which gaming mode will please my mice?
description: Gaming monitors are cheap, have fast response time and high refresh rate. They come with plenty of fancy gaming modes which are not well described. What are they and which one should I use for visual stimulation?
tags: visual-stimulation calibration display hardware-config
categories: hardware-config
featured: true
date: 2025-08-08 12:00:00
giscus_comments: true
authors:
  - name: Antonin Blot
    url: "https://ablot.github.io/"
    affiliations:
      name: The Francis Crick Institute, London
google-scholar: true
toc:
  sidebar: left
thumbnail: assets/img/msi_screen/mouse.png
---

We use VR setups, see for instance [this study](https://www.biorxiv.org/content/10.1101/2024.09.27.615442v1.abstract), which require fast monitors. We recently got some cheap gaming monitors from [MSI](https://www.msi.com/Monitor/G255F)

<div class="row mt-3">
    <div class="col-sm mt-3 mt-md-0">
        <a href="https://www.msi.com/Monitor/G255F" rel="external nofollow noopener" target="_blank">
            {% include figure.liquid loading="eager" path="/assets/img/msi_screen/msi-g255f-monitor.webp" class="img-fluid rounded z-depth-1" %}
        </a>
    </div>
</div>
<div class="caption">
    We picked the MSI G255F because it's small enough to fit in our setup and has a "frameless" design that is convenient when
    putting screens side by side in mosaic. Image from <a href="https://www.msi.com/Monitor/G255F" rel="external nofollow noopener" target="_blank">MSI</a>.
</div>

The screens have a 180 Hz refresh rate with 1 ms response time but it's quite unclear
for which of the many modes they offer this performance can be reached. The descriptions
on the website and manual are not really informative. In particular, MSI monitors have 4
different gaming modes but apart from some high level [description](https://www.msi.com/blog/the-amazing-display-mode-of-msi-gaming-monitor),
I couldn't find what they actually do in practice. It's clear that they change a bunch
of the exposed settings (brightness and co.) and the color balance but they seemed to do
more than that. So I tried to fix every parameters I could access and change them one by
one and looked at what happens. More precisely, I used a photodiode to measure
how fast the screen reached a steady state when switching from white to black. I
measured the response to a single step, to see how long it takes to reach steady state,
and the response to alternating black and white frames, to see if the luminance is
somewhat comparable to the steady state response.

# Brightness and sharpness

First, I checked that brightness and sharpness do not affect the pixel response
time. Obviously, with higher brightness, the luminance is higher, to focus on response
time only, I normalised by the steady state value (defined as the 90% percentile of
the photodiode signal amplitude when the screen is white).

<div class="row">
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/brightness_step.png" title="Response to step from black to white with different blightness settings" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/brightness_flicker.png" title="Response to alternating steps from black to white with different blightness settings" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    The rise time of the monitor seems insensitive to brightness and sharpness settings
</div>

Surprinsingly the steady-state is not quite steady. Every other frame is marginally
darker and the effect is more obvious at lower brightness. Unfortunately, we need quite
low brigthness settings in our conditions, but the the variation looks acceptable. Apart
from that, as expected, the rise time is unaffected by these settings.

# Response time

"Pixel response time" is the MSI name for overdrive, or RTC (response time correction),
they have three options forresponse time, `normal`, `fast`, and `fastest`. A low response
time is likely to induce ghosting, where pixels take too long to flip color and leave a
track behind objects when they move fast. On the opposite, over-overdriving can
induce inverse ghosting, or coronas, if the pixel overshoot their final value before
settling down. For more description and some fun tests, see the [blur buster webpage](https://blurbusters.com/faq/lcd-overdrive-artifacts/).

<div class="row">
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/responsetime_step.png" title="Response to step from black to white with different pixel response time settings" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/responsetime_flicker.png" title="Response to alternating steps from black to white with different pixel response time settings" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    The normal setting takes a bit more than 2 frames to reach steady state, with fast
    the rise time is reduced to ~1.5 frames. The fastest mode reaches the steady state
    in less than half a frame but has then a large overshoot which make it quite useless. 
</div>

So we go with fast.

# MPRT; which is not actually MPRT

MPRT stands for Moving Picture Response Time and is a [measurement standard of display
persistence](https://blurbusters.com/gtg-versus-mprt-frequently-asked-questions-about-display-pixel-response/).
The name that MSI, gives to the backlight strobing setting reducing MPRT is ... MPRT,
which is kinda confusing.

<div class="row">
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/mprt_step.png" title="Response to step from black to white with and without MPRT" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/mprt_flicker.png" title="Response to alternating steps from black to white with and without MPRT" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    MPRT strobes the backlight but seems to use the normal pixel response time.
</div>

When MPRT is on, the brightness setting is unavailable and the only option is far too
bright for our use case, so for now, we'll forget about it.

# Gaming mode

Finally, once all other settings are set, we can try the gaming mode and see if they
do anything apart from changing the color balance (which won't be obvious on this test
with black and white images).

<div class="row">
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/gamingmode_step.png" title="Response to step from black to white with different gaming mode settings" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-6 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/msi_screen/gamingmode_flicker.png" title="Response to alternating steps from black to white with different gaming mode settings" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Only the racing mode seems to affect the response time, slowing it down. Probably 
    because the turtle wins the race.
</div>

# Conclusion

For now I'll go with `Brightness = 10`, `Sharpness = 0`, `Fast`, `MPRT Off`, `RTS`, which
is the grey curve in all the figures.

I did not test if the gaming modes affect the closed loop response time or the frequency
of frame drops. If I get the chance I might do that another time.
