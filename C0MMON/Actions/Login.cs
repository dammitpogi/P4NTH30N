using System;
using System.Drawing;
using OpenQA.Selenium.Chrome;

namespace P4NTHE0N.C0MMON;

public static partial class Actions
{
	public static bool Login(this ChromeDriver driver, string username, string password)
	{
		try
		{
			int iterations = 0;
			while (true)
			{
				// Console.WriteLine("LoginIteration: " + iterations);
				if (iterations++.Equals(10))
					throw new Exception($"[{username}] Credential retries limit exceeded. Skipping this Credential.");

				Mouse.Click(470, 310);
				Thread.Sleep(400);
				Keyboard.Send(username);
				Mouse.Click(470, 380);
				Thread.Sleep(400);
				Keyboard.Send(password).Wait(400).Enter();
				bool NotReloaded = true,
					Loaded = false;

				int loadingIterations = 0;
				while (Loaded == false && NotReloaded)
				{
					Thread.Sleep(200);

					bool HomeScreenLoaded = Screen.GetColorAt(new Point(892, 120)).Equals(Color.FromArgb(255, 254, 250, 38));
					bool MessageBoxPopped = Screen.GetColorAt(new Point(937, 177)).Equals(Color.FromArgb(255, 228, 227, 70));
					Loaded = HomeScreenLoaded || MessageBoxPopped;

					loadingIterations++;
					if (loadingIterations > 300)
					{
						throw new Exception("Login took too long.");
					}

					if (Screen.GetColorAt(new Point(535, 403)).Equals(Color.FromArgb(255, 121, 125, 47)))
					{
						driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
						Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51));
						NotReloaded = false;
						break;
					}

					if (Loaded)
					{
						for (int i = 0; i < 14; i++)
						{
							if (Screen.GetColorAt(new Point(937, 177)).Equals(Color.FromArgb(255, 228, 227, 70)))
							{
								Mouse.Click(937, 177);
								break;
							}
							else
								Thread.Sleep(200);
						}
					}
				}
				if (NotReloaded)
					break;
			}
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Exception on Login: {ex.Message}");
			return false;
		}
	}
}
