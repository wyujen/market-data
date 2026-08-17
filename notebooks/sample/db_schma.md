# Database Schema

目前資料庫使用 **PostgreSQL**，主要分為：

* `instrument`：投資標的基本資料
* `market_daily`：投資標的每日市場資料

---

## instrument

儲存投資標的的基本資訊。

例如：

* `Y9999`：加權指數
* `2330`：台積電
* `0050`：元大台灣 50

| 欄位名稱              | 格式             | 中文意思  | 說明                                   |
| ----------------- | -------------- | ----- | ------------------------------------ |
| `id`              | `BIGINT`       | 標的 ID | 主鍵，由資料庫自動產生                          |
| `code`            | `VARCHAR(20)`  | 標的代碼  | 股票、ETF、指數代碼，例如 `2330`、`0050`、`Y9999` |
| `name_zh`         | `VARCHAR(100)` | 中文名稱  | 標的中文名稱，例如「加權指數」                      |
| `market`          | `VARCHAR(20)`  | 市場    | 標的所屬市場，例如 `TSE`                      |
| `instrument_type` | `VARCHAR(20)`  | 標的類型  | 例如 `STOCK`、`ETF`、`INDEX`             |
| `created_at`      | `TIMESTAMPTZ`  | 建立時間  | 此筆標的資料建立時間                           |
| `updated_at`      | `TIMESTAMPTZ`  | 更新時間  | 此筆標的資料最後更新時間                         |

### 約束

* `id`

  * Primary Key
  * 自動產生

* `market + code`

  * Unique
  * 同一市場中不可存在重複的標的代碼

例如：

`TSE + Y9999`

只會存在一筆。

---

## market_daily

儲存每個投資標的的**每日市場資料**。

一筆資料代表：

> 某一個投資標的，在某一個交易日的市場狀況。

### 基本欄位

| 欄位名稱            | 格式              | 中文意思  | 說明                    |
| --------------- | --------------- | ----- | --------------------- |
| `instrument_id` | `BIGINT`        | 標的 ID | 外鍵，對應 `instrument.id` |
| `trade_date`    | `DATE`          | 交易日期  | 該筆市場資料所屬的交易日          |
| `open`          | `NUMERIC(18,4)` | 開盤價   | 當日開盤價格                |
| `high`          | `NUMERIC(18,4)` | 最高價   | 當日最高價格                |
| `low`           | `NUMERIC(18,4)` | 最低價   | 當日最低價格                |
| `close`         | `NUMERIC(18,4)` | 收盤價   | 當日收盤價格                |
| `volume`        | `BIGINT`        | 成交量   | 當日市場成交量               |

### 其他市場資料

目前 `market_daily` 另外包含下列市場資訊：

| 資料內容     | 常用格式           | 中文意思           | 說明               |
| -------- | -------------- | -------------- | ---------------- |
| 成交值      | `BIGINT`       | 成交金額           | 當日總成交金額          |
| 報酬率      | `NUMERIC(...)` | 報酬率            | 當日價格相對前一交易日的變動比例 |
| 週轉率      | `NUMERIC(...)` | 週轉率            | 衡量股票成交活躍程度       |
| 市值       | `BIGINT`       | 市場價值           | 標的當日市場總價值        |
| 本益比      | `NUMERIC(...)` | P/E Ratio      | 股價相對每股盈餘的估值指標    |
| 股價淨值比    | `NUMERIC(...)` | P/B Ratio      | 股價相對每股淨值的估值指標    |
| 股價營收比    | `NUMERIC(...)` | P/S Ratio      | 股價相對營收的估值指標      |
| 股利殖利率    | `NUMERIC(...)` | Dividend Yield | 股利相對股價的比例        |
| 其他每日市場資訊 | 依欄位而定          | 其他市場指標         | 依資料來源提供的每日市場欄位保存 |

> `NUMERIC(...)` 的實際精度與其他欄位的正式英文名稱，以 `sql/001_create_schema.sql` 為準。

---

## 資料表關係

`instrument`

↓ `id`

`market_daily.instrument_id`

也就是：

* 一個 `instrument`

  * 可以有很多筆 `market_daily`
* 一筆 `market_daily`

  * 只屬於一個 `instrument`

關係屬於：

**One-to-Many（一對多）**

例如：

`Y9999 加權指數`

可以對應：

* 2000-01-04
* 2000-01-05
* 2000-01-06
* ...
* 2026-08-13

等大量每日市場資料。

---

## market_daily 唯一鍵

`market_daily` 使用：

`instrument_id + trade_date`

作為唯一組合。

代表：

> 同一個投資標的，同一個交易日，只允許存在一筆市場資料。

例如：

| instrument_id | trade_date | 結果   |
| ------------- | ---------- | ---- |
| 1             | 2026-08-12 | 可存在  |
| 1             | 2026-08-13 | 可存在  |
| 2             | 2026-08-13 | 可存在  |
| 1             | 2026-08-13 | 不可重複 |

---

## 目前資料關係

以加權指數為例：

* `instrument`

  * `code`：`Y9999`
  * `name_zh`：加權指數
  * `market`：`TSE`
  * `instrument_type`：`INDEX`

* `market_daily`

  * 透過 `instrument_id` 找到 `Y9999`
  * 再依 `trade_date` 儲存每日行情

因此：

**instrument 負責回答「這是什麼標的」**

**market_daily 負責回答「這個標的某一天的市場資料是什麼」**
