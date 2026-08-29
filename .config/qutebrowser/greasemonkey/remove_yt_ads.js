// ==UserScript==
// @name                 YouTube Ads-Bypass
// @namespace            YouTube_Ad-Bypass_Fckoff
// @version              1.28.3
// @description:en       Lightweight and high-performance script to skip video ads and hide intrusive UI elements (banners, overlays, and promos).
// @author               WakeUpNeo
// @match                *://www.youtube.com/*
// @match                *://music.youtube.com/*
// @run-at               document-start
// @grant                none
// @license              MIT
// @description Script ligero y de alto rendimiento para saltar anuncios de video y ocultar elementos molestos de la interfaz (banners, superposiciones y promos).
// @downloadURL https://update.greasyfork.org/scripts/575941/YouTube%20Ads-Bypass.user.js
// @updateURL https://update.greasyfork.org/scripts/575941/YouTube%20Ads-Bypass.meta.js
// ==/UserScript==

(function () {
    "use strict";

    // ==========================================
    // Opciones del Sistema
    // ==========================================
    const CONFIG = {
        debug: true,
        prefix: "[YouTube Ads-Bypass]",
        maxCheckAttempt: 2,
    };

    const LNG = { wait_or_skip: "Wait or Press Skip" };

    /**
     * Centralized message router for the developer console.
     * Applies a standard prefix and allows categorization by alert levels.
     */
    function log(message) {
        console.log(`${CONFIG.prefix} ⚙️ ${message}`);
    }

    log("Starting script...");

    /**
     * Configuration object containing CSS selectors for different types of ad elements.
     */
    const SELECTORS = {
        // Elements that should be visually hidden from the UI
        toHide: [
            ".ytp-ad-message-container",
            "ytd-player-legacy-desktop-watch-ads-renderer",
            "ytd-ad-slot-renderer",
            "#masthead-ad",
            "tp-yt-paper-dialog:has(#feedback.ytd-enforcement-message-view-model)",
            ".yt-mealbar-promo-renderer",
            ".ytp-ad-player-overlay-layout__player-card-container",
            ".ytp-ad-player-overlay-layout__ad-info-container",
            ".ytp-ad-player-overlay-layout__ad-disclosure-banner-container",
            ".ytp-ad-player-overlay",
            ".ad-showing > video",
            ".ad-interrupting > video",
            "div:has(> div#banner)",
            'ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-ads"]',
            "ytd-rich-item-renderer:has(ytd-ad-slot-renderer)",
            "ytmusic-mealbar-promo-renderer",
            "ytd-in-feed-ad-layout-renderer",
            "#player-ads",
            ".ytd-video-masthead-ad-v3-renderer",
            "ytd-ad-selection-preview-renderer",
            ".ytp-ad-image-overlay",
            "#root.yt-chips-search-renderer-header-v2",
            ".ytp-cued-thumbnail-overlay",
            ".ytp-ad-avatar",
            ".ytp-ad-button-vm",
        ],
        // Selectors for the main YouTube video player container
        player: ["#movie_player", ".html5-video-player"],
        // Selectors for the various "Skip Ad" buttons
        skipButtons: [
            ".ytp-ad-skip-button-modern",
            ".ytp-skip-ad-button",
            ".ytp-ad-skip-button",
            ".ytp-ad-skip-button-slot",
            ".ytp-ad-skip-button-container",
        ],
    };

    // Classes added by YouTube when an ad is active
    const adsClasses = [
        "ad-showing",
        "ad-interrupting",
        "ytp-ad-player-overlay",
        "ytp-ad-display-override",
    ];

    const selector = {
        playerSpinner: ".ytp-spinner",
        adPlayerOverlay: ".ytp-ad-player-overlay-layout",
        cuedThumbOverlay: ".ytp-cued-thumbnail-overlay",
    };

    /**
     * Convert arrays of selectors into single comma-separated strings for querySelectorAll/matches usage.
     */
    const selectors = Object.fromEntries(
        Object.entries(SELECTORS).map(([key, value]) => [
            key,
            value.join(", "),
        ]),
    );

    let player = null;
    let playerObserver = null;
    let video = null;
    let spinner = null;
    let cuedThumbOverlay = null;
    let lastSkipAttempt = 0;
    let lastCheckAttempt = 0;
    let isAdDetected = false;

    /**
     * Injects a global <style> tag to hide ad-related elements using CSS.
     * Uses visibility:hidden and 1px size to avoid breaking layout while making ads invisible.
     */
    const injectStyles = () => {
        const style = document.createElement("style");
        style.textContent = `
             @keyframes animateSkip {
               0% {
                   transform: translate(-8px, 0);
                   opacity: 0;
               }
               25% {
                   opacity: 1;
               }
               75% {
                   opacity: 1;
               }
               100% {
                   transform: translate(30px, 0);
                   opacity: 0;
               }
            }
            ${selectors.toHide} {
                display: flex !important;
                visibility: hidden !important;
                opacity: 0 !important;
                pointer-events: none !important;
                height: 1px !important;
                width: 1px !important;
                overflow: hidden !important;
            }
            ${selectors.skipButtons} {
                display: flex !important;
                text-transform: uppercase !important;
                border: 1px solid #fd0 !important;
                background-color: rgba(255,230,50,0.65) !important;
                box-shadow: 0 0 20px #fc0 !important;
                overflow: hidden !important;
            }
            ${adsClasses.map((c) => `.${c} .ytp-spinner-circle`).join(", ")} {
                border-color: #fc0 #fc0 transparent !important;
            }
            .ytp-skip-ad,
            .ytp-prev-button,
            .ytp-next-button {
                display: flex !important;
            }
            .ad-simple-attributed-string {
                visibility: hidden;
            }
            .ad-simple-attributed-string::before {
                content: "${LNG.wait_or_skip}";
                display: flex !important;
                visibility: visible;
                color: white;
                width: 100% !important;
                justify-content: center !important;
                white-space: nowrap !important;
            }
            .ytp-skip-ad-button__icon {
                transform: translate(-8px, 0);
                animation: 1s linear 0s infinite animateSkip;
            }
        `;
        (document.head || document.documentElement).appendChild(style);
        log("Styles injected");
    };

    /**
     * Checks if the player has some ad class.
     */
    const isAdActive = () => {
        return adsClasses.some(function (item) {
            return player.classList.contains(item);
        });
    };

    /**
     * Executes the skipping logic: fast-forwards the video to the end and clicks the skip button.
     */
    const skipAction = () => {
        const overlay = player.querySelector(selector.adPlayerOverlay);
        if (overlay) {
            overlay.style.display = "";
            overlay.setAttribute("style", "");
        }
        if (spinner) {
            spinner.style.display = "";
        }
        if (cuedThumbOverlay) {
            cuedThumbOverlay.style.display = "none";
        }
        if (video.style.display != "none") {
            video.style.display = "none";
        }
        if (!video.paused) {
            log("Ad paused");
            video.pause();
            video.paused = true;
        }
        if (!video.muted) {
            video.muted = true;
            log("Ad muted");
        }
        if (video.playbackRate != 2.0) {
            video.playbackRate = 2.0;
            log("Ad accelerated");
        }
        if (isFinite(video.duration) && video.duration > 0) {
            video.currentTime = video.duration - 0.1;
            log("Ad seekToEnd");
        }
        if (video.style.display == "none") {
            video.style.display = "block";
        }
        /* It was deactivated because this triggers the YouTube block
        if (video.paused) {
            video.play();
            log('Ad play');
        }
        */
    };

    /**
     * Checks if the player is currently showing an ad.
     */
    const checkVideoAds = () => {
        // Re-fetch the video element if it's missing or disconnected from DOM
        if (!video || !video.isConnected) {
            video = player.querySelector("video");
        }
        if (!video) return;

        const now = Date.now();
        // Throttle skip attempts to avoid rapid loops
        if (now - lastSkipAttempt < 250) return;
        lastSkipAttempt = now;

        // If player has ad-related classes, trigger skip; otherwise, reset playback speed
        if (isAdActive()) {
            isAdDetected = true;
            lastCheckAttempt = CONFIG.maxCheckAttempt;
            log("SkipAd start");
            skipAction();
            log("SkipAd end");
        } else if (lastCheckAttempt > 0) {
            isAdDetected = false;
            lastCheckAttempt--;
            if (video.style.display == "none") {
                video.style.display = "block";
            }
            if (spinner) {
                spinner.style.display = "none";
                log("Hide cued thumbnail");
            }
            if (cuedThumbOverlay) {
                cuedThumbOverlay.style.display = "none";
                log("Hide spinner");
            }
            if (video.muted) {
                video.muted = false;
                log("Restore mute");
            }
            // Restore normal speed if the script had previously accelerated it
            if (video.playbackRate > 1) {
                video.playbackRate = 1;
                log("Restore playRate");
            }
            /* It was deactivated because this triggers the YouTube block
            if (video.paused) {
                video.play();
                log('Restore pause');
            }
            */
            log("Restore Play");
        }
    };

    /**
     * Initializes a MutationObserver to watch for changes in the player's class attribute.
     * This allows the script to react instantly when an ad starts.
     */
    const setupPlayerObserver = () => {
        if (!player) {
            player = document.querySelector(selectors.player);
        }

        if (player && !playerObserver) {
            video = player.querySelector("video");

            playerObserver = new MutationObserver(() => checkVideoAds());
            // Monitor class changes which indicate ad transitions
            playerObserver.observe(player, {
                attributes: true,
                attributeFilter: ["class"],
            });

            // Run initial check
            checkVideoAds();
        }
    };

    // Event listeners to handle page loads and YouTube's internal navigation (SPA)
    window.addEventListener("yt-navigate-finish", setupPlayerObserver);
    window.addEventListener("yt-page-data-updated", setupPlayerObserver);

    window.addEventListener("load", (event) => {
        if (!player) {
            player = document.querySelector(selectors.player);
        }
        if (player) {
            spinner = player.querySelector(selector.playerSpinner);
            cuedThumbOverlay = player.querySelector(selector.cuedThumbOverlay);
        }
        setupPlayerObserver();
    });

    // Inject CSS as soon as the DOM structure is available
    window.addEventListener("DOMContentLoaded", (event) => {
        injectStyles();
    });

    /**
     * Fallback mechanism: attempts to initialize the observer every 1000ms
     * in case 'load' events fire before the player is ready.
     */
    let retry = 0;
    const fallback = setInterval(() => {
        log("attempt setupPlayerObserver:" + retry);
        setupPlayerObserver();
        // Stop retrying if observer is active or after 10 failed attempts
        if (playerObserver || retry > 10) clearInterval(fallback);
        retry++;
    }, 1000);

    log("Script loaded!");
})();
