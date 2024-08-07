view: sessions {
  derived_table: {
    #datagroup_trigger: ecommerce_etl_modified
    #materialized_view: yes
    sql:
      -- session rollup table
      SELECT
        session_id
        , CAST(MIN(created_at) AS TIMESTAMP) AS session_start
        , CAST(MAX(created_at) AS TIMESTAMP) AS session_end
        , COUNT(*) AS number_of_events_in_session
        , SUM(CASE WHEN event_type IN ('Category','Brand') THEN 1 ELSE NULL END) AS browse_events
        , SUM(CASE WHEN event_type = 'Product' THEN 1 ELSE NULL END) AS product_events
        , SUM(CASE WHEN event_type = 'Cart' THEN 1 ELSE NULL END) AS cart_events
        , SUM(CASE WHEN event_type = 'Purchase' THEN 1 ELSE NULL end) AS purchase_events
        , CAST(MAX(user_id) AS INT64)  AS session_user_id
        , MIN(id) AS landing_event_id
        , MAX(id) AS bounce_event_id
      FROM looker-private-demo.ecomm.events
      GROUP BY session_id
       ;;
  }


  #####  Basic Web Info  ########

  measure: count {
    label: "セッション数"
    type: count
    drill_fields: [detail*]
  }

  dimension: session_id {
    label: "セッションID"
    type: string
    primary_key: yes
    tags: ["mp_session_id"]
    sql: ${TABLE}.session_id ;;
  }

  dimension: session_user_id {
    label: "セッションユーザーID"
    tags: ["mp_session_uuid"]
    sql: ${TABLE}.session_user_id ;;
  }

  dimension: landing_event_id {
    label: "ランディングイベントID"
    sql: ${TABLE}.landing_event_id ;;
  }

  dimension: bounce_event_id {
    label: "バウンスイベントID"
    sql: ${TABLE}.bounce_event_id ;;
  }

  dimension_group: session_start {
    label: "セッション開始日時"
    type: time
#     timeframes: [time, date, week, month, hour_of_day, day_of_week]
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end {
    label: "セッション終了日時"
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.session_end ;;
  }

  dimension: duration {
    label: "継続時間 (秒)"
    type: number
    sql: (UNIX_MICROS(${TABLE}.session_end) - UNIX_MICROS(${TABLE}.session_start))/1000000 ;;
  }

  measure: average_duration {
    label: "継続滞在時間 (秒)"
    type: average
    value_format_name: decimal_2
    sql: ${duration} ;;
  }

  dimension: duration_seconds_tier {
    label: "継続時間ティア (秒)"
    type: tier
    tiers: [10, 30, 60, 120, 300]
    style: integer
    sql: ${duration} ;;
  }

  #####  Bounce Information  ########

  dimension: is_bounce_session {
    label: "直帰セッションフラグ"
    type: yesno
    sql: ${number_of_events_in_session} = 1 ;;
  }

  measure: count_bounce_sessions {
    label: "セッション数（直帰セッション）"
    type: count
    filters: {
      field: is_bounce_session
      value: "Yes"
    }
    drill_fields: [detail*]
  }

  measure: percent_bounce_sessions {
    label: "直帰率"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_bounce_sessions} / nullif(${count},0) ;;
  }

  ####### Session by event types included  ########

  dimension: number_of_browse_events_in_session {
    label: "セッション内ブラウズイベント数"
    type: number
    hidden: yes
    sql: ${TABLE}.browse_events ;;
  }

  dimension: number_of_product_events_in_session {
    label: "セッション内プロダクトイベント数"
    type: number
    hidden: yes
    sql: ${TABLE}.product_events ;;
  }

  dimension: number_of_cart_events_in_session {
    label: "セッション内カートイベント数"
    type: number
    hidden: yes
    sql: ${TABLE}.cart_events ;;
  }

  dimension: number_of_purchase_events_in_session {
    label: "セッション内購買イベント数"
    type: number
    hidden: yes
    sql: ${TABLE}.purchase_events ;;
  }

  dimension: includes_browse {
    label: "フラグ：ブラウズを含むか"
    type: yesno
    sql: ${number_of_browse_events_in_session} > 0 ;;
  }

  dimension: includes_product {
    label: "フラグ：プロダクトを含むか"
    type: yesno
    sql: ${number_of_product_events_in_session} > 0 ;;
  }

  dimension: includes_cart {
    label: "フラグ：カートを含むか"
    type: yesno
    sql: ${number_of_cart_events_in_session} > 0 ;;
  }

  dimension: includes_purchase {
    label: "フラグ：購買を含むか"
    type: yesno
    sql: ${number_of_purchase_events_in_session} > 0 ;;
  }

  measure: count_with_cart {
    label: "セッション数（カート有）"
    type: count
    filters: {
      field: includes_cart
      value: "Yes"
    }
    drill_fields: [detail*]
  }

  measure: count_with_purchase {
    label: "セッション数（購買有）"
    type: count
    filters: {
      field: includes_purchase
      value: "Yes"
    }
    drill_fields: [detail*]
  }

  dimension: number_of_events_in_session {
    label: "セッション内イベント数"
    type: number
    sql: ${TABLE}.number_of_events_in_session ;;
  }

  ####### Linear Funnel   ########

  dimension: furthest_funnel_step {
    label: "最深到達ファネル"
    sql: CASE
      WHEN ${number_of_purchase_events_in_session} > 0 THEN '(5) Purchase'
      WHEN ${number_of_cart_events_in_session} > 0 THEN '(4) Add to Cart'
      WHEN ${number_of_product_events_in_session} > 0 THEN '(3) View Product'
      WHEN ${number_of_browse_events_in_session} > 0 THEN '(2) Browse'
      ELSE '(1) Land'
      END
       ;;
  }

  measure: all_sessions {
    view_label: "ファネルビュー"
    label: "(1) 全セッション"
    type: count
    drill_fields: [detail*]
  }

  measure: count_browse_or_later {
    view_label: "ファネルビュー"
    label: "(2) ブラウズ、及びそれ以降"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(2) Browse,(3) View Product,(4) Add to Cart,(5) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: count_product_or_later {
    view_label: "ファネルビュー"
    label: "(3) プロダクト閲覧、及びそれ以降"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(3) View Product,(4) Add to Cart,(5) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: count_cart_or_later {
    view_label: "ファネルビュー"
    label: "(4) カート追加、及びそれ以降"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(4) Add to Cart,(5) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: count_purchase {
    view_label: "ファネルビュー"
    label: "(5) 購買"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(5) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: cart_to_checkout_conversion {
    label: "CVR（購買/カート）"
    view_label: "ファネルビュー"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_purchase} / nullif(${count_cart_or_later},0) ;;
  }

  measure: overall_conversion {
    label: "CVR（購買/セッション数）"
    view_label: "ファネルビュー"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_purchase} / nullif(${count},0) ;;
  }

  set: detail {
    fields: [session_id, session_start_time, session_end_time, number_of_events_in_session, duration, number_of_purchase_events_in_session, number_of_cart_events_in_session]
  }
}
