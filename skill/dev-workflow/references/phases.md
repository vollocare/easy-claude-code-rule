# 開發流程階段詳解

## 目錄
1. [規劃階段詳解](#規劃階段詳解)
2. [執行階段詳解](#執行階段詳解)
3. [驗證階段詳解](#驗證階段詳解)
4. [閉環階段詳解](#閉環階段詳解)

---

## 規劃階段詳解

### Spec 文件撰寫指引

規格文件是整個流程的 **單一事實來源 (SSOT)**，必須包含：

```markdown
# spec_XXX: [功能名稱]

## 背景與目標
[為什麼需要這個功能？解決什麼問題？]

## 功能需求
- FR-1: [功能需求描述]
- FR-2: [功能需求描述]

## 技術規格
- 影響模組：[列出會修改的模組]
- API 接口：[新增或修改的 API]
- 資料結構：[新增或修改的資料模型]

## 驗收標準
- AC-1: [可測試的驗收條件]
- AC-2: [可測試的驗收條件]

## 相依性
- 前置條件：[需要先完成什麼]
- 後續影響：[會影響什麼功能]
```

### 任務清單產生

使用 `/plan` 分析 spec 後，產出的任務清單格式：

```markdown
# spec_XXX_task: [功能名稱] 任務清單

## 修改檔案清單
- [ ] `src/xxx/file1.ts` - [修改內容描述]
- [ ] `src/xxx/file2.ts` - [修改內容描述]

## API/組件接口
- [ ] `POST /api/xxx` - [接口描述]
- [ ] `<ComponentName />` - [組件描述]

## 測試案例
- [ ] 單元測試：[測試描述]
- [ ] 整合測試：[測試描述]
- [ ] E2E 測試：[測試描述]
```

---

## 執行階段詳解

### Worktree 操作流程

```bash
# 1. 確保主分支最新
git checkout main && git pull

# 2. 建立 feature 分支與 worktree
git worktree add ../task-XXX -b feat/XXX

# 3. 進入 worktree 開始開發
cd ../task-XXX

# 4. 開啟新的 Claude Code session
# (此時 Claude 的索引範圍僅限該分支)
```

### 開發中的操作

```bash
# 查看 worktree 狀態
git worktree list

# 提交進度
git add . && git commit -m "feat(XXX): [進度描述]"

# 同步主分支變更（如需要）
git fetch origin main
git rebase origin/main
```

### Worktree 的優勢

1. **物理隔離**：主專案可同時進行其他工作
2. **獨立 Session**：Claude 不會被其他變更干擾
3. **乾淨索引**：僅索引該分支相關檔案
4. **並行開發**：可同時開多個 worktree 處理不同任務

---

## 驗證階段詳解

### QA 檢查清單

```markdown
# QA 報告：spec_XXX

## 測試執行結果
- [ ] 單元測試通過
- [ ] 整合測試通過
- [ ] E2E 測試通過

## 功能驗證
- [ ] AC-1 驗收通過
- [ ] AC-2 驗收通過

## 程式碼品質
- [ ] ESLint/Prettier 無錯誤
- [ ] TypeScript 無型別錯誤
- [ ] 無 console.log 殘留

## 效能檢查
- [ ] 無明顯效能退化
- [ ] 無記憶體洩漏

## 問題記錄
| 編號 | 描述 | 狀態 |
|------|------|------|
| 1 | ... | 已修復/待處理 |
```

### PR 建立最佳實踐

```bash
# 使用任務清單作為 PR 內容
gh pr create \
  --title "feat(XXX): [功能名稱]" \
  --body-file .dev/specs/spec_XXX_task.md \
  --base main \
  --head feat/XXX
```

PR 的好處：
- Reviewer 可直接對照任務清單檢視
- 清楚看出開發內容是否符合 `/plan` 預期

---

## 閉環階段詳解

### ARCHITECTURE.md 更新指引

合併後必須更新架構文件：

```markdown
# 更新項目

## 新增模組
- [模組名稱]：[用途描述]
- 位置：`src/xxx/`
- 依賴：[相依模組]

## 資料流變更
[描述新的資料流動方式]

## API 變更
| 端點 | 方法 | 描述 |
|------|------|------|
| /api/xxx | POST | 新增 |
```

### 清理流程

```bash
# 1. 確認 PR 已合併
gh pr view --json state

# 2. 切回主分支
cd /path/to/main-project
git checkout main && git pull

# 3. 移除 worktree
git worktree remove ../task-XXX

# 4. 歸檔或標記 spec 為完成
mv .dev/specs/spec_XXX.md .dev/.claudeignore/
# 或在文件頂部加上 `# [COMPLETED]`
```

### 閉環檢查清單

- [ ] PR 已合併
- [ ] ARCHITECTURE.md 已更新
- [ ] spec 已歸檔或標記完成
- [ ] worktree 已移除
- [ ] 主分支已同步
