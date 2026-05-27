// ==UserScript==
// @name               Remove YouTube Shorts
// @namespace          https://github.com/strangeZombies
// @version            2025.4.4.0
// @description        Remove YouTube Shorts tags, dismissible elements, Shorts links, and Reel Shelf
// @author             StrangeZombies
// @icon               https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @match              https://*.youtube.com/*
// @match              https://m.youtube.com/*
// @grant              none
// @run-at             document-start
// ==/UserScript==

(function() {
    'use strict';

    const hideHistoryShorts = false;
    const debug = false;

    const commonSelectors = [
        'a[href*="/shorts/"]',
        '[is-shorts]',
        'yt-chip-cloud-chip-renderer:has(a[href*="/shorts/"])',
        'ytd-reel-shelf-renderer',
        'ytd-thumbnail-overlay-time-status-renderer[overlay-style="SHORTS"]',
        '#guide [title="Shorts"]',
        '.ytd-mini-guide-entry-renderer[title="Shorts"]',
        '.ytd-mini-guide-entry-renderer[aria-label="Shorts"]',
    ];

    const mobileSelectors = [
        '.pivot-shorts',
        'ytm-reel-shelf-renderer',
        'ytm-search ytm-video-with-context-renderer [data-style="SHORTS"]',
    ];

    const feedSelectors = [
        'ytd-browse[page-subtype="subscriptions"] ytd-grid-video-renderer [overlay-style="SHORTS"]',
        'ytd-browse[page-subtype="subscriptions"] ytd-video-renderer [overlay-style="SHORTS"]',
        'ytd-browse[page-subtype="subscriptions"] ytd-rich-item-renderer [overlay-style="SHORTS"]',
    ];
    const channelSelectors = ['yt-tab-shape[tab-title="Shorts"]'];
    const historySelectors = ['ytd-browse[page-subtype="history"] ytd-reel-shelf-renderer'];

    function removeElementsBySelectors(selectors) {
        selectors.forEach((selector) => {
            try {
                const elements = document.querySelectorAll(selector);
                elements.forEach((element) => {
                    if (element.dataset.removedByScript) return;
                    let parent = element.closest(
                        'ytd-video-renderer, ytd-grid-video-renderer, ytd-compact-video-renderer, ytd-rich-item-renderer, ytm-video-with-context-renderer'
                    );
                    if (!parent) parent = element;
                    parent.remove();
                    parent.dataset.removedByScript = 'true';
                    if (debug) console.log(`Removed element: ${parent}`);
                });
            } catch (error) {
                if (debug) console.warn(`Error processing selector: ${selector}`, error);
            }
        });
    }

    function removeElements() {
        const currentUrl = window.location.href;
        if (debug) console.log('Current URL:', currentUrl);

        if (currentUrl.includes('m.youtube.com')) {
            removeElementsBySelectors(mobileSelectors);
        }
        if (currentUrl.includes('/feed/subscriptions')) {
            removeElementsBySelectors(feedSelectors);
        }
        //if (currentUrl.includes('/channel') || currentUrl.includes('/@')) {
        //    removeElementsBySelectors(channelSelectors);
        //}
        if (hideHistoryShorts && currentUrl.includes('/feed/history')) {
            removeElementsBySelectors(historySelectors);
        }

        removeElementsBySelectors(commonSelectors);
    }

    function debounce(func, delay) {
        let timeout;
        return (...args) => {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), delay);
        };
    }

    const debouncedRemoveElements = debounce(removeElements, 300);

    function init() {
        if (debug) console.log('Remove YouTube Shorts script activated');
        removeElements();

        const isFirefox = navigator.userAgent.includes('Firefox');
        if (isFirefox) {
            window.addEventListener('popstate', removeElements);
        } else {
            document.addEventListener('yt-navigate-finish', removeElements);
        }

        const observer = new MutationObserver(debouncedRemoveElements);
        observer.observe(document.body, { childList: true, subtree: true });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
