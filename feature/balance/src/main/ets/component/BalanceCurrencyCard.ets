/**
 * 项目名称: ApiUsage
 * 文件名称: BalanceCurrencyCard
 * 创建时间: 2026-08-15 22:59
 * 创建人：  @author Ffffei
 * 文件描述: 余额组件
 */
import { CommonConstants } from "common";

@Component
export struct BalanceCurrencyCard {
  @Prop currency: string = ''; // 币种，如 CNY / USD
  @Prop totalBalance: string = ''; // 总余额

  build() {
    Column() {
      Row({ space: CommonConstants.SPACE_12 }) {
        Text($r('app.string.total_balance'))
        Text($r('app.string.CNY'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Row({ space: $r('sys.float.padding_level2') }) {
        Text(this.totalBalance)
          .fontSize(52)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_color'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Center)
      .margin({ top: CommonConstants.SPACE_14 })
    }
    .width('100%')
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
  }
}
