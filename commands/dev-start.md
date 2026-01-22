---
name: dev-start
description: 開始開發指定的任務，建立 worktree 並依照任務清單執行開發
args: "[task_number] - 可選，任務編號（如 001）。若未指定則自動尋找待開發任務"
---

# /dev-start [task_number] - 開始開發任務

開始開發指定的任務，或自動尋找待開發任務。

## 參數

- `task_number`（可選）：任務編號，如 `001`、`002`
  - 若指定：開發指定的 spec_XXX
  - 若未指定：自動掃描 `.dev/specs/` 找出待開發任務

## 執行流程

### 1. 確定任務編號

**若有指定編號：**
- 檢查 `.dev/specs/spec_{task_number}.md` 是否存在
- 檢查 `.dev/specs/spec_{task_number}_task.md` 是否存在
- 若任務清單不存在，先讀取 spec 並使用 `/plan` 產生任務清單

**若未指定編號：**
- 掃描 `.dev/specs/` 目錄
- 找出所有 `spec_XXX.md` 檔案
- 排除已在 `.dev/.claudeignore/` 中的（已完成）
- 排除已有對應 worktree 的（開發中）
- 選擇編號最小的待開發任務
- 若無待開發任務，提示使用者建立新的 spec

### 2. 檢查/建立任務清單

讀取 `spec_{task_number}_task.md`：
- 若存在且有未完成項目 `[ ]`，繼續
- 若不存在，讀取 `spec_{task_number}.md` 後產生任務清單

任務清單格式：
```markdown
# spec_XXX_task: [功能名稱]

## 修改檔案清單
- [ ] `src/xxx/file1.ts` - [描述]

## API/組件接口
- [ ] `POST /api/xxx` - [描述]

## 測試案例
- [ ] 單元測試：[描述]
```

### 3. 建立 Worktree（若不存在）

```bash
# 確保主分支最新
git fetch origin

# 檢查 worktree 是否已存在
git worktree list | grep "task-{task_number}"

# 若不存在，建立新的 worktree
git worktree add ../task-{task_number} -b feat/{task_number}-{short_desc}
```

### 4. 開始開發

輸出提示：
```
🚀 開始開發 spec_{task_number}

📋 任務清單：.dev/specs/spec_{task_number}_task.md
📁 Worktree：../task-{task_number}
🌿 分支：feat/{task_number}-{short_desc}

待完成項目：
- [ ] item 1
- [ ] item 2
...

請在 Worktree 目錄中開啟新的 Claude Code session 進行開發：
  cd ../task-{task_number}

或在當前 session 繼續開發。
```

### 5. 執行開發

依照任務清單逐項開發：
1. 讀取任務清單中的第一個 `[ ]` 項目
2. 執行該項目的開發工作
3. 完成後將 `[ ]` 改為 `[x]`
4. 提交進度：`git commit -m "feat({task_number}): {項目描述}"`
5. 重複直到所有項目完成

### 6. 開發完成檢查

當所有 `[ ]` 都變成 `[x]` 時：
```
✅ spec_{task_number} 所有任務項目已完成！

下一步：
1. 執行測試確認功能正常
2. 執行 /dev-pr {task_number} 提交 PR
```

## 錯誤處理

- **spec 不存在**：提示使用者先建立 `.dev/specs/spec_{task_number}.md`
- **目錄結構不存在**：提示執行 `/dev-init`
- **worktree 衝突**：提示清理或使用其他編號
