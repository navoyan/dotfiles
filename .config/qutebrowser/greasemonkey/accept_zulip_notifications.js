// ==UserScript==
// @name        Accept Zulip Notifications
// @description Hits the notification button, once
// @version     1.0
// @include     https://zulip.*.*/*
// @run-at      document-idle
// @grant       none
// ==/UserScript==

let checkAndClickButton = setInterval(function() {
    let button = document.querySelector(".request-desktop-notifications")
    if (button) {
        button.click();
        clearInterval(checkAndClickButton);
    }
}, 500)
