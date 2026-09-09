# GPT Image 2.5 中文技能包

一套面向 Codex 与 ChatGPT Plugin 的中文图像工作流。它不会替代图像生成工具，而是帮助智能体选择正确流程、保留参考图约束、组织提示并检查结果。

> 社区项目，与 OpenAI 无隶属或官方背书关系。模型和产品能力请以 OpenAI 当前文档为准。

## 包含的 Skill

| Skill | 独立目录 | 适用任务 |
|---|---|---|
| `gpt-image25-social-design` | [查看](plugins/gpt-image-2-5-skills/skills/gpt-image25-social-design) | 社媒封面、活动海报、视频封面 |
| `gpt-image25-product-studio` | [查看](plugins/gpt-image-2-5-skills/skills/gpt-image25-product-studio) | 商品主图、场景图、包装与材质展示 |
| `gpt-image25-precise-edit` | [查看](plugins/gpt-image-2-5-skills/skills/gpt-image25-precise-edit) | 局部修改、换背景、文字替换、多图合成 |
| `gpt-image25-sketch-render` | [查看](plugins/gpt-image-2-5-skills/skills/gpt-image25-sketch-render) | 草图、线稿、涂鸦或线框转视觉稿 |
| `gpt-image25-knowledge-visual` | [查看](plugins/gpt-image-2-5-skills/skills/gpt-image25-knowledge-visual) | 知识卡片、课程配图、轻量信息图 |
| `gpt-image25-brand-series` | [查看](plugins/gpt-image-2-5-skills/skills/gpt-image25-brand-series) | 品牌参考、角色和系列视觉一致性生成 |

每个目录都是完整、独立的 Skill，包含自己的 `SKILL.md`、`agents/`、`references/` 和必要素材，不依赖其他五个 Skill。

## 单个 Skill 一行安装

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-social-design
```

六条可以直接复制分享的命令：

```bash
# 海报与社媒设计
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-social-design

# 商品图工作室
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-product-studio

# 精准改图
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-precise-edit

# 草图成图
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-sketch-render

# 知识卡片与课程配图
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-knowledge-visual

# 品牌与系列素材
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh -s -- --skill gpt-image25-brand-series
```

Windows PowerShell：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.ps1))) -Skill gpt-image25-social-design
```

在 Codex 对话中也可以把某个 Skill 的独立目录交给 `$skill-installer`，例如：

```text
$skill-installer install https://github.com/Seesoai/gpt-image-2-5-skills/tree/main/plugins/gpt-image-2-5-skills/skills/gpt-image25-social-design
```

这三个入口都只安装指定 Skill，适合把某一个能力单独发给学员或同事。

## 六个 Skill 一键安装

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh | sh
```

Windows PowerShell：

```powershell
irm https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.ps1 | iex
```

不传 `--skill` 时，脚本把六个 Skill 全部安装到 Codex 的用户级目录 `~/.agents/skills`。再次运行相同命令即可更新；已有版本会移到 `~/.agents/skill-backups/gpt-image-2-5-skills/`。

安装后重启 Codex，通过 `/skills` 查看，或用 `$gpt-image25-social-design` 这类名字明确调用。

如果希望先审查脚本：

```bash
curl -fsSL https://raw.githubusercontent.com/Seesoai/gpt-image-2-5-skills/main/install.sh -o /tmp/gpt-image-skills-install.sh
less /tmp/gpt-image-skills-install.sh
sh /tmp/gpt-image-skills-install.sh
```

## 作为 Plugin 安装

仓库同时包含标准 marketplace 与 Plugin 清单。支持 Plugin 的 Codex 环境可以执行：

```bash
codex plugin marketplace add Seesoai/gpt-image-2-5-skills --ref main && codex plugin add gpt-image-2-5-skills@gpt-image-2-5
```

Plugin 形式便于团队统一安装和版本管理。Codex IDE 扩展如暂不支持 Plugin，可使用上面的一行脚本安装独立 Skill。

## ChatGPT 使用方式

终端脚本不能直接写入 ChatGPT 网页端。分享时可选择：

1. 将此仓库作为团队 Plugin marketplace，由管理员或用户在 ChatGPT 的 Plugins 界面安装。
2. 打开上表中的独立目录，只下载并上传所需 Skill 文件夹；每个文件夹都可单独导入 ChatGPT Skills。
3. 对已经在 ChatGPT 创建的个人 Skill，使用 Skills 页面中的 **Share**，接收者从共享列表安装。

安装后可用 `@` 选择 Skill，也可以自然描述任务，让 ChatGPT 按描述自动匹配。

## 卸载

macOS / Linux，在仓库目录运行：

```bash
sh uninstall.sh
```

只卸载一个 Skill：

```bash
sh uninstall.sh --skill gpt-image25-social-design
```

Windows PowerShell：

```powershell
.\uninstall.ps1
```

PowerShell 只卸载一个 Skill：

```powershell
.\uninstall.ps1 -Skill gpt-image25-social-design
```

不传 `--skill` 时卸载全部六个；指定名称时只卸载对应 Skill。卸载会把目录移到备份位置，不会直接删除用户文件。

## 发布自己的副本

1. 在 GitHub 创建一个空的公开仓库，例如 `gpt-image-2-5-skills`。
2. 在本目录运行 `python3 scripts/configure-repository.py 你的用户名/仓库名`。
3. 提交并推送：

```bash
git init
git add .
git commit -m "Publish GPT Image 2.5 Chinese skills"
git branch -M main
git remote add origin https://github.com/你的用户名/仓库名.git
git push -u origin main
```

4. 打开 README 里的 raw 链接，确认 `install.sh` 可以访问，再从一个干净测试目录执行安装命令。

## 维护与质量检查

每个 Skill 保持小而专一：`SKILL.md` 放触发条件和工作流，`references/` 放模型说明与示例，`agents/openai.yaml` 放展示信息。根目录 [skills.json](skills.json) 提供机器可读的名称、说明和独立路径。修改后运行：

```bash
sh scripts/validate.sh
```

发布新版本时同时更新根目录 `VERSION` 和 `.codex-plugin/plugin.json` 的 `version`，再用相同安装命令验证升级路径。

贡献者可按 [CONTRIBUTING.md](CONTRIBUTING.md) 的七项清单评审触发、边界、工具兼容性和验收标准。

## 许可

[MIT](LICENSE)
