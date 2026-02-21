# Tool Output: tool_c75400285001ZTBNV3S0f5vpkd
**Date**: 2026-02-19 09:34:15 UTC
**Size**: 149,550 bytes

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
  "name": "click",
  "title": null,
  "description": "Clicks on the provided element",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "dblClick": {
        "description": "Set to true for double clicks. Default is false.",
        "type": "boolean"
      },
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      },
      "uid": {
        "description": "The uid of an element on the page from the page content snapshot",
        "type": "string"
      }
    },
    "required": [
      "uid"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "close_page",
  "title": null,
  "description": "Closes the page by its index. The last open page cannot be closed.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "pageId": {
        "description": "The ID of the page to close. Call list_pages to list pages.",
        "type": "number"
      }
    },
    "required": [
      "pageId"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "navigation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "drag",
  "title": null,
  "description": "Drag an element onto another element",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "from_uid": {
        "description": "The uid of the element to drag",
        "type": "string"
      },
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      },
      "to_uid": {
        "description": "The uid of the element to drop into",
        "type": "string"
      }
    },
    "required": [
      "from_uid",
      "to_uid"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "emulate",
  "title": null,
  "description": "Emulates various features on the selected page.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "colorScheme": {
        "description": "Emulate the dark or the light mode. Set to \"auto\" to reset to the default.",
        "enum": [
          "dark",
          "light",
          "auto"
        ],
        "type": "string"
      },
      "cpuThrottlingRate": {
        "description": "Represents the CPU slowdown factor. Set the rate to 1 to disable throttling. If omitted, throttling remains unchanged.",
        "maximum": 20,
        "minimum": 1,
        "type": "number"
      },
      "geolocation": {
        "anyOf": [
          {
            "additionalProperties": false,
            "properties": {
              "latitude": {
                "description": "Latitude between -90 and 90.",
                "maximum": 90,
                "minimum": -90,
                "type": "number"
              },
              "longitude": {
                "description": "Longitude between -180 and 180.",
                "maximum": 180,
                "minimum": -180,
                "type": "number"
              }
            },
            "required": [
              "latitude",
              "longitude"
            ],
            "type": "object"
          },
          {
            "type": "null"
          }
        ],
        "description": "Geolocation to emulate. Set to null to clear the geolocation override."
      },
      "networkConditions": {
        "description": "Throttle network. Set to \"No emulation\" to disable. If omitted, conditions remain unchanged.",
        "enum": [
          "No emulation",
          "Offline",
          "Slow 3G",
          "Fast 3G",
          "Slow 4G",
          "Fast 4G"
        ],
        "type": "string"
      },
      "userAgent": {
        "description": "User agent to emulate. Set to null to clear the user agent override.",
        "type": [
          "string",
          "null"
        ]
      },
      "viewport": {
        "anyOf": [
          {
            "additionalProperties": false,
            "properties": {
              "deviceScaleFactor": {
                "description": "Specify device scale factor (can be thought of as dpr).",
                "minimum": 0,
                "type": "number"
              },
              "hasTouch": {
                "description": "Specifies if viewport supports touch events. This should be set to true for mobile devices.",
                "type": "boolean"
              },
              "height": {
                "description": "Page height in pixels.",
                "minimum": 0,
                "type": "integer"
              },
              "isLandscape": {
                "description": "Specifies if viewport is in landscape mode. Defaults to false.",
                "type": "boolean"
              },
              "isMobile": {
                "description": "Whether the meta viewport tag is taken into account. Defaults to false.",
                "type": "boolean"
              },
              "width": {
                "description": "Page width in pixels.",
                "minimum": 0,
                "type": "integer"
              }
            },
            "required": [
              "width",
              "height"
            ],
            "type": "object"
          },
          {
            "type": "null"
          }
        ],
        "description": "Viewport to emulate. Set to null to reset to the default viewport."
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "emulation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "evaluate_script",
  "title": null,
  "description": "Evaluate a JavaScript function inside the currently selected page. Returns the response as JSON,\nso returned values have to be JSON-serializable.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "args": {
        "description": "An optional list of arguments to pass to the function.",
        "items": {
          "additionalProperties": false,
          "properties": {
            "uid": {
              "description": "The uid of an element on the page from the page content snapshot",
              "type": "string"
            }
          },
          "required": [
            "uid"
          ],
          "type": "object"
        },
        "type": "array"
      },
      "function": {
        "description": "A JavaScript function declaration to be executed by the tool in the currently selected page.\nExample without arguments: `() => {\n  return document.title\n}` or `async () => {\n  return await fetch(\"example.com\")\n}`.\nExample with arguments: `(el) => {\n  return el.innerText;\n}`\n",
        "type": "string"
      }
    },
    "required": [
      "function"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "debugging"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "fill",
  "title": null,
  "description": "Type text into a input, text area or select an option from a <select> element.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      },
      "uid": {
        "description": "The uid of an element on the page from the page content snapshot",
        "type": "string"
      },
      "value": {
        "description": "The value to fill in",
        "type": "string"
      }
    },
    "required": [
      "uid",
      "value"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "fill_form",
  "title": null,
  "description": "Fill out multiple form elements at once",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "elements": {
        "description": "Elements from snapshot to fill out.",
        "items": {
          "additionalProperties": false,
          "properties": {
            "uid": {
              "description": "The uid of the element to fill out",
              "type": "string"
            },
            "value": {
              "description": "Value for the element",
              "type": "string"
            }
          },
          "required": [
            "uid",
            "value"
          ],
          "type": "object"
        },
        "type": "array"
      },
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      }
    },
    "required": [
      "elements"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "get_console_message",
  "title": null,
  "description": "Gets a console message by its ID. You can get all messages by calling list_console_messages.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "msgid": {
        "description": "The msgid of a console message on the page from the listed console messages",
        "type": "number"
      }
    },
    "required": [
      "msgid"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "debugging"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "get_network_request",
  "title": null,
  "description": "Gets a network request by an optional reqid, if omitted returns the currently selected request in the DevTools Network panel.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "reqid": {
        "description": "The reqid of the network request. If omitted returns the currently selected request in the DevTools Network panel.",
        "type": "number"
      },
      "requestFilePath": {
        "description": "The absolute or relative path to save the request body to. If omitted, the body is returned inline.",
        "type": "string"
      },
      "responseFilePath": {
        "description": "The absolute or relative path to save the response body to. If omitted, the body is returned inline.",
        "type": "string"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "network"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "handle_dialog",
  "title": null,
  "description": "If a browser dialog was opened, use this command to handle it",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "action": {
        "description": "Whether to dismiss or accept the dialog",
        "enum": [
          "accept",
          "dismiss"
        ],
        "type": "string"
      },
      "promptText": {
        "description": "Optional prompt text to enter into the dialog.",
        "type": "string"
      }
    },
    "required": [
      "action"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "hover",
  "title": null,
  "description": "Hover over the provided element",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      },
      "uid": {
        "description": "The uid of an element on the page from the page content snapshot",
        "type": "string"
      }
    },
    "required": [
      "uid"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "list_console_messages",
  "title": null,
  "description": "List all console messages for the currently selected page since the last navigation.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "includePreservedMessages": {
        "default": false,
        "description": "Set to true to return the preserved messages over the last 3 navigations.",
        "type": "boolean"
      },
      "pageIdx": {
        "description": "Page number to return (0-based). When omitted, returns the first page.",
        "minimum": 0,
        "type": "integer"
      },
      "pageSize": {
        "description": "Maximum number of messages to return. When omitted, returns all requests.",
        "exclusiveMinimum": 0,
        "type": "integer"
      },
      "types": {
        "description": "Filter messages to only return messages of the specified resource types. When omitted or empty, returns all messages.",
        "items": {
          "enum": [
            "log",
            "debug",
            "info",
            "error",
            "warn",
            "dir",
            "dirxml",
            "table",
            "trace",
            "clear",
            "startGroup",
            "startGroupCollapsed",
            "endGroup",
            "assert",
            "profile",
            "profileEnd",
            "count",
            "timeEnd",
            "verbose",
            "issue"
          ],
          "type": "string"
        },
        "type": "array"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "debugging"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "list_network_requests",
  "title": null,
  "description": "List all requests for the currently selected page since the last navigation.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "includePreservedRequests": {
        "default": false,
        "description": "Set to true to return the preserved requests over the last 3 navigations.",
        "type": "boolean"
      },
      "pageIdx": {
        "description": "Page number to return (0-based). When omitted, returns the first page.",
        "minimum": 0,
        "type": "integer"
      },
      "pageSize": {
        "description": "Maximum number of requests to return. When omitted, returns all requests.",
        "exclusiveMinimum": 0,
        "type": "integer"
      },
      "resourceTypes": {
        "description": "Filter requests to only return requests of the specified resource types. When omitted or empty, returns all requests.",
        "items": {
          "enum": [
            "document",
            "stylesheet",
            "image",
            "media",
            "font",
            "script",
            "texttrack",
            "xhr",
            "fetch",
            "prefetch",
            "eventsource",
            "websocket",
            "manifest",
            "signedexchange",
            "ping",
            "cspviolationreport",
            "preflight",
            "fedcm",
            "other"
          ],
          "type": "string"
        },
        "type": "array"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "network"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "list_pages",
  "title": null,
  "description": "Get a list of pages open in the browser.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "properties": {},
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "navigation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "navigate_page",
  "title": null,
  "description": "Navigates the currently selected page to a URL.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "handleBeforeUnload": {
        "description": "Whether to auto accept or beforeunload dialogs triggered by this navigation. Default is accept.",
        "enum": [
          "accept",
          "decline"
        ],
        "type": "string"
      },
      "ignoreCache": {
        "description": "Whether to ignore cache on reload.",
        "type": "boolean"
      },
      "initScript": {
        "description": "A JavaScript script to be executed on each new document before any other scripts for the next navigation.",
        "type": "string"
      },
      "timeout": {
        "description": "Maximum wait time in milliseconds. If set to 0, the default timeout will be used.",
        "type": "integer"
      },
      "type": {
        "description": "Navigate the page by URL, back or forward in history, or reload.",
        "enum": [
          "url",
          "back",
          "forward",
          "reload"
        ],
        "type": "string"
      },
      "url": {
        "description": "Target URL (only type=url)",
        "type": "string"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "navigation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "new_page",
  "title": null,
  "description": "Creates a new page",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "background": {
        "description": "Whether to open the page in the background without bringing it to the front. Default is false (foreground).",
        "type": "boolean"
      },
      "timeout": {
        "description": "Maximum wait time in milliseconds. If set to 0, the default timeout will be used.",
        "type": "integer"
      },
      "url": {
        "description": "URL to load in a new page.",
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
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "navigation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "performance_analyze_insight",
  "title": null,
  "description": "Provides more detailed information on a specific Performance Insight of an insight set that was highlighted in the results of a trace recording.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "insightName": {
        "description": "The name of the Insight you want more information on. For example: \"DocumentLatency\" or \"LCPBreakdown\"",
        "type": "string"
      },
      "insightSetId": {
        "description": "The id for the specific insight set. Only use the ids given in the \"Available insight sets\" list.",
        "type": "string"
      }
    },
    "required": [
      "insightSetId",
      "insightName"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "performance"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "performance_start_trace",
  "title": null,
  "description": "Starts a performance trace recording on the selected page. This can be used to look for performance problems and insights to improve the performance of the page. It will also report Core Web Vital (CWV) scores for the page.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "autoStop": {
        "description": "Determines if the trace recording should be automatically stopped.",
        "type": "boolean"
      },
      "filePath": {
        "description": "The absolute file path, or a file path relative to the current working directory, to save the raw trace data. For example, trace.json.gz (compressed) or trace.json (uncompressed).",
        "type": "string"
      },
      "reload": {
        "description": "Determines if, once tracing has started, the current selected page should be automatically reloaded. Navigate the page to the right URL using the navigate_page tool BEFORE starting the trace if reload or autoStop is set to true.",
        "type": "boolean"
      }
    },
    "required": [
      "reload",
      "autoStop"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "performance"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "performance_stop_trace",
  "title": null,
  "description": "Stops the active performance trace recording on the selected page.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "filePath": {
        "description": "The absolute file path, or a file path relative to the current working directory, to save the raw trace data. For example, trace.json.gz (compressed) or trace.json (uncompressed).",
        "type": "string"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "performance"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "press_key",
  "title": null,
  "description": "Press a key or key combination. Use this when other input methods like fill() cannot be used (e.g., keyboard shortcuts, navigation keys, or special key combinations).",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      },
      "key": {
        "description": "A key or a combination (e.g., \"Enter\", \"Control+A\", \"Control++\", \"Control+Shift+R\"). Modifiers: Control, Shift, Alt, Meta",
        "type": "string"
      }
    },
    "required": [
      "key"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "resize_page",
  "title": null,
  "description": "Resizes the selected page's window so that the page has specified dimension",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "height": {
        "description": "Page height",
        "type": "number"
      },
      "width": {
        "description": "Page width",
        "type": "number"
      }
    },
    "required": [
      "width",
      "height"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "emulation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "select_page",
  "title": null,
  "description": "Select a page as a context for future tool calls.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "bringToFront": {
        "description": "Whether to focus the page and bring it to the top.",
        "type": "boolean"
      },
      "pageId": {
        "description": "The ID of the page to select. Call list_pages to get available pages.",
        "type": "number"
      }
    },
    "required": [
      "pageId"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "navigation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "take_screenshot",
  "title": null,
  "description": "Take a screenshot of the page or element.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "filePath": {
        "description": "The absolute path, or a path relative to the current working directory, to save the screenshot to instead of attaching it to the response.",
        "type": "string"
      },
      "format": {
        "default": "png",
        "description": "Type of format to save the screenshot as. Default is \"png\"",
        "enum": [
          "png",
          "jpeg",
          "webp"
        ],
        "type": "string"
      },
      "fullPage": {
        "description": "If set to true takes a screenshot of the full page instead of the currently visible viewport. Incompatible with uid.",
        "type": "boolean"
      },
      "quality": {
        "description": "Compression quality for JPEG and WebP formats (0-100). Higher values mean better quality but larger file sizes. Ignored for PNG format.",
        "maximum": 100,
        "minimum": 0,
        "type": "number"
      },
      "uid": {
        "description": "The uid of an element on the page from the page content snapshot. If omitted takes a pages screenshot.",
        "type": "string"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "debugging"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "take_snapshot",
  "title": null,
  "description": "Take a text snapshot of the currently selected page based on the a11y tree. The snapshot lists page elements along with a unique\nidentifier (uid). Always use the latest snapshot. Prefer taking a snapshot over taking a screenshot. The snapshot indicates the element selected\nin the DevTools Elements panel (if any).",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "filePath": {
        "description": "The absolute path, or a path relative to the current working directory, to save the snapshot to instead of attaching it to the response.",
        "type": "string"
      },
      "verbose": {
        "description": "Whether to include all possible information available in the full a11y tree. Default is false.",
        "type": "boolean"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "debugging"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "upload_file",
  "title": null,
  "description": "Upload a file through a provided element.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "filePath": {
        "description": "The local path of the file to upload",
        "type": "string"
      },
      "includeSnapshot": {
        "description": "Whether to include a snapshot in the response. Default is false.",
        "type": "boolean"
      },
      "uid": {
        "description": "The uid of the file input element or an element that will open file chooser on the page from the page content snapshot",
        "type": "string"
      }
    },
    "required": [
      "uid",
      "filePath"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": false,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "input"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "wait_for",
  "title": null,
  "description": "Wait for the specified text to appear on the selected page.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "additionalProperties": false,
    "properties": {
      "text": {
        "description": "Text to appear on the page",
        "type": "string"
      },
      "timeout": {
        "description": "Maximum wait time in milliseconds. If set to 0, the default timeout will be used.",
        "type": "integer"
      }
    },
    "required": [
      "text"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": {
    "title": null,
    "readOnlyHint": true,
    "destructiveHint": null,
    "idempotentHint": null,
    "openWorldHint": null,
    "category": "navigation"
  },
  "_meta": null,
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "chrome-devtools-mcp",
  "meta": null
}

