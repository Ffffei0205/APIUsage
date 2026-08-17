/**
 * 项目名称: ApiUsage
 * 文件名称: SettingView
 * 文件描述: 应用设置页面
 */
import { hdsMaterial, HdsNavDestination, ScrollEffectType } from '@kit.UIDesignKit';
import { CommonConstants, GlobalInfoModel, hdsListItem, StorageKey } from 'common';
import { SelectSettingItemEvent, SettingPageVM, InitializeSettingEvent } from '../viewmodel/SettingPageVM';
import { SettingItem, SettingItemGroup, SettingState } from '../viewmodel/SettingState';

@Builder
export function SettingViewBuilder() {
  SettingView();
}

@Component
export struct SettingView {
  @State viewModel: SettingPageVM = SettingPageVM.getInstance();
  @State settingState: SettingState = this.viewModel.getState();
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();

  aboutToAppear(): void {
    this.viewModel.sendEvent(new InitializeSettingEvent());
  }

  @Builder
  settingContent() {
    Column({ space: CommonConstants.SPACE_12 }) {
      ForEach(this.settingState.itemGroups, (group: SettingItemGroup) => {
        Column() {
          ForEach(group.items, (item: SettingItem, index: number) => {
            if (index > 0) {
              Divider()
                .color($r('sys.color.comp_background_tertiary'))
                .width(CommonConstants.FULL_PERCENT)
                .padding({ left: CommonConstants.SPACE_40, right: $r('sys.float.padding_level6') });
            }
            hdsListItem({
              prefixResource: item.symbolSrc,
              title: item.title,
              handleClickAction: () => {
                this.viewModel.sendEvent(new SelectSettingItemEvent(item.id));
              },
            });
          }, (item: SettingItem) => item.id);
        }
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius($r('sys.float.corner_radius_level8'))
        .padding($r('sys.float.padding_level2'));
      }, (group: SettingItemGroup) => group.id.toString());
    }
    .padding({ left: CommonConstants.SPACE_12, right: CommonConstants.SPACE_12 })
    .margin({
      top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
      bottom: this.globalInfoModel.naviIndicatorHeight,
    })
    .width(CommonConstants.FULL_PERCENT);
  }

  build() {
    HdsNavDestination() {
      this.settingContent();
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
        title: { mainTitle: $r('app.string.title_settings') },
      },
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM]);
  }
}
