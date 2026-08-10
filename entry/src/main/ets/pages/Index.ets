import DeepSeekApi from '../api/DeepSeekApi';
import { BalanceResponse, BalanceInfo } from '../api/DeepSeekApi';
import { PreferenceManager } from 'common/src/main/ets/storagemanager/PreferenceManager';
import { StorageKey } from 'common/src/main/ets/constant/CommonEnums';
import { UIContext } from '@kit.ArkUI';
import { HdsTabs,hdsMaterial, HdsTabsController, HdsNavigation, HdsNavDestination } from '@kit.UIDesignKit';
import { TabsBarModel } from '../model/TabsBarModel';
import { GlobalInfoModel, Logger } from "common";


@Entry
@Component
struct Index {
  @State balanceResponse: BalanceResponse | null = null
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  @State apiKeyInput: string = ''
  @State savedKeyMasked: string = ''
  @State hasApiKey: boolean = false
  private controller: HdsTabsController = new HdsTabsController();
  private tabsBar: BottomTabBarStyle[] = TabsBarModel.getTabBarByPage() ?? [];
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance()
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();


  aboutToAppear(): void {
    this.tryInitAndLoad()
  }

  private tryInitAndLoad(): void {
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT)
    if (uiContext != undefined) {
      this.preferenceManager.initPreference('hanbaoStore')
      this.loadApiKey()
    } else {
      setTimeout(() => {
        this.tryInitAndLoad()
      }, 100)
    }
  }

  private loadApiKey(): void {
    const key: string | null = this.preferenceManager.getValue<string>(StorageKey.DS_API_KEY)
    if (key != null && key.length > 0) {
      this.hasApiKey = true
      this.savedKeyMasked = this.maskKey(key)
      this.queryBalance(key)
    } else {
      this.hasApiKey = false
      this.savedKeyMasked = ''
    }
  }

  private maskKey(key: string): string {
    if (key.length <= 8) {
      return '****'
    }
    const start = key.substring(0, 4)
    const end = key.substring(key.length - 4)
    return start + '****' + end
  }

  private async queryBalance(apiKey: string): Promise<void> {
    this.isLoading = true
    this.errorMessage = ''
    try {
      const response = await DeepSeekApi.getBalance(apiKey)
      this.balanceResponse = response
      this.isLoading = false
    } catch (error) {
      this.isLoading = false
      this.errorMessage = '查询失败，请检查 API Key 或网络连接'
    }
  }

  private saveApiKey(): void {
    const key = this.apiKeyInput.trim()
    if (key.length === 0) {
      return
    }
    this.preferenceManager.setValue<string>(StorageKey.DS_API_KEY, key)
    this.hasApiKey = true
    this.savedKeyMasked = this.maskKey(key)
    this.apiKeyInput = ''
    this.controller.changeIndex(0)
    this.queryBalance(key)
  }

  private deleteApiKey(): void {
    this.preferenceManager.deleteValue(StorageKey.DS_API_KEY)
    this.hasApiKey = false
    this.savedKeyMasked = ''
    this.balanceResponse = null
    this.errorMessage = ''
  }

  @Builder
  balancePage() {
    Column() {
      Text($r('app.string.title_balance'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.title_color'))
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 8 })

      if (!this.hasApiKey) {
        this.noKeyHint()
      } else if (this.isLoading) {
        this.loadingView()
      } else if (this.errorMessage.length > 0) {
        this.errorView()
      } else if (this.balanceResponse != null) {
        this.balanceContent()
      }

      Blank()
    }
    .padding({top: this.globalInfoModel.statusBarHeight})
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  noKeyHint() {
    Column() {
      Text($r('app.string.no_api_key_hint'))
        .fontSize(16)
        .fontColor($r('app.color.secondary_color'))
        .margin({ bottom: 16 })
      Button($r('app.string.go_to_settings'))
        .backgroundColor($r('app.color.primary_color'))
        .fontColor(Color.White)
        .borderRadius(8)
        .onClick(() => {
        })
    }
    .width('100%')
    .padding(16)
    .margin({ top: 40 })
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  loadingView() {
    Column() {
      LoadingProgress()
        .width(48)
        .height(48)
        .color($r('app.color.primary_color'))
      Text($r('app.string.loading'))
        .fontSize(14)
        .fontColor($r('app.color.secondary_color'))
        .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .margin({ top: 40 })
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  errorView() {
    Column() {
      Text(this.errorMessage)
        .fontSize(14)
        .fontColor($r('app.color.error_color'))
        .margin({ bottom: 16 })
      Button($r('app.string.retry'))
        .backgroundColor($r('app.color.primary_color'))
        .fontColor(Color.White)
        .borderRadius(8)
        .onClick(() => {
          const key: string | null = this.preferenceManager.getValue<string>(StorageKey.DS_API_KEY)
          if (key != null) {
            this.queryBalance(key)
          }
        })
    }
    .width('100%')
    .padding(16)
    .margin({ top: 40 })
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  balanceContent() {
    Scroll() {
      Column({ space: 12 }) {
        Row() {
          Button($r('app.string.refresh'))
            .backgroundColor($r('app.color.primary_color'))
            .fontColor(Color.White)
            .fontSize(14)
            .borderRadius(8)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              const key: string | null = this.preferenceManager.getValue<string>(StorageKey.DS_API_KEY)
              if (key != null) {
                this.queryBalance(key)
              }
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .padding({ left: 16, right: 16 })

        if (this.balanceResponse != null) {
          this.statusCard(this.balanceResponse!.is_available)

          ForEach(this.balanceResponse!.balance_infos, (item: BalanceInfo) => {
            this.balanceCard(item)
          }, (item: BalanceInfo, index: number) => item.currency + index.toString())
        }
      }
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  statusCard(isAvailable: boolean) {
    Row() {
      Text('\u25CF')
        .fontSize(20)
        .fontColor(isAvailable ? $r('app.color.success_color') : $r('app.color.error_color'))
        .margin({ right: 8 })
      Text(isAvailable ? $r('app.string.account_available') : $r('app.string.account_unavailable'))
        .fontSize(16)
        .fontColor(isAvailable ? $r('app.color.success_color') : $r('app.color.error_color'))
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
  }

  @Builder
  balanceCard(item: BalanceInfo) {
    Column() {
      Text(item.currency)
        .fontSize(14)
        .fontColor($r('app.color.secondary_color'))
        .width('100%')

      Text(item.total_balance)
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_color'))
        .width('100%')
        .margin({ top: 8, bottom: 16 })

      Row() {
        Column() {
          Text($r('app.string.granted_balance'))
            .fontSize(12)
            .fontColor($r('app.color.secondary_color'))
          Text(item.granted_balance)
            .fontSize(16)
            .fontColor($r('app.color.body_color'))
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text($r('app.string.topped_up_balance'))
            .fontSize(12)
            .fontColor($r('app.color.secondary_color'))
          Text(item.topped_up_balance)
            .fontSize(16)
            .fontColor($r('app.color.body_color'))
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
  }

  @Builder
  settingsPage() {
    Column() {
      Text($r('app.string.title_settings'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.title_color'))
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 8 })

      Scroll() {
        Column({ space: 12 }) {
          this.apiKeyCard()
        }
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
      .layoutWeight(1)
    }
    .padding({top: this.globalInfoModel.statusBarHeight})
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  apiKeyCard() {
    Column({ space: 12 }) {
      Text($r('app.string.api_key_label'))
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.title_color'))
        .width('100%')

      if (this.hasApiKey) {
        Row() {
          Text($r('app.string.key_saved'))
            .fontSize(14)
            .fontColor($r('app.color.success_color'))
          Text(this.savedKeyMasked)
            .fontSize(14)
            .fontColor($r('app.color.secondary_color'))
            .margin({ left: 8 })
        }
        .width('100%')
      } else {
        Text($r('app.string.key_not_set'))
          .fontSize(14)
          .fontColor($r('app.color.secondary_color'))
          .width('100%')
      }

      Divider()
        .color($r('app.color.divider_color'))

      TextInput({ placeholder: $r('app.string.api_key_placeholder'), text: this.apiKeyInput })
        .type(InputType.Password)
        .fontSize(14)
        .borderRadius(8)
        .width('100%')
        .onChange((value: string) => {
          this.apiKeyInput = value
        })

      Row({ space: 12 }) {
        Button($r('app.string.save'))
          .backgroundColor($r('app.color.primary_color'))
          .fontColor(Color.White)
          .borderRadius(8)
          .layoutWeight(1)
          .onClick(() => {
            this.saveApiKey()
          })

        if (this.hasApiKey) {
          Button($r('app.string.delete_key'))
            .backgroundColor(Color.Transparent)
            .fontColor($r('app.color.error_color'))
            .borderRadius(8)
            .layoutWeight(1)
            .border({ width: 1, color: $r('app.color.error_color'), radius: 8 })
            .onClick(() => {
              this.deleteApiKey()
            })
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
  }

  build() {
    Column() {
      HdsNavigation() {
        HdsTabs({ controller: this.controller }) {
          Repeat(this.tabsBar).each((repeatItem: RepeatItem<BottomTabBarStyle>) => {
            TabContent() {
              // 根据 repeatItem.index 渲染对应页面
              if (repeatItem.index == 0) {
                this.balancePage()
              }else if (repeatItem.index == 1) {
                this.settingsPage()
              }
            }
            .tabBar(repeatItem.item)
          })
        }
        .width('100%')
        //悬浮导航
        .vertical(false)
        .barOverlap(true)
        .barPosition(BarPosition.End)
        .barFloatingStyle({
          barWidth: { smallWidth: 200, mediumWidth: 300, largeWidth: 400 },
          barBottomMargin: this.globalInfoModel.naviIndicatorHeight,
          systemMaterialEffect: {
            materialType: hdsMaterial.MaterialType.IMMERSIVE,
            materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
          }
        })
      }
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
  }
}
