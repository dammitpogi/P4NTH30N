
// PROF3T: H0UND [v0.0.1] 2025-06-06_00:17

const { Builder, Browser } = require('selenium-webdriver');
const chrome = require("selenium-webdriver/chrome");
const credentials = require('C:\\credentials.js');
const FilePath = "C:\\OneDrive\\Auto-Firekirin\\";
const { Hardware } = require('keysender');

const PROF3T_ID = credentials().PROF3T_ID;
const formatMemoryUsage = (m) => Math.round(m/1024/1024*100)/100;
function sleep(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }

Grand = -1, Major = -1, Minor = -1, Mini = -1, Balance = 0, Page = "";
Grand_prior = -1, Major_prior = -1, Minor_prior = -1, Mini_prior = -1;
Balance_prior = 0, SpinningForJackpot = false, iterations = 0;

(async function auto_firekirin()  {
    const promise = await import('timers/promises');
    let driver; let handle;
    while (true) {
        try {
            await promise.setTimeout(3000);
            console.log('test')
        } catch (e) {
            try {
                driver.quit();
            } catch { }
            console.log(e)
        }
    }
}())