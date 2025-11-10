using System;
using OpenQA.Selenium.Chrome;
using WindowsInput;

namespace P4NTH30N.C0MMON;

public static partial class Actions {
    public static ChromeDriver Launch() {
        Mouse.Click(1279, 180);
        ChromeDriver driver = new();
        driver.Navigate().GoToUrl("chrome://extensions/");
        Thread.Sleep(2000);
        Mouse.Click(1030, 180);
        Mouse.Click(100, 230);
        Mouse.Click(660, 70);
        Thread.Sleep(800);
        Keyboard.Send("C:\\OneDrive\\Auto-Firekirin\\auto-override").Enter();
        Mouse.Click(800, 510);
        Mouse.Click(505, 535);
        Keyboard.PressPageDown().PageDown();
        Mouse.Click(574, 490);
        Thread.Sleep(400);
        Mouse.Click(843, 415);
        Mouse.Click(843, 415);
        Thread.Sleep(800);
        Mouse.Click(776, 409);
        Thread.Sleep(200);
        Mouse.Click(692, 450);
        Thread.Sleep(800);
        Mouse.Click(692, 485);
        Thread.Sleep(400);
        Keyboard.Send("C:\\OneDrive\\Auto-Firekirin\\resource_override_rules.json").Enter();
        Mouse.Click(855, 192);
        Mouse.Click(944, 332);
        // Keyboard.WindowsManager();
        // Mouse.Click(1265, 570);
        // Mouse.Click(1114, 655);
        // Mouse.Click(1114, 27);
        // Mouse.Click(134, 30);
        // Mouse.Click(197, 270);
        Mouse.Click(1026, 122);
        Mouse.RtClick(182, 30);
        Mouse.Click(243, 268);
        return driver;
    }
}
