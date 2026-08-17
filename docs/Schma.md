# Database Schema

目前資料庫主要包含兩張資料表：

* `instrument`：儲存投資標的基本資料
* `market_daily`：儲存各投資標的每日市場資料

---

## instrument

儲存股票、ETF、指數等投資標的的基本資訊。

| 欄位名稱              | 格式                | 中文意思  | 說明                       |
| ----------------- | ----------------- | ----- | ------------------------ |
| `id`              | `BIGINT IDENTITY` | 標的 ID | 主鍵，由 PostgreSQL 自動產生     |
| `code`            | `VARCHAR(20)`     | 標的代碼  | 例如 `Y9999`、`2330`、`0050` |
| `name_zh`         | `VARCHAR(100)`    | 中文名稱  | 標的中文名稱                   |
| `market`          | `VARCHAR(20)`     | 市場    | 標的所屬市場，例如 `TSE`          |
| `instrument_type` | `VARCHAR(20)`     | 標的類型  | 例如 `INDEX`、`STOCK`、`ETF` |
| `created_at`      | `TIMESTAMPTZ`     | 建立時間  | 資料建立時間，預設為 `NOW()`       |
| `updated_at`      | `TIMESTAMPTZ`     | 更新時間  | 資料最後更新時間，預設為 `NOW()`     |

### 約束

* `id`

  * Primary Key
  * 使用 `GENERATED ALWAYS AS IDENTITY` 自動產生

* `market + code`

  * Unique
  * 同一市場中，同一標的代碼只能存在一筆

---

## market_daily

儲存每個投資標的每日的市場行情、成交資訊、報酬率及估值資料。

### 基本資訊

| 欄位名稱            | 格式                | 中文意思    | 說明                    |
| --------------- | ----------------- | ------- | --------------------- |
| `id`            | `BIGINT IDENTITY` | 每日資料 ID | 主鍵，由 PostgreSQL 自動產生  |
| `instrument_id` | `BIGINT`          | 標的 ID   | 外鍵，對應 `instrument.id` |
| `trade_date`    | `DATE`            | 交易日期    | 市場交易日                 |

### 價格資料

| 欄位名稱                  | 格式              | 中文意思  | 說明               |
| --------------------- | --------------- | ----- | ---------------- |
| `open_price`          | `NUMERIC(18,4)` | 開盤價   | 當日開盤價格           |
| `high_price`          | `NUMERIC(18,4)` | 最高價   | 當日最高成交價格         |
| `low_price`           | `NUMERIC(18,4)` | 最低價   | 當日最低成交價格         |
| `close_price`         | `NUMERIC(18,4)` | 收盤價   | 當日收盤價格           |
| `last_bid_price`      | `NUMERIC(18,4)` | 最後買價  | 當日最後揭示的買進價格      |
| `last_ask_price`      | `NUMERIC(18,4)` | 最後賣價  | 當日最後揭示的賣出價格      |
| `price_change`        | `NUMERIC(18,4)` | 漲跌點數  | 與前一交易日相比的價格變化    |
| `high_low_spread_pct` | `NUMERIC(12,6)` | 高低價差率 | 當日最高價與最低價之間的波動幅度 |

### 成交資料

| 欄位名稱                        | 格式              | 中文意思     | 說明              |
| --------------------------- | --------------- | -------- | --------------- |
| `volume_thousand_shares`    | `BIGINT`        | 成交量（千股）  | 當日成交股數，以千股為單位   |
| `turnover_value_thousand`   | `BIGINT`        | 成交值（千元）  | 當日成交金額，以千元為單位   |
| `trade_count`               | `BIGINT`        | 成交筆數     | 當日市場成交筆數        |
| `turnover_rate_pct`         | `NUMERIC(12,6)` | 週轉率（%）   | 衡量流通股票交易活躍程度    |
| `turnover_value_weight_pct` | `NUMERIC(12,6)` | 成交值比重（%） | 該標的成交值占市場成交值的比例 |

### 報酬資料

| 欄位名稱         | 格式              | 中文意思   | 說明            |
| ------------ | --------------- | ------ | ------------- |
| `return_pct` | `NUMERIC(12,6)` | 報酬率（%） | 相較前一交易日的價格報酬率 |
| `log_return` | `NUMERIC(12,6)` | 對數報酬率  | 使用自然對數計算的報酬率  |

### 市值資料

| 欄位名稱                          | 格式              | 中文意思       | 說明              |
| ----------------------------- | --------------- | ---------- | --------------- |
| `shares_outstanding_thousand` | `BIGINT`        | 流通在外股數（千股） | 流通在外股票數量，以千股為單位 |
| `market_cap_million`          | `BIGINT`        | 市值（百萬元）    | 標的總市場價值，以百萬元為單位 |
| `market_cap_weight_pct`       | `NUMERIC(12,6)` | 市值權重（%）    | 該標的市值占整體市場市值的比例 |

### 本益比

