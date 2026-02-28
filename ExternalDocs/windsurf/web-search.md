> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Web and Docs Search

> Enable Cascade to search the web and read documentation pages in real-time using @web and @docs mentions for up-to-date context.

Cascade can now intuitively parse through and chunk up web pages and documentation, providing realtime context to the models. The key way to understand this feature is that Cascade will browse the Internet as a human would.

Our web tools are designed in such a way that gets only the information that is necessary in order to efficiently use your credits.

## Overview

To help you better understand how Web Search works, we've recorded a short video covering the key concepts and best practices.

<iframe width="560" height="315" src="https://www.youtube.com/embed/moIySJ4d0UY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen />

### Quick Start

The fastest way to get started is to activate web search in your Windsurf Settings in the bottom right corner of the editor. You can activate it a couple of different ways:

1. Ask a question that probably needs the Internet (ie. "What's new in the latest version of React?").
2. Use `@web` to force a docs search.
3. Use `@docs` to query over a list of docs that we are confident we can read with high quality.
4. Paste a URL into your message.

## Search the web

Cascade can deduce that certain prompts from the user may require a real-time web search to provide the optimal response. In these cases, Cascade will perform a web search and provide the results to the user. This can happen automatically or manually using the `@web` mention.

<Frame style={{ border: "none", background: "none" }}>
  <img src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=b525aef8bc3d129ee5a6d93d10c2cb06" data-og-width="1150" width="1150" data-og-height="530" height="530" data-path="assets/windsurf/cascade/cascade-search-web.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=e2eee016969bdcd5f0572659690c7df7 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=3b131c992adfe832ded1b8722cbb4e7f 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=2cdac74f260dedf5da5bf42abe82869d 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=27abbec8f15aeec6e0319093cbf4d049 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=e96bf16e2f5a79fce342efbbf2bed8fb 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-search-web.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=f95fde4ebf0cac5e0dfb792ae238d071 2500w" />
</Frame>

## Reading Pages

Cascade can read individual pages for things like documentation, blog posts, and GitHub files. The page reads happen entirely on your device within your network so if you're using a VPN you shouldn't have any problems.

Pages are picked up either from web search results, inferred based on the conversation, or from URLs pasted directly into your message.

We break pages up into multiple chunks, very similar to how a human would read a page: for a long page we skim to the section we want then read the text that's relevant. This is how Cascade operates as well.

<Frame style={{ border: "none", background: "none" }}>
  <img src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=9963f9eadcca6c5e8152cae398999e00" data-og-width="1158" width="1158" data-og-height="538" height="538" data-path="assets/windsurf/cascade/cascade-parse-url.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=4b943dbae4a899d98f8d1e30588634a2 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=1f549cf84cb41fb9b853d87d9972e069 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=a79f381fe2fae01f383bf4836f734055 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=a67a8ec724d365f27c18e4a6f6d25f08 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=c791fad06d7c86395d52d4792f321eb5 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-parse-url.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=e04bbf62bc9adbbd5c40d2d1e27d9bcf 2500w" />
</Frame>

It's worth noting that not all pages can be parsed. We are actively working on improving the quality of our website reading. If you have specific sites you'd like us to handle better, feel free to file a feature request!
