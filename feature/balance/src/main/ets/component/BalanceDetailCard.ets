import { CommonConstants } from "common";

@Component
export struct BalanceDetailCard {
  @Prop title: Resource = $r('app.string.granted_balance');
  @Prop balance: string = '';

  build() {
    Column({ space: $r('sys.float.padding_level2') }) {
      Text(this.title)
        .fontSize($r('sys.float.Body_S'))
        .fontColor($r('sys.color.font_secondary'))
      Row({ space: $r('sys.float.padding_level1') }) {
        Text($r('app.string.rmb_symbol'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
        Text(this.balance)
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .alignItems(VerticalAlign.Center)
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding($r('sys.float.padding_level6'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
    .alignItems(HorizontalAlign.Start)
  }
}
