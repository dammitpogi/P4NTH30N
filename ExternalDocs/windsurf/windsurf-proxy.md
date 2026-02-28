> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Proxy Configuration in Windsurf Editor

> Configure HTTP/HTTPS proxy settings for Windsurf Editor in corporate networks. Includes auto-detect, manual configuration, and SSH remote proxy setup.

Some corporate and enterprise networks route traffic through HTTP/HTTPS proxies. Windsurf Editor needs to reach a few external services (for sign-in and AI features), so you may need to configure a proxy before things work reliably.

In particular, proxy configuration may be required if:

* You see **"Failed to connect"** or similar network errors

* The **editor or Cascade panel shows a blank screen** and never loads

* Cascade or other cloud-backed features **cannot load or connect**

* Sign-in or activation flows fail unexpectedly

All proxy options live in **Windsurf Settings**. You can open them from the **top-right dropdown → Windsurf Settings**, or via the **Command Palette (Ctrl/⌘+Shift+P) → "Open Windsurf Settings Page"**.

***

## **1. Check whether your network uses a proxy**

Before changing anything in the editor:

1. **Ask your IT / infra / network team**:

   * Do we use an HTTP/HTTPS proxy for outbound traffic?

   * If yes, is it configured **automatically** (system settings / PAC file), or do I need to configure it **manually** in applications?

2. If your organization does **not** use a proxy, you usually don't need to change these settings.

3. If your organization does use one, collect the proxy details (address, port, and any credentials) from your IT team.

You can share a screenshot of the Windsurf proxy settings with them so they can tell you exactly what to fill in.

***

## **2. Use your system proxy ("Detect proxy")**

If your proxy is **already configured on your machine** (for example via system network settings or a PAC file), you can let Windsurf detect and reuse it:

1. Open **Windsurf Settings**.

2. In the settings search bar, type **"proxy"**.

3. Locate the **Detect proxy** toggle (see screenshot).

4. Turn **Detect proxy** **ON**.

5. Close the settings page and **restart Windsurf Editor**.

6. Try again:

   * Reload the editor / Cascade

   * Retry sign-in or any previously failing operation

<Frame style={{ border: 'none', background: 'none' }}>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=a1d3af3f5373df545673865fed24697f" data-og-width="1773" width="1773" data-og-height="790" height="790" data-path="assets/windsurf/proxy-detect-proxy-setting.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?w=280&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=2f6331eb85274e8c72faf513d8e959d0 280w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?w=560&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=5e9e89fef86395266a8b5f28477eb871 560w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?w=840&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=bda2658c46a8d21e3d4ab35050be5b23 840w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?w=1100&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=8b1361b3cbf8761247cedcd46c3587de 1100w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?w=1650&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=4ed02d6803aca6770e95cfccc23ddeda 1650w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-detect-proxy-setting.png?w=2500&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=4b283fb6eca856637928945ce25cae56 2500w" />
</Frame>

If things stop working after enabling this, you can turn **Detect proxy** back **OFF** and use manual settings instead (see next section), or follow guidance from your IT team.

***

## **3. Manually configure a proxy in Windsurf Editor**

If your organization requires you to **manually specify** the proxy in applications:

1. Collect the required details from your IT / infra team:

   * **Proxy protocol + address** (for example `http://proxy.company.com:8080` or `https://proxy.company.com:8443`)

   * Whether the proxy **requires authentication**

   * Your **proxy username/password** or other credentials, if needed

2. Open **Windsurf Settings**.

3. In the settings search bar, type **"proxy"** to open the proxy configuration section (see screenshot).

4. Fill in the fields:

   * **Proxy URL / address** – include protocol and port (e.g. `http://proxy.company.com:8080`)

   * **Authentication** – if your proxy requires it, enter the username and password fields shown in the UI

5. (Optional, if recommended by IT) Turn **Detect proxy** **ON** if your setup still relies on system/PAC detection alongside the manual settings.

6. Close the settings page and **restart Windsurf Editor** so the new proxy configuration is fully applied.

7. Try again:

   * Reload the editor or Cascade if you previously saw a **blank screen**

   * Retry the operation that was failing with **"Failed to connect"** or similar errors

<Frame style={{ border: 'none', background: 'none' }}>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=7bc6103beb74c91208fe342992217dea" data-og-width="1418" width="1418" data-og-height="1430" height="1430" data-path="assets/windsurf/proxy-manual-configuration.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?w=280&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=ef9f1b3410da3fe8776f1ad2eb419c96 280w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?w=560&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=702bd073a97f4112c9e76d53adf3dc48 560w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?w=840&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=712a60ff3b35955aaecaca8972da366b 840w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?w=1100&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=ce168c344baee5bd57e56abe2eefa8ee 1100w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?w=1650&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=d888c7b78f525fee3d8870ef5981d52a 1650w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-manual-configuration.png?w=2500&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=623ea038b7a99d01e36ca63a7d319ef2 2500w" />
</Frame>

***

## **4. Proxy settings for remote development (SSH / dev containers)**

If you use **remote development** (for example a dev container or Windsurf SSH remote), there is a separate set of proxy settings that control traffic between your local Windsurf Editor and the **remote** environment.

You may need to adjust these settings if:

* Connecting to a **dev container** or **SSH remote** fails or times out

* The remote window opens, but tools that depend on the network don't work as expected

* Your IT / infra team says the **remote host** must also go through a proxy

To configure the proxy for remote environments:

1. Open **Windsurf Settings**.

2. In the search bar, type **"proxy"**.

3. Under **User → Extensions → Windsurf Remote…**, locate:

   * **Remote › Windsurf SSH: Http Proxy**

   * **Remote › Windsurf SSH: Https Proxy**

4. Enter the proxy address(es) provided by your IT / infra team (usually including protocol and port, for example `http://proxy.company.com:8080`).

5. Restart the remote session (close the remote window and reconnect, or restart the dev container) and try again.

<Note>These **remote** proxy settings are independent from the general proxy / Detect proxy options described above. In some environments you may need to configure **both** the local editor proxy and the Windsurf Remote SSH proxy values.</Note>

<Frame style={{ border: 'none', background: 'none' }}>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=195e25ee466aab96a8cde2965d2222f3" data-og-width="1938" width="1938" data-og-height="903" height="903" data-path="assets/windsurf/proxy-remote-ssh-settings.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?w=280&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=86cd824f54a74f3ea601c58bb7d103e7 280w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?w=560&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=4d4c4363168e537da3e0c0e025d8b597 560w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?w=840&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=4bd9b6797a0d9d3cb6400a20e4ba3415 840w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?w=1100&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=e29db80228010fa32f40f2bbb6a63ca3 1100w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?w=1650&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=04355a89927533be56bdc0f8508a696c 1650w, https://mintcdn.com/codeium/wMUgYjlL-wAQ3CJD/assets/windsurf/proxy-remote-ssh-settings.png?w=2500&fit=max&auto=format&n=wMUgYjlL-wAQ3CJD&q=85&s=944281d9600a09e55b4f3582c0f31839 2500w" />
</Frame>

***

## **5. When to use which option**

* **Use "Detect proxy" only** if:

  * Your organization configures proxies centrally on your device (system network settings, PAC file), **and**

  * IT tells you apps should "just pick up the system proxy."

* **Use manual configuration (with or without Detect proxy)** if:

  * IT gives you a specific proxy URL and credentials to enter in each application, or

  * Auto-detection in your environment is unreliable or not supported.

If you're unsure which of these applies to you, your **IT / infra team is the source of truth**—they can confirm whether you need proxy settings at all, what to enter, and whether the **Detect proxy** toggle should be on or off.
