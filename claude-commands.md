# Claude Code 命令参考

## 核心命令

### `/help`
显示 Claude Code 的帮助信息和可用命令列表。

### `/fast` / `/slow`
- `/fast` - 切换到快速模式（使用 Opus 4.6 模型，输出更快）
- `/slow` - 切换回正常模式

### `/clear`
清除当前的对话历史，重新开始对话。

### `/exit`
退出 Claude Code。

## Git 相关

### `/commit`
交互式创建 git commit。Claude 会：
1. 查看当前状态（git status、git diff）
2. 分析更改内容
3. 起草提交信息
4. 创建提交

### `/review`
审查代码更改，提供反馈和建议。

### `/pr` 或 `/pull-request`
创建 GitHub 拉取请求。

## 任务管理

### `/tasks` 或 `/todo`
显示当前的任务列表，包括：
- 待处理任务
- 进行中任务
- 已完成任务
- 任务依赖关系

### `/plan`
进入计划模式，用于：
- 设计实现方案
- 探索代码库
- 制定实施计划
- 在开始编码前与用户对齐方案

## 记忆管理

### `/memory`
查看所有已保存的记忆内容。

### `/remember <内容>`
让 Claude 记住特定信息，保存到持久化记忆中。

### `/forget <内容>`
让 Claude 忘记已保存的特定记忆。

### `/memory:edit`
编辑现有的记忆内容。

## 配置相关

### `/config` 或 `/settings`
打开并编辑 `settings.json` 配置文件。

### `/config:local`
编辑本地配置文件 `settings.local.json`。

## 循环任务

### `/loop <间隔> <命令>`
设置循环执行命令。
- 示例：`/loop 5m /tasks` - 每 5 分钟显示任务列表
- 示例：`/loop 10m /babysit-prs` - 每 10 分钟检查 PR 状态
- 默认间隔为 10 分钟

### `/loop:list`
列出所有活动的循环任务。

### `/loop:stop <ID>`
停止指定的循环任务。

## 批量更改

### `/batch <指令>`
对多个文件进行批量更改。Claude 会：
1. 分析整个代码库
2. 识别所有需要修改的文件
3. 应用统一的更改
4. 显示修改摘要

**示例用法：**
- `/batch migrate from react to vue` - 从 React 迁移到 Vue
- `/batch replace all uses of lodash with native equivalents` - 用原生代码替换 lodash
- `/batch add type annotations to all untyped function parameters` - 添加类型注解
- `/batch convert all callbacks to async/await` - 转换回调为 async/await
- `/batch rename all foo variables to bar` - 批量重命名变量

**适用场景：**
- 重构：统一命名规范、代码模式
- 迁移：升级库版本、更换依赖
- 添加功能：批量添加错误处理、日志
- 代码清理：移除未使用的导入、统一格式

## 其他工具

### `/simplify`
审查更改的代码，检查可重用性、质量和效率，并修复发现的问题。

### `/babysit` 或 `/babysit-prs`
监控 Pull Request 的状态，检查检查状态、评论和更改。

### `/diff`
显示当前更改的 diff 视图。

### `/model`
切换或查看当前使用的模型。

### `/theme`
更改界面主题。

## 工作树相关

### `/worktree`
创建和管理 git 工作树，用于隔离开发环境。

### `/worktree:exit`
退出当前工作树会话。

## 技能（Skills）

### 什么是 Skills？

Skills 是 Claude Code 的可扩展功能，允许你定义可重用的自定义命令和自动化任务。

### 使用方式

#### 1. 直接调用技能
```
/<skill-name> [参数]
```

**示例：**
```
/commit                    # 创建 git commit
/commit -m "Fix bug"       # 带参数的 commit
/review-pr 123             # 审查 PR #123
/pdf analyze document.pdf  # 分析 PDF 文件
```

#### 2. 通过对话触发
某些技能会在对话中自动触发，无需显式调用：

**触发条件示例：**
- 代码导入 `anthropic` 或 `@anthropic-ai/sdk` → 自动触发 `claude-api` 技能
- 用户说 "commit these changes" → 自动触发 `commit` 技能
- 用户要求 "review my PR" → 自动触发 `review-pr` 技能

#### 3. 列出可用技能
使用 `/skills` 或 `/help` 查看所有可用的技能列表。

### 内置技能

| 技能名称 | 功能描述 | 触发条件 |
|---------|---------|---------|
| `commit` | 创建 git commit | 显式调用或对话提及 |
| `review-pr` | 审查 Pull Request | 显式调用或对话提及 |
| `pdf` | 处理 PDF 文件 | 文件路径为 .pdf |
| `update-config` | 修改 settings.json | 配置相关请求 |
| `simplify` | 代码简化和优化 | 显式调用 |
| `loop` | 循环执行任务 | `/loop` 命令 |
| `claude-api` | Claude API 开发 | 导入 Anthropic SDK |
| `claude-code-guide` | Claude Code 使用帮助 | 询问如何使用 Claude |

### 创建自定义技能

技能定义在项目目录下的 `.claude/skills/` 文件夹中：

**文件结构：**
```
.claude/
└── skills/
    └── my-skill.md       # 技能定义文件
```

**技能文件格式：**
```markdown
---
name: my-skill
description: 简短描述这个技能的作用
---

You are a specialized assistant for...
（详细的指令，告诉 AI 如何执行这个任务）
```

**示例技能：**
```markdown
---
name: test-runner
description: Run all tests and report results
---

When invoked, you should:
1. Run the test command for this project
2. Parse the output
3. Report any failures with context
4. Suggest fixes if applicable
```

### 技能参数传递

技能可以接受参数：

```
/<skill-name> arg1 arg2 --flag=value
```

在技能定义中通过 `{{args}}` 访问参数。

### 技能最佳实践

1. **命名清晰**：使用描述性的技能名称
2. **单一职责**：每个技能只做一件事
3. **明确触发**：在描述中说明何时触发
4. **提供示例**：在技能文件中包含使用示例
5. **错误处理**：告诉 AI 如何处理失败情况

## 快捷操作

- `! <命令>` - 直接在终端执行 shell 命令
- `@<文件>` - 引用特定文件
- `#<符号>` - 搜索代码符号

---

**提示**：大多数命令支持简写形式，输入 `/` 后可以查看可用命令的自动补全列表。
