---
name: advanced-skill-creator
description: Advanced WindSurf skill creation handler that executes the official 5-step research flow with comprehensive analysis and best practices. Ensures proper methodology when users request to create or modify WindSurf skills following official standards.
when: "When user mentions '写一个触发', '写skill', 'skill creation', 'create skill', '创建技能', '写一个让它...', or any request related to creating or modifying WindSurf skills"
examples:
  - "写一个触发监控系统"
  - "写skill让它发送通知"
  - "创建skill提醒功能"
  - "创建windurf skill翻译功能"
  - "定时任务skill"
  - "创建技能备份数据"
  - "写一个让它自动回复的技能"
  - "写一个触发定时任务的技能"
  - "创建天气查询技能"
  - "写一个让它管理日程的技能"
metadata:
 {
   "windsurf": {
     "requires": { "bins": ["python3", "bash"], "anyBins": ["python3", "python"] },
     "emoji": "⚡",
     "primaryEnv": null
   }
 }
---

# Advanced Skill Creator

Advanced skill creation handler that executes the official 5-step research flow with comprehensive analysis and best practices. Ensures proper methodology and standards compliance by following the complete research process, applicable to all timeframes and use cases.

## When to use
- When user mentions "写一个触发", "写skill", "skill creation", "create skill", "创建技能", or "写一个让它..."
- When proper skill creation methodology needs to be followed according to official standards
- When ensuring adherence to 5-step research flow (documentation, research, community, fusion, output)
- For comprehensive skill analysis and creation with best practices

## 5-Step Research Flow Execution

### Step 1: Consult Official Documentation
Comprehensively access official documentation:
- https://docs.windsurf.com/skills
- WindSurf skills documentation
- Skills specification and best practices

Extract key information:
- SKILL.md format requirements
- YAML frontmatter specifications (name, description)
- Trigger mechanisms (natural language triggers)
- Tool calling conventions and integration
- Loading precedence and skill discovery
- WindSurf-specific features and capabilities
- Breaking changes and version compatibility

### Step 2: Research Related Public Skills
Thoroughly query existing skills for relevant patterns:
- Search keywords: weather, reminder, schedule, translate, image, cron, memory, task-tracker, notification, backup, automation
- Select 2-4 most relevant skills with high quality and recent updates
- Analyze:
  - Trigger descriptions and examples
  - YAML metadata and structure
  - Pure Markdown vs. scripts/ organization
  - Dependency declarations
  - Error handling recommendations
  - Community feedback and adoption
  - Security considerations

### Step 3: Search Best Practices
Use comprehensive keyword combinations for searches:
- "WindSurf SKILL.md" OR "skill creation example" OR "create WindSurf skill"
- "SKILL.md" "description:" OR "skill metadata" site:github.com
- "WindSurf skill tutorial" OR "skill best practices"
- "skill security" OR "prompt injection prevention" OR "skill development guide"

Focus on:
- Active repositories and documentation
- Recent commits and updates
- Blog posts and tutorials
- Security best practices
- Known security pitfalls (prompt injection, input validation)
- WindSurf-specific patterns and conventions

### Step 4: Solution Fusion & Comparison
Comprehensively summarize implementation approaches from all three sources:
Compare across key dimensions:
- Trigger precision and effectiveness
- Maintainability and readability
- Loading speed and memory impact
- Compatibility across different environments
- Security & error isolation
- Upgrade friendliness and dependency management
- Performance optimization
- Error handling robustness

Select optimal solution for current context with 4-7 clear reasons prioritized:
- Official documentation > High-quality existing skills > Active community solutions > Self-optimization

### Step 5: Proper Output Structure
Output must follow exact structure without adding extra headers or showing raw search logs:
- Use the exact headings: 【最终推荐方案】, 【文件结构预览】, 【完整文件内容】
- Provide complete file contents with proper formatting
- Include tree-style directory structure preview
- Use proper YAML frontmatter in SKILL.md examples
- Ensure comprehensive documentation

## Resource Utilization

### Documentation Features Utilized
- YAML frontmatter format (name, description)
- Trigger mechanism definition (description field)
- Example specification and use cases
- Metadata definition and configuration
- Standardized skill description structure

### Skills Referenced
- Various existing skills: Structure and functional organization
- Security-focused skills: Metadata definition format
- Integrated skills: Script organization and implementation
- Other existing skills: YAML frontmatter best practices

### Community Practices Integrated
- Popular WindSurf skill project structures
- Community-recommended security practices (input validation, error handling)
- Optimal metadata configuration methods
- Effective trigger word definition patterns

### Custom Scripts Created
- advanced_skill_processor.py: Implements complete 5-step research flow automation
  - Automated documentation query, public skill research, best practice search
  - Solution fusion and comparison functionality
  - Standardized output generation
  - Error handling and logging features

## Implementation Requirements
1. Execute all 5 steps in strict sequence - no skipping allowed
2. Do not rely on memory or "approximately correct" code
3. Demonstrate research → comparison → selection logical chain
4. Show evidence of consulting official documentation
5. Include proper metadata and security considerations
6. Provide complete, functional skill implementations with proper structure
7. Ensure all outputs follow the exact template structure required
8. Apply universally regardless of timeframe or version
9. Include security best practices and error handling
10. Provide comprehensive examples and use cases
11. Include system prompt integration for enhanced AI interaction
12. Incorporate thinking model framework for improved decision-making

## System Prompt Integration

When creating new skills, include system prompt elements that enhance AI interaction:

"You are now a WindSurf skill development expert, implementing advanced thinking models for enhanced decision-making. Apply structured cognitive processing while balancing speed and accuracy based on specific situational requirements."

### Skill Creation Guidelines
- Apply the multi-stage cognitive processing pipeline during skill design
- Integrate memory systems for continuous learning and improvement
- Balance speed optimization with accuracy enhancement in skill functionality
- Include appropriate system prompts for AI assistants using the skill
- Document decision-making processes for future reference and learning