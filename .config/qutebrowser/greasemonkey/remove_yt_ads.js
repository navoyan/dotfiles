// ==UserScript==
// @name                 YouTube Ads-Bypass
// @namespace            YouTube_Ad-Bypass_Fckoff
// @version              1.28.1
// @description:en       Lightweight and high-performance script to skip video ads and hide intrusive UI elements (banners, overlays, and promos).
// @author               WakeUpNeo
// @match                *://www.youtube.com/*
// @match                *://music.youtube.com/*
// @run-at               document-start
// @grant                none
// @license              MIT
// @description Script ligero y de alto rendimiento para saltar anuncios de video y ocultar elementos molestos de la interfaz (banners, superposiciones y promos).
// ==/UserScript==
 
(function() {
    'use strict';
 
    // ==========================================
    // Opciones del Sistema de Diagnóstico (Debug)
    // ==========================================
    const DEBUG_CONFIG = {
      enabled: true,
      prefix: '[YouTube Ads-Bypass]'
    };
 
    const LANGS = {
        ar: { wait_or_skip: 'انتظر أو اضغط تخطي' }, // Árabe
        bn: { wait_or_skip: 'অপেক্ষা করুন বা স্কিপ টিপুন' }, // Bengalí
        cs: { wait_or_skip: 'Počkejte nebo klikněte na Přeskočit' }, // Checo
        de: { wait_or_skip: 'Warten oder Überspringen' }, // Alemán
        en: { wait_or_skip: 'Wait or Press Skip' }, // Inglés
        es: { wait_or_skip: 'Espera o Presiona Saltar' }, // Español
        fa: { wait_or_skip: 'منتظر بمانید یا رد کردن را فشار دهید' }, // Persa
        fr: { wait_or_skip: 'Attendre ou Passer' }, // Francés
        hi: { wait_or_skip: 'प्रतीक्षा करें या छोड़ें दबाएं' }, // Hindi
        id: { wait_or_skip: 'Tunggu atau Tekan Lewati' }, // Indonesio
        it: { wait_or_skip: 'Aspetta o Premi Salta' }, // Italiano
        ja: { wait_or_skip: '待つかスキップを押す' }, // Japonés
        ko: { wait_or_skip: '기다리거나 건너뛰기 누르기' }, // Coreano
        nl: { wait_or_skip: 'Wacht of druk op Overslaan' }, // Neerlandés
        pl: { wait_or_skip: 'Czekaj lub naciśnij Pomiń' }, // Polaco
        pt: { wait_or_skip: 'Aguarde ou Pressione Pular' }, // Português
        ro: { wait_or_skip: 'Așteaptă sau apasă Înapoi/Sari' }, // Rumano
        ru: { wait_or_skip: 'Подождите или нажмите Пропустить' }, // Ruso
        th: { wait_or_skip: 'รอหรือกดข้าม' }, // Tailandés
        tr: { wait_or_skip: 'Bekleyin veya Atla Tuşuna Basın' }, // Turco
        uk: { wait_or_skip: 'Зачекайте або натисніть Пропустити' }, // Ucraniano
        vi: { wait_or_skip: 'Chờ hoặc nhấn Bỏ qua' }, // Vietnamita
        zh: { wait_or_skip: '等待或点击跳过' } // Chino Simplificado (zh-CN)
    };
 
    const userLang = navigator.language.substring(0, 2);
    const LNG = (userLang in LANGS) ? LANGS[userLang] : LANGS.en;
 
    /**
    * Centralized message router for the developer console.
    * Applies a standard prefix and allows categorization by alert levels.
    */
    function log(message, type = 'log') {
        if (!DEBUG_CONFIG.enabled) return;
        if (type === 'error') console.error(`${DEBUG_CONFIG.prefix} ❌ ${message}`);
        else if (type === 'warn') console.warn(`${DEBUG_CONFIG.prefix} ⚠️ ${message}`);
        else if (type === 'info') console.info(`${DEBUG_CONFIG.prefix} ℹ️ ${message}`);
        else console.log(`${DEBUG_CONFIG.prefix} ⚙️ ${message}`);
    }
 
    log('Starting script...', 'info');
 
    /**
     * Configuration object containing CSS selectors for different types of ad elements.
     */
    const SELECTORS = {
        // Elements that should be visually hidden from the UI
        toHide: [
            '.ytp-ad-message-container',
            'ytd-player-legacy-desktop-watch-ads-renderer',
            'ytd-ad-slot-renderer',
            '#masthead-ad',
            'tp-yt-paper-dialog:has(#feedback.ytd-enforcement-message-view-model)',
            '.yt-mealbar-promo-renderer',
            '.ytp-ad-player-overlay-layout__player-card-container',
            '.ytp-ad-player-overlay-layout__ad-info-container',
            '.ytp-ad-player-overlay-layout__ad-disclosure-banner-container',
            '.ytp-ad-player-overlay',
            '.ad-showing > video',
            '.ad-interrupting > video',
            'div:has(> div#banner)',
            'ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-ads"]',
            'ytd-rich-item-renderer:has(ytd-ad-slot-renderer)',
            'ytmusic-mealbar-promo-renderer',
            'ytd-in-feed-ad-layout-renderer',
            '#player-ads',
            '.ytd-video-masthead-ad-v3-renderer',
            'ytd-ad-selection-preview-renderer',
            '.ytp-ad-image-overlay',
            '#root.yt-chips-search-renderer-header-v2',
            '.ytp-cued-thumbnail-overlay',
            '.ytp-ad-avatar',
            '.ytp-ad-button-vm'
        ],
        // Selectors for the main YouTube video player container
        player: [
            '#movie_player',
            '.html5-video-player'
        ],
        // Classes added by YouTube when an ad is active
        adsClasses: [
            '.ad-showing',
            '.ad-interrupting',
            '.ytp-ad-player-overlay'
        ],
        // Selectors for the various "Skip Ad" buttons
        skipButtons: [
            '.ytp-ad-skip-button-modern',
            '.ytp-skip-ad-button',
            '.ytp-ad-skip-button',
            '.ytp-ad-skip-button-slot',
            '.ytp-ad-skip-button-container'
        ]
    };
 
    const selector = {
        playerSpinner: '.ytp-spinner',
        adPlayerOverlay: '.ytp-ad-player-overlay-layout',
        cuedThumbOverlay: '.ytp-cued-thumbnail-overlay',
    };
 
 
    /**
     * Convert arrays of selectors into single comma-separated strings for querySelectorAll/matches usage.
     */
    const selectors = Object.fromEntries(
       Object.entries(SELECTORS).map(([key, value]) => [key, value.join(', ')])
    );
 
    let player = null;
    let playerObserver = null;
    let video = null;
    let spinner = null;
    let cuedThumbOverlay = null;
    let lastSkipAttempt = 0;
    let isAdDetected = false;
 
    /**
     * Injects a global <style> tag to hide ad-related elements using CSS.
     * Uses visibility:hidden and 1px size to avoid breaking layout while making ads invisible.
     */
    const injectStyles = () => {
        const style = document.createElement('style');
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
                border: 1px solid yellow !important;
                background-color: rgba(247,241,40,0.6) !important;
                box-shadow: 0 0 20px #DD3 !important;
                overflow: hidden !important;
            }
            .ytp-skip-ad {
                display: flex !important;
            }
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
        log('Styles injected', 'info');
    };
 
     const isAdActive = () => {
        return (
            player.classList.contains('ad-showing') ||
            player.classList.contains('ad-interrupting') ||
            player.classList.contains('ytp-ad-player-overlay')
        );
    }
 
    /**
     * Executes the skipping logic: fast-forwards the video to the end and clicks the skip button.
     */
    const skipAction = () => {
        const overlay = player.querySelector(selector.adPlayerOverlay);
        if (overlay){
            overlay.style.display = '';
            overlay.setAttribute('style', '');
        }
        if (spinner){
            spinner.style.display = '';
            if (cuedThumbOverlay){
                cuedThumbOverlay.style.display = 'none';
            }
        }
        if (video.style.display != 'none') {
            video.style.display = 'none';
        }
        if (!video.paused){
            log('Ad paused', 'info');
            video.pause();
            video.paused = true;
        }
        if (!video.muted) {
            video.muted = true;
            video.volume = 0;
            log('Ad muted', 'info');
        }
        if (video.playbackRate !== 2.0) {
            video.playbackRate = 2.0;
            log('Ad accelerated', 'info');
        }
        if (isFinite(video.duration) && video.duration > 0) {
            video.currentTime = video.duration - 0.1;
            log('Ad seekToEnd', 'info');
        }
        if (video.style.display == 'none') {
            video.style.display = 'block';
        }
        if (video.paused) {
            video.play();
            log('Ad play', 'info');
        }
    };
 
    /**
     * Checks if the player is currently showing an ad.
     */
    const checkAndSkip = () => {
       // Re-fetch the video element if it's missing or disconnected from DOM
       if (!video || !video.isConnected) {
            video = document.querySelector('video');
        }
        if (!video) return;
 
        const now = Date.now();
        // Throttle skip attempts to avoid rapid loops
        if (now - lastSkipAttempt < 500) return;
        lastSkipAttempt = now;
 
        // If player has ad-related classes, trigger skip; otherwise, reset playback speed
        if (isAdActive()) {
            isAdDetected = true;
            log('SkipAd start', 'info');
            skipAction();
            log('SkipAd end', 'info');
        } else if (isAdDetected) {
            isAdDetected = false;
            video.style.display = 'block';
            if (spinner) {
                spinner.style.display = 'none';
                if (cuedThumbOverlay){
                    cuedThumbOverlay.style.display = 'none';
                }
                log('Hide spinner and cued thumbnail', 'info');
            }
            if (video.muted) {
                video.muted = false;
                log('Restore mute', 'info');
            }
            // Restore normal speed if the script had previously accelerated it
            if (video.playbackRate > 1) {
                video.playbackRate = 1;
                log('Restore playRate', 'info');
            }
            //if (video.paused) { video.play(); log('Restore pause');}
            log('Restore Play', 'info');
        }
    };
 
    /**
     * Initializes a MutationObserver to watch for changes in the player's class attribute.
     * This allows the script to react instantly when an ad starts.
     */
    const setupPlayerObserver = () => {
        player = document.querySelector(selectors.player);
 
        if (player && !playerObserver) {
            playerObserver = new MutationObserver(() => checkAndSkip(player));
            // Monitor class changes which indicate ad transitions
            playerObserver.observe(player, { attributes: true, attributeFilter: ['class'] });
 
            spinner = player.querySelector(selector.playerSpinner);
            cuedThumbOverlay = player.querySelector(selector.cuedThumbOverlay);
 
            // Run initial check
            checkAndSkip(player);
        }
    };
 
    // Event listeners to handle page loads and YouTube's internal navigation (SPA)
    window.addEventListener('yt-navigate-finish', setupPlayerObserver);
    window.addEventListener('yt-page-data-updated', setupPlayerObserver);
    window.addEventListener('load', (event) => {
        setupPlayerObserver();
    });
 
    // Inject CSS as soon as the DOM structure is available
    window.addEventListener('DOMContentLoaded', (event) => {
        injectStyles();
    });
 
 
    /**
     * Fallback mechanism: attempts to initialize the observer every 1000ms
     * in case 'load' events fire before the player is ready.
     */
    let retry = 0;
    const fallback = setInterval(() => {
        log('attempt setupPlayerObserver:' + retry, 'info');
        setupPlayerObserver();
        // Stop retrying if observer is active or after 10 failed attempts
        if (playerObserver || retry > 10) clearInterval(fallback);
        retry++;
    }, 1000);
 
    log('Script loaded!', 'info');
})();
