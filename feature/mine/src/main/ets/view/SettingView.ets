/**
 * 项目名称: ApiUsage
 * 文件名称: SettingView
 * 创建时间: 2026-08-13
 * 创建人：  @author Ffffei
 * 文件描述: 设置页面，独立承载 API Key 配置卡片
 */
import { UIContext } from '@kit.ArkUI';
import { HdsNavDestination, HdsNavDestinationTitleMode } from "@kit.UIDesignKit"
import { CommonConstants, GlobalInfoModel, PreferenceManager, StorageKey } from "common"

@Builder
export function SettingViewBuilder() {
  SettingView()
}
@Component
export struct SettingView {
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance()

  aboutToAppear(): void {

  }

  build() {
    HdsNavDestination() {
      Column() {

      }
      .margin({
        top: this.globalInfoModel.statusBarHeight + 56,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      })
    }

    .titleBar({
      // avoidLayoutSafeArea: true,
      content: {
        title: { mainTitle: $r('app.string.title_settings') },
      }
    })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}


