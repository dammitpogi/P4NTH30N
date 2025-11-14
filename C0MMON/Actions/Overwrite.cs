using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static partial class Actions {
    public static ChromeDriver Launch_v2() {
        ChromeDriver _driver = new();
        _driver.Navigate().GoToUrl("about:blank");

        Mouse.Move(1024, 130);
        Screen.WaitForColor(new Point(1024, 130), Color.FromArgb(231, 231, 231));

        Mouse.Click(1024, 130);
        Keyboard.DevTools();
        Screen.WaitForColor(new Point(900, 170), Color.FromArgb(211, 227, 253));
        
        Mouse.Click(728, 110);
        Mouse.Click(635, 135);
        
        Mouse.Move(670, 175);
        Screen.WaitForColor(new Point(700, 175), Color.FromArgb(242, 242, 242));
        Mouse.Click(670, 175);

        Mouse.Move(670, 165);
        Screen.WaitForColor(new Point(685, 165), Color.FromArgb(242, 242, 242));
        Mouse.Click(670, 165);
        
        Screen.WaitForColor(new Point(100, 500), Color.FromArgb(240, 240, 240));
        Mouse.Click(540, 70);

        Screen.WaitForColor(new Point(215, 65), Color.FromArgb(0, 120, 215));
        Keyboard.Send("C:\\OneDrive\\P4NTH30N\\RUL3S").Wait(400).Enter().Wait(400).Enter();


        Mouse.Move(605, 200);
        Screen.WaitForColor(new Point(605, 185), Color.FromArgb(35, 104, 212));
        Mouse.Click(605, 200);
        
        Screen.WaitForColor(new Point(605, 195), Color.FromArgb(242, 242, 242));
        Keyboard.DevTools();

        return _driver;
    }
}
