view: page_view{
  view_label: "アクセス履歴"
  sql_table_name: looker-private-demo.ecomm.order_items ;;
  drill_fields: [id]

  parameter: interval_days {
    label: "アクセス後何日までを見るか"
    type: number
    default_value: "3"
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  # 生のアクセス日時に○日を足したディメンション
  dimension: date_upper {
    type: date_time
    sql: DATE_ADD(${created_raw} , INTERVAL {% parameter interval_days %} DAY) ;;
  }


  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    label: "アクセスID"
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    label: "LPタイトル"
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
  measure: sum_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }
}
