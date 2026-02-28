> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Visual Studio Code (VSCode) Troubleshooting

> Troubleshoot VS Code extension issues including proxy settings, certificate errors, API server configuration, and chat response problems.

<Note>
  We strongly recommend using the native Windsurf Editor or the JetBrains local plugin for their advanced agentic AI capabilities and cutting-edge features.
  The VSCode plugin is under maintenance mode.
</Note>

VSCode 1.89 or greater are supported.

# Gathering extension logs

Starting in VS Code Extension 1.10.0, the Extension Diagnostics are accessible for download via the Settings page. This download will contain a collection of relevant logs and parameters into a text file.

*For full output logs of VSCode:*

1. Go to the Command Palette (`Ctrl/Cmd + Shift + P` or go to View > Command Palette)

2. Type in "Show logs" and select the option that reads `Developer: Show Logs`

3. From the dropdown, select `Extension Host`

4. You should see something similar to the image below:

<Frame>
  <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=8a5317496a257a1efffaf5191c7963c9" data-og-width="2244" width="2244" data-og-height="410" height="410" data-path="assets/plugins/troubleshooting-vscode-showlogs.jpg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=4268142b3843c514977b07d8388232a3 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=728c2a187b07fa4e33dc32f5a9c7e9fb 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=2635e312277210b8124f3676fe9b13ed 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=33cab90539c14a54e1d5b29d7d2a6f1e 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=a249a33aaa1e4a9c8b6f99e08e08e8bc 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/plugins/troubleshooting-vscode-showlogs.jpg?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=271ab0396f1060a9cfda797488f66eda 2500w" />
</Frame>

5. Change the dropdown in the top right that reads "Extension Host" and select "Codeium"

6. Export or copy the logs

# Known IDE issues and solutions

## e.split is not defined

You are using an unsupported VS Code version, please update to a supported version and try again. You can find a list of supported versions [here](/plugins/compatibility).

## Using the wrong API Server

If a user changes their API Server/Portal URL in their **workspace** settings, this will override their user settings and may result in an error where the extension is communicating with the wrong API server.

Make sure that your API Server/Portal URL is set correctly and not overridden accidentally by the workspace settings.

## Not seeing Codeium Chat responses

If you are trying to send messages to Codeium chat but not seeing responses, check if you can cancel the response. If you are unable to cancel the response, this means that the response was completed but not displayed. This can happen if the Chat Web Server loses connection to the extension. Reloading VS Code and opening the Codeium Chat panel again should show the responses.

## Unable to read file .../package.json

```
Unable to read file .../.vscode/extensions/codeium.codeium-<version>/package.json
```

If the above error shows up in the Codeium logs, try deleting the extension folder (.../.vscode/extensions/codeium.codeium-\<version>) and reinstall the extension.

In order to do so manually:

1. Open the command palette ( CTRL + SHIFT + P )
2. Run 'Codeium Enterprise: Reset'
3. Select "Help" from the popup
4. Select "Show Disabled Extensions"
5. Re-enable your Codeium Extension

## Proxy / Network Issues

Unchecking `Detect Proxy` in Codeium settings in VSCode can sometimes resolve issues where the extension is incorrectly attempting to use a proxy.

## Certificate Issues

If you encounter the following errors:

```
ConnectError: [internal] unable to get issuer certificate
```

```
[ERROR]: [internal] unable to verify the first certificate
```

```
tls: failed to verify certificate: x509: "<yourdomainurl>" certificate is not standards compliant
```

This suggests that the Codeium extension is unable to trust the TLS connection to your enterprise portal / API server because it does not trust the certificate being presented. This either means that the certificate presented by the Codeium deployment is untrusted or a certificate presented by a corporate proxy intercepting the request is untrusted.

In either case, the most preferable solution is to ensure that the root certificate that signed this certificate is properly installed on end-user machines in the appropriate location. VS Code and most other IDEs load certificates from the operating system's default location.

Your certificate is issued and managed by your local IT or Admin team. Please reach out to them for assistance with installing the necessary certificates on your system.

It is important that the full certificate chain is being presented from wherever TLS is being terminated. Oftentimes, if only the leaf certificate is presented, VS Code and other IDEs are unable to verify its authenticity because they are not aware of the intermediate certificate which validates the leaf certificate and is validated by the root certificate. Browsers are often able to work around this issue as users will likely have encountered a different website that does present the full certificate chain, so the intermediate cert is seen and cached, but applications like VS Code don't have this advantage.

The Network Proxy Text VS Code extension is useful for debugging certificate issues.
