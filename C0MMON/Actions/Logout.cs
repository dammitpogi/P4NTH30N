using System;
using System.Drawing;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static partial class Actions {
    public static void Logout() {
        Mouse.Click(996, 184);
        Thread.Sleep(2400);
        Mouse.Click(858, 548);
        Thread.Sleep(3200);
        Mouse.Click(533, 500);
    }
}
