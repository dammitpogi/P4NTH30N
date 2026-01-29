
const { Builder, Browser } = require('selenium-webdriver');
const chrome = require("selenium-webdriver/chrome");
const credentials = require('C:\\credentials.js');
const FilePath = "C:\\OneDrive\\Auto-Firekirin\\";
const { Hardware } = require('keysender');

// PROF3T: auto-firekirin [v1.2.9] 20250605_2342
var Grand = -1; var Major = -1; var Minor = -1; var Mini = -1; var Balance = 0; var Page = "";
var Grand_prior = -1; var Major_prior = -1; var Minor_prior = -1; var Mini_prior = -1;
var Balance_prior = 0; var SpinningForJackpot = false; var iterations = 0;

const Grand_trigger = 1783.8; const Major_trigger = 564.2;
const Minor_trigger = 115.9; const Mini_trigger = 22.5;

const Username = credentials().username;
const Password = credentials().password;
const formatMemoryUsage = (m) => Math.round(m/1024/1024*100)/100;
function sleep(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }

(async function auto_firekirin()  {
    let driver; let handle;
    while (true) {
        try {
            let options = new chrome.Options();
            // options.addExtensions('universal-resource-override.crx');
            // options.addArguments("--remote-allow-origins=*"); 
            // options.addArguments('--load-extension=C:\\OneDrive\\Auto-Firekirin\\universal-resource-override');
            //driver = await new Builder().forBrowser(Browser.CHROME).setChromeOptions(options).build();
            driver = await new Builder().forBrowser(Browser.CHROME).build();

            await driver.get('chrome://extensions/');
            await sleep(1000);


            handle = new Hardware();
            await handle.mouse.humanMoveTo(1030, 180);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(100, 230);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(660, 70);
            await handle.mouse.click("left", 70, 400);
            await handle.keyboard.printText(FilePath + "universal-resource-override"); await sleep(400);
            await handle.keyboard.sendKey("enter"); await sleep(800);

            // await handle.keyboard.sendKey("enter"); await sleep(400);
            await handle.mouse.humanMoveTo(810, 510);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(505, 535);
            await handle.mouse.click("left", 70, 400);


            // await handle.mouse.humanMoveTo(944, 360);
            // await handle.mouse.click("left", 70, 400);
            // await handle.keyboard.sendKey("enter");
            // await handle.mouse.humanMoveTo(908, 150);
            // await handle.mouse.click("left", 70, 400);
            // await handle.keyboard.sendKey("escape");
            // await sleep(400);

            // await handle.mouse.humanMoveTo(574, 220);
            // await handle.mouse.click("left", 70, 400);
            await handle.keyboard.sendKey("pageDown");
            await handle.keyboard.sendKey("pageDown"); await sleep(400);
            await handle.mouse.humanMoveTo(574, 490);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(843, 415);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 800);
            await handle.mouse.humanMoveTo(776, 409);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(692, 450);
            await handle.mouse.click("left", 70, 1400);
            // await handle.mouse.humanMoveTo(550, 240);
            // await handle.mouse.humanMoveTo(690, 240);
            // await handle.mouse.humanMoveTo(692, 480);
            // await handle.mouse.humanMoveTo(1080, 310);
            
            await handle.mouse.humanMoveTo(692, 485);
            await handle.mouse.click("left", 70, 200);
            await handle.keyboard.printText(FilePath + "resource_override_rules.json"); await sleep(800);
            await handle.keyboard.sendKey("enter"); await sleep(800);

            await handle.mouse.humanMoveTo(848, 212);
            await handle.mouse.click("left", 70, 400);

            // try {
            //     await handle.quit();
            // } catch { }
            // handle = new Hardware();

            // await handle.mouse.click("left", 70, 1400);
            // // await handle.mouse.humanMoveTo(1000, 310);
            // await handle.mouse.click("left", 70, 200);
            // await handle.keyboard.sendKey("escape");
            // await sleep(400);

            await handle.mouse.humanMoveTo(944, 332);
            await handle.mouse.click("left", 70, 400);
            // await handle.mouse.humanMoveTo(1026, 177);
            // await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(1026, 122);
            await handle.mouse.click("left", 70, 400);

            await handle.keyboard.sendKey(["ctrl", "shift", "d"], 70, 400);

            await handle.mouse.humanMoveTo(1265, 570);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(1114, 655);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(1114, 27);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(134, 30);
            await handle.mouse.click("right", 70, 400);
            await handle.mouse.humanMoveTo(197, 270);
            await handle.mouse.click("left", 70, 400);

            let currentlyAuthenticating = true;
            while (currentlyAuthenticating) {
                await driver.get('http://play.firekirin.in/web_mobile/firekirin/');
                await sleep(8000);
                Page = await driver.executeScript("return window.parent.Page");
                if (Page == null) throw new Error("Something went wrong. Integrity of extension check threw an undefined instance.");

                await sleep(22000);
                await handle.mouse.humanMoveTo(470, 310);

                await handle.mouse.click("left", 70, 600);
                await handle.keyboard.printText(Username);
                await handle.mouse.humanMoveTo(470, 380);
                await handle.mouse.click("left", 70, 600);
                await handle.keyboard.printText(Password);
                await handle.mouse.humanMoveTo(630, 520);
                await handle.mouse.click("left", 70, 400);

                for (let i = 0; i < 10; i++) {
                    await sleep(2500)
                    let ReceivedBalance = (await driver.executeScript("return window.parent.Balance")) / 100
                    if (ReceivedBalance > 0) {
                        currentlyAuthenticating = false;
                        break;
                    }
                }
            }

            await sleep(2500)
            await handle.mouse.humanMoveTo(937, 177);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.click("left", 70, 400);
            await handle.mouse.humanMoveTo(603, 457);
            console.log('');

            while (true) {
                Grand_prior = Grand; Major_prior = Major; Minor_prior = Minor; Mini_prior = Mini; Balance_prior = Balance; 
                Balance = (await driver.executeScript("return window.parent.Balance")) / 100;
                Grand = (await driver.executeScript("return window.parent.Grand")) / 100;
                Major = (await driver.executeScript("return window.parent.Major")) / 100;
                Minor = (await driver.executeScript("return window.parent.Minor")) / 100;
                Mini = (await driver.executeScript("return window.parent.Mini")) / 100;
                Page = await driver.executeScript("return window.parent.Page");

                console.log(new Date().toLocaleString("en-US", { timeZone: 'America/Denver' }) + " || Balance: " + Balance);
                console.log('Grand: ' + Grand + ' / ' + Grand_trigger + ' || Major: ' + Major + ' / ' + Major_trigger);
                console.log('Minor: ' + Minor + ' / ' + Minor_trigger + ' || Mini: ' + Mini + ' / ' + Mini_trigger);
                console.log('');

                let MemoryUsage = formatMemoryUsage(process.memoryUsage().rss);
                if (MemoryUsage > 75 || iterations > 40) {
                    await handle.mouse.humanMoveTo(1114, 27);
                    await handle.mouse.click("left", 70, 400); iterations = 0;
                    await handle.keyboard.sendKey(["ctrl", "shift", "f5"], 70, 400);
                }

                 // console.log(`${formatMemoryUsage(process.memoryUsage().rss)} -> Resident Set Size - total memory allocated for the process execution`);
                // console.log(`${formatMemoryUsage(process.memoryUsage().heapTotal)} -> total size of the allocated heap`);
                // console.log(`${formatMemoryUsage(process.memoryUsage().heapUsed)} -> actual memory used during the execution`);
                // console.log(`${formatMemoryUsage(process.memoryUsage().external)} -> V8 external memory`);
                console.log(`${MemoryUsage} | ${iterations}`);
                console.log('');

                iterations++;
                if (Grand >= Grand_trigger || Major >= Major_trigger || Minor >= Minor_trigger || Mini >= Mini_trigger) {
                    SpinningForJackpot = true;
                }

                if (SpinningForJackpot == false) {
                    await sleep(58000);
                    await driver.get('http://play.firekirin.in/web_mobile/firekirin/');
                   
                    await sleep(1000)
                    let seconds = 90; grandReceived = false;

                    for (let ii = 0; ii < seconds; ii++) {
                        await sleep(1000)
                        Grand = (await driver.executeScript("return window.parent.Grand")) / 100;
                        if (Grand > 0) {
                            grandReceived = true;
                            ii = seconds;
                        }

                    }
                    if (grandReceived == false){
                        throw new Error("Something went wrong. Grand check threw an undefined instance.");
                    } else {
                        Balance = (await driver.executeScript("return window.parent.Balance")) / 100;
                        Major = (await driver.executeScript("return window.parent.Major")) / 100;
                        Minor = (await driver.executeScript("return window.parent.Minor")) / 100;
                        Mini = (await driver.executeScript("return window.parent.Mini")) / 100;
                        Page = await driver.executeScript("return window.parent.Page");
                    }
                    await handle.mouse.humanMoveTo(603, 457);
                }
                
                if (Grand <= 0) {
                    if (SpinningForJackpot) {
                        await sleep(8000);
                        
                        Balance = (await driver.executeScript("return window.parent.Balance")) / 100;
                        Grand = (await driver.executeScript("return window.parent.Grand")) / 100;
                        Major = (await driver.executeScript("return window.parent.Major")) / 100;
                        Minor = (await driver.executeScript("return window.parent.Minor")) / 100;
                        Mini = (await driver.executeScript("return window.parent.Mini")) / 100;
                        Page = await driver.executeScript("return window.parent.Page");
                        if (Grand <= 0) {
                            break;
                        }
                    } else {
                        break;
                    }
                }

                if (Grand < Grand_prior || Major < Major_prior || Minor < Minor_prior || Mini < Mini_prior) {
                    SpinningForJackpot = false;
                }

                console.log(new Date().toLocaleString("en-US", { timeZone: 'America/Denver' }) + " || Balance: " + Balance);
                console.log('Grand: ' + Grand + ' / ' + Grand_trigger + ' || Major: ' + Major + ' / ' + Major_trigger);
                console.log('Minor: ' + Minor + ' / ' + Minor_trigger + ' || Mini: ' + Mini + ' / ' + Mini_trigger);
                console.log('');

                if (SpinningForJackpot) {
                    let SlotsLoaded = false;
                    while (SlotsLoaded == false) {
                        Page = await driver.executeScript("return window.parent.Page");
                        let Clicks = 0
                        while (Page != "Slots") {
                            await handle.mouse.humanMoveTo(603, 457);
                            await handle.mouse.click("left", 70, 1000);
                            Page = await driver.executeScript("return window.parent.Page");
                            Clicks++;
                            if (Clicks > 90) 
                                throw new Error("Something went wrong. Unable to reach slots for Jackpot.");
                        }

                        // await sleep(3000);
                        // Grand = (await driver.executeScript("return window.parent.Grand")) / 100;
                        
                        await sleep(15000);
                        Balance = (await driver.executeScript("return window.parent.Balance")) / 100;
                        if (Balance == 0) {
                            console.log('Balance was undefined...');
                            console.log('Restarting.');
                            console.log('');

                            await driver.get('http://play.firekirin.in/web_mobile/firekirin/');
                            let walletHasLoaded = false;
                            for (let i = 0; i < 10; i++) {
                                await sleep(2500)
                                let ReceivedBalance = (await driver.executeScript("return window.parent.Balance")) / 100;
                                if (ReceivedBalance > 0) {
                                    walletHasLoaded = true;
                                    break;
                                }
                            }
                            if (walletHasLoaded == false){
                                throw new Error("Wallet Balance threw an undefined instance.");
                            }
                        } else {
                            SlotsLoaded = true;
                        }
                    }
                    
                    await handle.mouse.humanMoveTo(534, 466);
                    await handle.mouse.click("left", 70, 400)
                    await handle.mouse.humanMoveTo(534, 523);
                    await handle.mouse.click("left", 70, 400);;
                    await handle.mouse.humanMoveTo(955, 610);
                    await handle.mouse.click("left", 3000, 400);
                    await handle.mouse.humanMoveTo(955, 290);
                    await handle.mouse.click("left", 70, 400);

                    var SpinningConfirmed = false;
                    var FailedSpinChecks = 0;

                    while (true) {
                        Balance = (await driver.executeScript("return window.parent.Balance")) / 100;
                        if (Balance == 0) {
                            console.log('Balance was undefined...');
                            console.log('Restarting.');
                            console.log('');
                            break;
                        }

                        Balance_prior = Balance; Grand_prior = Grand; Major_prior = Major; Minor_prior = Minor; Mini_prior = Mini;
                        Grand = (await driver.executeScript("return window.parent.Grand")) / 100;
                        Major = (await driver.executeScript("return window.parent.Major")) / 100;
                        Minor = (await driver.executeScript("return window.parent.Minor")) / 100;
                        Mini = (await driver.executeScript("return window.parent.Mini")) / 100;
                        Page = await driver.executeScript("return window.parent.Page");

                        console.log(new Date().toLocaleString("en-US", { timeZone: 'America/Denver' }) + " || Balance: " + Balance);
                        console.log('Grand: ' + Grand + ' / ' + Grand_trigger + ' || Major: ' + Major + ' / ' + Major_trigger);
                        console.log('Minor: ' + Minor + ' / ' + Minor_trigger + ' || Mini: ' + Mini + ' / ' + Mini_trigger);
                        console.log('Spinning for Jackpot!');
                        console.log('');

                        if (Page != "Slots") {
                            break;
                        }

                        await sleep(10000);
                        await handle.mouse.humanMoveTo(534, 466);
                        await handle.mouse.click("left", 70, 400);
                        await handle.mouse.humanMoveTo(534, 523);
                        await handle.mouse.click("left", 70, 400);

                        if (Balance == Balance_prior && SpinningConfirmed == false) {
                            FailedSpinChecks++;
                            if (FailedSpinChecks >= 3) {
                                await handle.mouse.humanMoveTo(534, 466);
                                await handle.mouse.click("left", 70, 400);
                                await handle.mouse.humanMoveTo(534, 523);
                                await handle.mouse.click("left", 70, 400);
                                FailedSpinChecks = 0;
                            }
                        } else {
                            SpinningConfirmed = true;
                        }

                        if (Grand < Grand_prior || Major < Major_prior || Minor < Minor_prior || Mini < Mini_prior) {
                            await sleep(120000);
                            SpinningForJackpot = false;
                            break;
                        }
                    }
                }
            }
        } catch (e) {
            try {
                driver.quit();
            } catch { }
            console.log(e)
        }
    }
}())
