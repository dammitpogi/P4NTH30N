/* globals chrome, bgapp, match */
{
    bgapp.ruleDomains = {};
    bgapp.syncFunctions = [];
    bgapp.settings = bgapp.settings || {};

    const simpleError = bgapp.util.simpleError;
    const settingsDefaults = {
        devTools: "true",
        showSuggestions: "true",
        showLogs: "false"
    };

    const loadSettings = () => new Promise(resolve => {
        chrome.storage.local.get(settingsDefaults, items => {
            Object.assign(bgapp.settings, items);
            resolve(bgapp.settings);
        });
    });

    // Called when the user clicks on the browser action icon.
    chrome.action.onClicked.addListener(function() {
        // open or focus options page.
        const optionsUrl = chrome.runtime.getURL("src/ui/devtoolstab.html");
        chrome.tabs.query({}, function(extensionTabs) {
            let found = false;
            for (let i = 0, len = extensionTabs.length; i < len; i++) {
                if (optionsUrl === extensionTabs[i].url) {
                    found = true;
                    chrome.tabs.update(extensionTabs[i].id, {selected: true});
                    break;
                }
            }
            if (found === false) {
                chrome.tabs.create({url: optionsUrl});
            }
        });
    });

    const syncAllInstances = function() {
        // Doing this weird dance because I cant figure out how to
        // send data from this script to the dev tools script.
        // Nothing seems to work (even the examples!).
        bgapp.syncFunctions.forEach(function(fn) {
            try {
                fn();
            } catch (e) { /**/ }
        });
        bgapp.syncFunctions = [];
    };

    chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
        if (request.action === "saveDomain") {
            bgapp.mainStorage.put(request.data)
                .then(syncAllInstances)
                .catch(simpleError);
            bgapp.ruleDomains[request.data.id] = request.data;
        } else if (request.action === "getDomains") {
            bgapp.mainStorage.getAll().then(function(domains) {
                sendResponse(domains || []);
            }).catch(simpleError);
        } else if (request.action === "deleteDomain") {
            bgapp.mainStorage.delete(request.id)
                .then(syncAllInstances)
                .catch(simpleError);
            delete bgapp.ruleDomains[request.id];
        } else if (request.action === "import") {
            let maxId = 0;
            for (const id in bgapp.ruleDomains) {
                maxId = Math.max(maxId, parseInt(id.substring(1)));
            }
            maxId++;
            Promise.all(request.data.map(function(domainData) {
                // dont overwrite any pre-existing domains.
                domainData.id = "d" + maxId++;
                bgapp.ruleDomains[domainData.id] = domainData;
                return bgapp.mainStorage.put(domainData);
            }))
            .then(syncAllInstances)
            .catch(simpleError);
        } else if (request.action === "makeGetRequest") {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", request.url, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    sendResponse(xhr.responseText);
                }
            };
            xhr.send();
        } else if (request.action === "setSetting") {
            chrome.storage.local.set({[request.setting]: request.value}, () => {
                bgapp.settings[request.setting] = request.value;
            });
        } else if (request.action === "getSetting") {
            chrome.storage.local.get(request.setting, items => {
                sendResponse(items[request.setting]);
            });
        } else if (request.action === "syncMe") {
            bgapp.syncFunctions.push(sendResponse);
        } else if (request.action === "match") {
            sendResponse(match(request.domainUrl, request.windowUrl).matched);
        } else if (request.action === "extractMimeType") {
            sendResponse(bgapp.extractMimeType(request.fileName, request.file));
        }

        // !!!Important!!! Need to return true for sendResponse to work.
        return true;
    });

    chrome.webRequest.onBeforeRequest.addListener(function(details) {
        if (!bgapp.requestIdTracker.has(details.requestId)) {
            if (details.tabId > -1) {
                let tabUrl = bgapp.tabUrlTracker.getUrlFromId(details.tabId);
                if (details.type === "main_frame") {
                    // a new tab must have just been created.
                    tabUrl = details.url;
                }
                if (tabUrl) {
                    const result = bgapp.handleRequest(details.url, tabUrl, details.tabId, details.requestId);
                    if (result) {
                        // make sure we don't try to redirect again.
                        bgapp.requestIdTracker.push(details.requestId);
                    }
                    return result;
                }
            }
        }
    }, {
        urls: ["<all_urls>"]
    }, ["blocking"]);

    chrome.webRequest.onHeadersReceived.addListener(bgapp.makeHeaderHandler("response"), {
        urls: ["<all_urls>"]
    }, ["blocking", "responseHeaders"]);

    chrome.webRequest.onBeforeSendHeaders.addListener(bgapp.makeHeaderHandler("request"), {
        urls: ["<all_urls>"]
    }, ["blocking", "requestHeaders"]);

    chrome.runtime.onInstalled.addListener(function() {
        chrome.storage.local.get(settingsDefaults, items => {
            const updates = {};
            for (const key in settingsDefaults) {
                if (items[key] === undefined) {
                    updates[key] = settingsDefaults[key];
                }
            }
            if (Object.keys(updates).length) {
                chrome.storage.local.set(updates);
            }
        });
    });

    loadSettings().catch(simpleError);

    // init domain storage
    bgapp.mainStorage.getAll().then(function(domains) {
        if (domains) {
            domains.forEach(function(domainObj) {
                bgapp.ruleDomains[domainObj.id] = domainObj;
            });
        }
    }).catch(simpleError);

}
