view: events {
  sql_table_name: looker-private-demo.ecomm.events ;;
  label: "WEBイベント"

  dimension: event_id {
    label: "イベントID"
    type: number
    primary_key: yes
    tags: ["mp_event_id"]
    sql: ${TABLE}.id ;;
  }

  dimension: session_id {
    label: "セッションID"
    type: number
    hidden: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension: ip {
    label: "IPアドレス"
    view_label: "ビジター"
    sql: ${TABLE}.ip_address ;;
  }

  dimension: user_id {
    label: "ユーザーID"
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: event {
    label: "イベント日時"
    type: time
#     timeframes: [time, date, hour, time_of_day, hour_of_day, week, day_of_week_index, day_of_week]
    sql: ${TABLE}.created_at ;;
  }

  dimension: sequence_number {
    label: "シーケンス番号"
    type: number
    # description: "Within a given session, what order did the events take place in? 1=First, 2=Second, etc"
    description: "当該セッション内で何番目のイベントかを示す。 1=一つ目, 2=二つ目, etc"
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: is_entry_event {
    label: "エントリーイベントフラグ"
    type: yesno
    # description: "Yes indicates this was the entry point / landing page of the session"
    description: "Yes：このイベントが当該セッションの初回イベント・ランディングページであることを示す"
    sql: ${sequence_number} = 1 ;;
  }

  dimension: is_exit_event {
    type: yesno
    label: "UTMソース"
    sql: ${sequence_number} = ${sessions.number_of_events_in_session} ;;
    # description: "Yes indicates this was the exit point / bounce page of the session"
    description: "Yes：このイベントが当該セッションの最終イベント・離脱ページであることを示す"
  }

  measure: count_bounces {
    label: "離脱数"
    type: count
    # description: "Count of events where those events were the bounce page for the session"
    description: "セッションの離脱イベントの数。セッションの数と等しい"

    filters: {
      field: is_exit_event
      value: "Yes"
    }
  }

  measure: bounce_rate {
    label: "離脱イベント発生率"
    type: number
    value_format_name: percent_2
    # description: "Percent of events where those events were the bounce page for the session, out of all events"
    description: "全イベントに占める離脱イベントの割合"
    sql: ${count_bounces}*1.0 / nullif(${count}*1.0,0) ;;
  }

  dimension: full_page_url {
    label: "フルページURL"
    sql: ${TABLE}.uri ;;
  }

  dimension: viewed_product_id {
    label: "閲覧された商品ID"
    type: number
    sql: CASE WHEN ${event_type} = 'Product' THEN
          CAST(SPLIT(${full_page_url}, '/')[OFFSET(ARRAY_LENGTH(SPLIT(${full_page_url}, '/'))-1)] AS INT64)
      END
       ;;
  }

  dimension: event_type {
    label: "イベントタイプ"
    sql: ${TABLE}.event_type ;;
    tags: ["mp_event_name"]
  }

  dimension: funnel_step {
    label: "ファネルステップ"
    description: "Login -> Browse -> Add to Cart -> Checkout"
    sql: CASE
        WHEN ${event_type} IN ('Login', 'Home') THEN '(1) Land'
        WHEN ${event_type} IN ('Category', 'Brand') THEN '(2) Browse Inventory'
        WHEN ${event_type} = 'Product' THEN '(3) View Product'
        WHEN ${event_type} = 'Cart' THEN '(4) Add Item to Cart'
        WHEN ${event_type} = 'Purchase' THEN '(5) Purchase'
      END
       ;;
  }

  measure: unique_visitors {
    label: "ユニークビジター数"
    type: count_distinct
    # description: "Uniqueness determined by IP Address and User Login"
    description: "IPアドレスのユニーク数をカウント"
    view_label: "ビジター"
    sql: ${ip} ;;
    drill_fields: [visitors*]
  }

  dimension: location {
    label: "位置情報"
    type: location
    view_label: "ビジター"
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: approx_location {
    label: "位置情報（概算）"
    type: location
    view_label: "ビジター"
    sql_latitude: round(${TABLE}.latitude,1) ;;
    sql_longitude: round(${TABLE}.longitude,1) ;;
  }

  dimension: has_user_id {
    label: "ユーザーID有無"
    type: yesno
    view_label: "ビジター"
    # description: "Did the visitor sign in as a website user?"
    description: "ビジターがWEBサイトにユーザーとしてログインしているか否かを示す"
    sql: ${users.id} > 0 ;;
  }

  dimension: browser {
    label: "ブラウザ"
    view_label: "ビジター"
    sql: ${TABLE}.browser ;;
  }

  dimension: os {
    label: "使用OS"
    view_label: "ビジター"
    sql: ${TABLE}.os ;;
  }

  measure: count {
    label: "カウント"
    type: count
    drill_fields: [simple_page_info*]
  }

  measure: sessions_count {
    label: "セッションカウント"
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: count_m {
    label: "カウント(M)"
    type: number
    hidden: yes
    sql: ${count}/1000000.0 ;;
    drill_fields: [simple_page_info*]
    value_format: "#.### \"M\""
  }

  measure: unique_visitors_m {
    label: "ユニークビジター数(M)"
    view_label: "ビジター"
    type: number
    sql: count (distinct ${ip}) / 1000000.0 ;;
    # description: "Uniqueness determined by IP Address and User Login"
    description: "IPアドレスのユニーク数をカウント"
    value_format: "#.### \"M\""
    hidden: yes
    drill_fields: [visitors*]
  }

  measure: unique_visitors_k {
    label: "ユニークビジター数(k)"
    view_label: "ビジター"
    type: number
    hidden: yes
    # description: "Uniqueness determined by IP Address and User Login"
    description: "IPアドレスのユニーク数をカウント"
    sql: count (distinct ${ip}) / 1000.0 ;;
    value_format: "#.### \"k\""
    drill_fields: [visitors*]
  }

  set: simple_page_info {
    fields: [event_id, event_time, event_type, full_page_url, user_id, funnel_step]
  }

  set: visitors {
    fields: [ip, os, browser, user_id, count]
  }
}
