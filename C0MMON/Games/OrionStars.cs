using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static class OrionStars {
    public static void Logout(ChromeDriver driver) {
        bool loggedOut = false;
        int iterations = 6;
        while (loggedOut == false) {
            Mouse.Click(975, 630);
            Screen.WaitForColor(new Point(533, 550), Color.FromArgb(255, 228, 228, 228), 5);
            Mouse.Click(535, 555);
            loggedOut = Screen.WaitForColor(new Point(850, 210), Color.FromArgb(255, 229, 148, 29), 5);
            if (0 > iterations--) {
                driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
            }
        }
    }
    public static bool Login(ChromeDriver driver, string username, string password) {
        try {
            Screen.WaitForColor(new Point(850, 210), Color.FromArgb(255, 229, 148, 29));

            Mouse.Click(685, 345);
            Screen.WaitForColor(new Point(975, 490), Color.FromArgb(255, 216, 216, 216)); Mouse.Click(865, 355);
            Thread.Sleep(800); Keyboard.Send(username).Enter(); Mouse.Click(865, 325);

            Mouse.Click(685, 425);
            Screen.WaitForColor(new Point(975, 490), Color.FromArgb(255, 216, 216, 216)); Mouse.Click(865, 355);
            Thread.Sleep(800); Keyboard.Send(password).Enter(); Mouse.Click(865, 325);

            Thread.Sleep(400); Mouse.Click(535, 555); Thread.Sleep(400);

            int Iterations_LoginNotifications = 0;
            while (Iterations_LoginNotifications++ < 20) {
                Thread.Sleep(250);
                bool dialogBoxPopped = Screen.GetColorAt(new Point(525, 315)).Equals(Color.FromArgb(255, 0, 55, 135));
                bool messageBoxPopped = Screen.GetColorAt(new Point(525, 315)).Equals(Color.FromArgb(255, 0, 55, 135));
                if (dialogBoxPopped) { Thread.Sleep(400); Mouse.Click(515, 455); }
                if (messageBoxPopped) { Thread.Sleep(400); Mouse.Click(940, 185); }
                if (dialogBoxPopped && messageBoxPopped) break;
            }

            // if (Screen.GetColorAt(new Point(930, 187)).Equals(Color.FromArgb(255, 228, 161, 35))) Mouse.Click(940, 185);
            if (Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181), 15).Equals(false)) {
                throw new Exception("Home Screen failed to load after 15 seconds.");
            }

            return true;

        } catch (Exception ex) {
            Console.WriteLine($"Exception on Login: {ex.Message}");
            return false;
        }
    }
}