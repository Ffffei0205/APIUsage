/**
 * 项目名称: ApiUsage
 * 文件名称: APISettingView
 * 文件描述: API 配置页面，只负责渲染配置列表并将用户操作转发给 VM
 */
import { ApiConfiguration, ApiConfigurationManager, CommonConstants, GlobalInfoModel, StorageKey } from "common";
import { hdsMaterial, HdsNavDestination, ScrollEffectType } from "@kit.UIDesignKit";
import { ApiSettingPageState } from "../viewmodel/ApiSettingPageState";
import { ApiSettingEventType, ApiSettingPageVM } from "../viewmodel/ApiSettingPageVM";

@Builder
export function APISettingViewBuilder() {
  APISettingView()
}

@Component
export struct APISettingView {
  @State viewModel: ApiSettingPageVM = ApiSettingPageVM.getInstance();
  @State apiSettingPageState: ApiSettingPageState = this.viewModel.getState();
  @State pressedConfigurationId: string = '';
  @State contextMenuConfigurationId: string = '';
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();

  aboutToAppear(): void {
    this.viewModel.sendEvent<null>({ type: ApiSettingEventType.INIT_DATA, param: null });
  }

  private showDeleteConfirmation(): void {
    const configurationId: string = this.contextMenuConfigurationId;
    if (configurationId === '') {
      return;
    }
    this.getUIContext().showAlertDialog({
      title: $r('app.string.api_config_delete_title'),
      message: $r('app.string.api_config_delete_message'),
      primaryButton: {
        value: $r('app.string.cancel'),
        action: () => {
        },
      },
      secondaryButton: {
        value: $r('app.string.delete_key'),
        action: () => {
          this.viewModel.sendEvent<string>({ type: ApiSettingEventType.DELETE, param: configurationId });
        },
      },
    });
  }

  private isContextMenuTargetEnabled(): boolean {
    for (let index: number = 0; index < this.apiSettingPageState.apiConfigurations.length; index++) {
      const configuration: ApiConfiguration | undefined = this.apiSettingPageState.apiConfigurations[index];
      if (configuration !== undefined && configuration.id === this.contextMenuConfigurationId) {
        return configuration.isEnabled;
      }
    }
    return false;
  }

  private maskKey(apiKey: string): string {
    if (apiKey.length <= 8) {
      return '·······';
    }
    const start: string = apiKey.substring(0, 4);
    const end: string = apiKey.substring(apiKey.length - 4);
    return `${start}·······${end}`;
  }

  private formatDate(timestamp: number): string {
    if (timestamp <= 0) {
      return '';
    }
    const date: Date = new Date(timestamp);
    const month: string = this.formatTwoDigits(date.getMonth() + 1);
    const day: string = this.formatTwoDigits(date.getDate());
    const hour: string = this.formatTwoDigits(date.getHours());
    const minute: string = this.formatTwoDigits(date.getMinutes());
    return `${date.getFullYear()}-${month}-${day} ${hour}:${minute}`;
  }

  private formatTwoDigits(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }

