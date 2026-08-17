import { CommonConstants } from "common";

/**
 * 项目名称: ApiUsage
 * 文件名称: BalanceStatusCard
 * 创建时间: 2026-08-15 22:58
 * 创建人：  @author Ffffei
 * 文件描述: 账户是否可以用组件
 */
@Component
export struct BalanceStatusCard {
  @Prop isAvailable: boolean = false; // 账户是否可用
  onRefresh?: () => void;

  build() {
    Row() {
      Row() {
        Text('\u25CF')
          .fontSize(20)
          .fontColor(this.isAvailable ? $r('app.color.success_color') : $r('app.color.error_color'))
          .margin({ right: 8 })
        Text(this.isAvailable ? $r('app.string.account_available') : $r('app.string.account_unavailable'))
          .fontSize(16)
          .fontColor(this.isAvailable ? $r('app.color.success_color') : $r('app.color.error_color'))
          .fontWeight(FontWeight.Medium)
      }
      // .padding($r('sys.float.padding_level8'))
      // .backgroundColor($r('sys.color.comp_background_primary'))
      // .borderRadius($r('sys.float.corner_radius_level12'))


      Button($r('app.string.refresh'))
        .backgroundColor($r('app.color.primary_color'))
        .fontSize(14)
        .borderRadius(8)
        .height(36)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.onRefresh?.(); // 有回调才执行，动作逻辑由父级决定
        })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }
}