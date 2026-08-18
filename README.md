# Market Data

`market-data` 是投資專案中的市場資料模組，主要用來學習、整理、清洗並儲存股票、ETF、指數等歷史市場資料。

目前第一階段以台灣市場資料為主，使用 **Python + Jupyter Notebook + PostgreSQL + Docker** 建立資料處理流程。

## 技術環境

* Python 3.12
* Conda
* Pandas
* Jupyter Notebook
* PostgreSQL 18
* Docker / Docker Compose
* DBeaver
* psycopg

## 專案結構

```text
market-data/
├── input/
│   └── .gitkeep
├── notebooks/
│   ├── study/
│   │   ├── 20260813.ipynb
│   ├── inspect_market_data.ipynb
│   └── import_market_data.ipynb
├── sql/
│   └── 001_create_schema.sql
├── src/
├── .gitignore
├── compose.yaml
└── README.md
```

### input

存放原始市場資料，例如 Excel 或 CSV。

原始資料不會提交至 Git。

目前檔案命名規則：

```text
{代碼}_{YYYYMMDD}.xlsx
```

例如：

```text
Y9999_20260813.xlsx
```

其中：

* `Y9999`：加權指數代碼
* `20260813`：資料取得日期

## 資料庫

目前使用 PostgreSQL。

主要資料表：

### instrument

儲存投資標的基本資料，例如：

```text
Y9999 / 加權指數 / TSE / INDEX
2330  / 台積電   / TSE / STOCK
0050  / 元大台灣50 / TSE / ETF
```

主要欄位：

* `id`
* `code`
* `name_zh`
* `market`
* `instrument_type`

### market_daily

儲存各投資標的每日市場資料，包括：

* 開盤價
* 最高價
* 最低價
* 收盤價
* 成交量
* 成交值
* 報酬率
* 週轉率
* 市值
* 本益比
* 股價淨值比
* 股價營收比
* 股利殖利率
* 其他每日市場資訊

每個投資標的每個交易日只會有一筆資料：

```text
instrument_id + trade_date
```

為唯一鍵。

## 啟動 PostgreSQL

在專案根目錄執行：

```bash
docker compose up -d
```

查看 Container：

```bash
docker compose ps
```

停止：

```bash
docker compose down
```

PostgreSQL 資料使用 Docker Volume 保存，因此一般執行 `docker compose down` 不會刪除資料。

## Python 環境

建立 Conda 環境：

```bash
conda create -n investment python=3.12
```

啟用：

```bash
conda activate investment
```

安裝目前需要的套件：

```bash
pip install pandas openpyxl psycopg[binary] jupyter
```

## 建立資料庫 Schema

資料表建立 SQL 位於：

```text
sql/001_create_schema.sql
```

可使用 DBeaver 開啟 PostgreSQL SQL 編輯器並執行此檔案。

目前會建立：

```text
instrument
market_daily
```

兩張主要資料表。

## Jupyter Notebook

### inspect_market_data.ipynb

主要用於：

* 檢查原始 Excel
* 查看欄位
* 檢查資料型別
* 檢查 NULL
* 日期轉換
* 資料探索

### import_market_data.ipynb

主要用於：

* 讀取市場資料
* 中文欄位轉換成英文欄位
* 資料清理
* PostgreSQL 連線
* 建立或更新 `instrument`
* 匯入 `market_daily`

## 第一個資料標的

目前第一個測試標的是：

```text
代碼：Y9999
名稱：加權指數
市場：TSE
類型：INDEX
```

原始資料約包含 6,733 筆歷史每日資料。

## Git 注意事項

以下內容不應提交至 Git：

```text
input/*.xlsx
input/*.csv
.env
```

`input` 資料夾透過 `.gitkeep` 保留目錄結構。

原始市場資料可能具有授權或使用限制，因此不直接存放於 Git Repository。