| 欄位名稱     | 格式              | 中文意思     | 說明         |
| -------- | --------------- | -------- | ---------- |
| `pe_tse` | `NUMERIC(18,6)` | 本益比（TSE） | 證交所口徑的本益比  |
| `pe_tej` | `NUMERIC(18,6)` | 本益比（TEJ） | TEJ 口徑的本益比 |

### 股價淨值比

| 欄位名稱     | 格式              | 中文意思       | 說明           |
| -------- | --------------- | ---------- | ------------ |
| `pb_tse` | `NUMERIC(18,6)` | 股價淨值比（TSE） | 證交所口徑的股價淨值比  |
| `pb_tej` | `NUMERIC(18,6)` | 股價淨值比（TEJ） | TEJ 口徑的股價淨值比 |

### 股價營收比

| 欄位名稱     | 格式              | 中文意思       | 說明                           |
| -------- | --------------- | ---------- | ---------------------------- |
| `ps_tej` | `NUMERIC(18,6)` | 股價營收比（TEJ） | TEJ 計算的 Price-to-Sales Ratio |

### 股利殖利率

| 欄位名稱                  | 格式              | 中文意思     | 說明          |
| --------------------- | --------------- | -------- | ----------- |
| `dividend_yield_tse`  | `NUMERIC(12,6)` | 殖利率（TSE） | 證交所口徑的股利殖利率 |
| `cash_dividend_yield` | `NUMERIC(12,6)` | 現金股利殖利率  | 以現金股利計算的殖利率 |

### 次一交易日參考價格

| 欄位名稱                        | 格式              | 中文意思    | 說明             |
| --------------------------- | --------------- | ------- | -------------- |
| `next_open_reference_price` | `NUMERIC(18,4)` | 次日開盤參考價 | 下一交易日使用的開盤參考價格 |
| `next_limit_up_price`       | `NUMERIC(18,4)` | 次日漲停價   | 下一交易日的漲停價格     |
| `next_limit_down_price`     | `NUMERIC(18,4)` | 次日跌停價   | 下一交易日的跌停價格     |

### 交易狀態

| 欄位名稱                 | 格式            | 中文意思  | 說明                     |
| -------------------- | ------------- | ----- | ---------------------- |
| `price_limit_status` | `VARCHAR(20)` | 漲跌停狀態 | 紀錄當日是否處於漲停、跌停或其他價格限制狀態 |
| `is_attention`       | `BOOLEAN`     | 注意股票  | 是否被列為注意股票              |
| `is_disposition`     | `BOOLEAN`     | 處置股票  | 是否被列為處置股票              |
| `is_full_delivery`   | `BOOLEAN`     | 全額交割股 | 是否屬於全額交割股票             |

### 系統欄位

| 欄位名稱         | 格式            | 中文意思 | 說明                   |
| ------------ | ------------- | ---- | -------------------- |
| `created_at` | `TIMESTAMPTZ` | 建立時間 | 資料建立時間，預設為 `NOW()`   |
| `updated_at` | `TIMESTAMPTZ` | 更新時間 | 資料最後更新時間，預設為 `NOW()` |

---

## 資料表關係

* `instrument.id`

  * 一個投資標的

* `market_daily.instrument_id`

  * 對應該投資標的的每日市場資料

因此兩張表之間為：

**instrument 1 → N market_daily**

例如：

* `instrument`

  * `Y9999 / 加權指數`

* `market_daily`

  * `2026-08-10`
  * `2026-08-11`
  * `2026-08-12`
  * `2026-08-13`

---

## market_daily 唯一鍵

`market_daily` 使用以下組合作為 Unique Constraint：

* `instrument_id`
* `trade_date`

也就是：

> 同一個投資標的，在同一個交易日，只能存在一筆市場資料。

例如：

| instrument_id | trade_date   | 是否允許 |
| ------------- | ------------ | ---- |
| `1`           | `2026-08-12` | ✓    |
| `1`           | `2026-08-13` | ✓    |
| `2`           | `2026-08-13` | ✓    |
| `1`           | `2026-08-13` | ✗ 重複 |

---

## NULL 規則

### instrument

以下欄位不可為 NULL：

* `code`
* `name_zh`
* `market`
* `instrument_type`
* `created_at`
* `updated_at`

### market_daily

以下欄位不可為 NULL：

* `instrument_id`
* `trade_date`
* `created_at`
* `updated_at`

其他市場資料欄位允許 NULL。

這代表：

> 某些標的或某些交易日若資料來源沒有提供特定指標，可以保留 NULL，而不需要使用 `0` 代表缺失資料。

---

## 設計概念

* `instrument`

  * 描述「**這是什麼投資標的**」

* `market_daily`

  * 描述「**這個標的某一天發生了什麼**」

* `instrument_id + trade_date`

  * 定義「**哪一個標的、哪一天**」

這樣後續無論加入股票、ETF 或指數，都可以共用同一套每日市場資料結構。
