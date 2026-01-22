#!/bin/bash
# 初始化專案開發流程目錄結構
# 用法: ./init_dev_structure.sh [專案根目錄]

PROJECT_ROOT="${1:-.}"

echo "🚀 初始化開發流程目錄結構..."
echo "   專案目錄: $PROJECT_ROOT"

# 建立 .dev 目錄結構
mkdir -p "$PROJECT_ROOT/.dev/specs"
mkdir -p "$PROJECT_ROOT/.dev/qa"
mkdir -p "$PROJECT_ROOT/.dev/codereview"
mkdir -p "$PROJECT_ROOT/.dev/.claudeignore"

# 建立 .gitkeep 檔案
touch "$PROJECT_ROOT/.dev/specs/.gitkeep"
touch "$PROJECT_ROOT/.dev/qa/.gitkeep"
touch "$PROJECT_ROOT/.dev/codereview/.gitkeep"
touch "$PROJECT_ROOT/.dev/.claudeignore/.gitkeep"

# 建立基礎 ARCHITECTURE.md (如果不存在)
if [ ! -f "$PROJECT_ROOT/ARCHITECTURE.md" ]; then
    cat > "$PROJECT_ROOT/ARCHITECTURE.md" << 'EOF'
# 專案架構文件

> 最後更新：$(date +%Y-%m-%d)

## 概述

[專案簡介與目的]

## 技術棧

- 前端：
- 後端：
- 資料庫：
- 其他：

## 目錄結構

```
project/
├── src/
├── tests/
├── .dev/          # 開發流程文件
└── ...
```

## 模組依賴圖

```
[模組 A] --> [模組 B] --> [模組 C]
```

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
EOF
    echo "✅ 建立 ARCHITECTURE.md"
fi

echo ""
echo "✅ 開發流程目錄結構初始化完成！"
echo ""
echo "目錄結構:"
echo "  $PROJECT_ROOT/.dev/"
echo "  ├── specs/         # 規格文件 (spec_XXX.md)"
echo "  ├── qa/            # QA 測試報告"
echo "  ├── codereview/    # Code Review 記錄"
echo "  └── .claudeignore/ # 舊資料歸檔"
echo ""
echo "下一步:"
echo "  1. 建立第一個規格文件: .dev/specs/spec_001.md"
echo "  2. 使用 /plan 分析規格並產生任務清單"
echo "  3. 建立 worktree 開始開發"
