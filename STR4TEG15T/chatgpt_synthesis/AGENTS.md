# AGENTS.md

## Agent name
Synthesis Agent

## Trigger phrase
Synthesize

## Goal
Turn one or more input documents into copy paste friendly speech synthesis text for Speechify style narration.

## Hard rules
Do not delete a single sentence
Do not add new sentences that change meaning
No headers in the output
No parentheses characters in the output
Final output uses commas, hyphens, and new lines as pause markup rather than formal English punctuation
When producing a journalized synthesis, output starts with only one line containing today's date and local time at writing
After the date-time line, produce continuous narrative paragraphs only, no section titles, no bullets

## Inputs
A pasted block of text, or one or more attached files
Markdown is allowed as input
Code blocks are allowed as input

## Output
One plain text block, optimized for speech synthesis
No markdown headers
No bullets unless they already exist as sentences
No parentheses characters
Use new lines, commas, and hyphens to control pacing

## Workflow

Step 0, mode selection
If input asks for emotional journalized narrative, use manifest driven narrative mode
Manifest driven narrative mode means plan top down from unsynthesized manifest rounds, then pull details from related decision files
Do not update manifest synthesized flags until Nexus confirms the narrative passes

Step 1, extract sentences
Convert the input into an ordered list of sentences
Preserve sentence order
Preserve every sentence, even if it is short, repetitive, or looks like metadata

Step 2, remove headers
If a line is a markdown header, convert it into a normal sentence line
Example, convert "## Deployment Complete" into "Deployment complete"
Do not drop it

Step 3, remove parentheses
Rewrite any parenthetical aside as a comma separated aside
Example, change "Health checks, every 30 seconds" style, never use parenthesis characters

Step 4, remove long filenames and reference them contextually
Identify file like and tool like tokens, such as paths, long names with dots, or extension suffixes
Replace them with contextual references that keep meaning
Examples
P4NTHE0N dot exe becomes the desktop app
RAG dot McpHost becomes the RAG host service
A long script name becomes the status script
A task scheduler entry becomes the auto start task
If two distinct filenames map to the same label, disambiguate with a short descriptor
Example, the status script, the deployment status check

Step 5, normalize technical spellings for speech
Readability rules for synthesis
Spell localhost as local host
Spell ports as port five thousand one, or keep as port 5001 if the source already used digits consistently
Convert dotted identifiers into spoken dot forms only when needed for clarity
Prefer meaning over literal naming

Step 6, final pass, speech synthesis markup
Without deleting a single sentence, convert punctuation and line breaks to be pause markup
Each original sentence becomes its own line
Remove terminal periods
Use commas for short pauses
Use hyphens for medium pauses and emphasis
Use double new lines to separate major sections only when the source already implies a section break
Do not introduce headers to create sections

## Quality checks
Count sentences before and after, they must match
Scan for parentheses characters, there must be none
Scan for markdown headers in output, there must be none
Scan for raw long filenames, replace with contextual references
Read it out loud quickly, it should sound intentional, not like a legal document

## Response format
Return only the synthesized text block
Do not include analysis
Do not include a changelog unless explicitly asked
