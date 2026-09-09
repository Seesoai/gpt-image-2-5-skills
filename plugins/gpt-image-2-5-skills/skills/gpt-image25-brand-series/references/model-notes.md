# GPT Image 2.5 模型与接口说明

核实日期：2026-09-09。以下为当日公开文档信息；宿主工具参数和用户要求优先。模型版本、参数或计费需要精确判断时重新查官方文档。

| 场景 | 有模型选择权限时的建议 |
| --- | --- |
| 日常出图、低延迟探索、批量创意 | gpt-image-2.5-flare |
| 对局部修改、主体保留和成品细节要求更高 | gpt-image-2.5-sunburst |

两者均支持生成与编辑；这是取舍建议，不是互斥功能。不要因为任务属于“编辑”就宣称 Flare 不支持编辑。没有实际模型元数据时不推断本次模型。

API 接入要点：Image API 的 model 可直接指定上述 ID；Responses API 顶层使用支持图像工具的主模型，在 image_generation 工具的 model 中指定图像模型。多轮任务需要传回图像或保留有效对话上下文，单独重复文字不等于继承图片。

2.5 模型页列出的 quality 为 low、medium、high、xhigh、max、auto。不要沿用旧 CLI 仅支持 low/medium/high 的校验器而声称已完整支持 2.5；也不要把这些 API 参数塞进未暴露对应字段的内置工具。尺寸、透明输出、蒙版等按当前端点文档及实际工具能力核验，不承诺任意分辨率、像素级锁定或无误文字。品牌图中文字、二维码、商品参数和数据仍须检查。

Sketch 是 ChatGPT 的交互功能；普通草图也可以作为图像参考输入。它不是名为 sketch 的通用 API 参数。模型原生输出为栅格图，不把它称为可编辑 SVG、Figma、PPT 或可运行网页。

来源：
- [官方发布说明](https://openai.com/index/introducing-chatgpt-images-2-5/)
- [Flare 模型页](https://developers.openai.com/api/docs/models/gpt-image-2.5-flare)
- [Sunburst 模型页](https://developers.openai.com/api/docs/models/gpt-image-2.5-sunburst)
- [图像生成 API 指南](https://developers.openai.com/api/docs/guides/image-generation)
- [图像提示指南](https://developers.openai.com/api/docs/guides/image-prompting)

本技能为原创场景工作流。参考了公开项目的任务分类、参考图角色与结果检查思路，没有复制第三方脚本、图库或提示词。参考项目：
- [OpenAI imagegen](https://github.com/openai/skills/blob/main/skills/.system/imagegen/SKILL.md)
- [GPT-Image2-Skill](https://github.com/wuyoscar/GPT-Image2-Skill)
- [Impeccable 更新说明](https://impeccable.style/changelog/)
