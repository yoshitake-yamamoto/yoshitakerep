# If necessary, uncomment the line below to include explore_source.

# include: "thelook_jp.model.lkml"


view: test {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_count {}
      column: first_purchase_count {}

      # filters: {
      #   field: user_order_facts.latest_order_date
      #   value: "after 2021/03/01"
      # }

      bind_filters: {
         to_field: user_order_facts.latest_order_date
         from_field: test.filter_date
      }
    }
  }

  filter: filter_date {
    type: date
    default_value: "before 1 year ago"
  }

  dimension: id {
    label: "顧客マスタ 顧客ID"
    description: ""
    type: number
  }
  dimension: order_count {
    label: "受注履歴 受注件数"
    description: ""
    type: number
  }
  dimension: first_purchase_count {
    label: "受注履歴 初回受注件数"
    description: "各顧客にとっての初回受注のみをカウント"
    type: number
  }
}


  # derived_table: {
  #   explore_source: order_items {
  #     column: id { field: users.id }
  #     column: order_count {}
  #     column: total_sale_price {}
  #     bind_filters: {
  #       to_field: order_items.created_date
  #       from_field: test.filter_date
  #     }
  #   }
  # }
