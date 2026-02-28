# SKILL.md

## Skill name
speechify_synthesis

## When to use
Use this skill when the user says Synthesize
Also use when the user asks for Speechify friendly copy paste narration output

## What it produces
A single plain text output optimized for speech synthesis
The output preserves every sentence and keeps the original order
The output removes headers, removes parentheses, and replaces long filenames with contextual references
The final output uses commas, hyphens, and new lines as pause markup
For journalized emotional synthesis, the first line is only today's date and local time at writing
For journalized emotional synthesis, the body is paragraph narrative only, no section headers

## Inputs
text, required
filename_context_map, optional
voice_style, optional, values neutral, intense, calm, cinematic

## Core constraints
Do not delete any sentence
Do not add any new sentence that changes meaning
No headers in output
No parentheses characters in output

## Steps

0, narrative planning when manifest mode is requested
Read unsynthesized rounds from the manifest
Plan emotional arc top down from manifest narrative fields
Pull supporting details from referenced decision files
Draft story first, then wait for Nexus pass/fail before any manifest synthesized flag updates

1, sentence preservation
Split into sentences while preserving order
Treat standalone metadata lines as sentences

2, header flattening
Convert markdown headers into normal text sentences
Keep the words, drop the header syntax

3, parentheses removal
Replace any parenthetical content with comma separated content
Never output parentheses characters

4, filename and identifier contextualization
Detect tokens that look like files, binaries, scripts, services, tasks, or identifiers
Replace with short spoken labels
Use the optional filename_context_map when provided
If not provided, apply heuristics
exe, the desktop app
ps1 or bat, the script
cs or dll, the service component
task scheduler entry, the auto start task
localhost or 127.0.0.1, local host
dot separated process names, the host service, or the named service

5, synthesis markup conversion
Each preserved sentence becomes one line
Remove terminal periods
Prefer commas over periods
Use hyphens to create deliberate beats
Avoid semicolons, avoid colons, prefer commas

## Heuristics for detection
A token is filename like if any of these are true
Contains a slash or backslash
Ends in an extension like exe, ps1, cs, dll, json, md
Contains multiple dots and has no spaces
Looks like a namespace or process name

## Default mapping suggestions
P4NTHE0N dot exe, the desktop app
RAG dot McpHost, the RAG host service
ToolHive, the tools registry
mcp p4nthon, the database tool set
mongod, the database service

## Validation
Sentence count unchanged
No parentheses characters
No markdown headers
All detected long filenames replaced or intentionally spoken

## Output
Return the final synthesized text only
No extra commentary unless asked
