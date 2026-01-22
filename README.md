# Easy Claude Code Rule

AI 軟體工程標準開發流程 - 為 [Claude Code](https://claude.com/claude-code) 設計的 Skill 與 Commands。

採用**文件驅動開發 (Docs-driven)** 與 **Worktree 物理隔離模式**，確保開發流程可追蹤、可重現。

## 核心理念

> 一規格、一任務、一 Worktree、一 PR

四階段標準循環：**規劃 → 執行 → 驗證 → 閉環**

## Commands

| 指令 | 用途 | 參數 |
|------|------|------|
| `/dev-init` | 初始化專案目錄結構 | 無 |
| `/dev-plan <XXX>` | 分析 spec 並產生任務清單 | 必填：任務編號 |
| `/dev-start [XXX]` | 開始開發任務（主專案） | 可選：任務編號 |
| `/dev-resume [XXX]` | 接續開發任務（Worktree） | 可選：任務編號 |
| `/dev-pr [XXX]` | QA + Code Review + 提交 PR | 可選：任務編號 |

## 安裝

將 `commands/` 和 `skill/` 目錄複製到您的 Claude Code 設定目錄：

```bash
# 複製 commands
cp -r commands/* ~/.claude/commands/

# 複製 skill
cp -r skill/* ~/.claude/skills/
```

或在專案內使用（僅該專案生效）：

```bash
# 在專案根目錄
cp -r commands/* .claude/commands/
cp -r skill/* .claude/skills/
```

## 目錄結構

初始化後，專案會產生以下結構：

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

## 快速開始

```bash
# 1. 初始化專案結構
/dev-init

# 2. 建立規格文件 .dev/specs/spec_001.md

# 3. 分析規格並產生任務清單
/dev-plan 001

# 4. 開始開發（建立 Worktree）
/dev-start 001

# 5. 在 Worktree 目錄開啟新 session，執行
/dev-resume 001

# 6. 完成後提交 PR
/dev-pr 001
```

## 關鍵原則

### 防止漂移 (Drift)
> 永遠先改 `.md` 文件，再改代碼。代碼不能領先於文件。

### ARCHITECTURE.md 的重要性
- 作為 Claude 的「地圖」
- 確保規劃新需求時不會與現有架構衝突
- 每次閉環必須更新

## License

MIT