{
  "name": "resolve-library-id",
  "title": "Resolve Context7 Library ID",
  "description": "Resolves a package/product name to a Context7-compatible library ID and returns matching libraries.\n\nYou MUST call this function before 'query-docs' to obtain a valid Context7-compatible library ID UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.\n\nSelection Process:\n1. Analyze the query to understand what library/package the user is looking for\n2. Return the most relevant match based on:\n- Name similarity to the query (exact matches prioritized)\n- Description relevance to the query's intent\n- Documentation coverage (prioritize libraries with higher Code Snippet counts)\n- Source reputation (consider libraries with High or Medium reputation more authoritative)\n- Benchmark Score: Quality indicator (100 is the highest score)\n\nResponse Format:\n- Return the selected library ID in a clearly marked section\n- Provide a brief explanation for why this library was chosen\n- If multiple good matches exist, acknowledge this but proceed with the most relevant one\n- If no good matches exist, clearly state this and suggest query refinements\n\nFor ambiguous queries, request clarification before proceeding with a best-guess match.\n\nIMPORTANT: Do not call this tool more than 3 times per question. If you cannot find what you need after 3 calls, use the best result you have.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "The question or task you need help with. This is used to rank library results by relevance to what the user is trying to accomplish. The query is sent to the Context7 API for processing. Do not include any sensitive or confidential information such as API keys, passwords, credentials, personal data, or proprietary code in your query."
      },
      "libraryName": {
        "type": "string",
        "description": "Library name to search for and retrieve a Context7-compatible library ID."
      }
    },
    "required": [
      "query",
      "libraryName"
    ]
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
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "context7-remote",
  "meta": null
}

