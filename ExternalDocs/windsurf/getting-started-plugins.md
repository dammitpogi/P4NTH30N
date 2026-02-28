> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Welcome to Windsurf Plugins

> Install and set up Windsurf Plugins for JetBrains, VS Code, Visual Studio, Vim, NeoVim, Jupyter, Chrome, and other IDEs with AI-powered coding assistance.

**Windsurf Plugins** bring AI-powered coding assistance to your preferred IDE or editor.

<Card title="Teams and Enterprise" icon="users" href="/plugins/accounts/teams-getting-started">
  Get started with your team!
</Card>

<CardGroup cols={3}>
  <Card
    title="Cascade"
    icon={
    <svg
      width="25"
      height="25"
      viewBox="0 0 1292 1292"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M1195 599C1195 848.08 993.08 1050 744 1050C494.92 1050 293 848.08 293 599C293 349.92 494.92 148 744 148C993.08 148 1195 349.92 1195 599ZM411.5 599C411.5 782.635 560.365 931.5 744 931.5C927.635 931.5 1076.5 782.635 1076.5 599C1076.5 415.365 927.635 266.5 744 266.5C560.365 266.5 411.5 415.365 411.5 599Z"
        fill="#34E8BB"
      />
      <path
        d="M1096.19 1053.62C1116.8 1078.03 1113.86 1114.77 1087.65 1133.04C1002.41 1192.46 903.441 1229.92 799.584 1241.61C676.505 1255.46 552.082 1232.51 442.049 1175.65C332.016 1118.79 241.314 1030.58 181.415 922.172C130.87 830.693 104.172 728.301 103.33 624.396C103.071 592.449 131.338 568.79 163.173 571.479C195.007 574.168 218.29 602.208 219.218 634.143C221.573 715.175 243.206 794.78 282.679 866.22C331.512 954.6 405.457 1026.51 495.161 1072.87C584.866 1119.22 686.302 1137.94 786.643 1126.64C867.75 1117.51 945.198 1089.11 1012.66 1044.15C1039.24 1026.44 1075.58 1029.21 1096.19 1053.62Z"
        fill="#34E8BB"
      />
      <path
        d="M177.334 450.08C146.261 442.514 126.947 411.072 137.349 380.829C160.687 312.983 195.56 249.512 240.566 193.267C285.571 137.023 339.851 89.0802 400.928 51.4326C428.153 34.6511 463.065 46.5999 477.261 75.2582C491.457 103.917 479.508 138.389 452.641 155.738C406.542 185.506 365.436 222.584 330.994 265.627C296.552 308.67 269.39 356.906 250.456 408.411C239.421 438.428 208.408 457.646 177.334 450.08Z"
        fill="#34E8BB"
      />
    </svg>
  }
    href="/plugins/cascade/cascade-overview"
  >
    Windsurf's coding agent.
  </Card>

  <Card title="Usage" icon="bars-progress" href="/plugins/accounts/usage">
    Credits and usage.
  </Card>

  <Card title="Models" icon="robot" href="/plugins/cascade/models">
    Models available for use.
  </Card>
</CardGroup>

## JetBrains (Local)

<Note>
  These steps do not apply for enterprises on a self-hosted plan.
  If you are an enterprise user, please refer to the instructions in your enterprise portal.
</Note>

