using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

// Legacy wrapper retained for tools that still call FireKirin directly.
public static class FireKirin {
	public static bool Login(ChromeDriver driver, string username, string password) {
		return FireKirinFlow.Login(driver, username, password);
	}

	public static void Logout() {
		FireKirinFlow.Logout();
	}
}
