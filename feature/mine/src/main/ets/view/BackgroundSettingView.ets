/**
 * 项目名称: ApiUsage
 * 文件名称: BackgroundSettingView
 * 文件描述: 应用显示模式设置页面
 */
import { hdsMaterial, HdsNavDestination, ScrollEffectType } from '@kit.UIDesignKit';
import { AppThemeMode, CommonConstants, GlobalInfoModel, StorageKey } from 'common';
import {
  BackgroundSettingPageVM,
  InitializeBackgroundSettingEvent,
  SelectThemeModeEvent,
} from '../viewmodel/BackgroundSettingPageVM';
import { BackgroundSettingState } from '../viewmodel/BackgroundSettingState';

@Builder
export function BackgroundSettingViewBuilder() {
  BackgroundSettingView();
}

@Component
export struct BackgroundSettingView {
  @State viewModel: BackgroundSettingPageVM = BackgroundSettingPageVM.getInstance();
  @State backgroundSettingState: BackgroundSettingState = this.viewModel.getState();
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();

  aboutToAppear(): void {
    this.viewModel.sendEvent(new InitializeBackgroundSettingEvent());
  }

  private createRadioOptions(themeMode: AppThemeMode): RadioOptions {
    const options: RadioOptions = {
      group: 'appThemeMode',
      value: themeMode,
    };
    return options;
  }

  @Builder
  themeOption(title: ResourceStr, themeMode: AppThemeMode) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .layoutWeight(1)
      Radio(this.createRadioOptions(themeMode))
        .checked(this.backgroundSettingState.selectedThemeMode === themeMode)
        .width(24)
        .height(24)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.viewModel.sendEvent(new SelectThemeModeEvent(themeMode));
          }
        })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(56)
    .padding({ left: CommonConstants.SPACE_16, right: CommonConstants.SPACE_16 })
    .onClick(() => {
      this.viewModel.sendEvent(new SelectThemeModeEvent(themeMode));
    });
  }

  build() {
    HdsNavDestination() {
      Column() {
        Column() {
          this.themeOption($r('app.string.theme_follow_system'), AppThemeMode.SYSTEM);
          Divider().color($r('sys.color.comp_divider')).margin({ left: CommonConstants.SPACE_16 });
          this.themeOption($r('app.string.theme_light'), AppThemeMode.LIGHT);
          Divider().color($r('sys.color.comp_divider')).margin({ left: CommonConstants.SPACE_16 });
          this.themeOption($r('app.string.theme_dark'), AppThemeMode.DARK);
        }
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius($r('sys.float.corner_radius_level8'))
        .padding($r('sys.float.padding_level2'));
      }
      .padding({ left: CommonConstants.SPACE_12, right: CommonConstants.SPACE_12 })
      .margin({
        top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      })
      .width(CommonConstants.FULL_PERCENT);
    }
    .titleBar({
      style: {
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: ScrollEffectType.GRADIENT_BLUR,
        },
      },
      content: {
        title: { mainTitle: $r('app.string.background_setting') },
      },
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM]);
  }
}