<Note>
  For remote development environments, use the "Windsurf (Remote Development)" plugin instead. See the [Remote Development section](#remote-development) below.
</Note>

<Steps>
  <Step title="Install Local Plugin">
    Open the `Plugins` menu in your JetBrains IDE. The shortcut for this is `⌘+,` on Mac and `Ctrl+,` on Linux/Windows. It is also accessible from the settings menu.
    Search for the Windsurf plugin, and install it. The plugin loader will prompt you to restart the IDE.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e33799e1448d861a017d76f8c81daab8" data-og-width="1368" width="1368" data-og-height="1052" height="1052" data-path="assets/jetbrains_plugin_install.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9fd0638ea39f24f470cd24a8d6e3700a 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b8c9b4838d07cbb0cb477f49fcf7659f 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=72dc21e16b15c6f2b0e13ceed560f8c4 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e1f9d2bceffa745a5487787382ebbfa4 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=94428045a530787f402d9cfa389729f8 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_plugin_install.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=4f00851b0234e8a481aa9a20c72961f9 2500w" />
    </Frame>
  </Step>

  <Step title="Wait for Language Server">
    Upon successful installation, Windsurf will begin downloading a language server.
    This is the program that communicates with our APIs to let you use Windsurf's AI features.
    The download usually takes ten to twenty seconds, but the download speed may depend on your internet connection.
    In the meantime, you are free to use your IDE as usual.

    You should see a notification on the bottom right to indicate the progress of the download.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=83c47b7eb7dc9329b628a46e8907def2" data-og-width="1174" width="1174" data-og-height="158" height="158" data-path="assets/jetbrains_ls_download_bar.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e61bb008da3ab29782aceef44a2e9d88 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=6eeba8339ea901196394bf1912132cef 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1c65098e81553ff68bf4bff80eb976a0 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=23a76b659007fe928a2cf6ff314a68e5 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=25969302c3a2abbbb60a2daa80bccd25 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=f04b9995097d675928760a7e546d5713 2500w" />
    </Frame>
  </Step>

  <Step title="Authorize">
    Open a project. Windsurf will prompt you to sign in with a notification popup at the bottom right linking you to a login page.
    Equivalently, click the widget at the right of the bottom status bar and select the login option there.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=bfa992229c936db6bf7a8127db88f45a" data-og-width="690" width="690" data-og-height="230" height="230" data-path="assets/jetbrains_login_widget.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=09182ac0963790dec8622fb99e34beb0 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=7fe6b1876ddc3720f719d04300ea5f55 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9d30ffe36b2a622968d83d90d2ea6d5b 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=93f54e0d9ccbc80f9b7d66e6a6378e14 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=ad5d4305bcec8771cf038bde807640b0 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=df3653940d8c5336400baa666cf9e47b 2500w" />
    </Frame>

    If you're not already signed in, you'll be prompted to sign in or create an account.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=672f1635e88f7046b5eb4b3105a2df7a" data-og-width="1896" width="1896" data-og-height="1442" height="1442" data-path="assets/login_prompt_webpage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=db65794f3cc9d2d96e9749cfb9b80483 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1e2030393a08040b3edce944b1003b7b 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b26d305a7c779494bb0ed0163a5b8357 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=89f1408e2589cef146bbf5dbe02a50a3 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=fa96ee1301840a5549005389757324cd 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=8d5b9aaeaf0f0c2fd75ee1bd12a9e849 2500w" />
    </Frame>

    Once you've signed in, the webpage will indicate that you can return to your IDE.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d7984d21a30dec05af01c3cd7e7b8f7c" data-og-width="1702" width="1702" data-og-height="450" height="450" data-path="assets/login_successful_webpage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d8eca1dc4cfeb08312bf679c0697631d 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=23cd31e8b0d21511fb91807ee653f899 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=beb4a54dac8a5dac142434ca28da5620 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=0c06cd132ae347e4237a2952c4c41dce 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=65828b581f20e71d39c398c1309b0056 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=98db7a38bf6b302ba716262e7241266d 2500w" />
    </Frame>
  </Step>

  <Step title="All Done!">
    You're all set. Windsurf's AI features — Autocomplete, Chat, Command, and more — are now available.

    At any point, you can check your status by clicking the status bar widget at the bottom right.
    If signed in, you will have access to your Windsurf settings and other controls.

    If you'd like early access to new features, click on "Switch to Pre-Release"
    to try out the [latest pre-release version](https://plugins.jetbrains.com/plugin/20540-windsurf-plugin-for-python-js-java-go--/versions/pre-release)
    of the plugin.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=88a5e47f629e1845d61e658b5deb78cb" data-og-width="688" width="688" data-og-height="542" height="542" data-path="assets/jetbrains_status_bar.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=6ca052f2cf4072827fe0180984f6d1d5 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=2fbb2d670a421204bc26db5ab2e68ba4 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=129172ac81e47df236bf764927276358 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=16f1bcd9b876b8798efc5c2d40c692e8 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=209654eb653db633278201a472142377 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_status_bar.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=4aac0c027b201204d2e095e6e0729f68 2500w" />
    </Frame>
  </Step>
</Steps>

### Remote Development

For JetBrains IDEs used in remote development environments, you need to use the separate "Windsurf (Remote Development)" plugin.

For advanced agentic AI capabilities and cutting-edge features, we strongly recommend using the native Windsurf Editor or the JetBrains local plugin. This plugin continues to receive the latest models, compatibility updates, and bug fixes, but does not include newer features exclusive to the Windsurf Editor.

#### Requirements

* JetBrains IDE version 2025.1.3 or greater

#### Installation Steps

<Steps>
  <Step title="Install on Host">
    Open the `Plugins (Host)` menu in your JetBrains IDE. The shortcut for this is `⌘+,` on Mac and `Ctrl+,` on Linux/Windows. It is also accessible from the settings menu.
    Search for **"Windsurf (Remote Development)"** and install it.
    Restart your IDE when prompted.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d211e58031d19dd7c14625882e105068" data-og-width="1494" width="1494" data-og-height="1110" height="1110" data-path="assets/jetbrains_remote_plugin_install_host.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=414c87310c072979677ba0f40c87ca39 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=2730fab386283bcda33d7dd3a4bcc680 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=3ffc5ed84ab5b76a7988ec43d13d9bd0 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b89fbb65563423783a5e3bdc10f1b798 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=0bc28c1317b0f8d495bfc8d528103644 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_host.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=7e116f50fadc495064267b0f28949269 2500w" />
    </Frame>
  </Step>

  <Step title="Install on Client">
    Open the `Plugins (Client)` menu and search for **"Windsurf (Remote Development)"**.
    Install the plugin and restart the IDE again.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=ab22c1e39b3e2213a042c5b77e9485da" data-og-width="1496" width="1496" data-og-height="1098" height="1098" data-path="assets/jetbrains_remote_plugin_install_client.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=db937a60880616dd0bd4a5f596ba92ec 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=8dec360498151e89fb91d5f44ed377d3 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1d9289fbf9d8439ee32f6e788d00a4cf 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=7dcc7308ca332a6ec3958bb7d0ab4b3e 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e306e9c40b837c5ac92d9dff86383483 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_remote_plugin_install_client.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1c249ed8f90c6ff91d2893bf5cfb3c0b 2500w" />
    </Frame>
  </Step>

  <Step title="Wait for Language Server">
    After installing the plugin on the host, Windsurf will begin downloading a language server.
    This is the program that communicates with our APIs to let you use Windsurf's AI features.
    The download usually takes ten to twenty seconds, but the download speed may depend on your internet connection.
    In the meantime, you are free to use your IDE as usual.

    You should see a notification on the bottom right to indicate the progress of the download.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=83c47b7eb7dc9329b628a46e8907def2" data-og-width="1174" width="1174" data-og-height="158" height="158" data-path="assets/jetbrains_ls_download_bar.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e61bb008da3ab29782aceef44a2e9d88 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=6eeba8339ea901196394bf1912132cef 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1c65098e81553ff68bf4bff80eb976a0 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=23a76b659007fe928a2cf6ff314a68e5 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=25969302c3a2abbbb60a2daa80bccd25 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_ls_download_bar.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=f04b9995097d675928760a7e546d5713 2500w" />
    </Frame>
  </Step>

  <Step title="Authorize">
    After the language server download is completed, Windsurf will prompt you to sign in with a notification popup at the bottom right linking you to a login page.
    Equivalently, click the widget at the right of the bottom status bar and select the login option there.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=bfa992229c936db6bf7a8127db88f45a" data-og-width="690" width="690" data-og-height="230" height="230" data-path="assets/jetbrains_login_widget.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=09182ac0963790dec8622fb99e34beb0 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=7fe6b1876ddc3720f719d04300ea5f55 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9d30ffe36b2a622968d83d90d2ea6d5b 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=93f54e0d9ccbc80f9b7d66e6a6378e14 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=ad5d4305bcec8771cf038bde807640b0 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_login_widget.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=df3653940d8c5336400baa666cf9e47b 2500w" />
    </Frame>

    If you're not already signed in, you'll be prompted to sign in or create an account.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=672f1635e88f7046b5eb4b3105a2df7a" data-og-width="1896" width="1896" data-og-height="1442" height="1442" data-path="assets/login_prompt_webpage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=db65794f3cc9d2d96e9749cfb9b80483 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1e2030393a08040b3edce944b1003b7b 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b26d305a7c779494bb0ed0163a5b8357 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=89f1408e2589cef146bbf5dbe02a50a3 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=fa96ee1301840a5549005389757324cd 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=8d5b9aaeaf0f0c2fd75ee1bd12a9e849 2500w" />
    </Frame>

    Once you've signed in, the webpage will indicate that you can return to your IDE.

    <Frame>
      <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d7984d21a30dec05af01c3cd7e7b8f7c" data-og-width="1702" width="1702" data-og-height="450" height="450" data-path="assets/login_successful_webpage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d8eca1dc4cfeb08312bf679c0697631d 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=23cd31e8b0d21511fb91807ee653f899 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=beb4a54dac8a5dac142434ca28da5620 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=0c06cd132ae347e4237a2952c4c41dce 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=65828b581f20e71d39c398c1309b0056 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_successful_webpage.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=98db7a38bf6b302ba716262e7241266d 2500w" />
    </Frame>
  </Step>

  <Step title="All Done!">
    You're all set. Windsurf's AI features are now available in your remote environment.
  </Step>
</Steps>

## Older Plugins

We strongly recommend using the native Windsurf Editor or the JetBrains local plugin for their advanced agentic AI capabilities and cutting-edge features.
The plugins below are in maintenance mode.

<Tabs>
  <Tab title="Visual Studio Code">
    <Steps>
      <Step title="Install Plugin">
        Find the Windsurf Plugin (formerly Codeium) in the VS Code Marketplace and install it.

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=543ab4d80d64932510d9db4378301ec0" data-og-width="3100" width="3100" data-og-height="2300" height="2300" data-path="assets/vscode_extension_page.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=fb00864f666577f53b8a181e1b88df08 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=0743d2d63420106c444beb5374ec7b3f 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=440c8a34f7c89bbf426e15667655829a 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=83b8a64f44cdbe1cf9efe010b7342956 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=eb7bb2de6afff351cebf2e18acc9cd84 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_extension_page.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=f2105aca1cfba29b0204d7d7106ad209 2500w" />
        </Frame>
      </Step>

      <Step title="Authorize">
        After installation, VS Code will prompt you with a notification in the bottom right corner to sign in to Windsurf.
        Equivalently, you can sign in to Windsurf via the profile icon at the bottom of the left sidebar.

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=40142fcfc135e01628f5545051b8120a" data-og-width="1870" width="1870" data-og-height="360" height="360" data-path="assets/vscode_login_init_left.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=2be3c8e105210bd0e97a58a664f4103a 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=01652fe32e88c74950f06f6672738d3e 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=839e1a7da0b9d1a067df915a4682d7a8 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=cc6ed5cf56bba1a46fa2351ea5ae4129 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=30ac41ca56988bc8be76bfec9e769143 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_login_init_left.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=434c27fe1917b8726a025f1486dcb51b 2500w" />
        </Frame>

        <Note>If you get an error message indicating that the browser cannot open a link from Visual Studio Code, you may need to update your browser and restart the authorization flow.</Note>
        If you're not already signed in, you'll be prompted to sign in or create an account.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=672f1635e88f7046b5eb4b3105a2df7a" data-og-width="1896" width="1896" data-og-height="1442" height="1442" data-path="assets/login_prompt_webpage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=db65794f3cc9d2d96e9749cfb9b80483 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1e2030393a08040b3edce944b1003b7b 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b26d305a7c779494bb0ed0163a5b8357 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=89f1408e2589cef146bbf5dbe02a50a3 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=fa96ee1301840a5549005389757324cd 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/login_prompt_webpage.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=8d5b9aaeaf0f0c2fd75ee1bd12a9e849 2500w" />
        </Frame>

        Once you sign in, you'll be redirected back to Visual Studio Code.
        <Note>If you are using a browser-based VS Code IDE like GitPod or Codespaces, you will be routed to instructions on how to complete authentication by providing an access token.</Note>
      </Step>

      <Step title="Wait for Language Server">
        Once you're signed in, Windsurf will start downloading a language server.
        This is the program that communicates with our APIs to let you use Windsurf's AI features.
        The download usually takes ten to twenty seconds, but the download speed may depend on your internet connection.
        In the meantime, you are free to use VS Code as usual.
      </Step>

      <Step title="All Done!">
        You're all set. Windsurf's AI features — Autocomplete, Chat, and Command — are now available.
      </Step>
    </Steps>
  </Tab>

  <Tab title="Vim / Neovim">
    ### Extension Installation

    <Steps>
      <Step title="Install Plugin">
        Follow the **Get Started** instructions in the public [`codeium.vim` repo](https://github.com/Exafunction/codeium.vim). That’s it!
      </Step>
    </Steps>

    ### Using Windsurf Plugin

    <Steps>
      <Step title="Setup">
        While Windsurf supports many languages, we’ll demonstrate with Python. Create a new file `test.py`.
      </Step>

      <Step title="From Code">
        Windsurf can suggest multiple lines of code from a partial function header:

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=409f51d6a4a90405ac91cee23edee16b" alt="Snippet one" data-og-width="508" width="508" data-og-height="260" height="260" data-path="assets/vim_tutorial/snippet_one.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=f7cf715f9ca4607000836ad41098c421 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=b064ea325a36519a2f081ddd4afc8c88 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=aa4513cd8c1daa07eb8a5473fad0226b 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=b56a682eb2e30c81e6904a36b5b72fcd 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=92686ebc384206730389c69594851839 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_one.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=31e4005807287bb3951513358bb5a5bc 2500w" />
        </Frame>
      </Step>

      <Step title="Accept Suggestion">
        Press **Tab** to accept.
      </Step>

      <Step title="From Comments">
        Windsurf also understands comments:

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=48c14b1d408acb68c97e5dac5c4ed421" alt="Snippet two" data-og-width="712" width="712" data-og-height="392" height="392" data-path="assets/vim_tutorial/snippet_two.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=2e064f0a8827a48f944eafe210e5c548 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=a22b17ea2cb1267b903e984279784a29 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=612bba50ea0377516d3a36fb91fc1d50 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=f20f1a31efb451e1b83b4cafeacd4250 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=234f14baa7491420f5d6acd5861b86ad 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vim_tutorial/snippet_two.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=5da32fd160fe285587e69c53c3e5798a 2500w" />
        </Frame>
      </Step>
    </Steps>
  </Tab>

  <Tab title="Visual Studio">
    ### Extension Installation

    <Steps>
      <Step title="Open Extension Marketplace">
        In the Visual Studio menu bar, click **Extensions → Manage Extensions**.

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=35d03bb50b8499567c41ea93fe8ea178" alt="Manage Extensions" data-og-width="636" width="636" data-og-height="171" height="171" data-path="assets/visual_studio_tutorial/manage_extensions.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=416afdc177726f0f9c866b723cfb09fa 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=e6df383e2a067ba6475470d6cbc34a95 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=8b672de47a30dae2279447d5071647d5 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=64ef339b35d3e09063b47214e9b27b64 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=82c6fe8c9bdd815b6acd429d0c565d93 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/manage_extensions.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=31660b8e9a9f255853e9c9a92c6c6f07 2500w" />
        </Frame>
      </Step>

      <Step title="Install Windsurf Plugin">
        In **Manage Extensions**, click **Visual Studio Marketplace**, search for **Windsurf**, then click **Download**.

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=1c004b5b2883643ab0724038ae1df460" alt="Install plugin" data-og-width="1413" width="1413" data-og-height="985" height="985" data-path="assets/visual_studio_tutorial/install.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=a007c5f8382e0817a778134f6694216c 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=862e9691e57566e2aa58c4d75e7a6122 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=a0e1e22639f1cd3f23c34a4711fe6c8c 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=e65588fa8b416221893890e1258f7833 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=9f93244c33e62ced42cd0821621d4f26 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/install.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=d25e02bc6f2eb42835819599d3abc677 2500w" />
        </Frame>
      </Step>

      <Step title="Relaunch Visual Studio">
        Close the window and relaunch Visual Studio.
      </Step>

      <Step title="Sign in to Windsurf Plugin">
        Open or create a project. A browser window will open and prompt you to sign in.
      </Step>

      <Step title="Create Account">
        If you don’t have an account yet, you’ll be redirected to create one.
      </Step>

      <Step title="All Done!">
        You're all set. Windsurf's AI features are now available in Visual Studio.
      </Step>
    </Steps>

    ### Using Windsurf Plugin

    <Steps>
      <Step title="Setup">
        While Windsurf supports many languages, we’ll demonstrate with C#. Create or open a C# file.
      </Step>

      <Step title="From Code">
        Windsurf can suggest multiple lines of code from a partial function signature:

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=3ddaac8fa3871d2e99b4c6dfffc5f789" alt="Suggestion example" data-og-width="1128" width="1128" data-og-height="461" height="461" data-path="assets/visual_studio_tutorial/suggestion.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=1448fac1000c33cdd119f88869c60dd5 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=0e4bc4744a3ed4375adcf78e03ff53eb 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=ab860784ccdd78a51e4543f509462bb5 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=6379563a39b42f35c75803f796df1237 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=25be46fdb00bacfa7fa2e0ef4c8bcdd6 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/suggestion.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=6f0edde75be0fcbb96831fc19c9cb24b 2500w" />
        </Frame>
      </Step>

      <Step title="Accept Suggestion">
        Press **Tab** to accept.

        <Frame>
          <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=34e5899a41e604482b545aac8bb0bf8f" alt="After accept" data-og-width="1215" width="1215" data-og-height="514" height="514" data-path="assets/visual_studio_tutorial/post_accept.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=547a8c512319311afde66b85fc384b65 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=5d6c7f779af6634ed38e464734cb7ab4 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=f65b3ac5034af9d806fe00c7d9aaf01e 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=936a5940183e70d7fb3c58272d78a7ff 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=86aabe30bd517678dff634ac3129a674 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/visual_studio_tutorial/post_accept.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=91c5bc89660bc155a52881097e3e5d32 2500w" />
        </Frame>
      </Step>
    </Steps>
  </Tab>

  <Tab title="Jupyter Notebook">
    ### Install Windsurf Plugin

    <Steps>
      <Step title="Install Jupyter Extension">
        Open a new Jupyter Lab session. In a cell, paste and run `Shift+Enter` the following:

        ```python  theme={null}
        import sys
        !{sys.executable} -m pip install -U pip --user
        !{sys.executable} -m pip install -U codeium-jupyter --user
        ```

        If you’re inside a virtual environment, run:

        ```python  theme={null}
        import sys
        !{sys.executable} -m pip install -U pip
        !{sys.executable} -m pip install -U codeium-jupyter
        ```

        When the commands finish, close the notebook and stop the Jupyter server.
      </Step>

      <Step title="Launch Jupyter">
        Relaunch Jupyter and open a notebook. Open the settings (<kbd>Ctrl</kbd> + <kbd>,</kbd>) and navigate to the **Windsurf** section. You’ll see fields for an enterprise URL and a token.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9f4d0045130c5c2bebe332eb1d61aeea" alt="Settings UI" data-og-width="1025" width="1025" data-og-height="301" height="301" data-path="assets/jupyter_tutorial/codeium_settings.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=162c3268841b817f01749aee3552dcc9 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e08893da2d05a135e0719e302ab8bbc8 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=bae56ae676f7ebd4b861d985c15b6623 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=163443a500f99b4873bf3f38271b5db1 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a4f11966eb9d3a054d82774cb3ee5eb3 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/codeium_settings.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d3cc874ea9e1112e0a8953ec7e454de2 2500w" />
        </Frame>

        Click **Get Windsurf Authentication Token** and follow the link. Paste the token back into the settings dialog.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a22a4747a45c1f02e43ca6e8cf73c043" alt="Settings menu" data-og-width="330" width="330" data-og-height="89" height="89" data-path="assets/jupyter_tutorial/settings_menu.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9ff8010f2bab99477dc6143a1c627404 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=3615e49192449c2871c742cc6812fa0a 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=4164277a320d562ec583876cea600b6b 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1ff36ad08f69cc0bde8d590034029758 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d29f63555bbc2cdc2ac54d98d0dc6e72 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/settings_menu.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=bb2a9dfeacd4adf7ff4cd9a90a78e1ed 2500w" />
        </Frame>

        <Note>If you can’t find the Windsurf settings, you likely didn’t restart Jupyter. Stop the server (Ctrl+C) and start it again with <code>jupyter lab</code>.</Note>
      </Step>

      <Step title="Create Account">
        If you don’t have a Windsurf account, you’ll be prompted to create one.
      </Step>

      <Step title="Authenticate">
        After signing in, copy the token and paste it into the settings dialog.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=51ac326b9b5870e5fdc8ff11c8ce6e8a" alt="Auth token field" data-og-width="818" width="818" data-og-height="326" height="326" data-path="assets/jupyter_tutorial/auth_token_setting.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=db97a07d99805d9c8a56f253acbd259f 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=4b4f08330a3041594a839d80ec833ddf 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=18c98ae77723fd5bc25f793eff2fcb90 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e974df5acdb06d0d7dadbef21684ccca 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b923ea1ace4ad384ec770bdbaac6a82a 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/auth_token_setting.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a3884bf89040738d3554afa0aac63f64 2500w" />
        </Frame>
      </Step>

      <Step title="All Done!">
        You're all set. Windsurf's AI features are now available in Jupyter.
      </Step>
    </Steps>

    ### Using Windsurf Plugin

    <Steps>
      <Step title="From Code">
        Windsurf can suggest multiple lines of code from a partial function header:

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=ace6fe93ebf37f70b9301a67636f2fd7" alt="Snippet one" data-og-width="1420" width="1420" data-og-height="346" height="346" data-path="assets/jupyter_tutorial/snippet_one.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=5db0e5ae372503b71b2d792aa632fd9b 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=5baa7f886ba56d65b421f2e2df295398 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=78745dbc56aef001c0b60bfa7092a06b 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e6ce86b48ef7d026e28600dae80aea89 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=77c19d0021a2e43fffe9a28268c8d7cd 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_one.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=33b460e1899dad65fe12aa43689f6fa9 2500w" />
        </Frame>
      </Step>

      <Step title="Accept Suggestion">Press **Tab** to accept.</Step>

      <Step title="From Comments">
        Windsurf also understands comments:

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d657826f2cac6722e9ba2633849b44dc" alt="Snippet two" data-og-width="1741" width="1741" data-og-height="518" height="518" data-path="assets/jupyter_tutorial/snippet_two.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=8094efb944365b016f410708e5854a34 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=425c1d267db9bcfacbbd6d996916368d 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=849f45ba96471b2b53677d80d8eae790 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=611df7d45ea5789a06981329dfcb5dc5 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=214e01071dc31a3e44f7ce0633d0a6ab 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jupyter_tutorial/snippet_two.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9c2459b43729aa7e660731b8ea879366 2500w" />
        </Frame>
      </Step>
    </Steps>
  </Tab>

  <Tab title="Chrome">
    ### Install Windsurf

    <Steps>
      <Step title="Install Chrome Extension">
        Visit the [Chrome Web Store page](https://chrome.google.com/webstore/detail/codeium/hobjkcpmjhlegmobgonaagepfckjkceh) and click **Add to Chrome**.

        <Frame>
          <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=9989340a425cba8df53bb8f85dd34813" alt="Chrome Web Store" data-og-width="2070" width="2070" data-og-height="1608" height="1608" data-path="assets/chrome_tutorial/chrome_web_store.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=834cc3bb444ad9ec13a8a989346e666b 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6e812133130031e529828fff3f925b14 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6a3736332b19591e34d3782a88f09b12 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=48f83426105236382b48c7f51928db2b 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3751fafd621904917842eaf0f2f2398e 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/chrome_web_store.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=df259a9f0ecf6c7189ac297e9aefdbce 2500w" />
        </Frame>
      </Step>

      <Step title="Pin Extension">
        Open the extensions dropdown and click the **Pin** icon so the Windsurf icon stays visible.

        <Frame>
          <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=e291a9235581423bb3434721d89aeddb" alt="Pin extension" data-og-width="1106" width="1106" data-og-height="674" height="674" data-path="assets/chrome_tutorial/pin_extension.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=a9dd8b598724993cd71c448707c9ab2b 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=c215fd00878ef5f2c809f8e2acade79e 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=ee817d72513244ad9532d264047cfbbd 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=e6130b064d7b038d0d13d38dd1d3d194 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=0f4b67a7564baaf43ee4ae9450f1f381 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/pin_extension.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=c9ef5340e75b9d05fd524b01f2c57c39 2500w" />
        </Frame>
      </Step>

      <Step title="Sign In">
        The extension opens a login page automatically. If not, click the extension icon and follow the link.

        <Frame>
          <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=b92a046f9481a49030330a057a6d7177" alt="Sign in" data-og-width="1106" width="1106" data-og-height="674" height="674" data-path="assets/chrome_tutorial/sign_in.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=471978ae434d9be2305be09601c2a7ad 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3704e3bcba6b7aade113cf2ad3398ccf 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=9f875919b3bdccc1d3b08275b90ccea5 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=21fd3d55dc25b0bfcc2004cefb67bc3f 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=a951cddb545a99b0de7ddcc390eb7b0d 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/sign_in.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=15b6d1d12cd6bb88a536d565fb7b6a95 2500w" />
        </Frame>
      </Step>

      <Step title="All Done!">
        You're all set. Try [creating a new Colab notebook](https://colab.research.google.com/#create=true).

        <Frame>
          <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=0a3dbc6098340fbda5885248e4f30971" alt="Signed in" data-og-width="1106" width="1106" data-og-height="674" height="674" data-path="assets/chrome_tutorial/signed_in.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=01dc7f61188923760b5a75f1e2532124 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=7ffcf643cbe32654bc80eff70440d75d 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=5d3c9563cbd760cd488223912c9445d3 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6edc863a24ebb25ae271d4918d562852 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6de5eb4216cb63af89d8d18884b07b9b 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/signed_in.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=4ff317a853324b3144067cb8f1fa3102 2500w" />
        </Frame>
      </Step>
    </Steps>

    ### Using Windsurf

    <Steps>
      <Step title="From Code">
        Windsurf can suggest multiple lines of code from a partial function header:

        <Frame>
          <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=907e36fdf207886da70c41f1efe7e7b7" alt="Snippet one" data-og-width="1106" width="1106" data-og-height="674" height="674" data-path="assets/chrome_tutorial/snippet_one.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=53b5257099a5bd20c890b67e4080f08f 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=29fa468001dd327293c5a14ee43a5695 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=7fc22df136b0461ebc35bb41dfb8af83 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=9e1db1d578ab2168339fce418197fd41 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3fb969227f2f5d800e4067a49e020079 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_one.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=91802d76fd6c9806f46943604c99339f 2500w" />
        </Frame>
      </Step>

      <Step title="Accept Suggestion">Press **Tab** to accept.</Step>

      <Step title="From Comments">
        Windsurf also understands comments:

        <Frame>
          <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=db1902f22de4179508f52be5c3c6a93d" alt="Snippet two" data-og-width="1106" width="1106" data-og-height="766" height="766" data-path="assets/chrome_tutorial/snippet_two.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=d2be18c5a55cb46ccfc9f0ce8a3c002a 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=4e93fd3dea87d4bc03835c46b53bf0f3 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6357d45579279755890cd64528d746dd 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=ab818650cfb3bfae7e55e2c18112414f 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=404add16420561c8841b41fadff1a98b 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chrome_tutorial/snippet_two.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=4a40487f9d3c5bfa9c0eefba4a11ace9 2500w" />
        </Frame>
      </Step>
    </Steps>
  </Tab>

  <Tab title="Eclipse">
    ### Extension Installation

    <Steps>
      <Step title="Drag the Install button">
        Visit the [Windsurf Plugin page on Eclipse Marketplace](https://marketplace.eclipse.org/content/codeium) and drag the **Install** button to the Eclipse toolbar.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=363884b6bb7b71f1efab7219883a9271" alt="Drag Install button" data-og-width="1430" width="1430" data-og-height="732" height="732" data-path="assets/eclipse_tutorial/drag.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=37d5eaf723594c3fd6599c03c297ae20 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a83d8af2d19370650ac88366c0252214 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=44297a3be5cb504566c11c867e17f5c5 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=3f9b740b3f5bc0b67a037bf1c403606b 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=02bcaddcb99d549b2d323751ef4fba6c 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/drag.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=4aedfb377482d2ac03d8d99f55158dfc 2500w" />
        </Frame>
      </Step>

      <Step title="Confirm Selected Features">
        In the **Confirm Selected Features** prompt, click **Confirm**.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a32ed25242dcb249c11a7b549b879fcf" alt="Confirm features" data-og-width="1192" width="1192" data-og-height="666" height="666" data-path="assets/eclipse_tutorial/confirm.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=8a134c9e360984f92cbca1ee217ca2f9 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=7d08236d876c313f7257c74df221414b 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=32a3a79993859fc6ec8ea268333b6767 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=f86f1eb16741cbc52b7b21bdf0bcf593 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=ac140245225a09c3ab6469b898ed682c 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/confirm.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b0635e1f3b6066136c0731c5eadc9715 2500w" />
        </Frame>
      </Step>

      <Step title="Trust Unsigned Content">
        In the **Trust Artifacts** prompt, select **Unsigned** and click **Trust**.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=e8181502397e14314c82d732bc56bddc" alt="Trust unsigned" data-og-width="1154" width="1154" data-og-height="590" height="590" data-path="assets/eclipse_tutorial/trust.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=47cfb9f8ae6aeab5b9a87d08c0facc48 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=1f9478bea57ad783cd3c0f7b446436aa 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=361d411feec0edc856f5dd46437f3512 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=5c1459169457ee70f9cc2c82b6faef70 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=3ea5f60185028fb4b52cdf7087ec0551 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/trust.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a0f54f8feacf2b1e30da3808022c1567 2500w" />
        </Frame>
      </Step>

      <Step title="Restart Eclipse">
        When prompted, restart Eclipse to complete the installation.

        <Frame>
          <img src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=237032c3f9306b396c29a8c24bece219" alt="Restart Eclipse" data-og-width="1084" width="1084" data-og-height="242" height="242" data-path="assets/eclipse_tutorial/restart.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=d6d53e409bcdc6e4f756a6aaf29faba3 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=2877868a2b0a70233684ce58a34e0b44 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=9e4c0f636cd24e2b12bbe4d5e436070d 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=6ef483575c3fdf79072e016894621a50 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=a4ea8f50dc911e9b5ec2a85f161e0b37 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/eclipse_tutorial/restart.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=722f43d8070574cac6c61d6374fe973b 2500w" />
        </Frame>
      </Step>

      <Step title="Create / Sign In">
        When the browser opens, sign in or create an account, then return to Eclipse.
      </Step>

      <Step title="All Done!">You're all set. Windsurf's AI features are now available in Eclipse.</Step>
    </Steps>

    ### Using Windsurf

    <Steps>
      <Step title="Setup">
        While Windsurf supports many languages, we’ll demonstrate with Java. Create a new file `Fib.java`.
      </Step>

      <Step title="From Code">
        Windsurf can suggest multiple lines of code from a partial function header:

        ```java  theme={null}
        package test;

        public class Fib {

            public int fib(int n) {
            }

        }
        ```
      </Step>

      <Step title="Accept Suggestion">Press **Tab** to accept.</Step>
    </Steps>
  </Tab>
</Tabs>
