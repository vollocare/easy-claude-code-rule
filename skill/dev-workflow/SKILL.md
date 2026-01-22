---
name: dev-workflow
description: |
  AI 軟體工程標準開發流程 - 文件驅動開發 (Docs-driven) 與 Worktree 物理隔離模式。
  觸發條件：當使用者提到「開發流程」、「遵守開發流程」、「新功能開發」、「spec」、「worktree」、「任務規劃」時自動啟用。
  核心模式：一規格、一任務、一 Worktree、一 PR。
  Commands: /dev-init, /dev-plan, /dev-start, /dev-resume, /dev-pr
---

# AI 軟體工程開發流程

四階段標準循環：規劃 → 執行 → 驗證 → 閉環

## Commands

| 指令 | 用途 | 參數 |
|------|------|------|
| `/dev-init` | 初始化專案目錄結構 | 無 |
| `/dev-plan <XXX>` | 分析 spec 並產生任務清單 | 必填：任務編號 |
| `/dev-start [XXX]` | 開始開發任務（主專案） | 可選：任務編號 |
| `/dev-resume [XXX]` | 接續開發任務（Worktree） | 可選：任務編號 |
| `/dev-pr [XXX]` | QA + Code Review + 提交 PR | 可選：任務編號 |

### /dev-init
初始化專案以符合 dev-workflow 規範，建立 `.dev/` 目錄結構與 `ARCHITECTURE.md`。

### /dev-plan <task_number>
針對指定 spec 進行深度分析，產生任務清單。
- 讀取 `spec_XXX.md` 與 `ARCHITECTURE.md`
- **互動問答**：釐清模糊需求、技術選型、架構衝突
- 分解任務：檔案清單、API 接口、測試案例
- 產出 `spec_XXX_task.md`，含需求釐清記錄

### /dev-start [task_number]
在主專案目錄開始開發。若未指定編號，自動尋找待開發任務。
- 建立 Worktree `../task-XXX` 與 feature 分支
- 提示：到 Worktree 目錄開啟新 Claude Code session
- 使用 `/dev-resume` 接續開發

### /dev-resume [task_number]
在 Worktree 目錄的新 session 中接續開發。
- 自動偵測當前分支對應的任務
- 載入任務上下文與進度
- 從上次中斷處繼續開發

### /dev-pr [task_number]
完成驗證並提交 PR。若未指定編號，從當前分支推斷。
- 執行 QA 測試，產生報告
- 執行 Self Code Review
- 建立 PR（使用任務清單作為內容）
- 提示閉環作業

## 目錄結構

所有開發相關文件集中於 `.dev/` 第二層目錄：

```
project/
├── .dev/                    # 開發流程專用目錄
│   ├── specs/               # 規格文件
│   │   ├── spec_001.md      # 功能規格 (SSOT)
│   │   └── spec_001_task.md # 對應任務清單
│   ├── qa/                  # QA 測試報告
│   ├── codereview/          # Code Review 記錄
│   └── .claudeignore/       # 舊資料歸檔
├── ARCHITECTURE.md          # 架構地圖 (必須維護)
└── ...
```

## 階段一：規劃 (Planning)

**目標**：以 `spec_XXX.md` 作為單一事實來源 (SSOT)

1. 確認或建立規格文件 `.dev/specs/spec_XXX.md`
2. 執行 `/dev-plan XXX` 進行分析（含互動問答釐清需求）
3. 產出任務清單 `.dev/specs/spec_XXX_task.md`

任務清單必須包含：
- [ ] 修改檔案清單
- [ ] 新增的 API 或組件接口
- [ ] 測試案例清單

**範本**：見 `assets/spec_template.md` 與 `assets/task_template.md`

## 階段二：執行 (Execution - Worktree 模式)

**目標**：物理隔離，專注開發

```bash
# 1. 在主專案執行 /dev-start XXX（建立 Worktree）

# 2. 到 Worktree 目錄開啟新 Claude Code session
cd ../task-XXX

# 3. 在新 session 執行 /dev-resume（接續開發）
```

執行規則：
- `/dev-start`：在主專案建立 Worktree
- `/dev-resume`：在 Worktree 的新 session 中接續開發
- 依照 `spec_XXX_task.md` 逐項開發，完成後打勾 `[x]`
- 命名規範：`spec_XXX` 對應 `feat/XXX` 分支

## 階段三：驗證與交付 (Verification & PR)

**目標**：本地 QA + PR 轉化

1. **本地 QA**
   - 執行測試：`npm test` / `pytest` / 對應測試命令
   - 依任務清單 Self-check
   - 記錄於 `.dev/qa/qa_XXX.md`

2. **PR 轉化**
   ```bash
   gh pr create --title "feat: XXX 功能" --body-file .dev/specs/spec_XXX_task.md
   ```

3. **Code Review**
   - 記錄於 `.dev/codereview/review_XXX.md`

## 階段四：閉環 (Closing the Loop)

**目標**：確保下一個循環不會崩壞

1. **合併回主線**：PR 通過後合併

2. **更新資產**
   - 同步 `ARCHITECTURE.md`：反映新的模組依賴與資料流
   - 標記 `spec_XXX.md` 為完成或移至 `.dev/.claudeignore/`

3. **清理**
   ```bash
   git worktree remove ../task-XXX
   ```

## 關鍵原則

### 防止漂移 (Drift)
> 永遠先改 `.md` 文件，再改代碼。代碼不能領先於文件。

### ARCHITECTURE.md 的重要性
- 作為 Claude 的「地圖」
- 確保 `/plan` 新需求時不會與現有架構衝突
- 每次閉環必須更新

### 命名規範
| 規格 | 分支 | Worktree |
|------|------|----------|
| spec_001.md | feat/001-login | ../task-001 |
| spec_002.md | feat/002-payment | ../task-002 |

## 快速參考

詳細說明請參閱：
- **階段詳解**：`references/phases.md`
- **範本檔案**：`assets/` 目錄
- **Commands 詳細說明**：`commands/` 目錄
