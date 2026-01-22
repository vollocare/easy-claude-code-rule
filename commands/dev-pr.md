---
name: dev-pr
description: 完成開發流程的驗證與 PR 提交，包含 QA、Code Review 與閉環作業
args: "[task_number] - 可選，任務編號。若未指定則使用當前分支對應的任務"
---

# /dev-pr [task_number] - 提交 PR 與閉環

完成開發流程的驗證階段（QA + Code Review）並提交 PR。

## 參數

- `task_number`（可選）：任務編號，如 `001`
  - 若指定：處理指定的 spec_XXX
  - 若未指定：從當前分支名稱推斷（如 `feat/001-login` → `001`）

## 執行流程

### 階段一：前置檢查

1. **確認任務編號**
   ```bash
   # 若未指定，從分支名稱取得
   git branch --show-current  # feat/001-xxx → 001
   ```

2. **檢查任務清單完成度**
   - 讀取 `.dev/specs/spec_{task_number}_task.md`
   - 確認所有 `[ ]` 都已變成 `[x]`
   - 若有未完成項目，列出並詢問是否繼續

3. **檢查工作目錄狀態**
   ```bash
   git status
   ```
   - 若有未提交變更，提示使用者先提交

### 階段二：QA 驗證

1. **執行自動化測試**
   ```bash
   # 偵測專案類型並執行對應測試命令
   npm test          # Node.js
   pytest            # Python
   go test ./...     # Go
   cargo test        # Rust
   ```

2. **程式碼品質檢查**
   ```bash
   npm run lint      # 或對應 linter
   npm run typecheck # TypeScript 型別檢查
   ```

3. **產生 QA 報告**

   建立 `.dev/qa/qa_{task_number}.md`：
   ```markdown
   # QA 報告：spec_{task_number}

   > 測試日期：{current_date}

   ## 測試執行結果
   - [x] 自動化測試通過
   - [x] Lint 檢查通過
   - [x] 型別檢查通過

   ## 驗收標準驗證
   [根據 spec 的 AC 逐項驗證]

   ## 結論
   - [x] 通過 - 可以提交 PR
   ```

### 階段三：Self Code Review

1. **檢視變更**
   ```bash
   git diff main...HEAD --stat
   git diff main...HEAD
   ```

2. **產生 Code Review 記錄**

   建立 `.dev/codereview/review_{task_number}.md`：
   ```markdown
   # Code Review：spec_{task_number}

   > Review 日期：{current_date}

   ## 變更摘要
   [列出主要變更檔案與內容]

   ## 檢查結果
   - [x] 實作符合 spec 規格
   - [x] 程式碼品質良好
   - [x] 測試覆蓋完整

   ## 結論
   - [x] Approved - 可以合併
   ```

### 階段四：建立 PR

1. **推送分支**
   ```bash
   git push -u origin feat/{task_number}-{desc}
   ```

2. **建立 PR**
   ```bash
   gh pr create \
     --title "feat({task_number}): {功能名稱}" \
     --body-file .dev/specs/spec_{task_number}_task.md \
     --base main \
     --head feat/{task_number}-{desc}
   ```

   若 `gh` 不可用，輸出手動建立指引：
   ```
   請手動建立 PR：
   - 標題：feat({task_number}): {功能名稱}
   - 內容：複製 .dev/specs/spec_{task_number}_task.md
   - Base: main
   - Compare: feat/{task_number}-{desc}
   ```

3. **輸出結果**
   ```
   ✅ PR 已建立！

   📋 PR URL: {pr_url}
   📄 QA 報告：.dev/qa/qa_{task_number}.md
   📝 Review 記錄：.dev/codereview/review_{task_number}.md

   下一步（PR 合併後）：
   1. 更新 ARCHITECTURE.md
   2. 歸檔 spec：mv .dev/specs/spec_{task_number}.md .dev/.claudeignore/
   3. 清理 worktree：git worktree remove ../task-{task_number}
   ```

### 階段五：閉環提示（PR 合併後手動執行）

PR 合併後的閉環作業清單：

```bash
# 1. 切回主分支
git checkout main && git pull

# 2. 更新架構文件
# [根據本次變更更新 ARCHITECTURE.md]

# 3. 歸檔 spec
mv .dev/specs/spec_{task_number}.md .dev/.claudeignore/
mv .dev/specs/spec_{task_number}_task.md .dev/.claudeignore/

# 4. 清理 worktree
git worktree remove ../task-{task_number}

# 5. 刪除本地分支（可選）
git branch -d feat/{task_number}-{desc}
```

## 錯誤處理

- **測試失敗**：列出失敗項目，提示修復後重新執行
- **未提交變更**：提示先提交或 stash
- **分支未推送**：自動推送或提示手動推送
- **gh CLI 不可用**：提供手動建立 PR 的指引
