/**
 * 项目名称: ApiUsage
 * 文件名称: APISettingView
 * 创建时间: 2026-08-14
 * 创建人：  @author Ffffei
 * 文件描述: API Key 配置页面，负责 DeepSeek API Key 的保存、查看（脱敏）、删除
 */
import { CommonConstants, GlobalInfoModel, StorageKey } from "common";
import { hdsMaterial, HdsNavDestination, ScrollEffectType } from "@kit.UIDesignKit";
import { ApiSettingPageState } from "../viewmodel/ApiSettingPageState";
import { ApiSettingEventType, ApiSettingPageVM } from "../viewmodel/ApiSettingPageVM";


@Builder
export function APISettingViewBuilder() {
  APISettingView()
}

@Component
export struct APISettingView{
  @State viewModel: ApiSettingPageVM = ApiSettingPageVM.getInstance();
  @State apiSettingPageState: ApiSettingPageState = this.viewModel.getState();
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();

  // 输入框内容是临时 UI 状态，留在 View 局部，保存时一次性传给 VM
  @State apiKeyInput: string = ''

  aboutToAppear(): void {
    this.viewModel.sendEvent<null>({ type: ApiSettingEventType.INIT_DATA, param: null });
  }

  @Builder
  apiKeyCard() {
    Column({ space: 12 }) {
      Text($r('app.string.api_key_label'))
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .width('100%')

      if (this.apiSettingPageState.hasApiKey) {
        Row() {
          Text($r('app.string.key_saved'))
            .fontSize(14)
            .fontColor($r('app.color.success_color'))
          Text(this.apiSettingPageState.savedKeyMasked)
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ left: 8 })
        }
        .width('100%')
      } else {
        Text($r('app.string.key_not_set'))
          .fontSize(14)
          .fontColor($r('sys.color.font_secondary'))
          .width('100%')
      }

      Divider()
        .color($r('sys.color.comp_divider'))

      TextInput({ placeholder: $r('app.string.api_key_placeholder'), text: this.apiKeyInput })
        .type(InputType.Password)
        .fontSize(14)
        .fontColor($r('sys.color.font_primary'))
        .borderRadius($r('sys.float.corner_radius_level4'))
        .width('100%')
        .onChange((value: string) => {
          this.apiKeyInput = value
        })

      Row({ space: 12 }) {
        Button($r('app.string.save'))
          .backgroundColor($r('app.color.primary_color'))
          .fontColor(Color.White)
          .borderRadius($r('sys.float.corner_radius_level4'))
          .height(36)
          .layoutWeight(1)
          .onClick(() => {
            // 输入非空才保存（VM 里也会再 trim 判断），保存后清空输入框
            if (this.apiKeyInput.trim().length > 0) {
              this.viewModel.sendEvent<string>({
                type: ApiSettingEventType.SAVE,
                param: this.apiKeyInput,
              });
              this.apiKeyInput = '';
            }
          })

        if (this.apiSettingPageState.hasApiKey) {
          Button($r('app.string.delete_key'))
            .backgroundColor(Color.Transparent)
            .fontColor($r('app.color.error_color'))
            .borderRadius($r('sys.float.corner_radius_level4'))
            .layoutWeight(1)
            .border({ width: 1, color: $r('app.color.error_color'), radius: $r('sys.float.corner_radius_level4') })
            .onClick(() => {
              this.viewModel.sendEvent<null>({
                type: ApiSettingEventType.DELETE,
                param: null,
              });
            })
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
  }

  build() {
    HdsNavDestination() {
      Column() {
        this.apiKeyCard()
      }
      .padding({ left: CommonConstants.SPACE_12, right: CommonConstants.SPACE_12 })
      .margin({
        top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      })
      .width('100%')
    }
    .titleBar({
      // 根栈全屏页不要写 avoidLayoutSafeArea: true（沿用之前修好的规则）
      style: {
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: hdsMaterial.getSystemMaterialTypes().length > 0 ? ScrollEffectType.GRADIENT_BLUR :
            ScrollEffectType.COMMON_BLUR,
        },
      },
      content: {
        title: { mainTitle: $r('app.string.title_api_setting') },
      }
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}