{
  "name": "query-docs",
  "title": "Query Documentation",
  "description": "Retrieves and queries up-to-date documentation and code examples from Context7 for any programming library or framework.\n\nYou must call 'resolve-library-id' first to obtain the exact Context7-compatible library ID required to use this tool, UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.\n\nIMPORTANT: Do not call this tool more than 3 times per question. If you cannot find what you need after 3 calls, use the best information you have.",
  "inputSchema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
      "libraryId": {
        "type": "string",
        "description": "Exact Context7-compatible library ID (e.g., '/mongodb/docs', '/vercel/next.js', '/supabase/supabase', '/vercel/next.js/v14.3.0-canary.87') retrieved from 'resolve-library-id' or directly from user query in the format '/org/project' or '/org/project/version'."
      },
      "query": {
        "type": "string",
        "description": "The question or task you need help with. Be specific and include relevant details. Good: 'How to set up authentication with JWT in Express.js' or 'React useEffect cleanup function examples'. Bad: 'auth' or 'hooks'. The query is sent to the Context7 API for processing. Do not include any sensitive or confidential information such as API keys, passwords, credentials, personal data, or proprietary code in your query."
      }
    },
    "required": [
      "libraryId",
      "query"
    ]
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
  "execution": {
    "taskSupport": "forbidden"
  },
  "mcp_server_name": "context7-remote",
  "meta": null
}

