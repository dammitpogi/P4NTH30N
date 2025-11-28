using System.Diagnostics;
using System.Net.NetworkInformation;
using System.Text.Json;
using System.Threading.Tasks;
using C0MMON.Entities;
using Figgle;
using P4NTH30N;
using P4NTH30N.C0MMON;

namespace P4NTH30N {
    [GenerateFiggleText(sourceText: "v    0 . 2 . 3 . 4", memberName: "Version", fontName: "colossal")]
    internal static partial class Header { }
}

internal class Program {

    internal static readonly string[] ForbiddenRegions = ["Nevada", "California"];
    private static async Task Main(string[] args) {
        Console.WriteLine(Header.Version);
        
        // bool debug = new Ping().Send("google.com", 1000, new byte[32], new PingOptions()).Status.Equals(IPStatus.Success);
        
        string runMode = args.Length > 0 ? args[0] : "H4ND";
        if (new[] { "H4ND", "H0UND" }.Contains(runMode).Equals(false)) {
            string errorMessage = $"RunMode Argument was invalid. ({runMode})";
            Console.WriteLine(errorMessage); Console.ReadKey(true).KeyChar.ToString();
            throw new Exception(errorMessage);
        }
        Console.WriteLine($"RunMode Activated: {runMode}");

        string myIP = "";
        HttpClient client = new();

        while (myIP == "") {
            Thread.Sleep(TimeSpan.FromSeconds(1));
            myIP = await NetworkAddress.MyIP(client);
        }

        string homeIP = (string)myIP.Clone();
        Console.WriteLine($"Home IP Address: {homeIP}");
        Console.WriteLine($"Started: {DateTime.Now:f}");
        Mouse.Click(749, 697); // Cyberghost taskbar

        while (new[] { "", homeIP }.Contains(myIP)) {
            try {
                Thread.Sleep(TimeSpan.FromSeconds(1));
                myIP = await NetworkAddress.MyIP(client);
            } catch { }
        }

        NetworkAddress network = await NetworkAddress.Get(client);
        while (ForbiddenRegions.Contains(network.location.state_prov)) {
            // Mouse.Click(1279, 280);
            Mouse.Click(1120, 280);

            Thread.Sleep(TimeSpan.FromSeconds(3));
            while (myIP != homeIP) {
                Thread.Sleep(TimeSpan.FromSeconds(1));
                myIP = await NetworkAddress.MyIP(client);
            }

            Thread.Sleep(TimeSpan.FromSeconds(2));
            Mouse.Click(1120, 280);

            Thread.Sleep(TimeSpan.FromSeconds(3));
            while (new[] { homeIP, "" }.Contains(myIP)) {
                Thread.Sleep(TimeSpan.FromSeconds(1));
                myIP = await NetworkAddress.MyIP(client);
            }

            network = await NetworkAddress.Get(client);
        }
        Console.WriteLine($"VPN Location, Region: {network.location.state_prov}");
        Console.WriteLine($"VPN Location, District: {network.location.district}");

        File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(false));
        ProcessStartInfo H4ND = new() {
            FileName = @"C:\OneDrive\P4NTH30N\H4ND\bin\release\net9.0-windows\H4ND.exe",
            WindowStyle = ProcessWindowStyle.Normal,
            UseShellExecute = true,
            CreateNoWindow = false,
            Arguments = runMode
        };
        Process.Start(H4ND);
        Console.WriteLine("Session successfully launched...\n");

        int minutesToSleep = 30 + new Random().Next(1, 31);
        DateTime timeToSleep = DateTime.Now.AddMinutes(minutesToSleep);
        Console.WriteLine($"Session will restart at {timeToSleep:t}.\n");

        // Thread.Sleep(TimeSpan.FromMinutes(minutesToSleep));

        bool internetDetected = true;
        while (DateTime.Now < timeToSleep && internetDetected) {
            Thread.Sleep(TimeSpan.FromMinutes(1));
            try {
                internetDetected = new Ping().Send("google.com", 1000, new byte[32], new PingOptions()).Status.Equals(IPStatus.Success);
            } catch (Exception) { internetDetected = false; }
        }

        bool spinningForSignal = true;
        while (spinningForSignal && internetDetected) {
            spinningForSignal = bool.Parse(File.ReadAllText(@"D:\S1GNAL.json"));
            if (spinningForSignal) Thread.Sleep(TimeSpan.FromMinutes(1));
        }

        ProcessStartInfo RestartWindows = new() {
            FileName = "cmd",
            Arguments = "/C shutdown -f -r -t 0",
            WindowStyle = ProcessWindowStyle.Normal,
            UseShellExecute = true,
            CreateNoWindow = false
        };
        Process.Start(RestartWindows);
    }
}