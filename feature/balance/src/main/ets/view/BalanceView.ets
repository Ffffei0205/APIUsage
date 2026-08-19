/**
 * 项目名称: ApiUsage
 * 文件名称: BalanceView
 * 创建时间: 2026-08-14
 * 创建人：  @author Ffffei
 * 文件描述: 余额查询页面，负责展示余额状态（无 Key 提示 / 加载中 / 失败重试 / 余额卡片）
 */
import { CommonConstants, GlobalInfoModel, StorageKey } from "common";
import { hdsMaterial, HdsNavDestination, HdsTabsController, ScrollEffectType } from "@kit.UIDesignKit";
import { BalanceInfo } from "../api/DeepSeekApi";
import { BalanceEventType, BalancePageVM } from "../viewmodel/BalancePageVM";
import { BalancePageState } from "../viewmodel/BalancePageState";
import { BaseHomeEventType, BaseHomeView, HomeContentParams, OffsetParam } from "commonbusiness";
import { BalanceStatusCard } from "../component/BalanceStatusCard";
import { BalanceCurrencyCard } from "../component/BalanceCurrencyCard";
import { BalanceDetailCard } from "../component/BalanceDetailCard";
import { BalanceNoKeyHint } from "../component/BalanceNoKeyHint";

@Builder
export function BalanceViewBuilder() {
  BalanceView()
}

@Component
export struct BalanceView {
  @State viewModel: BalancePageVM = BalancePageVM.getInstance();
  @State balancePageState: BalancePageState = this.viewModel.getState();
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  homeTabController: HdsTabsController = new HdsTabsController();
  scroller: Scroller = new Scroller();
  @State refreshedAtText: string = '';

  aboutToAppear(): void {
    //this.viewModel.sendEvent<null>({ type: BalanceEventType.INIT_DATA, param: null });
  }

  private updateRefreshedAtText(): void {
    const date: Date = new Date();
    const month: string = this.formatTwoDigits(date.getMonth() + 1);
    const day: string = this.formatTwoDigits(date.getDate());
    const hour: string = this.formatTwoDigits(date.getHours());
    const minute: string = this.formatTwoDigits(date.getMinutes());
    this.refreshedAtText = `${month}-${day} ${hour}:${minute}`;
  }

  private formatTwoDigits(value: number): string {
    return value < 10 ? `0${value}` : `${value}`;
  }

  private refreshBalance(): void {
    this.updateRefreshedAtText();
    this.viewModel.sendEvent<null>({ type: BalanceEventType.REFRESH, param: null });
  }

  @Builder
  balanceContentViewBuilder() {
    Scroll(this.scroller) {
      Column({ space: CommonConstants.SPACE_12 }) {
        if (this.balancePageState.balanceResponse != undefined) {
          // 数据往下流：state → 子组件 @Prop
          BalanceStatusCard({
            isAvailable: this.balancePageState.balanceResponse!.is_available,
            savedKeyMasked: this.balancePageState.savedKeyMasked,
            refreshedAtText: this.refreshedAtText,
            onRefresh: () => {
              this.refreshBalance();
            }
          })
          ForEach(this.balancePageState.balanceResponse!.balance_infos, (item: BalanceInfo) => {
            BalanceCurrencyCard({
              currency: item.currency,
              totalBalance: item.total_balance,
            })
            Row({ space: CommonConstants.SPACE_12 }) {
              BalanceDetailCard({
                title: $r('app.string.granted_balance'),
                balance: item.granted_balance,
              })
              .layoutWeight(1)

              BalanceDetailCard({
                title: $r('app.string.topped_up_balance'),
                balance: item.topped_up_balance,
              })
              .layoutWeight(1)
            }
            .width(CommonConstants.FULL_PERCENT)
          }, (item: BalanceInfo, index: number) => item.currency + index.toString())
        }

      }
      .padding({ left: CommonConstants.SPACE_12, right: CommonConstants.SPACE_12 })
      .margin({
        top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      })
      .width('100%')
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .align(Alignment.Top)
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .onDidScroll((xOffset: number, yOffset: number) => {
      this.viewModel.sendEvent<OffsetParam>({
        type: BaseHomeEventType.HANDLE_SCROLL_OFFSET,
        param: { yOffset: yOffset },
      });
    })
  }

  build() {
    HdsNavDestination() {
      if (!this.balancePageState.hasApiKey) {
        BalanceNoKeyHint({
          handleGoSetting: () => {
            this.viewModel.sendEvent<null>({
              type: BalanceEventType.JUMP_TO_API_SETTING_PAGE,
              param: null
            });
          }
        })
      } else {
        BaseHomeView({
          loadingModel: this.balancePageState.loadingModel,
          contentView: () => {
            this.balanceContentViewBuilder();
          },
          reloadData: () => {
            this.refreshBalance();
          }
        })
      }
    }
    .titleBar({
      avoidLayoutSafeArea: true,
      style: {
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: hdsMaterial.getSystemMaterialTypes().length > 0 ? ScrollEffectType.GRADIENT_BLUR :
            ScrollEffectType.COMMON_BLUR
        },
      },
      content: {
        title: { mainTitle: $r('app.string.title_balance') },
      },
    })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .hideBackButton(true)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .onShown(() => {
      // 每次页面重新可见（从配置页返回 / 切回本 tab）都重新读 Key 并刷新余额
      this.updateRefreshedAtText();
      this.viewModel.sendEvent<null>({
        type: BalanceEventType.INIT_DATA,
        param: null,
      });
    })
    .onReady((ctx: NavDestinationContext) => {
      const params: HomeContentParams = ctx.pathInfo.param as HomeContentParams;
      this.scroller = params.scroller;
      this.homeTabController = params.homeTabController;
    })
    .onBackPressed(() => {
      return !!this.viewModel.sendEvent<null>({
        type: BaseHomeEventType.ON_BACK_PRESS,
        param: null
      });
    })
  }
}
