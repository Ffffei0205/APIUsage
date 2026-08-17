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
  @Prop grantedBalance: string = ''; // 赠送余额
  @Prop toppedUpBalance: string = ''; // 充值余额

  build() {
    Column() {
      Row({ space: CommonConstants.SPACE_12 }) {
        Text($r('app.string.total_balance'))
        Text($r('app.string.CNY'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Text(this.totalBalance)
        .fontSize(52)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_color'))
        .width('100%')
        .margin({ top: CommonConstants.SPACE_14, bottom: CommonConstants.SPACE_14 })

      Divider()
        .width(CommonConstants.FULL_PERCENT)

      Row() {
        Column() {
          Text($r('app.string.topped_up_balance')).fontSize(12)
          Text(this.toppedUpBalance).fontSize(16).fontWeight(FontWeight.Medium).margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text($r('app.string.granted_balance')).fontSize(12)
          Text(this.grantedBalance).fontSize(16).fontWeight(FontWeight.Medium).margin({ top: 4 })
        }
        .layoutWeight(1)
      }
      .margin({top:CommonConstants.SPACE_14})
      .width('100%')
    }
    .width('100%')
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
  }
}