  @Builder
  apiKeyContextMenu() {
    Column() {
      if (!this.isContextMenuTargetEnabled()) {
        Row({ space: $r('sys.float.padding_level4') }) {
          SymbolGlyph($r('sys.symbol.key'))
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('sys.color.font_primary')])
          Text($r('app.string.api_config_enable'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
        }
        .width('100%')
        .height(52)
        .padding({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
        .borderRadius($r('sys.float.corner_radius_level8'))
        .onClick(() => {
          this.viewModel.sendEvent<string>({
            type: ApiSettingEventType.ENABLE,
            param: this.contextMenuConfigurationId,
          });
        })

        Divider()
          .color($r('app.color.divider_color'))
          .margin({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
      }

      Row({ space: $r('sys.float.padding_level4') }) {
        SymbolGlyph($r('sys.symbol.square_and_pencil'))
          .fontSize($r('sys.float.Title_M'))
          .fontColor([$r('sys.color.font_primary')])
        Text($r('app.string.edit'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .height(52)
      .padding({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
      .borderRadius($r('sys.float.corner_radius_level8'))
      .onClick(() => {
        this.viewModel.sendEvent<string>({
          type: ApiSettingEventType.EDIT,
          param: this.contextMenuConfigurationId,
        });
      })

      Divider()
        .color($r('app.color.divider_color'))
        .margin({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })

      Row({ space: $r('sys.float.padding_level4') }) {
        SymbolGlyph($r('sys.symbol.trash'))
          .fontSize($r('sys.float.Title_M'))
          .fontColor([$r('app.color.error_color')])
        Text($r('app.string.delete_key'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.error_color'))
      }
      .width('100%')
      .height(52)
      .padding({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
      .borderRadius($r('sys.float.corner_radius_level8'))
      .onClick(() => {
        this.showDeleteConfirmation();
      })
    }
    .width(172)
    .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
  }

  @Builder
  apiConfigurationCard(configuration: ApiConfiguration) {
    Column({ space: $r('sys.float.padding_level4') }) {
      Row() {
        Row() {
          SymbolGlyph($r('sys.symbol.key'))
            .fontSize($r('sys.float.Title_L'))
            .fontColor([$r('app.color.primary_color')])
        }
        .width(48)
        .height(48)
        .justifyContent(FlexAlign.Center)
        .borderRadius($r('sys.float.corner_radius_level8'))
        .backgroundColor($r('sys.color.comp_background_secondary'))

        Column({ space: $r('sys.float.padding_level1') }) {
          if (configuration.apiType === '') {
            Text($r('app.string.api_config_default_type'))
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          } else {
            Text(configuration.apiType)
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
          Text(this.maskKey(configuration.apiKey))
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_secondary'))
        }
        .margin({ left: $r('sys.float.padding_level6') })
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text(configuration.isEnabled ? $r('app.string.api_config_enabled') : $r('app.string.api_config_inactive'))
          .fontSize($r('sys.float.Body_S'))
          .fontWeight(FontWeight.Medium)
          .fontColor(configuration.isEnabled ? $r('app.color.success_color') : $r('sys.color.font_secondary'))
          .padding({
            left: $r('sys.float.padding_level4'),
            right: $r('sys.float.padding_level4'),
            top: $r('sys.float.padding_level2'),
            bottom: $r('sys.float.padding_level2'),
          })
          .backgroundColor($r('sys.color.comp_background_secondary'))
          .borderRadius($r('sys.float.corner_radius_level8'))
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Row() {
        Text($r('app.string.api_config_recent_update'))
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_secondary'))
        Text(this.formatDate(configuration.updatedAt))
          .margin({ left: $r('sys.float.padding_level2') })
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_secondary'))
      }
      .width('100%')
    }
    .width('100%')
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
    .scale({
      x: this.pressedConfigurationId === configuration.id ? 0.94 : 1,
      y: this.pressedConfigurationId === configuration.id ? 0.94 : 1,
    })
    .translate({ y: this.pressedConfigurationId === configuration.id ? 4 : 0 })
    .opacity(this.pressedConfigurationId === configuration.id ? 0.84 : 1)
    .animation({ duration: 160, curve: Curve.EaseOut })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.pressedConfigurationId = configuration.id;
        this.contextMenuConfigurationId = configuration.id;
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.pressedConfigurationId = '';
      }
    })
    .bindContextMenu(this.apiKeyContextMenu, ResponseType.LongPress, {
      placement: Placement.BottomRight,
      onAppear: () => {
        this.pressedConfigurationId = '';
      },
      onDisappear: () => {
        this.pressedConfigurationId = '';
      },
    })
  }

  @Builder
  apiKeyEditorCard() {
    Column({ space: $r('sys.float.padding_level6') }) {
      Text(this.apiSettingPageState.editingConfigurationId === '' ?
        $r('app.string.api_config_add') : $r('app.string.edit'))
        .fontSize($r('sys.float.Title_S'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))

      TextInput({ placeholder: $r('app.string.api_key_placeholder'), text: this.apiSettingPageState.apiKeyInput })
        .type(InputType.Password)
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .borderRadius($r('sys.float.corner_radius_level6'))
        .width('100%')
        .onChange((value: string) => {
          this.viewModel.sendEvent<string>({ type: ApiSettingEventType.UPDATE_INPUT, param: value });
        })

      Row({ space: $r('sys.float.padding_level4') }) {
        Button($r('app.string.cancel'))
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_secondary'))
          .borderRadius($r('sys.float.corner_radius_level6'))
          .height(40)
          .layoutWeight(1)
          .onClick(() => {
            this.viewModel.sendEvent<null>({ type: ApiSettingEventType.CANCEL_EDIT, param: null });
          })

        Button($r('app.string.save'))
          .fontColor(Color.White)
          .backgroundColor($r('app.color.primary_color'))
          .borderRadius($r('sys.float.corner_radius_level6'))
          .height(40)
          .layoutWeight(1)
          .onClick(() => {
            this.viewModel.sendEvent<null>({ type: ApiSettingEventType.SAVE, param: null });
          })
      }
      .width('100%')
    }
    .width('100%')
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
  }

  build() {
    HdsNavDestination() {
      List({ space: CommonConstants.SPACE_8 }) {
          if (this.apiSettingPageState.isEditing) {
            ListItem() {
              this.apiKeyEditorCard()
            }
            .width('100%')
          } else {
            ForEach(this.apiSettingPageState.apiConfigurations, (configuration: ApiConfiguration) => {
              ListItem() {
                this.apiConfigurationCard(configuration)
              }
              .width('100%')
            }, (configuration: ApiConfiguration) => configuration.id)

            if (this.apiSettingPageState.apiConfigurations.length < ApiConfigurationManager.MAX_CONFIGURATION_COUNT) {
              ListItem() {
                Button($r('app.string.api_config_add'))
                  .width('100%')
                  .height(44)
                  .fontColor($r('app.color.primary_color'))
                  .backgroundColor($r('sys.color.comp_background_primary'))
                  .borderRadius($r('sys.float.corner_radius_level8'))
                  .onClick(() => {
                    this.viewModel.sendEvent<null>({ type: ApiSettingEventType.ADD, param: null });
                  })
              }
              .width('100%')
            }
          }
      }
      .width('100%')
      .height('100%')
      .padding({ left: CommonConstants.SPACE_12, right: CommonConstants.SPACE_12 })
      .margin({
        top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      })
    }
    .titleBar({
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
