using System.Net.Http.Json;

namespace C0MMON.Entities;

public class CountryMetadata {
    public string calling_code { get; set; }
    public string tld { get; set; }
    public List<string> languages { get; set; }
}

public class Currency {
    public string code { get; set; }
    public string name { get; set; }
    public string symbol { get; set; }
}

public class Location {
    public string continent_code { get; set; }
    public string continent_name { get; set; }
    public string country_code2 { get; set; }
    public string country_code3 { get; set; }
    public string country_name { get; set; }
    public string country_name_official { get; set; }
    public string country_capital { get; set; }
    public string state_prov { get; set; }
    public string state_code { get; set; }
    public string district { get; set; }
    public string city { get; set; }
    public string zipcode { get; set; }
    public string latitude { get; set; }
    public string longitude { get; set; }
    public bool is_eu { get; set; }
    public string country_flag { get; set; }
    public string geoname_id { get; set; }
    public string country_emoji { get; set; }
}

public class NetworkAddress {
    public string ip { get; set; }
    public Location location { get; set; }
    public CountryMetadata country_metadata { get; set; }
    public Currency currency { get; set; }

    public static async Task<NetworkAddress> Get(HttpClient client) {
        string url = "https://api.ipgeolocation.io/v2/ipgeo?apiKey=b4d1fe0cfaac4fd2adde2fa732c472e3";
        NetworkAddress? data = await client.GetFromJsonAsync<NetworkAddress>(url);
        return data ?? new NetworkAddress();
    }

    public static async Task<string> MyIP(HttpClient client) {
        try {
            HttpResponseMessage response = await client.GetAsync("https://api.ipify.org");
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        } catch { return ""; }
    }
}

