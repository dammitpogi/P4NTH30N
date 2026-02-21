# Tool Output: tool_c6441c431001TwdW3dQCtvy3Ae
**Date**: 2026-02-16 02:22:37 UTC
**Size**: 92,843 bytes

```
{
  "name": "search_engine",
  "title": null,
  "description": "Scrape search results from Google, Bing or Yandex. Returns SERP results in JSON or Markdown (URL, title, description), Ideal forgathering current information, news, and detailed search results.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "cursor": {
        "description": "Pagination cursor for next page",
        "type": "string"
      },
      "engine": {
        "default": "google",
        "enum": [
          "google",
          "bing",
          "yandex"
        ],
        "type": "string"
      },
      "query": {
        "type": "string"
      }
    },
    "required": [
      "query"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "Search Engine",
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": true
  },
  "_meta": null,
  "execution": null,
  "mcp_server_name": "brightdata-mcp",
  "meta": null
}

{
  "name": "scrape_as_markdown",
  "title": null,
  "description": "Scrape a single webpage URL with advanced options for content extraction and get back the results in MarkDown language. This tool can unlock any webpage even if it uses bot detection or CAPTCHA.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "url": {
        "format": "uri",
        "type": "string"
      }
    },
    "required": [
      "url"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "Scrape as Markdown",
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": true
  },
  "_meta": null,
  "execution": null,
  "mcp_server_name": "brightdata-mcp",
  "meta": null
}

{
  "name": "search_engine_batch",
  "title": null,
  "description": "Run multiple search queries simultaneously. Returns JSON for Google, Markdown for Bing/Yandex.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "queries": {
        "items": {
          "additionalProperties": false,
          "properties": {
            "cursor": {
              "type": "string"
            },
            "engine": {
              "default": "google",
              "enum": [
                "google",
                "bing",
                "yandex"
              ],
              "type": "string"
            },
            "query": {
              "type": "string"
            }
          },
          "required": [
            "query"
          ],
          "type": "object"
        },
        "maxItems": 5,
        "minItems": 1,
        "type": "array"
      }
    },
    "required": [
      "queries"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "Search Engine Batch",
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": true
  },
  "_meta": null,
  "execution": null,
  "mcp_server_name": "brightdata-mcp",
  "meta": null
}

{
  "name": "scrape_batch",
  "title": null,
  "description": "Scrape multiple webpages URLs with advanced options for content extraction and get back the results in MarkDown language. This tool can unlock any webpage even if it uses bot detection or CAPTCHA.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "urls": {
        "description": "Array of URLs to scrape (max 5)",
        "items": {
          "format": "uri",
          "type": "string"
        },
        "maxItems": 5,
        "minItems": 1,
        "type": "array"
      }
    },
    "required": [
      "urls"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "Scrape Batch",
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": true
  },
  "_meta": null,
  "execution": null,
  "mcp_server_name": "brightdata-mcp",
  "meta": null
}

{
  "name": "resolve-library-id",
  "title": "Resolve Context7 Library ID",
  "description": "Resolves a package/product name to a Context7-compatible library ID and returns matching libraries.\n\nYou MUST call this function before 'query-docs' to obtain a valid Context7-compatible library ID UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.\n\nSelection Process:\n1. Analyze the query to understand what library/package the user is looking for\n2. Return the most relevant match based on:\n- Name similarity to the query (exact matches prioritized)\n- Description relevance to the query's intent\n- Documentation coverage (prioritize libraries with higher Code Snippet counts)\n- Source reputation (consider libraries with High or Medium reputation more authoritative)\n- Benchmark Score: Quality indicator (100 is the highest score)\n\nResponse Format:\n- Return the selected library ID in a clearly marked section\n- Provide a brief explanation for why this library was chosen\n- If multiple good matches exist, acknowledge this but proceed with the most relevant one\n- If no good matches exist, clearly state this and suggest query refinements\n\nFor ambiguous queries, request clarification before proceeding with a best-guess match.\n\nIMPORTANT: Do not call this tool more than 3 times per question. If you cannot find what you need after 3 calls, use the best result you have.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "The user's original question or task. This is used to rank library results by relevance to what the user is trying to accomplish. IMPORTANT: Do not include any sensitive or confidential information such as API keys, passwords, credentials, or personal data in your query."
      },
      "libraryName": {
        "type": "string",
        "description": "Library name to search for and retrieve a Context7-compatible library ID."
      }
    },
    "required": [
      "query",
      "libraryName"
    ],
    "additionalProperties": false,
    "$schema": "http://json-schema.org/draft-07/schema#"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null
  },
  "_meta": null,
  "execution": null,
  "mcp_server_name": "context7-remote",
  "meta": null
}

{
  "name": "query-docs",
  "title": "Query Documentation",
  "description": "Retrieves and queries up-to-date documentation and code examples from Context7 for any programming library or framework.\n\nYou must call 'resolve-library-id' first to obtain the exact Context7-compatible library ID required to use this tool, UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.\n\nIMPORTANT: Do not call this tool more than 3 times per question. If you cannot find what you need after 3 calls, use the best information you have.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "libraryId": {
        "type": "string",
        "description": "Exact Context7-compatible library ID (e.g., '/mongodb/docs', '/vercel/next.js', '/supabase/supabase', '/vercel/next.js/v14.3.0-canary.87') retrieved from 'resolve-library-id' or directly from user query in the format '/org/project' or '/org/project/version'."
      },
      "query": {
        "type": "string",
        "description": "The question or task you need help with. Be specific and include relevant details. Good: 'How to set up authentication with JWT in Express.js' or 'React useEffect cleanup function examples'. Bad: 'auth' or 'hooks'. IMPORTANT: Do not include any sensitive or confidential information such as API keys, passwords, credentials, or personal data in your query."
      }
    },
    "required": [
      "libraryId",
      "query"
    ],
    "additionalProperties": false,
    "$schema": "http://json-schema.org/draft-07/schema#"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null
  },
  "_meta": null,
  "execution": null,
  "mcp_server_name": "context7-remote",
  "meta": null
}

{
  "name": "fetch",
  "title": null,
  "description": "Fetches a URL from the internet and optionally extracts its contents as markdown.",
  "inputSchema": {
    "type": "object",
    "required": [
      "url"
    ],
    "properties": {
      "max_length": {
        "type": [
          "null",
          "integer"
        ]
      },
      "raw": {
        "type": "boolean"
      },
      "start_index": {
        "type": [
          "null",
          "integer"
        ]
      },
      "url": {
        "type": "string"
      }
    },
    "additionalProperties": false
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "fetch",
  "meta": null
}

{
  "name": "firecrawl_scrape",
  "title": null,
  "description": "\nScrape content from a single URL with advanced options. \nThis is the most powerful, fastest and most reliable scraper tool, if available you should always default to using this tool for any web scraping needs.\n\n**Best for:** Single page content extraction, when you know exactly which page contains the information.\n**Not recommended for:** Multiple pages (use batch_scrape), unknown page (use search), structured data (use extract).\n**Common mistakes:** Using scrape for a list of URLs (use batch_scrape instead). If batch scrape doesnt work, just use scrape and call it multiple times.\n**Other Features:** Use 'branding' format to extract brand identity (colors, fonts, typography, spacing, UI components) for design analysis or style replication.\n**Prompt Example:** \"Get the content of the page at https://example.com.\"\n**Usage Example:**\n```json\n{\n  \"name\": \"firecrawl_scrape\",\n  \"arguments\": {\n    \"url\": \"https://example.com\",\n    \"formats\": [\"markdown\"],\n    \"maxAge\": 172800000\n  }\n}\n```\n**Performance:** Add maxAge parameter for 500% faster scrapes using cached data.\n**Returns:** Markdown, HTML, or other formats as specified.\n\n",
  "inputSchema": {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "additionalProperties": false,
    "properties": {
      "actions": {
        "items": {
          "additionalProperties": false,
          "properties": {
            "direction": {
              "enum": [
                "up",
                "down"
              ],
              "type": "string"
            },
            "fullPage": {
              "type": "boolean"
            },
            "key": {
              "type": "string"
            },
            "milliseconds": {
              "type": "number"
            },
            "script": {
              "type": "string"
            },
            "selector": {
              "type": "string"
            },
            "text": {
              "type": "string"
            },
            "type": {
              "enum": [
                "wait",
                "screenshot",
                "scroll",
                "scrape",
                "click",
                "write",
                "press",
                "executeJavascript",
                "generatePDF"
              ],
              "type": "string"
            }
          },
          "required": [
            "type"
          ],
          "type": "object"
        },
        "type": "array"
      },
      "excludeTags": {
        "items": {
          "type": "string"
        },
        "type": "array"
      },
      "formats": {
        "items": {
          "anyOf": [
            {
              "enum": [
                "markdown",
                "html",
                "rawHtml",
                "screenshot",
                "links",
                "summary",
                "changeTracking",
                "branding"
              ],
              "type": "string"
            },
            {
              "additionalProperties": false,
              "properties": {
                "prompt": {
                  "type": "string"
                },
                "schema": {
                  "additionalProperties": {},
                  "propertyNames": {
                    "type": "string"
                  },
                  "type": "object"
                },
                "type": {
                  "const": "json",
                  "type": "string"
                }
              },
              "required": [
                "type"
              ],
              "type": "object"
            },
            {
              "additionalProperties": false,
              "properties": {
                "fullPage": {
                  "type": "boolean"
                },
                "quality": {
                  "type": "number"
                },
                "type": {
                  "const": "screenshot",
                  "type": "string"
                },
                "viewport": {
                  "additionalProperties": false,
                  "properties": {
                    "height": {
                      "type": "number"
                    },
                    "width": {
                      "type": "number"
                    }
                  },
                  "required": [
                    "width",
                    "height"
                  ],
                  "type": "object"
                }
              },
              "required": [
                "type"
              ],
              "type": "object"
            }
          ]
        },
        "type": "array"
      },
      "includeTags": {
        "items": {
          "type": "string"
        },
        "type": "array"
      },
      "location": {
        "additionalProperties": false,
        "properties": {
          "country": {
            "type": "string"
          },
          "languages": {
            "items": {
              "type": "string"
            },
            "type": "array"
          }
        },
        "type": "object"
      },
      "maxAge": {
        "type": "number"
      },
      "mobile": {
        "type": "boolean"
      },
      "onlyMainContent": {
        "type": "boolean"
      },
      "parsers": {
        "items": {
          "anyOf": [
            {
              "enum": [
                "pdf"
              ],
              "type": "string"
            },
            {
              "additionalProperties": false,
              "properties": {
                "maxPages": {
                  "maximum": 10000,
                  "minimum": 1,
                  "type": "integer"
                },
                "type": {
                  "enum": [
                    "pdf"
                  ],
                  "type": "string"
                }
              },
              "required": [
                "type"
              ],
              "type": "object"
            }
          ]
        },
        "type": "array"
      },
      "removeBase64Images": {
        "type": "boolean"
      },
      "skipTlsVerification": {
        "type": "boolean"
      },
      "storeInCache": {
        "type": "boolean"
      },
      "url": {
        "format": "uri",
        "type": "string"
      },
      "waitFor": {
        "type": "number"
      }
    },
    "required": [
      "url"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "firecrawl",
  "meta": null
}

{
  "name": "firecrawl_map",
  "title": null,
  "description": "\nMap a website to discover all indexed URLs on the site.\n\n**Best for:** Discovering URLs on a website before deciding what to scrape; finding specific sections of a website.\n**Not recommended for:** When you already know which specific URL you need (use scrape or batch_scrape); when you need the content of the pages (use scrape after mapping).\n**Common mistakes:** Using crawl to discover URLs instead of map.\n**Prompt Example:** \"List all URLs on example.com.\"\n**Usage Example:**\n```json\n{\n  \"name\": \"firecrawl_map\",\n  \"arguments\": {\n    \"url\": \"https://example.com\"\n  }\n}\n```\n**Returns:** Array of URLs found on the site.\n",
  "inputSchema": {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "additionalProperties": false,
    "properties": {
      "ignoreQueryParameters": {
        "type": "boolean"
      },
      "includeSubdomains": {
        "type": "boolean"
      },
      "limit": {
        "type": "number"
      },
      "search": {
        "type": "string"
      },
      "sitemap": {
        "enum": [
          "include",
          "skip",
          "only"
        ],
        "type": "string"
      },
      "url": {
        "format": "uri",
        "type": "string"
      }
    },
    "required": [
      "url"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "firecrawl",
  "meta": null
}

{
  "name": "firecrawl_search",
  "title": null,
  "description": "\nSearch the web and optionally extract content from search results. This is the most powerful web search tool available, and if available you should always default to using this tool for any web search needs.\n\nThe query also supports search operators, that you can use if needed to refine the search:\n| Operator | Functionality | Examples |\n---|-|-|\n| `\"\"` | Non-fuzzy matches a string of text | `\"Firecrawl\"`\n| `-` | Excludes certain keywords or negates other operators | `-bad`, `-site:firecrawl.dev`\n| `site:` | Only returns results from a specified website | `site:firecrawl.dev`\n| `inurl:` | Only returns results that include a word in the URL | `inurl:firecrawl`\n| `allinurl:` | Only returns results that include multiple words in the URL | `allinurl:git firecrawl`\n| `intitle:` | Only returns results that include a word in the title of the page | `intitle:Firecrawl`\n| `allintitle:` | Only returns results that include multiple words in the title of the page | `allintitle:firecrawl playground`\n| `related:` | Only returns results that are related to a specific domain | `related:firecrawl.dev`\n| `imagesize:` | Only returns images with exact dimensions | `imagesize:1920x1080`\n| `larger:` | Only returns images larger than specified dimensions | `larger:1920x1080`\n\n**Best for:** Finding specific information across multiple websites, when you don't know which website has the information; when you need the most relevant content for a query.\n**Not recommended for:** When you need to search the filesystem. When you already know which website to scrape (use scrape); when you need comprehensive coverage of a single website (use map or crawl.\n**Common mistakes:** Using crawl or map for open-ended questions (use search instead).\n**Prompt Example:** \"Find the latest research papers on AI published in 2023.\"\n**Sources:** web, images, news, default to web unless needed images or news.\n**Scrape Options:** Only use scrapeOptions when you think it is absolutely necessary. When you do so default to a lower limit to avoid timeouts, 5 or lower.\n**Optimal Workflow:** Search first using firecrawl_search without formats, then after fetching the results, use the scrape tool to get the content of the relevantpage(s) that you want to scrape\n\n**Usage Example without formats (Preferred):**\n```json\n{\n  \"name\": \"firecrawl_search\",\n  \"arguments\": {\n    \"query\": \"top AI companies\",\n    \"limit\": 5,\n    \"sources\": [\n      \"web\"\n    ]\n  }\n}\n```\n**Usage Example with formats:**\n```json\n{\n  \"name\": \"firecrawl_search\",\n  \"arguments\": {\n    \"query\": \"latest AI research papers 2023\",\n    \"limit\": 5,\n    \"lang\": \"en\",\n    \"country\": \"us\",\n    \"sources\": [\n      \"web\",\n      \"images\",\n      \"news\"\n    ],\n    \"scrapeOptions\": {\n      \"formats\": [\"markdown\"],\n      \"onlyMainContent\": true\n    }\n  }\n}\n```\n**Returns:** Array of search results (with optional scraped content).\n",
  "inputSchema": {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "additionalProperties": false,
    "properties": {
      "filter": {
        "type": "string"
      },
      "limit": {
        "type": "number"
      },
      "location": {
        "type": "string"
      },
      "query": {
        "minLength": 1,
        "type": "string"
      },
      "scrapeOptions": {
        "additionalProperties": false,
        "properties": {
          "actions": {
            "items": {
              "additionalProperties": false,
              "properties": {
                "direction": {
                  "enum": [
                    "up",
                    "down"
                  ],
                  "type": "string"
                },
                "fullPage": {
                  "type": "boolean"
                },
                "key": {
                  "type": "string"
                },
                "milliseconds": {
                  "type": "number"
                },
                "script": {
                  "type": "string"
                },
                "selector": {
                  "type": "string"
                },
                "text": {
                  "type": "string"
                },
                "type": {
                  "enum": [
                    "wait",
                    "screenshot",
                    "scroll",
                    "scrape",
                    "click",
                    "write",
                    "press",
                    "executeJavascript",
                    "generatePDF"
                  ],
                  "type": "string"
                }
              },
              "required": [
                "type"
              ],
              "type": "object"
            },
            "type": "array"
          },
          "excludeTags": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "formats": {
            "items": {
              "anyOf": [
                {
                  "enum": [
                    "markdown",
                    "html",
                    "rawHtml",
                    "screenshot",
                    "links",
                    "summary",
                    "changeTracking",
                    "branding"
                  ],
                  "type": "string"
                },
                {
                  "additionalProperties": false,
                  "properties": {
                    "prompt": {
                      "type": "string"
                    },
                    "schema": {
                      "additionalProperties": {},
                      "propertyNames": {
                        "type": "string"
                      },
                      "type": "object"
                    },
                    "type": {
                      "const": "json",
                      "type": "string"
                    }
                  },
                  "required": [
                    "type"
                  ],
                  "type": "object"
                },
                {
                  "additionalProperties": false,
                  "properties": {
                    "fullPage": {
                      "type": "boolean"
                    },
                    "quality": {
                      "type": "number"
                    },
                    "type": {
                      "const": "screenshot",
                      "type": "string"
                    },
                    "viewport": {
                      "additionalProperties": false,
                      "properties": {
                        "height": {
                          "type": "number"
                        },
                        "width": {
                          "type": "number"
                        }
                      },
                      "required": [
                        "width",
                        "height"
                      ],
                      "type": "object"
                    }
                  },
                  "required": [
                    "type"
                  ],
                  "type": "object"
                }
              ]
            },
            "type": "array"
          },
          "includeTags": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "location": {
            "additionalProperties": false,
            "properties": {
              "country": {
                "type": "string"
              },
              "languages": {
                "items": {
                  "type": "string"
                },
                "type": "array"
              }
            },
            "type": "object"
          },
          "maxAge": {
            "type": "number"
          },
          "mobile": {
            "type": "boolean"
          },
          "onlyMainContent": {
            "type": "boolean"
          },
          "parsers": {
            "items": {
              "anyOf": [
                {
                  "enum": [
                    "pdf"
                  ],
                  "type": "string"
                },
                {
                  "additionalProperties": false,
                  "properties": {
                    "maxPages": {
                      "maximum": 10000,
                      "minimum": 1,
                      "type": "integer"
                    },
                    "type": {
                      "enum": [
                        "pdf"
                      ],
                      "type": "string"
                    }
                  },
                  "required": [
                    "type"
                  ],
                  "type": "object"
                }
              ]
            },
            "type": "array"
          },
          "removeBase64Images": {
            "type": "boolean"
          },
          "skipTlsVerification": {
            "type": "boolean"
          },
          "storeInCache": {
            "type": "boolean"
          },
          "waitFor": {
            "type": "number"
          }
        },
        "type": "object"
      },
      "sources": {
        "items": {
          "additionalProperties": false,
          "properties": {
            "type": {
              "enum": [
                "web",
                "images",
                "news"
              ],
              "type": "string"
            }
          },
          "required": [
            "type"
          ],
          "type": "object"
        },
        "type": "array"
      },
      "tbs": {
        "type": "string"
      }
    },
    "required": [
      "query"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "firecrawl",
  "meta": null
}

{
  "name": "firecrawl_crawl",
  "title": null,
  "description": "\n Starts a crawl job on a website and extracts content from all pages.\n \n **Best for:** Extracting content from multiple related pages, when you need comprehensive coverage.\n **Not recommended for:** Extracting content from a single page (use scrape); when token limits are a concern (use map + batch_scrape); when you need fast results (crawling can be slow).\n **Warning:** Crawl responses can be very large and may exceed token limits. Limit the crawl depth and number of pages, or use map + batch_scrape for better control.\n **Common mistakes:** Setting limit or maxDiscoveryDepth too high (causes token overflow) or too low (causes missing pages); using crawl for a single page (use scrape instead). Using a /* wildcard is not recommended.\n **Prompt Example:** \"Get all blog posts from the first two levels of example.com/blog.\"\n **Usage Example:**\n ```json\n {\n   \"name\": \"firecrawl_crawl\",\n   \"arguments\": {\n     \"url\": \"https://example.com/blog/*\",\n     \"maxDiscoveryDepth\": 5,\n     \"limit\": 20,\n     \"allowExternalLinks\": false,\n     \"deduplicateSimilarURLs\": true,\n     \"sitemap\": \"include\"\n   }\n }\n ```\n **Returns:** Operation ID for status checking; use firecrawl_check_crawl_status to check progress.\n \n ",
  "inputSchema": {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "additionalProperties": false,
    "properties": {
      "allowExternalLinks": {
        "type": "boolean"
      },
      "allowSubdomains": {
        "type": "boolean"
      },
      "crawlEntireDomain": {
        "type": "boolean"
      },
      "deduplicateSimilarURLs": {
        "type": "boolean"
      },
      "delay": {
        "type": "number"
      },
      "excludePaths": {
        "items": {
          "type": "string"
        },
        "type": "array"
      },
      "ignoreQueryParameters": {
        "type": "boolean"
      },
      "includePaths": {
        "items": {
          "type": "string"
        },
        "type": "array"
      },
      "limit": {
        "type": "number"
      },
      "maxConcurrency": {
        "type": "number"
      },
      "maxDiscoveryDepth": {
        "type": "number"
      },
      "prompt": {
        "type": "string"
      },
      "scrapeOptions": {
        "additionalProperties": false,
        "properties": {
          "actions": {
            "items": {
              "additionalProperties": false,
              "properties": {
                "direction": {
                  "enum": [
                    "up",
                    "down"
                  ],
                  "type": "string"
                },
                "fullPage": {
                  "type": "boolean"
                },
                "key": {
                  "type": "string"
                },
                "milliseconds": {
                  "type": "number"
                },
                "script": {
                  "type": "string"
                },
                "selector": {
                  "type": "string"
                },
                "text": {
                  "type": "string"
                },
                "type": {
                  "enum": [
                    "wait",
                    "screenshot",
                    "scroll",
                    "scrape",
                    "click",
                    "write",
                    "press",
                    "executeJavascript",
                    "generatePDF"
                  ],
                  "type": "string"
                }
              },
              "required": [
                "type"
              ],
              "type": "object"
            },
            "type": "array"
          },
          "excludeTags": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "formats": {
            "items": {
              "anyOf": [
                {
                  "enum": [
                    "markdown",
                    "html",
                    "rawHtml",
                    "screenshot",
                    "links",
                    "summary",
                    "changeTracking",
                    "branding"
                  ],
                  "type": "string"
                },
                {
                  "additionalProperties": false,
                  "properties": {
                    "prompt": {
                      "type": "string"
                    },
                    "schema": {
                      "additionalProperties": {},
                      "propertyNames": {
                        "type": "string"
                      },
                      "type": "object"
                    },
                    "type": {
                      "const": "json",
                      "type": "string"
                    }
                  },
                  "required": [
                    "type"
                  ],
                  "type": "object"
                },
                {
                  "additionalProperties": false,
                  "properties": {
                    "fullPage": {
                      "type": "boolean"
                    },
                    "quality": {
                      "type": "number"
                    },
                    "type": {
                      "const": "screenshot",
                      "type": "string"
                    },
                    "viewport": {
                      "additionalProperties": false,
                      "properties": {
                        "height": {
                          "type": "number"
                        },
                        "width": {
                          "type": "number"
                        }
                      },
                      "required": [
                        "width",
                        "height"
                      ],
                      "type": "object"
                    }
                  },
                  "required": [
                    "type"
                  ],
                  "type": "object"
                }
              ]
            },
            "type": "array"
          },
          "includeTags": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "location": {
            "additionalProperties": false,
            "properties": {
              "country": {
                "type": "string"
              },
              "languages": {
                "items": {
                  "type": "string"
                },
                "type": "array"
              }
            },
            "type": "object"
          },
          "maxAge": {
            "type": "number"
          },
          "mobile": {
            "type": "boolean"
          },
          "onlyMainContent": {
            "type": "boolean"
          },
          "parsers": {
            "items": {
              "anyOf": [
                {
                  "enum": [
                    "pdf"
                  ],
                  "type": "string"
                },
                {
                  "additionalProperties": false,
                  "properties": {
                    "maxPages": {
                      "maximum": 10000,
                      "minimum": 1,
                      "type": "integer"
                    },
                    "type": {
                      "enum": [
                        "pdf"
                      ],
                      "type": "string"
                    }
                  },
                  "required": [
                    "type"
                  ],
                  "type": "object"
                }
              ]
            },
            "type": "array"
          },
          "removeBase64Images": {
            "type": "boolean"
          },
          "skipTlsVerification": {
            "type": "boolean"
          },
          "storeInCache": {
            "type": "boolean"
          },
          "waitFor": {
            "type": "number"
          }
        },
        "type": "object"
      },
      "sitemap": {
        "enum": [
          "skip",
          "include",
          "only"
        ],
        "type": "string"
      },
      "url": {
        "type": "string"
      },
      "webhook": {
        "anyOf": [
          {
            "type": "string"
          },
          {
            "additionalProperties": false,
            "properties": {
              "headers": {
                "additionalProperties": {
                  "type": "string"
                },
                "propertyNames": {
                  "type": "string"
                },
                "type": "object"
              },
              "url": {
                "type": "string"
              }
            },
            "required": [
              "url"
            ],
            "type": "object"
          }
        ]
      }
    },
    "required": [
      "url"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "firecrawl",
  "meta": null
}

{
  "name": "firecrawl_check_crawl_status",
  "title": null,
  "description": "\nCheck the status of a crawl job.\n\n**Usage Example:**\n```json\n{\n  \"name\": \"firecrawl_check_crawl_status\",\n  \"arguments\": {\n    \"id\": \"550e8400-e29b-41d4-a716-446655440000\"\n  }\n}\n```\n**Returns:** Status and progress of the crawl job, including results if available.\n",
  "inputSchema": {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "additionalProperties": false,
    "properties": {
      "id": {
        "type": "string"
      }
    },
    "required": [
      "id"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "firecrawl",
  "meta": null
}

{
  "name": "firecrawl_extract",
  "title": null,
  "description": "\nExtract structured information from web pages using LLM capabilities. Supports both cloud AI and self-hosted LLM extraction.\n\n**Best for:** Extracting specific structured data like prices, names, details from web pages.\n**Not recommended for:** When you need the full content of a page (use scrape); when you're not looking for specific structured data.\n**Arguments:**\n- urls: Array of URLs to extract information from\n- prompt: Custom prompt for the LLM extraction\n- schema: JSON schema for structured data extraction\n- allowExternalLinks: Allow extraction from external links\n- enableWebSearch: Enable web search for additional context\n- includeSubdomains: Include subdomains in extraction\n**Prompt Example:** \"Extract the product name, price, and description from these product pages.\"\n**Usage Example:**\n```json\n{\n  \"name\": \"firecrawl_extract\",\n  \"arguments\": {\n    \"urls\": [\"https://example.com/page1\", \"https://example.com/page2\"],\n    \"prompt\": \"Extract product information including name, price, and description\",\n    \"schema\": {\n      \"type\": \"object\",\n      \"properties\": {\n        \"name\": { \"type\": \"string\" },\n        \"price\": { \"type\": \"number\" },\n        \"description\": { \"type\": \"string\" }\n      },\n      \"required\": [\"name\", \"price\"]\n    },\n    \"allowExternalLinks\": false,\n    \"enableWebSearch\": false,\n    \"includeSubdomains\": false\n  }\n}\n```\n**Returns:** Extracted structured data as defined by your schema.\n",
  "inputSchema": {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "additionalProperties": false,
    "properties": {
      "allowExternalLinks": {
        "type": "boolean"
      },
      "enableWebSearch": {
        "type": "boolean"
      },
      "includeSubdomains": {
        "type": "boolean"
      },
      "prompt": {
        "type": "string"
      },
      "schema": {
        "additionalProperties": {},
        "propertyNames": {
          "type": "string"
        },
        "type": "object"
      },
      "urls": {
        "items": {
          "type": "string"
        },
        "type": "array"
      }
    },
    "required": [
      "urls"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "firecrawl",
  "meta": null
}

{
  "name": "json_query_jsonpath",
  "title": null,
  "description": "Query a JSON file using JSONPath expressions for precise value extraction.\n\nWHEN TO USE:\n• You know the exact path structure (e.g., $.users[0].name)\n• You need efficient extraction from large JSON files\n• Working with known JSON schemas\n\nWHEN NOT TO USE:\n• You do not know the structure → use json_query_search_keys instead\n• Searching for values by content → use json_query_search_values instead\n• Exploring unfamiliar JSON files\n\nJSONPATH SYNTAX:\n$          Root element\n.property  Child property (dot notation)\n[\"prop\"]   Child property (bracket notation for special characters)\n..         Recursive descent (find anywhere)\n[n]        Array index\n[*]        All array elements\n[?(@.x)]   Filter expression\n\nEXAMPLES:\n• Get all users: $.users\n• Get first user's email: $.users[0].email\n• Find all \"name\" properties recursively: $..name\n• Filter users by age: $.users[?(@.age > 18)]\n\nPARAMETERS:\n• file_path: REQUIRED - Absolute path to the JSON file (parameters.file_path)\n• jsonpath: REQUIRED - JSONPath expression to evaluate (parameters.jsonpath)",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "file_path": {
        "description": "REQUIRED - Absolute path to the JSON file (parameters.file_path)",
        "type": "string"
      },
      "jsonpath": {
        "description": "REQUIRED - JSONPath expression to evaluate (parameters.jsonpath)",
        "type": "string"
      }
    },
    "required": [
      "file_path",
      "jsonpath"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "json-query-mcp",
  "meta": null
}

{
  "name": "json_query_search_keys",
  "title": null,
  "description": "Search for keys in a JSON file by name pattern.\n\nWHEN TO USE:\n• You know the property name but not its location in the structure\n• Exploring and understanding unfamiliar JSON files\n• Looking for all occurrences of a specific key name\n\nWHEN NOT TO USE:\n• You know the exact path → use json_query_jsonpath for better performance\n• Searching for values rather than keys → use json_query_search_values\n• You need complex filtering → extract first, then filter\n\nEXAMPLES:\n• Find all \"id\" keys: query=\"id\"\n• Find keys containing \"user\": query=\"user\"\n\nPARAMETERS:\n• file_path: REQUIRED - Absolute path to JSON file (parameters.file_path)\n• query: REQUIRED - Search term for finding matching keys (parameters.query)\n• page: OPTIONAL - Page number to retrieve, default is 1 (parameters.page)\n\nReturns 25 results per page. Response includes currentPage and totalPages.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "file_path": {
        "description": "REQUIRED - Absolute path to JSON file (parameters.file_path)",
        "type": "string"
      },
      "page": {
        "default": 1,
        "description": "OPTIONAL - Page number to retrieve, default is 1 (parameters.page)",
        "minimum": 1,
        "type": "integer"
      },
      "query": {
        "description": "REQUIRED - Search term for finding matching keys (parameters.query)",
        "type": "string"
      }
    },
    "required": [
      "file_path",
      "query"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "json-query-mcp",
  "meta": null
}

{
  "name": "json_query_search_values",
  "title": null,
  "description": "Search for values in a JSON file by content pattern.\n\nWHEN TO USE:\n• You know the value content but not where it is located\n• Searching for specific text, numbers, or boolean values\n• Finding where particular data appears in the file\n\nWHEN NOT TO USE:\n• You know the key name → use json_query_search_keys instead\n• You need structured path extraction → use json_query_jsonpath\n• Performance is critical on very large files (this scans all values)\n\nEXAMPLES:\n• Find \"admin\" role: query=\"admin\"\n• Search for email domain: query=\"@company.com\"\n• Find user ID 12345: query=\"12345\"\n\nPARAMETERS:\n• file_path: REQUIRED - Absolute path to JSON file (parameters.file_path)\n• query: REQUIRED - Value content to search for (parameters.query)\n• page: OPTIONAL - Page number to retrieve, default is 1 (parameters.page)\n\nReturns 25 results per page. Response includes currentPage and totalPages.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "file_path": {
        "description": "REQUIRED - Absolute path to JSON file (parameters.file_path)",
        "type": "string"
      },
      "page": {
        "default": 1,
        "description": "OPTIONAL - Page number to retrieve, default is 1 (parameters.page)",
        "minimum": 1,
        "type": "integer"
      },
      "query": {
        "description": "REQUIRED - Value content to search for (parameters.query)",
        "type": "string"
      }
    },
    "required": [
      "file_path",
      "query"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "json-query-mcp",
  "meta": null
}

{
  "name": "aggregate",
  "title": null,
  "description": "Run an aggregation against a MongoDB collection",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "collection": {
        "description": "Collection name",
        "type": "string"
      },
      "database": {
        "description": "Database name",
        "type": "string"
      },
      "pipeline": {
        "description": "An array of aggregation stages to execute.",
        "items": {
          "additionalProperties": true,
          "properties": {},
          "type": "object"
        },
        "type": "array"
      },
      "responseBytesLimit": {
        "default": 1048576,
        "description": "The maximum number of bytes to return in the response. This value is capped by the server's configured maxBytesPerQuery and cannot be exceeded. Note to LLM: If the entire aggregation result is required, use the \"export\" tool instead of increasing this limit.",
        "type": "number"
      }
    },
    "required": [
      "database",
      "collection",
      "pipeline"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "aggregate",
    "readOnlyHint": true,
    "destructiveHint": false,
    "idempotentHint": null,
    "openWorldHint": null
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "mongodb",
  "meta": {
    "com.mongodb/maxRequestPayloadBytes": 52428800,
    "com.mongodb/transport": "stdio"
  }
}

{
  "name": "collection-indexes",
  "title": null,
  "description": "Describe the indexes for a collection",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "collection": {
        "description": "Collection name",
        "type": "string"
      },
      "database": {
        "description": "Database name",
        "type": "string"
      }
    },
    "required": [
      "database",
      "collection"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "collection-indexes",
    "readOnlyHint": true,
    "destructiveHint": false,
    "idempotentHint": null,
    "openWorldHint": null
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "mongodb",
  "meta": {
    "com.mongodb/maxRequestPayloadBytes": 52428800,
    "com.mongodb/transport": "stdio"
  }
}

{
  "name": "collection-schema",
  "title": null,
  "description": "Describe the schema for a collection",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "collection": {
        "description": "Collection name",
        "type": "string"
      },
      "database": {
        "description": "Database name",
        "type": "string"
      },
      "responseBytesLimit": {
        "default": 1048576,
        "description": "The maximum number of bytes to return in the response. This value is capped by the server's configured maxBytesPerQuery and cannot be exceeded.",
        "type": "number"
      },
      "sampleSize": {
        "default": 50,
        "description": "Number of documents to sample for schema inference",
        "type": "number"
      }
    },
    "required": [
      "database",
      "collection"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": "collection-schema",
    "readOnlyHint": true,
    "destructiveHint": false,
    "idempotentHint": null,
    "openWorldHint": null
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "mongodb",
  "meta": {
    "com.mongodb/maxRequestPayloadBytes": 52428800,
    "com.mongodb/transport": "stdio"
  }
}

{
  "name": "collection-storage-size",
  "title": null,
  "description": "Gets the size of the collection",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "collection": {
        "description": "Collection name",
        "type": "string"
      },
      "database": {
        "description": "Database name",
        "type": "string"
      }
    },
    "required": 

... (truncated)
```
