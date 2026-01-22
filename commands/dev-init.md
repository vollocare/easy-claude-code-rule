---
name: dev-init
description: 初始化專案目錄結構，使其符合 dev-workflow 開發流程規範
---

# /dev-init - 初始化開發流程目錄結構

初始化專案以符合 dev-workflow 開發流程規範。

## 執行步驟

1. **檢查當前目錄**
   - 確認位於 git 專案根目錄
   - 若不在 git 專案中，提示使用者先執行 `git init`

2. **建立 .dev 目錄結構**
   ```bash
   mkdir -p .dev/specs
   mkdir -p .dev/qa
   mkdir -p .dev/codereview
   mkdir -p .dev/.claudeignore
   ```

3. **建立 .gitkeep 檔案**（確保空目錄被 git 追蹤）
   ```bash
   touch .dev/specs/.gitkeep
   touch .dev/qa/.gitkeep
   touch .dev/codereview/.gitkeep
   touch .dev/.claudeignore/.gitkeep
   ```

4. **檢查 ARCHITECTURE.md**
   - 若不存在，建立基礎模板
   - 若已存在，跳過此步驟

5. **輸出結果摘要**
   ```
   ✅ 開發流程目錄結構初始化完成！

   已建立：
   .dev/
   ├── specs/           # 規格文件 (spec_XXX.md, spec_XXX_task.md)
   ├── qa/              # QA 測試報告
   ├── codereview/      # Code Review 記錄
   └── .claudeignore/   # 舊資料歸檔

   下一步：
   1. 建立規格文件：.dev/specs/spec_001.md
   2. 執行 /dev-start 001 開始開發
   ```

## ARCHITECTURE.md 模板

若需建立，使用以下模板：

```markdown
# 專案架構文件

> 最後更新：[當前日期]

## 概述

[專案簡介與目的]

## 技術棧

- 前端：
- 後端：
- 資料庫：

## 目錄結構

\`\`\`
project/
├── src/
├── tests/
├── .dev/          # 開發流程文件
└── ...
\`\`\`

## 模組依賴圖

[描述主要模組間的依賴關係]

## 資料流

[描述主要資料流動方式]

## API 端點總覽

| 端點 | 方法 | 描述 |
|------|------|------|
| | | |

## 變更記錄

| 日期 | 變更內容 | 相關 Spec |
|------|----------|-----------|
| | | |
```