{
  "name": "connect",
  "title": null,
  "description": "Connect to MongoDB database",
  "inputSchema": {
    "properties": {
      "connectionString": {
        "description": "MongoDB URI (optional)",
        "type": "string"
      }
    },
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "disconnect",
  "title": null,
  "description": "Disconnect from database",
  "inputSchema": {
    "properties": {},
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "findById",
  "title": null,
  "description": "Find a decision by its ID with optional field projection",
  "inputSchema": {
    "properties": {
      "decisionId": {
        "description": "Decision ID (e.g., DECISION_001)",
        "type": "string"
      },
      "fields": {
        "description": "Fields to return (optional, e.g., [\"decisionId\", \"title\", \"status\"])",
        "type": "array"
      }
    },
    "required": [
      "decisionId"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "findByCategory",
  "title": null,
  "description": "Find decisions by category with optional field projection",
  "inputSchema": {
    "properties": {
      "category": {
        "description": "Category name",
        "type": "string"
      },
      "fields": {
        "description": "Fields to return (optional)",
        "type": "array"
      },
      "status": {
        "description": "Filter by status (optional)",
        "type": "string"
      }
    },
    "required": [
      "category"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "findByStatus",
  "title": null,
  "description": "Find decisions by status with optional field projection",
  "inputSchema": {
    "properties": {
      "fields": {
        "description": "Fields to return (optional)",
        "type": "array"
      },
      "limit": {
        "description": "Maximum results (optional)",
        "type": "number"
      },
      "status": {
        "description": "Status (Proposed/Approved/InProgress/Completed/Rejected)",
        "type": "string"
      }
    },
    "required": [
      "status"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "search",
  "title": null,
  "description": "Search decisions by title or description with optional field projection",
  "inputSchema": {
    "properties": {
      "fields": {
        "description": "Fields to return (optional)",
        "type": "array"
      },
      "limit": {
        "description": "Maximum results (optional)",
        "type": "number"
      },
      "query": {
        "description": "Search text",
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
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "createDecision",
  "title": null,
  "description": "Create a new decision record with optional dependencies",
  "inputSchema": {
    "properties": {
      "category": {
        "description": "Category",
        "type": "string"
      },
      "decisionId": {
        "description": "Unique decision ID",
        "type": "string"
      },
      "dependencies": {
        "description": "Array of decision IDs this depends on",
        "type": "array"
      },
      "description": {
        "description": "Full description",
        "type": "string"
      },
      "details": {
        "description": "Decision details",
        "type": "object"
      },
      "implementation": {
        "description": "Implementation tracking",
        "type": "object"
      },
      "priority": {
        "description": "Priority (Low/Medium/High/Critical, default: Medium)",
        "type": "string"
      },
      "section": {
        "description": "Section reference",
        "type": "string"
      },
      "source": {
        "description": "Source document",
        "type": "string"
      },
      "status": {
        "description": "Status (default: Proposed)",
        "type": "string"
      },
      "title": {
        "description": "Decision title",
        "type": "string"
      }
    },
    "required": [
      "decisionId",
      "title",
      "category",
      "description"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "updateStatus",
  "title": null,
  "description": "Update decision status with history tracking",
  "inputSchema": {
    "properties": {
      "decisionId": {
        "description": "Decision ID",
        "type": "string"
      },
      "note": {
        "description": "Optional note",
        "type": "string"
      },
      "status": {
        "description": "New status",
        "type": "string"
      }
    },
    "required": [
      "decisionId",
      "status"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "updateImplementation",
  "title": null,
  "description": "Update implementation details",
  "inputSchema": {
    "properties": {
      "decisionId": {
        "description": "Decision ID",
        "type": "string"
      },
      "implementation": {
        "description": "Implementation object",
        "type": "object"
      }
    },
    "required": [
      "decisionId",
      "implementation"
    ],
    "type": "object"
  },
  "outputSchema": null,
  "icons": null,
  "annotations": null,
  "_meta": null,
  "execution": null,
  "mcp_server_name": "decisions-server",
  "meta": null
}

{
  "name": "addActionItem",
  "title": null,
  "description": "Add an action item to a decision",
  "inputSchema": {
    "properties": {
      "decisionId": {
        "description": "Decision ID",
        "type": "string"
      },
      "files": {
        "description": "Related files",
        "type": "array"
      },
      "priority": {
        "description": "Priority (1-10, default: 1)",
        "type": "number"
      },
      "task": {
        "description": "Task description",
        "type": "string"
      }
    },
    "required"

... (truncated)
```
