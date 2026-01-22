---
name: dev-resume
description: 在 Worktree 中接續開發任務，自動偵測當前分支對應的任務並繼續執行
args: "[task_number] - 可選，任務編號。若未指定則從當前分支自動偵測"
---

# /dev-resume [task_number] - 接續開發任務

在新的 Claude Code session 中接續開發任務。適用於：
- 在 Worktree 目錄開啟新 session 後
- 中斷開發後重新開始
- 切換到已存在的 Worktree 繼續開發

## 參數

- `task_number`（可選）：任務編號，如 `001`
  - 若指定：直接載入該任務
  - 若未指定：從當前分支名稱自動偵測

## 執行流程

### 1. 偵測當前環境

```bash
# 取得當前分支
git branch --show-current
# 輸出範例：feat/001-login → 任務編號 001

# 確認當前目錄
pwd
# 預期：../task-XXX 或專案內的 worktree
```

### 2. 載入任務上下文

1. **讀取任務清單**
   ```
   .dev/specs/spec_{task_number}_task.md
   ```
   - 若在 worktree 中，路徑可能是相對於主專案

2. **讀取原始規格**
   ```
   .dev/specs/spec_{task_number}.md
   ```

3. **讀取架構文件**
   ```
   ARCHITECTURE.md
   ```

4. **讀取需求釐清記錄**（如果任務清單中有記錄）

### 3. 分析開發進度

掃描任務清單，統計進度：

```
📊 開發進度：spec_{task_number}

已完成：
- [x] item 1
- [x] item 2

待完成：
- [ ] item 3
- [ ] item 4

進度：2/4 (50%)
```

### 4. 輸出接續資訊

```
🔄 接續開發 spec_{task_number}: {功能名稱}

📋 任務清單：.dev/specs/spec_{task_number}_task.md
🌿 當前分支：feat/{task_number}-{desc}
📁 工作目錄：{current_path}

═══════════════════════════════════════
📊 進度：{completed}/{total} ({percentage}%)
═══════════════════════════════════════

✅ 已完成：
- [x] {已完成項目1}
- [x] {已完成項目2}

⏳ 待完成（將從這裡繼續）：
- [ ] {待完成項目1} ← 下一個任務
- [ ] {待完成項目2}

═══════════════════════════════════════

準備繼續開發 "{待完成項目1}"...
```

### 5. 繼續開發

自動開始執行下一個未完成的任務項目：
1. 讀取 `[ ]` 標記的第一個項目
2. 執行該項目的開發工作
3. 完成後將 `[ ]` 改為 `[x]`
4. 提交進度

### 6. 開發完成檢查

當所有項目完成時：
```
✅ spec_{task_number} 所有任務項目已完成！

下一步：
1. 切回主專案目錄
2. 執行 /dev-pr {task_number} 提交 PR
```

## 特殊情況處理

### 找不到任務清單
```
⚠️ 找不到任務清單

當前分支：feat/001-login
預期檔案：.dev/specs/spec_001_task.md

可能原因：
1. 尚未執行 /dev-plan 產生任務清單
2. 路徑不正確

建議：
- 確認您在正確的 worktree 目錄
- 或回到主專案執行 /dev-plan 001
```

### 任務清單已全部完成
```
✅ spec_{task_number} 所有任務已完成！

無待完成項目。

下一步：
執行 /dev-pr {task_number} 提交 PR
```

### 不在 feature 分支
```
⚠️ 當前不在 feature 分支

當前分支：main

建議：
1. 切換到對應的 feature 分支
2. 或指定任務編號：/dev-resume 001
```

## 與 /dev-start 的差異

| 項目 | /dev-start | /dev-resume |
|------|------------|-------------|
| 用途 | 開始新任務 | 接續已開始的任務 |
| Worktree | 會建立新的 | 假設已在 worktree 中 |
| 進度 | 從頭開始 | 從上次中斷處繼續 |
| 情境 | 主專案目錄 | Worktree 目錄 |
