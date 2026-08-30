// ==UserScript==
// @name                Play with MPV
// @description         Play videos and songs on the website via mpv-handler
// @namespace           play-with-mpv-handler
// @version             2025.12.31.1
// @author              Akatsuki Rui
// @license             MIT License
// @run-at              document-idle
// @noframes
// @match               *://*.youtube.com/*
// @downloadURL         https://update.greasyfork.org/scripts/416271/Play%20with%20MPV.user.js
// @updateURL           https://update.greasyfork.org/scripts/416271/Play%20with%20MPV.meta.js
// ==/UserScript==

"use strict";

const SITE_YOUTUBE = {
    allow: true,
    list: ["/watch", "/playlist"],
};

const MATCHERS = {
    "www.youtube.com": SITE_YOUTUBE,
    "m.youtube.com": SITE_YOUTUBE,
};

const ICON_MPV =
    "PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI2NCIgaGVpZ2h0\
PSI2NCIgdmVyc2lvbj0iMSI+CiA8Y2lyY2xlIHN0eWxlPSJvcGFjaXR5Oi4yIiBjeD0iMzIiIGN5\
PSIzMyIgcj0iMjgiLz4KIDxjaXJjbGUgc3R5bGU9ImZpbGw6IzhkMzQ4ZSIgY3g9IjMyIiBjeT0i\
MzIiIHI9IjI4Ii8+CiA8Y2lyY2xlIHN0eWxlPSJvcGFjaXR5Oi4zIiBjeD0iMzQuNSIgY3k9IjI5\
LjUiIHI9IjIwLjUiLz4KIDxjaXJjbGUgc3R5bGU9Im9wYWNpdHk6LjIiIGN4PSIzMiIgY3k9IjMz\
IiByPSIxNCIvPgogPGNpcmNsZSBzdHlsZT0iZmlsbDojZmZmZmZmIiBjeD0iMzIiIGN5PSIzMiIg\
cj0iMTQiLz4KIDxwYXRoIHN0eWxlPSJmaWxsOiM2OTFmNjkiIHRyYW5zZm9ybT0ibWF0cml4KDEu\
NTE1NTQ0NSwwLDAsMS41LC0zLjY1Mzg3OSwtNC45ODczODQ4KSIgZD0ibTI3LjE1NDUxNyAyNC42\
NTgyNTctMy40NjQxMDEgMi0zLjQ2NDEwMiAxLjk5OTk5OXYtNC0zLjk5OTk5OWwzLjQ2NDEwMiAy\
eiIvPgogPHBhdGggc3R5bGU9ImZpbGw6I2ZmZmZmZjtvcGFjaXR5Oi4xIiBkPSJNIDMyIDQgQSAy\
OCAyOCAwIDAgMCA0IDMyIEEgMjggMjggMCAwIDAgNC4wMjE0ODQ0IDMyLjU4NTkzOCBBIDI4IDI4\
IDAgMCAxIDMyIDUgQSAyOCAyOCAwIDAgMSA1OS45Nzg1MTYgMzIuNDE0MDYyIEEgMjggMjggMCAw\
IDAgNjAgMzIgQSAyOCAyOCAwIDAgMCAzMiA0IHoiLz4KPC9zdmc+Cg==";

const css = String.raw;

const MPV_CSS = css`
  .play-with-mpv {
    z-index: 99999;
    position: fixed;
    left: 8px;
    bottom: 8px;
  }
  .pwm-play {
    width: 48px;
    height: 48px;
    border: 0;
    border-radius: 50%;
    background-size: 48px;
    background-image: url("https://github.com/mpv-player/mpv/raw/refs/heads/master/etc/mpv-icon.ico");
    background-repeat: no-repeat;
  }
  .pwm-play:hover {
    opacity: 1;
    visibility: visible;
    transition: all 0.2s ease-in-out;
  }
`;

// Generate protocol
function generateProto(url) {
    let btoaUrl = btoa(url)
        .replace(/\//g, "_")
        .replace(/\+/g, "-")
        .replace(/\=/g, "");

    return "mpv-handler://play/" + btoaUrl;
}

// Check the URL is matched or not
function matchUrl() {
    if (MATCHERS[location.hostname]) {
        let site = MATCHERS[location.hostname];
        let path = location.pathname;

        for (const item of site.list) {
            if (path.startsWith(item)) {
                if (
                    path.charAt(item.length) === "/" ||
                    path.charAt(item.length) === ""
                ) {
                    return site.allow;
                }
            }
        }

        if (path !== "/") {
            return !site.allow;
        }

        return false;
    }
}

// Update button display status and URL
function updateButton() {
    let isMatch = matchUrl();
    let button = document.getElementsByClassName("pwm-play")[0];

    if (button) {
        button.style =
            isMatch && !document.fullscreenElement
                ? "display: block"
                : "display: none";
        button.href = isMatch ? generateProto(location.href) : "";
    }
}

// Add play buttons to page
function createButton() {
    let head = document.getElementsByTagName("head")[0];
    let style = document.createElement("style");

    if (head) {
        style.textContent = MPV_CSS.trim();
        head.appendChild(style);
    }

    let body = document.body;
    let buttonDiv = document.createElement("div");
    let buttonPlay = document.createElement("a");

    let retries = 0;
    let pauseVideo = (e) => {
        let videoElement = document.getElementsByTagName("video")[0];
        if (videoElement) {
            videoElement.pause();
        } else {
            if (retries < 15) {
                setTimeout(pauseVideo, 500, e);
                retries += 1;
            }
        }
        if (e.stopPropagation) e.stopPropagation();
    };

    if (body) {
        buttonPlay.className = "pwm-play";
        buttonPlay.style = "display: none";
        buttonPlay.addEventListener("click", pauseVideo);

        buttonDiv.className = "play-with-mpv";
        buttonDiv.appendChild(buttonPlay);

        body.appendChild(buttonDiv);

        document.addEventListener("fullscreenchange", () => {
            let button = document.getElementsByClassName("pwm-play")[0];

            button.style = document.fullscreenElement
                ? "display: none"
                : "display: block";
        });
    }
}

// Detect PJAX changes
function detectPJAX() {
    let previousUrl = null;
    let currentUrl = null;

    setInterval(() => {
        currentUrl = location.href;

        if (previousUrl !== currentUrl) {
            updateButton();
            previousUrl = currentUrl;
        }
    }, 500);
}

// Fix TrustedHTML
if (window.trustedTypes && !trustedTypes.defaultPolicy) {
    const passThroughFn = (x) => x;
    trustedTypes.createPolicy("default", {
        createHTML: passThroughFn,
        createScriptURL: passThroughFn,
        createScript: passThroughFn,
    });
}

createButton();
detectPJAX();
